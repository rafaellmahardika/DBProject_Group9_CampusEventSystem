// =================================================================
// Backend Server "Eventify" - Week 4 Integration
// =================================================================

const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');

const app = express();
const port = 3001;

app.use(cors());
app.use(express.json());

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'eventify_db',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// =================================================================
// 1. AUTHENTICATION (LOGIN & REGISTER) - TABEL USERS

// REGISTER USER
app.post('/api/auth/register', async (req, res) => {
    try {
        const { nama_lengkap, email, password, nim } = req.body;
        if (!nama_lengkap || !email || !password) return res.status(400).json({ message: 'Data tidak lengkap' });

        const query = `INSERT INTO Users (nama_lengkap, email, password, nim) VALUES (?, ?, ?, ?)`;
        const [result] = await pool.query(query, [nama_lengkap, email, password, nim]);

        res.status(201).json({ message: 'Registrasi berhasil! Silakan login.', userId: result.insertId });
    } catch (error) {
        res.status(500).json({ message: 'Gagal registrasi (Email/NIM mungkin sudah ada).' });
    }
});

// LOGIN USER
app.post('/api/auth/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        const query = `SELECT * FROM Users WHERE email = ? AND password = ?`;
        const [users] = await pool.query(query, [email, password]);

        if (users.length === 0) {
            return res.status(401).json({ message: 'Email atau password salah.' });
        }

        const user = users[0];
        res.json({ 
            message: 'Login berhasil', 
            user: { id: user.user_id, nama: user.nama_lengkap, role: 'Mahasiswa' } 
        });
    } catch (error) {
        res.status(500).json({ message: 'Server error saat login.' });
    }
});

// =================================================================
// 2. DATA MASTER (DROPDOWN) - ORGANIZERS & CATEGORIES

// GET Categories
app.get('/api/categories', async (req, res) => {
    const [rows] = await pool.query('SELECT * FROM Categories');
    res.json(rows);
});

// GET Organizers
app.get('/api/organizers', async (req, res) => {
    const [rows] = await pool.query('SELECT * FROM Organizers');
    res.json(rows);
});

// =================================================================
// 3. ADMIN API (FITUR BARU: Tambah Data Master)

// Tambah Kategori Baru
app.post('/api/categories', async (req, res) => {
    try {
        const { nama_kategori } = req.body;
        if (!nama_kategori) return res.status(400).json({ message: 'Nama kategori wajib diisi' });

        await pool.query('INSERT INTO Categories (nama_kategori) VALUES (?)', [nama_kategori]);
        res.status(201).json({ message: 'Kategori berhasil ditambahkan!' });
    } catch (error) {
        res.status(500).json({ message: 'Gagal menambah kategori (Mungkin sudah ada).' });
    }
});

// Tambah Organizer Baru
app.post('/api/organizers', async (req, res) => {
    try {
        const { nama_organizer, email_kontak } = req.body;
        if (!nama_organizer || !email_kontak) return res.status(400).json({ message: 'Nama dan Email wajib diisi' });

        await pool.query('INSERT INTO Organizers (nama_organizer, email_kontak, is_verified) VALUES (?, ?, 1)', 
            [nama_organizer, email_kontak]);
            
        res.status(201).json({ message: 'Organizer berhasil ditambahkan!' });
    } catch (error) {
        res.status(500).json({ message: 'Gagal menambah organizer.' });
    }
});

// =================================================================
// 4. EVENTS (CORE CRUD + SEARCH)

// GET EVENTS (Search)
app.get('/api/events', async (req, res) => {
    try {
        const { search } = req.query; 
        let query = `
            SELECT e.*, c.nama_kategori, o.nama_organizer 
            FROM Events e
            LEFT JOIN Categories c ON e.category_id = c.category_id
            LEFT JOIN Organizers o ON e.organizer_id = o.organizer_id
        `;
        
        const params = [];
        if (search) {
            query += ` WHERE e.nama_acara LIKE ? OR e.lokasi LIKE ?`;
            params.push(`%${search}%`, `%${search}%`);
        }
        
        query += ` ORDER BY e.tanggal_waktu_mulai DESC`;

        const [events] = await pool.query(query, params);
        res.json(events);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal mengambil data events.' });
    }
});

// CREATE EVENT
app.post('/api/events', async (req, res) => {
    try {
        const { nama_acara, deskripsi, lokasi, kuota, tanggal_waktu_mulai, organizer_id, category_id } = req.body;
        const query = `INSERT INTO Events (nama_acara, deskripsi, lokasi, kuota, tanggal_waktu_mulai, organizer_id, category_id) VALUES (?, ?, ?, ?, ?, ?, ?)`;
        await pool.query(query, [nama_acara, deskripsi, lokasi, kuota, tanggal_waktu_mulai, organizer_id, category_id]);
        res.status(201).json({ message: 'Event berhasil dibuat!' });
    } catch (error) {
        res.status(500).json({ message: 'Gagal membuat event.' });
    }
});

// DELETE EVENT
app.delete('/api/events/:id', async (req, res) => {
    try {
        await pool.query('DELETE FROM Events WHERE event_id = ?', [req.params.id]);
        res.json({ message: 'Event dihapus.' });
    } catch (error) {
        res.status(500).json({ message: 'Gagal menghapus event.' });
    }
});

// =================================================================
// 5. REGISTRATIONS (TRANSAKSI)

// User mendaftar ke Event
app.post('/api/registrations', async (req, res) => {
    try {
        const { user_id, event_id } = req.body;
        
        // Cek duplikasi
        const [existing] = await pool.query('SELECT * FROM Registrations WHERE user_id = ? AND event_id = ?', [user_id, event_id]);
        if (existing.length > 0) return res.status(400).json({ message: 'Anda sudah terdaftar di event ini.' });

        const query = `INSERT INTO Registrations (user_id, event_id) VALUES (?, ?)`;
        await pool.query(query, [user_id, event_id]);
        
        res.status(201).json({ message: 'Berhasil mendaftar event!' });
    } catch (error) {
        res.status(500).json({ message: 'Gagal mendaftar.' });
    }
});

// =================================================================
// 6. FEEDBACK (RATING & ULASAN)

// Beri Feedback ke Event
app.post('/api/feedback', async (req, res) => {
    try {
        const { event_id, user_id, rating, komentar } = req.body;
        
        // Validasi Rating
        if (rating < 1 || rating > 5) return res.status(400).json({ message: 'Rating harus 1-5.' });

        // Cek apakah user sudah pernah review event ini
        const [existing] = await pool.query('SELECT * FROM Feedback WHERE event_id = ? AND user_id = ?', [event_id, user_id]);
        if (existing.length > 0) return res.status(400).json({ message: 'Anda sudah mengulas event ini.' });

        const query = `INSERT INTO Feedback (event_id, user_id, rating, komentar) VALUES (?, ?, ?, ?)`;
        await pool.query(query, [event_id, user_id, rating, komentar]);

        res.status(201).json({ message: 'Terima kasih atas ulasan Anda!' });
    } catch (error) {
        res.status(500).json({ message: 'Gagal mengirim ulasan.' });
    }
});

app.get('/api/feedback/:eventId', async (req, res) => {
    try {
        const query = `
            SELECT f.*, u.nama_lengkap 
            FROM Feedback f
            JOIN Users u ON f.user_id = u.user_id
            WHERE f.event_id = ?
            ORDER BY f.feedback_id DESC
        `;
        const [reviews] = await pool.query(query, [req.params.eventId]);
        res.json(reviews);
    } catch (error) {
        res.status(500).json({ message: 'Gagal memuat ulasan.' });
    }
});

// Menjalankan server
app.listen(port, () => {
    console.log(`Server Week 4 berjalan di http://localhost:${port}`);
});

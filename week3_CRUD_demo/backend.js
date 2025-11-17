// =================================================================
// Backend Server "Eventify" (Node.js + Express)
// Week 3: Implementasi CRUD
// =================================================================

const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors'); // Untuk mengizinkan koneksi dari frontend

const app = express();
const port = 3001; // Port untuk server backend

// Middleware
app.use(cors()); // Mengizinkan semua request (untuk development)
app.use(express.json()); // Untuk mem-parsing JSON body dari request

// --- KONEKSI DATABASE ---
// (Menggunakan Connection Pool untuk performa)
// Ganti detail ini sesuai dengan setup database MySQL Anda.
const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '', // <-- GANTI INI (biasanya '' jika XAMPP standar)
    database: 'eventify_db',   // Pastikan nama DB-nya sama
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

console.log("Mencoba terhubung ke database MySQL...");

// Test koneksi
pool.query('SELECT 1')
    .then(() => console.log("Database MySQL berhasil terhubung."))
    .catch(err => {
        console.error("Koneksi database GAGAL:", err.message);
        console.error("Pastikan server MySQL Anda berjalan (via XAMPP) dan detail koneksi (user, password, database) sudah benar.");
    });


// =================================================================
// API ENDPOINTS (RUTE) UNTUK CRUD
// Fokus pada entitas utama: Events
// =================================================================

// 1. CREATE (Membuat Event Baru)
// Rute: POST http://localhost:3001/api/events
app.post('/api/events', async (req, res) => {
    try {
        const { nama_acara, deskripsi, lokasi, kuota, tanggal_waktu_mulai, organizer_id, category_id } = req.body;

        if (!nama_acara || !lokasi || !tanggal_waktu_mulai) {
            return res.status(400).json({ message: 'Nama acara, lokasi, dan tanggal mulai wajib diisi.' });
        }
        
        const query = `
            INSERT INTO Events 
            (nama_acara, deskripsi, lokasi, kuota, tanggal_waktu_mulai, organizer_id, category_id)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        `;
        
        const [result] = await pool.query(query, [
            nama_acara, 
            deskripsi, 
            lokasi, 
            kuota || 0,
            tanggal_waktu_mulai,
            organizer_id || null,
            category_id || null
        ]);

        res.status(201).json({ 
            message: 'Event berhasil dibuat!', 
            eventId: result.insertId 
        });

    } catch (error) {
        console.error("Error saat CREATE event:", error);
        res.status(500).json({ message: 'Server error saat membuat event.' });
    }
});

// 2. READ (Membaca Semua Event)
// Rute: GET http://localhost:3001/api/events
app.get('/api/events', async (req, res) => {
    try {
        const query = `
            SELECT * FROM Events 
            ORDER BY tanggal_waktu_mulai DESC
        `;
        const [events] = await pool.query(query);
        
        res.status(200).json(events);

    } catch (error) {
        console.error("Error saat READ events:", error);
        res.status(500).json({ message: 'Server error saat mengambil data events.' });
    }
});

// 3. UPDATE (Mengubah Event)
// Rute: PUT http://localhost:3001/api/events/1 (Update event ID 1)
app.put('/api/events/:id', async (req, res) => {
    try {
        const { id } = req.params; 
        const { nama_acara, deskripsi, lokasi, kuota } = req.body; 

        if (!nama_acara || !lokasi) {
            return res.status(400).json({ message: 'Nama acara dan lokasi wajib diisi.' });
        }

        const query = `
            UPDATE Events 
            SET nama_acara = ?, deskripsi = ?, lokasi = ?, kuota = ?
            WHERE event_id = ?
        `;

        const [result] = await pool.query(query, [
            nama_acara, 
            deskripsi, 
            lokasi, 
            kuota, 
            id
        ]);

        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Event tidak ditemukan.' });
        }

        res.status(200).json({ message: 'Event berhasil diperbarui.' });

    } catch (error) {
        console.error("Error saat UPDATE event:", error);
        res.status(500).json({ message: 'Server error saat memperbarui event.' });
    }
});

// 4. DELETE (Menghapus Event)
// Rute: DELETE http://localhost:3001/api/events/1 (Hapus event ID 1)
app.delete('/api/events/:id', async (req, res) => {
    try {
        const { id } = req.params; 

        const query = "DELETE FROM Events WHERE event_id = ?";
        const [result] = await pool.query(query, [id]);

        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Event tidak ditemukan.' });
        }

        res.status(200).json({ message: 'Event berhasil dihapus.' });

    } catch (error) {
        console.error("Error saat DELETE event:", error);
        res.status(500).json({ message: 'Server error saat menghapus event.' });
    }
});


// Menjalankan server
app.listen(port, () => {
    console.log(`Server backend "Eventify" berjalan di http://localhost:${port}`);
});
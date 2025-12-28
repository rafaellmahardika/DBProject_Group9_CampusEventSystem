Eventify - Sistem Manajemen Event Kampus (Final Integration Week 5)

Eventify adalah platform berbasis web Full Stack yang dirancang untuk memudahkan mahasiswa dalam mencari, mendaftar, dan memberikan ulasan terhadap kegiatan kemahasiswaan. Repository ini berisi kode sumber final (Week 5) yang merupakan penyempurnaan dan integrasi penuh dari modul-modul sebelumnya.

---

## Apa yang Baru di Week 5? (Technical Improvements)

Berbeda dengan versi Week 4 yang mungkin masih bersifat parsial, versi Final Week 5 ini menghadirkan perbaikan arsitektur dan logika bisnis yang signifikan:

### 1. Integrasi Full Stack (End-to-End)
* **Database Real-time:** Frontend kini terhubung langsung ke MySQL via Backend API. Data kuota, pendaftaran, dan ulasan diambil secara *live*.
* **Smart Query Logic:** Backend menerapkan *Subquery SQL* cerdas untuk mengecek status personal user (`is_registered` dan `has_reviewed`) dalam satu kali *request*, menggantikan logika *fetch* berulang yang kurang efisien di versi sebelumnya.

### 2. Validasi Logika Bisnis "1 User 1 Event"
* **Pencegahan Duplikasi:** Sistem kini menerapkan pertahanan berlapis (*Defense in Depth*) untuk mencegah pendaftaran ganda:
    * **Frontend:** Tombol "Daftar" otomatis mati (*disabled*) jika user sudah terdaftar.
    * **Database:** Penerapan `UNIQUE CONSTRAINT (user_id, event_id)` yang akan menolak paksa data duplikat jika validasi frontend ditembus.

### 3. Manajemen State Dinamis (UX Enhancement)
* Tombol aksi di Dashboard kini bersifat adaptif dengan 3 status (State Machine):
    1.  **Status Awal:** Tombol "Daftar" aktif, tombol "Ulas" mati.
    2.  **Status Terdaftar:** Tombol "Daftar" berubah jadi "Sudah Daftar" (mati), tombol "Ulas" aktif.
    3.  **Status Selesai:** Tombol "Ulas" berubah jadi "Sudah Diulas" (mati) setelah memberi feedback.

### 4. Perbaikan Bug Kritis
* **Fix "Null ID" Bug:** Perbaikan pada logika pengambilan ID event di JavaScript yang sebelumnya menyebabkan kegagalan transaksi pada beberapa browser.
* **Modal Confirmation:** Penambahan lapisan konfirmasi sebelum submit data untuk mencegah klik yang tidak disengaja.

---

## Teknologi yang Digunakan
* **Frontend:** HTML5, Tailwind CSS, Vanilla JavaScript (Fetch API).
* **Backend:** Node.js, Express.js.
* **Database:** MySQL (Relational DB).

---

## Cara Menjalankan Aplikasi (Installation Guide)

Ikuti langkah-langkah berikut untuk menjalankan proyek ini di komputer lokal:

### Langkah 1: Persiapan Database
1.  Pastikan XAMPP (Apache & MySQL) sudah berjalan.
2.  Buka **phpMyAdmin** (`http://localhost/phpmyadmin`).
3.  Buat database baru dengan nama `eventify_db` (jika belum ada).
4.  Import file `eventify_db.sql` yang ada di folder ini ke dalam database tersebut.

### Langkah 2: Instalasi Dependencies
1.  Buka terminal (Command Prompt/PowerShell) di dalam folder ini.
2.  Install library yang dibutuhkan (Express & MySQL Driver) dengan perintah:
    ```bash
    npm install
    ```
    *(Pastikan file `package.json` sudah ada di folder sebelum menjalankan perintah ini)*

### Langkah 3: Menjalankan Server
1.  Jalankan server backend dengan perintah:
    ```bash
    node backend.js
    ```
2.  Jika berhasil, akan muncul pesan: `Server running on port 3000`.

### Langkah 4: Akses Aplikasi
1.  Buka browser (Chrome/Edge/Firefox).
2.  Untuk masuk sebagai pengguna, buka file: `login.html`.
    *Gunakan akun demo di database atau daftar akun baru.*
3.  Untuk akses dashboard admin, buka file: `admin.html`.

---

## 👥 Kelompok 9
- **Rafael Mahardika Arya Dewamurti** (24/536279/PA/22755)
- **Bobby Rahman Hartanto** (24/539383/PA/22903)
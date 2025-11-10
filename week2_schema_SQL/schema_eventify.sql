-- =================================================================
-- SQL Implementasi Database "Eventify"
-- Kelompok 9
-- =================================================================

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    nama_lengkap VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nim VARCHAR(50) UNIQUE
);

CREATE TABLE Organizers (
    organizer_id INT AUTO_INCREMENT PRIMARY KEY,
    nama_organizer VARCHAR(255) NOT NULL,
    email_kontak VARCHAR(255) NOT NULL,
    deskripsi TEXT,
    is_verified BOOLEAN DEFAULT false
);

CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    organizer_id INT,
    category_id INT,
    nama_acara VARCHAR(255) NOT NULL,
    deskripsi TEXT,
    tanggal_waktu_mulai DATETIME NOT NULL,
    tanggal_waktu_selesai DATETIME,
    lokasi VARCHAR(255) NOT NULL,
    kuota INT DEFAULT 0,
    poster_url VARCHAR(255),
    
    FOREIGN KEY (organizer_id) REFERENCES Organizers(organizer_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL
);

CREATE TABLE Registrations (
    registration_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    tanggal_registrasi DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_kehadiran VARCHAR(50) DEFAULT 'Mendaftar',

    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Events(event_id) ON DELETE CASCADE,
        
    UNIQUE(user_id, event_id)
);

CREATE TABLE Feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT,
    komentar TEXT,

    FOREIGN KEY (event_id) REFERENCES Events(event_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,

    CHECK (rating >= 1 AND rating <= 5),
    UNIQUE(event_id, user_id)
);
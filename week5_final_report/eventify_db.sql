-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 28 Des 2025 pada 07.28
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `eventify_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `nama_kategori` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `categories`
--

INSERT INTO `categories` (`category_id`, `nama_kategori`) VALUES
(9, 'Festival'),
(7, 'Konser Musik'),
(6, 'Lomba'),
(8, 'Pameran'),
(10, 'Program Kerja'),
(4, 'Seminar'),
(5, 'Workshop');

-- --------------------------------------------------------

--
-- Struktur dari tabel `events`
--

CREATE TABLE `events` (
  `event_id` int(11) NOT NULL,
  `organizer_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `nama_acara` varchar(255) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `tanggal_waktu_mulai` datetime NOT NULL,
  `tanggal_waktu_selesai` datetime DEFAULT NULL,
  `lokasi` varchar(255) NOT NULL,
  `kuota` int(11) DEFAULT 0,
  `poster_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `events`
--

INSERT INTO `events` (`event_id`, `organizer_id`, `category_id`, `nama_acara`, `deskripsi`, `tanggal_waktu_mulai`, `tanggal_waktu_selesai`, `lokasi`, `kuota`, `poster_url`) VALUES
(1, NULL, NULL, 'Malam Apresiasi 2025', 'Agenda tahunan KM FMIPA UGM yang ditujukan untuk mengapresiasi pencapaian di bidang akademik dan non-akademik. Acara ini menjadi panggung penghargaan sekaligus perayaan atas karya, inovasi, dan kontribusi seluruh civitas FMIPA UGM.\nRangkaian Malam Apresiasi meliputi pentas seni oleh mahasiswa, penampilan dari guest star, serta penganugerahan apresiasi bagi sivitas FMIPA UGM atas pencapaian akademik maupun non-akademik.', '2025-11-19 17:30:00', NULL, '-7.774740550428589, 110.37611961364748', 1000, NULL),
(2, NULL, NULL, 'Studi Banding with Universitas Brawijaya', 'Studi Banding antara BEM KM FMIPA UGM dan BEM FILKOM UB yang akan dilaksanakan di Auditorium Herman Yohanes Lt.7 FMIPA UGM. ', '2025-11-23 08:00:00', NULL, '-7.767607617542581, 110.37631273269655', 200, NULL),
(3, NULL, NULL, 'OmahTI Academy', 'OmahTI Academy merupakan program pelatihan intensif di bidang Teknologi Informasi langsung bersama mentor-mentor yang ahli di bidangnya. Kegiatan ini menjadi salah satu bentuk realisasi dari pilar pelayanan OmahTI, dengan tujuan untuk membagikan pengetahuan, memperluas wawasan, serta meningkatkan keterampilan masyarakat dalam bidang teknologi informasi. Selain sebagai bentuk pelayanan, program ini juga bertujuan untuk memperkenalkan OmahTI kepada masyarakat luas sebagai komunitas pembelajar teknologi yang inklusif dan progresif.', '2026-07-02 09:30:00', NULL, '-7.767612932738865, 110.37630736827852', 360, NULL),
(5, 6, 10, 'First Gathering MAKOMTI 2025/2026', 'Kegiatan First Gathering new member of Himakom & OmahTI UGM', '2025-12-06 18:00:00', NULL, '-7.76697510870352, 110.37678480148315', 0, NULL),
(6, 3, 9, 'GELEX 2026', 'Gelanggang Expo atau GELEX merupakan acara tahunan yang menghadirkan pameran dan penampilan dari berbagai Unit Kegiatan Mahasiswa (UKM) serta komunitas yang ada di Universitas Gadjah Mada. GELEX menjadi ruang bagi mahasiswa, khususnya mahasiswa baru, untuk mengenal lebih dekat wajah dan dinamika UKM di UGM.', '2026-08-20 17:30:00', NULL, '-7.771567420137292, 110.3774929046631', 800, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `feedback`
--

CREATE TABLE `feedback` (
  `feedback_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `komentar` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `feedback`
--

INSERT INTO `feedback` (`feedback_id`, `event_id`, `user_id`, `rating`, `komentar`, `created_at`) VALUES
(1, 6, 1, 5, 'mantap, seruu bangett', '2025-12-26 16:11:46'),
(2, 1, 1, 5, 'ASIKK BANGETTT', '2025-12-26 16:13:25');

-- --------------------------------------------------------

--
-- Struktur dari tabel `organizers`
--

CREATE TABLE `organizers` (
  `organizer_id` int(11) NOT NULL,
  `nama_organizer` varchar(255) NOT NULL,
  `email_kontak` varchar(255) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `organizers`
--

INSERT INTO `organizers` (`organizer_id`, `nama_organizer`, `email_kontak`, `deskripsi`, `is_verified`) VALUES
(3, 'BEM KM UGM', 'bemkm@ugm.ac.id', NULL, 1),
(4, 'KOMA (Komunitas Multimedia)', 'koma@ugm.ac.id', NULL, 1),
(5, 'Gamates', 'gamates@ugm.ac.id', NULL, 1),
(6, 'MAKOMTI', 'makomti@mail.ugm.ac.id', NULL, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `registrations`
--

CREATE TABLE `registrations` (
  `registration_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `tanggal_registrasi` datetime DEFAULT current_timestamp(),
  `status_kehadiran` varchar(50) DEFAULT 'Mendaftar'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `registrations`
--

INSERT INTO `registrations` (`registration_id`, `user_id`, `event_id`, `tanggal_registrasi`, `status_kehadiran`) VALUES
(1, 1, 3, '2025-11-24 20:16:12', 'Mendaftar'),
(2, 1, 6, '2025-12-26 23:11:31', 'Mendaftar'),
(3, 1, 1, '2025-12-26 23:13:05', 'Mendaftar');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `nama_lengkap` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nim` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`user_id`, `nama_lengkap`, `email`, `password`, `nim`) VALUES
(1, 'RAFAEL MAHARDIKA ARYA DEWAMURTI', 'rafaelmahardikaaryadewamurti@mail.ugm.ac.id', 'berprestasi1', '24/536279/PA/22755'),
(2, 'Bobby Rahman Hartanto', 'bobbyrahmanhartanto@mail.ugm.ac.id', 'berprestasi2', '24/539383/PA/22903'),
(3, 'Lionel Messi', 'lionelmessi@mail.ugm.co.id', 'pildun1', '24/32187/PA/24986');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `nama_kategori` (`nama_kategori`);

--
-- Indeks untuk tabel `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `organizer_id` (`organizer_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indeks untuk tabel `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`feedback_id`),
  ADD UNIQUE KEY `one_review_per_user` (`event_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `organizers`
--
ALTER TABLE `organizers`
  ADD PRIMARY KEY (`organizer_id`);

--
-- Indeks untuk tabel `registrations`
--
ALTER TABLE `registrations`
  ADD PRIMARY KEY (`registration_id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`event_id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `nim` (`nim`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `events`
--
ALTER TABLE `events`
  MODIFY `event_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `organizers`
--
ALTER TABLE `organizers`
  MODIFY `organizer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `registrations`
--
ALTER TABLE `registrations`
  MODIFY `registration_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_ibfk_1` FOREIGN KEY (`organizer_id`) REFERENCES `organizers` (`organizer_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `events_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `registrations`
--
ALTER TABLE `registrations`
  ADD CONSTRAINT `registrations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `registrations_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

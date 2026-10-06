-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 06, 2026 at 08:01 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_kasir_basdat`
--

-- --------------------------------------------------------

--
-- Table structure for table `detail_pesanan`
--

CREATE TABLE `detail_pesanan` (
  `id` int(11) NOT NULL,
  `pesanan_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `varian_id` int(11) DEFAULT NULL,
  `jumlah` int(11) NOT NULL DEFAULT 1,
  `harga_satuan` decimal(10,2) NOT NULL,
  `subtotal_item` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jam_operasional`
--

CREATE TABLE `jam_operasional` (
  `id` int(11) NOT NULL,
  `hari` varchar(20) NOT NULL,
  `jam_buka` time NOT NULL,
  `jam_tutup` time NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jam_operasional`
--

INSERT INTO `jam_operasional` (`id`, `hari`, `jam_buka`, `jam_tutup`, `is_active`) VALUES
(1, 'Senin', '08:00:00', '22:00:00', 1),
(2, 'Selasa', '08:00:00', '22:00:00', 1),
(3, 'Rabu', '08:00:00', '22:00:00', 1),
(4, 'Kamis', '08:00:00', '22:00:00', 1),
(5, 'Jumat', '08:00:00', '22:00:00', 1),
(6, 'Sabtu', '08:00:00', '23:00:00', 1),
(7, 'Minggu', '08:00:00', '23:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `kategori_menu`
--

CREATE TABLE `kategori_menu` (
  `id` int(11) NOT NULL,
  `nama_kategori` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kategori_menu`
--

INSERT INTO `kategori_menu` (`id`, `nama_kategori`) VALUES
(1, 'Kopi'),
(2, 'Non-Kopi'),
(3, 'Makanan');

-- --------------------------------------------------------

--
-- Table structure for table `meja`
--

CREATE TABLE `meja` (
  `id` int(11) NOT NULL,
  `nomor_meja` varchar(10) NOT NULL,
  `qr_code_token` varchar(255) NOT NULL,
  `status` enum('kosong','terisi') NOT NULL DEFAULT 'kosong'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `meja`
--

INSERT INTO `meja` (`id`, `nomor_meja`, `qr_code_token`, `status`) VALUES
(1, '1', 'TOKEN-MEJA-001', 'kosong'),
(2, '2', 'TOKEN-MEJA-002', 'kosong'),
(3, '3', 'TOKEN-MEJA-003', 'kosong');

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `id` int(11) NOT NULL,
  `kategori_id` int(11) NOT NULL,
  `nama_menu` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `harga_dasar` decimal(10,2) NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`id`, `kategori_id`, `nama_menu`, `deskripsi`, `harga_dasar`, `foto`, `is_available`) VALUES
(1, 1, 'Kopi Hitam', 'Kopi tubruk khas kedai', 10000.00, NULL, 1),
(2, 1, 'Kopi Susu', 'Kopi dengan susu', 15000.00, NULL, 1),
(3, 2, 'Teh Manis', 'Teh manis segar', 7000.00, NULL, 1),
(4, 3, 'Nasi Goreng', 'Nasi goreng spesial', 18000.00, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `id` int(11) NOT NULL,
  `kode_pesanan` varchar(50) NOT NULL,
  `pelanggan_id` int(11) DEFAULT NULL,
  `meja_id` int(11) DEFAULT NULL,
  `jenis_pesanan` enum('dine_in','take_away') NOT NULL DEFAULT 'dine_in',
  `status_pesanan` enum('menunggu_konfirmasi','diproses','selesai','dibatalkan') NOT NULL DEFAULT 'menunggu_konfirmasi',
  `catatan` text DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `potongan_coin` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_bayar` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`) VALUES
(1, 'admin'),
(2, 'kasir'),
(3, 'pelanggan');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id` int(11) NOT NULL,
  `pesanan_id` int(11) NOT NULL,
  `kasir_id` int(11) DEFAULT NULL,
  `metode_pembayaran` enum('tunai','qris','transfer_bank') NOT NULL,
  `total_bayar` decimal(10,2) NOT NULL,
  `uang_diterima` decimal(10,2) NOT NULL DEFAULT 0.00,
  `kembalian` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status_pembayaran` enum('pending','lunas','gagal') NOT NULL DEFAULT 'pending',
  `coin_diperoleh` int(11) NOT NULL DEFAULT 0,
  `waktu_transaksi` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `coin_balance` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `role_id`, `nama`, `email`, `password`, `no_hp`, `coin_balance`, `created_at`, `updated_at`) VALUES
(1, 1, 'Admin Kedai', 'admin@kedai.test', 'GANTI_DENGAN_HASH', NULL, 0, '2026-10-06 05:40:12', '2026-10-06 05:40:12'),
(2, 2, 'Kasir Satu', 'kasir@kedai.test', 'GANTI_DENGAN_HASH', NULL, 0, '2026-10-06 05:40:12', '2026-10-06 05:40:12');

-- --------------------------------------------------------

--
-- Table structure for table `varian`
--

CREATE TABLE `varian` (
  `id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `nama_varian` varchar(50) NOT NULL,
  `tambahan_harga` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `varian`
--

INSERT INTO `varian` (`id`, `menu_id`, `nama_varian`, `tambahan_harga`) VALUES
(1, 1, 'Panas', 0.00),
(2, 1, 'Dingin', 2000.00),
(3, 2, 'Panas', 0.00),
(4, 2, 'Dingin', 2000.00);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_detail_pesanan` (`pesanan_id`),
  ADD KEY `fk_detail_menu` (`menu_id`),
  ADD KEY `fk_detail_varian` (`varian_id`);

--
-- Indexes for table `jam_operasional`
--
ALTER TABLE `jam_operasional`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kategori_menu`
--
ALTER TABLE `kategori_menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `meja`
--
ALTER TABLE `meja`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_meja_nomor` (`nomor_meja`),
  ADD UNIQUE KEY `uq_meja_token` (`qr_code_token`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_menu_kategori` (`kategori_id`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_pesanan_kode` (`kode_pesanan`),
  ADD KEY `fk_pesanan_pelanggan` (`pelanggan_id`),
  ADD KEY `fk_pesanan_meja` (`meja_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_transaksi_pesanan` (`pesanan_id`),
  ADD KEY `fk_transaksi_kasir` (`kasir_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_users_email` (`email`),
  ADD KEY `fk_users_role` (`role_id`);

--
-- Indexes for table `varian`
--
ALTER TABLE `varian`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_varian_menu` (`menu_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jam_operasional`
--
ALTER TABLE `jam_operasional`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `kategori_menu`
--
ALTER TABLE `kategori_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `meja`
--
ALTER TABLE `meja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `varian`
--
ALTER TABLE `varian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD CONSTRAINT `fk_detail_menu` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_pesanan` FOREIGN KEY (`pesanan_id`) REFERENCES `pesanan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_varian` FOREIGN KEY (`varian_id`) REFERENCES `varian` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `menu`
--
ALTER TABLE `menu`
  ADD CONSTRAINT `fk_menu_kategori` FOREIGN KEY (`kategori_id`) REFERENCES `kategori_menu` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `fk_pesanan_meja` FOREIGN KEY (`meja_id`) REFERENCES `meja` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pesanan_pelanggan` FOREIGN KEY (`pelanggan_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `fk_transaksi_kasir` FOREIGN KEY (`kasir_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transaksi_pesanan` FOREIGN KEY (`pesanan_id`) REFERENCES `pesanan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `varian`
--
ALTER TABLE `varian`
  ADD CONSTRAINT `fk_varian_menu` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

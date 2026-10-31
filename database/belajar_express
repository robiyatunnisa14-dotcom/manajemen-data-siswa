-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.4.3 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for belajar_express
CREATE DATABASE IF NOT EXISTS `belajar_express` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `belajar_express`;

-- Dumping structure for table belajar_express.prodak
CREATE TABLE IF NOT EXISTS `prodak` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nama` varchar(50) DEFAULT NULL,
  `harga` decimal(20,6) DEFAULT NULL,
  `stok` int DEFAULT NULL,
  `kategori` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table belajar_express.prodak: ~2 rows (approximately)
INSERT INTO `prodak` (`id`, `nama`, `harga`, `stok`, `kategori`, `created_at`) VALUES
	(1, 'mouse logitech', 250000.000000, 4, 'aksesoris', '2026-09-17 06:28:18'),
	(2, 'keyboard rexus', 45000.000000, 4, 'aksesoris', '2026-09-17 06:28:19');

-- Dumping structure for table belajar_express.siswa
CREATE TABLE IF NOT EXISTS `siswa` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nipd` varchar(50) DEFAULT NULL,
  `nama_lengkap` varchar(50) DEFAULT NULL,
  `jenis_kelamin` enum('L','P') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `alamat` text,
  `kelas` varchar(20) DEFAULT NULL,
  `jurusan` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nipd` (`nipd`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table belajar_express.siswa: ~3 rows (approximately)
INSERT INTO `siswa` (`id`, `nipd`, `nama_lengkap`, `jenis_kelamin`, `alamat`, `kelas`, `jurusan`) VALUES
	(1, '242510064', 'Melvin Olivia', 'P', 'Kp.Sadangan', 'XII', 'RPL'),
	(2, '242510079', 'Siti Nur Kholisha', 'P', 'Kabasiran', 'XII', 'RPL'),
	(3, '242510070', 'Nurlita', 'P', 'Kp.Cibeber', 'XII', 'RPL');

-- Dumping structure for table belajar_express.user
CREATE TABLE IF NOT EXISTS `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nama` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `Created_at` (`Created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table belajar_express.user: ~6 rows (approximately)
INSERT INTO `user` (`id`, `nama`, `email`, `password`, `Created_at`) VALUES
	(3, 'Emre Razaq', 'emre@gmail.com', '$2b$10$qhqO.PoN3i9oI.UFeGkNOed9UXR0T8qk0YvWmLFLK2pGi4C99Lihq', '2026-09-24 08:55:31'),
	(5, 'felicya', 'felis@gmail.com', '$2b$10$.iWPL4129P/zz3UXEauosOH3mSRR5SJ6R3sLQCxDRHBge8ukodA.G', '2026-09-24 08:55:32'),
	(9, 'melvin olivia', 'melvin@gmail.com', '$2b$10$OKd3lFkSXkvkuQsNk9MN1OqLakmqMY8qMljZRJk9VxxoXPs9AimNS', '2026-09-24 08:55:35'),
	(11, 'lisha', 'lisha@gmail.com', '$2b$10$tQKaGQbdFKeuWwWZUbT3pennkLDP9T.mZgFi4xNTv1N63caUk8u.G', '2026-09-24 08:55:36'),
	(12, 'novi', 'novi@gmail.com', '$2b$10$C5p1Cp1Vjmr7d1bE6CytAO7zyGGDjeRas6Jj/Yq6OzaR9B.v6qX3G', '2026-09-24 08:55:38'),
	(13, 'okta', 'okta@gmail.com', '$2b$10$tFA44g3K.zVtBA9cfhAhdOdUg7APFvKvUWPEA0aFmFb1WihQi8Ouq', '2026-09-24 08:55:39');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

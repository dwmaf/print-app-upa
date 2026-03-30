-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: printapp
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filetoprints`
--

DROP TABLE IF EXISTS `filetoprints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `filetoprints` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `station_id` bigint unsigned DEFAULT NULL,
  `original_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `filetoprints_station_id_foreign` (`station_id`),
  CONSTRAINT `filetoprints_station_id_foreign` FOREIGN KEY (`station_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `filetoprints`
--

LOCK TABLES `filetoprints` WRITE;
/*!40000 ALTER TABLE `filetoprints` DISABLE KEYS */;
INSERT INTO `filetoprints` VALUES (8,'uploads/rpmttqbd16FmPrcICgRz39xIGldkIHKc8EKGm3Bz.pdf',2,'LAPORAN KP_MuhammadFahrulRamadhan_D1042191003.pdf','2026-02-22 19:45:50','2026-02-22 19:45:50'),(9,'uploads/grifVUjEP6GPZncsR0iBKPYmQ8D3BgsHnwYB2yVU.pdf',2,'LAPORAN KERJA PRAKTEK - D1041191045.pdf','2026-02-22 19:49:15','2026-02-22 19:49:15'),(10,'uploads/jeEjkRsbmxjwOxTqpT7vUGzPsestv2uomV3aF45M.pdf',2,'LAPORAN KERJA PRAKTEK - D1041191045.pdf','2026-02-22 20:15:12','2026-02-22 20:15:12'),(11,'uploads/MQadRWuN6vZGL8fhoPhud8e4ZhGWC4kGHtdvecO1.pdf',2,'LAPORAN KP_MuhammadFahrulRamadhan_D1042191003.pdf','2026-02-22 20:21:36','2026-02-22 20:21:36');
/*!40000 ALTER TABLE `filetoprints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000001_create_cache_table',1),(2,'0001_01_01_000002_create_jobs_table',1),(3,'0001_01_01_000003_create_outlets_table',1),(4,'0001_01_01_000004_create_users_table',1),(5,'2026_01_27_124408_create_printfiles_table',1),(6,'2026_02_02_090948_create_transactions_table',1),(7,'2026_02_03_084145_add_printfile_id_to_transactions_table',1),(8,'2026_02_04_185423_create_permission_tables',1),(9,'2026_02_04_190324_add_outlet_id_to_users_table',1),(10,'2026_02_05_061853_add_paid_at_to_transactions_table',1),(11,'2026_02_16_071225_create_filetoprints_table',1),(12,'2026_02_16_120000_create_print_requests_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_permissions`
--

DROP TABLE IF EXISTS `model_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_permissions`
--

LOCK TABLES `model_has_permissions` WRITE;
/*!40000 ALTER TABLE `model_has_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `model_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_roles`
--

DROP TABLE IF EXISTS `model_has_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_roles` (
  `role_id` bigint unsigned NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_roles`
--

LOCK TABLES `model_has_roles` WRITE;
/*!40000 ALTER TABLE `model_has_roles` DISABLE KEYS */;
INSERT INTO `model_has_roles` VALUES (1,'App\\Models\\User',1),(4,'App\\Models\\User',2),(2,'App\\Models\\User',3),(3,'App\\Models\\User',4),(3,'App\\Models\\User',5),(2,'App\\Models\\User',6),(3,'App\\Models\\User',7);
/*!40000 ALTER TABLE `model_has_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outlets`
--

DROP TABLE IF EXISTS `outlets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `outlets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `max_stations` int NOT NULL DEFAULT '1',
  `qris_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outlets`
--

LOCK TABLES `outlets` WRITE;
/*!40000 ALTER TABLE `outlets` DISABLE KEYS */;
INSERT INTO `outlets` VALUES (1,'Berkah Jaya Print','Jl. Kaliurang KM 5, Yogyakarta',3,NULL,'2026-02-20 07:06:25','2026-02-20 07:06:25'),(2,'Mahameru Photocopy','Jl. Gejayan No 12, Yogyakarta',1,NULL,'2026-02-20 07:06:26','2026-02-20 07:06:26');
/*!40000 ALTER TABLE `outlets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `print_requests`
--

DROP TABLE IF EXISTS `print_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `print_requests` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `request_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `station_id` bigint unsigned NOT NULL,
  `filetoprint_id` bigint unsigned DEFAULT NULL,
  `original_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `copies` int NOT NULL DEFAULT '1',
  `color_mode` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'bw',
  `paper_size` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'A4',
  `page_range` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'all',
  `detected_pages` int NOT NULL DEFAULT '1',
  `calculated_pages` int NOT NULL DEFAULT '1',
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `print_requests_request_id_unique` (`request_id`),
  KEY `print_requests_station_id_foreign` (`station_id`),
  KEY `print_requests_filetoprint_id_foreign` (`filetoprint_id`),
  CONSTRAINT `print_requests_filetoprint_id_foreign` FOREIGN KEY (`filetoprint_id`) REFERENCES `filetoprints` (`id`) ON DELETE SET NULL,
  CONSTRAINT `print_requests_station_id_foreign` FOREIGN KEY (`station_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `print_requests`
--

LOCK TABLES `print_requests` WRITE;
/*!40000 ALTER TABLE `print_requests` DISABLE KEYS */;
INSERT INTO `print_requests` VALUES (1,'REQ-69986B6CAA672',2,NULL,'LAPORAN KERJA PRAKTEK - D1041191045.pdf','completed',1,'color','A4','1,2-10,13-20',1,18,'2026-02-20 07:11:15','2026-02-20 07:10:52','2026-02-20 07:14:29'),(2,'REQ-69986BAF039E6',2,NULL,'LAPORAN KP_MuhammadFahrulRamadhan_D1042191003.pdf','rejected',1,'color','A4','all',1,1,NULL,'2026-02-20 07:11:59','2026-02-20 07:12:20'),(3,'REQ-699920A115B53',2,NULL,'Revisi Laporan Kerja Praktek_web profil bujang kurir.pdf','completed',2,'color','A4','1-10,11, 14-20',79,18,'2026-02-20 20:09:53','2026-02-20 20:04:01','2026-02-20 20:13:07'),(4,'REQ-6999246D95B30',2,NULL,'LAPORAN KERJA PRAKTEK - D1041191045.pdf','completed',1,'color','A4','1-10',35,10,'2026-02-20 20:20:21','2026-02-20 20:20:13','2026-02-20 20:20:36'),(5,'REQ-699BBF7DCE74C',2,8,'LAPORAN KP_MuhammadFahrulRamadhan_D1042191003.pdf','completed',1,'color','A4','1-7,20-22',42,10,'2026-02-22 19:46:32','2026-02-22 19:46:21','2026-02-22 19:46:43'),(6,'REQ-699BC03AE1430',2,9,'LAPORAN KERJA PRAKTEK - D1041191045.pdf','completed',1,'color','A4','1-5,7-9',35,8,'2026-02-22 19:49:39','2026-02-22 19:49:30','2026-02-22 19:50:59'),(7,'REQ-699BC64E06FF1',2,10,'LAPORAN KERJA PRAKTEK - D1041191045.pdf','completed',1,'color','A4','1-5',35,5,'2026-02-22 20:15:33','2026-02-22 20:15:26','2026-02-22 20:15:40'),(8,'REQ-699BC7D68A9D2',2,11,'LAPORAN KP_MuhammadFahrulRamadhan_D1042191003.pdf','completed',1,'color','A4','1-5,7-9',42,8,'2026-02-22 20:25:21','2026-02-22 20:21:58','2026-02-22 20:25:39'),(9,'REQ-699BCA1471F0C',2,11,'LAPORAN KP_MuhammadFahrulRamadhan_D1042191003.pdf','completed',1,'color','A4','1-7',42,7,'2026-02-22 20:36:54','2026-02-22 20:31:32','2026-02-22 20:37:00'),(10,'REQ-699BCB7669DC0',2,9,'LAPORAN KERJA PRAKTEK - D1041191045.pdf','rejected',1,'color','A4','1-2',35,2,NULL,'2026-02-22 20:37:26','2026-02-22 20:37:32'),(11,'REQ-699BCB8D624A0',2,8,'LAPORAN KP_MuhammadFahrulRamadhan_D1042191003.pdf','completed',1,'color','A4','1-2,30',42,3,'2026-02-22 20:37:55','2026-02-22 20:37:49','2026-02-22 20:38:02'),(12,'REQ-699BCCAA98050',2,11,'LAPORAN KP_MuhammadFahrulRamadhan_D1042191003.pdf','completed',1,'color','A4','1-5',42,5,'2026-02-22 20:42:40','2026-02-22 20:42:34','2026-02-22 20:42:53');
/*!40000 ALTER TABLE `print_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `printfiles`
--

DROP TABLE IF EXISTS `printfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `printfiles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `station_id` bigint unsigned DEFAULT NULL,
  `original_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `printfiles_station_id_foreign` (`station_id`),
  CONSTRAINT `printfiles_station_id_foreign` FOREIGN KEY (`station_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `printfiles`
--

LOCK TABLES `printfiles` WRITE;
/*!40000 ALTER TABLE `printfiles` DISABLE KEYS */;
INSERT INTO `printfiles` VALUES (1,'files/LAPORAN KERJA PRAKTEK - D1041191045-387n983s7.pdf',NULL,'LAPORAN KERJA PRAKTEK - D1041191045.pdf','2026-02-20 07:06:26','2026-02-20 07:06:26'),(2,'uploads/s3EYq2sWhjeAtWomGTtskl96nrKMkyQvx20f13HW.pdf',4,'Revisi Laporan Kerja Praktek_web profil bujang kurir.pdf','2026-02-20 17:27:17','2026-02-20 17:27:17'),(3,'uploads/iPuyM7ec4sDKoISe2Tc8hpmhvEwFZ7IchWOJQGGj.pdf',4,'Revisi Laporan Kerja Praktek_web profil bujang kurir.pdf','2026-02-20 19:44:48','2026-02-20 19:44:48');
/*!40000 ALTER TABLE `printfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_has_permissions`
--

DROP TABLE IF EXISTS `role_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `role_has_permissions_role_id_foreign` (`role_id`),
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_has_permissions`
--

LOCK TABLES `role_has_permissions` WRITE;
/*!40000 ALTER TABLE `role_has_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `role_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'super-admin','web','2026-02-20 07:06:24','2026-02-20 07:06:24'),(2,'outlet-owner','web','2026-02-20 07:06:24','2026-02-20 07:06:24'),(3,'station','web','2026-02-20 07:06:24','2026-02-20 07:06:24'),(4,'station-upa-pkk','web','2026-02-20 07:06:24','2026-02-20 07:06:24');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('hbAqNtbN774nuDB2RptviuQgLJmqprll6nhqQVeV',1,'10.85.14.137','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiRktpU0VCcUIyU1BibDdYU2JQVUNuRVhQc2FBN21aSzFMYk9FNE9nciI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDc6Imh0dHA6Ly8xMC44NS4xNC4xMzc6ODAwMC9hZG1pbi91cGEvdmVyaWZ5LXByaW50IjtzOjU6InJvdXRlIjtzOjI4OiJhZG1pbi51cGEudmVyaWZ5LXByaW50LmluZGV4Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTt9',1771820936),('xr6xEZh9hLdh9zQoPZ1IHyxeLDxGc4tjWny6sWPt',2,'10.85.14.137','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiTG1MM3dVbHNYWG9URmJHTUZpODZuUkVWeEgwMEZ3anhLZXdOT1U5aCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzY6Imh0dHA6Ly8xMC44NS4xNC4xMzc6ODAwMC91cGEvc3RhdGlvbiI7czo1OiJyb3V0ZSI7czoxNzoidXBhLnN0YXRpb24uaW5kZXgiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToyO30=',1771820932);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `printfile_id` bigint unsigned DEFAULT NULL,
  `order_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `station_id` bigint unsigned DEFAULT NULL,
  `file_id` bigint unsigned NOT NULL,
  `amount` int NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `paid_at` timestamp NULL DEFAULT NULL,
  `filename_snapshot` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `print_config` json NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transactions_order_id_unique` (`order_id`),
  KEY `transactions_station_id_foreign` (`station_id`),
  CONSTRAINT `transactions_station_id_foreign` FOREIGN KEY (`station_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,NULL,'ULYQNH',4,2,79000,'paid',NULL,'Revisi Laporan Kerja Praktek_web profil bujang kurir.pdf','\"{\\\"copies\\\":1,\\\"color_mode\\\":\\\"color\\\",\\\"paper_size\\\":\\\"A4\\\",\\\"page_range\\\":null,\\\"page_count\\\":79}\"','2026-02-20 20:06:31','2026-02-20 20:11:13');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `outlet_id` bigint unsigned DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_outlet_id_foreign` (`outlet_id`),
  CONSTRAINT `users_outlet_id_foreign` FOREIGN KEY (`outlet_id`) REFERENCES `outlets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Super Administrator','admin@upa.printation',NULL,'2026-02-20 07:06:24','$2y$12$PzwU79kftDdE6v1TKPWXCuELHEpnIeE/gfbkEBbTh.qcTATY1Im2e',NULL,'2026-02-20 07:06:24','2026-02-20 07:06:24'),(2,'Kiosk UPA PKK','kiosk@upa.printation',NULL,'2026-02-20 07:06:25','$2y$12$urnPEhCaSMizIDsXkYWev.xUMh1o8Gd1IQAc0meAdfBg/y/Bz0H7q',NULL,'2026-02-20 07:06:25','2026-02-20 07:06:25'),(3,'Pak Budi','budi@berkahjaya.com',1,'2026-02-20 07:06:25','$2y$12$d0KP9X.ZnrIT1IQ/ghpzXe0Mute0yhGKuXJ75nQtVMvaesgebFIe2',NULL,'2026-02-20 07:06:25','2026-02-20 07:06:25'),(4,'Station Depan - Berkah','st1@berkahjaya.com',1,'2026-02-20 07:06:25','$2y$12$2o/kZmvcbcosHYRKtACKGeo3ztJ5G0L85MzdRlWyciiD7gJ2MP4Mu',NULL,'2026-02-20 07:06:25','2026-02-20 07:06:25'),(5,'Station Belakang - Berkah','st2@berkahjaya.com',1,'2026-02-20 07:06:26','$2y$12$2DZGa08XPNpqpVXP8E/Yb.MIwRT.N4gzSECjswakgqCU69GtUS/xi',NULL,'2026-02-20 07:06:26','2026-02-20 07:06:26'),(6,'Bu Susi (Owner Mahameru)','susi@mahameru.com',2,'2026-02-20 07:06:26','$2y$12$WPmSGSqbeMKzqO0MzfAdN.4RdNx5GiMc0r1Gn.XN/M2y3TT0fKBKy',NULL,'2026-02-20 07:06:26','2026-02-20 07:06:26'),(7,'Station Utama - Mahameru','print@mahameru.com',2,'2026-02-20 07:06:26','$2y$12$a6ii3yxFPWMZZymT2JRAueT9EUw4O27wHnaPWiBDWeDehtjvQxBry',NULL,'2026-02-20 07:06:26','2026-02-20 07:06:26');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-23 12:38:32

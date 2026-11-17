-- MySQL dump 10.13  Distrib 8.4.3, for Win64 (x86_64)
--
-- Host: localhost    Database: chickguard
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `chickguard`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `chickguard` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `chickguard`;

--
-- Table structure for table `actuator_status`
--

DROP TABLE IF EXISTS `actuator_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actuator_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `kipas` tinyint(1) NOT NULL DEFAULT '0',
  `heater` tinyint(1) NOT NULL DEFAULT '0',
  `lampu` tinyint(1) NOT NULL DEFAULT '0',
  `motor_pakan` tinyint(1) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actuator_status`
--

LOCK TABLES `actuator_status` WRITE;
/*!40000 ALTER TABLE `actuator_status` DISABLE KEYS */;
INSERT INTO `actuator_status` VALUES (1,0,0,0,0,'2026-11-16 07:57:33');
/*!40000 ALTER TABLE `actuator_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_sensor`
--

DROP TABLE IF EXISTS `data_sensor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_sensor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `suhu` decimal(5,2) NOT NULL,
  `kelembaban` decimal(5,2) NOT NULL,
  `cahaya` decimal(8,2) NOT NULL DEFAULT '1240.00',
  `level_air` decimal(5,2) NOT NULL DEFAULT '72.00',
  `recorded_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=226 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_sensor`
--

LOCK TABLES `data_sensor` WRITE;
/*!40000 ALTER TABLE `data_sensor` DISABLE KEYS */;
INSERT INTO `data_sensor` VALUES (1,32.60,68.90,1260.00,73.00,'2026-10-10 08:00:00'),(2,32.30,67.10,1210.00,72.00,'2026-10-10 08:10:00'),(3,31.90,66.50,1120.00,71.00,'2026-10-10 08:20:00'),(4,32.10,67.80,1180.00,72.00,'2026-10-10 08:30:00'),(5,32.40,68.20,1240.00,72.00,'2026-10-10 08:40:00'),(6,31.72,68.38,1361.15,70.80,'2026-10-22 07:56:34'),(7,31.35,69.11,1411.75,69.90,'2026-10-25 08:45:46'),(8,30.29,70.23,951.34,68.30,'2026-10-26 01:33:29'),(9,29.73,71.72,970.42,66.80,'2026-10-26 08:55:25'),(10,29.05,73.11,559.77,66.20,'2026-10-26 23:27:12'),(11,29.33,73.49,996.50,65.20,'2026-10-27 11:28:20'),(12,28.92,75.17,859.38,63.80,'2026-11-02 06:39:24'),(13,28.46,76.14,811.45,63.20,'2026-11-06 06:52:11'),(14,28.13,76.37,815.69,61.80,'2026-11-10 06:55:12'),(15,27.51,76.98,469.10,60.30,'2026-11-16 03:27:28'),(16,32.30,79.50,936.00,0.00,'2026-11-15 20:29:12'),(17,32.30,79.40,946.00,0.00,'2026-11-15 20:29:15'),(18,32.30,79.30,952.00,0.00,'2026-11-15 20:29:17'),(19,32.30,79.20,947.00,0.00,'2026-11-15 20:29:20'),(20,32.30,79.20,950.00,0.00,'2026-11-15 20:29:22'),(21,32.40,79.10,949.00,0.00,'2026-11-15 20:29:25'),(22,32.40,79.10,951.00,0.00,'2026-11-15 20:29:27'),(23,32.40,79.20,951.00,0.00,'2026-11-15 20:29:30'),(24,32.40,79.20,952.00,0.00,'2026-11-15 20:29:32'),(25,32.40,79.30,951.00,0.00,'2026-11-15 20:29:35'),(26,32.40,79.30,951.00,0.00,'2026-11-15 20:29:37'),(27,32.40,79.30,951.00,0.00,'2026-11-15 20:29:40'),(28,32.40,79.30,952.00,0.00,'2026-11-15 20:29:42'),(29,32.40,79.30,951.00,0.00,'2026-11-15 20:29:44'),(30,32.40,79.30,906.00,0.00,'2026-11-15 20:29:47'),(31,32.40,79.40,1217.00,0.00,'2026-11-15 20:29:50'),(32,32.40,79.50,0.00,0.00,'2026-11-15 20:29:52'),(33,32.40,79.60,0.00,0.00,'2026-11-15 20:29:55'),(34,32.40,79.60,1030.00,0.00,'2026-11-15 20:29:57'),(35,32.40,79.60,1058.00,0.00,'2026-11-15 20:30:00'),(36,32.40,79.60,1059.00,0.00,'2026-11-15 20:30:02'),(37,32.40,79.50,1061.00,0.00,'2026-11-15 20:30:05'),(38,32.40,79.50,1061.00,0.00,'2026-11-15 20:30:07'),(39,32.40,79.40,1062.00,0.00,'2026-11-15 20:30:10'),(40,32.40,79.50,1064.00,0.00,'2026-11-15 20:30:12'),(41,32.40,79.50,1063.00,0.00,'2026-11-15 20:30:15'),(42,32.40,79.50,1062.00,0.00,'2026-11-15 20:30:17'),(43,32.40,79.40,1066.00,0.00,'2026-11-15 20:30:20'),(44,32.40,79.30,1068.00,0.00,'2026-11-15 20:30:22'),(45,32.40,79.30,1071.00,0.00,'2026-11-15 20:30:25'),(46,32.40,79.20,1072.00,0.00,'2026-11-15 20:30:27'),(47,32.40,79.20,1079.00,0.00,'2026-11-15 20:30:30'),(48,32.40,79.10,1073.00,0.00,'2026-11-15 20:30:32'),(49,32.40,79.10,1072.00,0.00,'2026-11-15 20:30:35'),(50,32.40,79.10,1069.00,0.00,'2026-11-15 20:30:37'),(51,29.20,65.50,1300.00,0.00,'2026-11-15 23:18:08'),(52,29.20,65.60,1307.00,0.00,'2026-11-15 23:18:09'),(53,27.50,63.10,1013.00,0.00,'2026-11-15 23:23:11'),(54,27.50,63.00,1005.00,0.00,'2026-11-15 23:23:13'),(55,27.50,63.00,1016.00,0.00,'2026-11-15 23:23:16'),(56,27.50,62.90,1004.00,0.00,'2026-11-15 23:23:18'),(57,27.50,62.90,1011.00,0.00,'2026-11-15 23:23:21'),(58,27.60,62.90,1012.00,0.00,'2026-11-15 23:23:24'),(59,27.60,63.00,996.00,0.00,'2026-11-15 23:23:26'),(60,27.60,62.90,882.00,0.00,'2026-11-15 23:23:29'),(61,27.60,62.80,779.00,0.00,'2026-11-15 23:23:31'),(62,27.60,62.70,756.00,0.00,'2026-11-15 23:23:33'),(63,27.60,62.70,577.00,0.00,'2026-11-15 23:23:36'),(64,27.60,62.70,1006.00,0.00,'2026-11-15 23:23:39'),(65,27.60,62.70,1004.00,0.00,'2026-11-15 23:23:41'),(66,27.60,62.70,1012.00,0.00,'2026-11-15 23:23:44'),(67,27.60,62.60,1008.00,0.00,'2026-11-15 23:23:46'),(68,27.60,62.50,1003.00,0.00,'2026-11-15 23:23:48'),(69,27.60,62.50,1004.00,0.00,'2026-11-15 23:23:51'),(70,27.60,62.40,1011.00,0.00,'2026-11-15 23:23:54'),(71,27.60,62.30,997.00,0.00,'2026-11-15 23:23:56'),(72,27.60,62.30,1008.00,0.00,'2026-11-15 23:23:59'),(73,27.60,62.20,1002.00,0.00,'2026-11-15 23:24:01'),(74,27.60,62.20,1011.00,0.00,'2026-11-15 23:24:03'),(75,27.60,62.20,998.00,0.00,'2026-11-15 23:24:07'),(76,27.60,62.10,1034.00,0.00,'2026-11-15 23:24:10'),(77,27.60,62.10,1052.00,0.00,'2026-11-15 23:24:11'),(78,27.60,62.10,1023.00,0.00,'2026-11-15 23:24:14'),(79,27.60,62.10,994.00,0.00,'2026-11-15 23:24:16'),(80,27.60,62.00,986.00,0.00,'2026-11-15 23:24:19'),(81,27.60,62.00,984.00,0.00,'2026-11-15 23:24:21'),(82,27.60,62.10,979.00,0.00,'2026-11-15 23:24:24'),(83,27.60,62.20,991.00,0.00,'2026-11-15 23:24:26'),(84,27.60,62.20,990.00,0.00,'2026-11-15 23:24:28'),(85,27.60,62.20,996.00,0.00,'2026-11-15 23:24:31'),(86,27.60,62.20,989.00,0.00,'2026-11-15 23:24:33'),(87,27.60,62.30,981.00,0.00,'2026-11-15 23:24:36'),(88,27.60,62.30,978.00,0.00,'2026-11-15 23:24:39'),(89,27.60,62.20,982.00,0.00,'2026-11-15 23:24:41'),(90,27.60,62.20,984.00,0.00,'2026-11-15 23:24:44'),(91,27.60,62.20,984.00,0.00,'2026-11-15 23:24:46'),(92,27.60,62.20,984.00,0.00,'2026-11-15 23:24:50'),(93,27.60,62.10,985.00,0.00,'2026-11-15 23:24:51'),(94,27.60,62.10,979.00,0.00,'2026-11-15 23:24:54'),(95,27.60,62.10,984.00,0.00,'2026-11-15 23:24:56'),(96,27.60,62.10,984.00,0.00,'2026-11-15 23:24:59'),(97,27.60,62.10,974.00,0.00,'2026-11-15 23:25:01'),(98,27.60,62.10,991.00,0.00,'2026-11-15 23:25:03'),(99,27.50,62.10,989.00,0.00,'2026-11-15 23:25:06'),(100,27.50,62.10,987.00,0.00,'2026-11-15 23:25:09'),(101,27.50,62.10,987.00,0.00,'2026-11-15 23:25:11'),(102,27.50,62.10,983.00,0.00,'2026-11-15 23:25:14'),(103,27.50,62.10,978.00,0.00,'2026-11-15 23:25:16'),(104,27.50,62.10,747.00,0.00,'2026-11-15 23:25:19'),(105,27.50,62.10,750.00,0.00,'2026-11-15 23:25:21'),(106,27.50,62.10,971.00,0.00,'2026-11-15 23:25:24'),(107,27.50,62.10,964.00,0.00,'2026-11-15 23:25:26'),(108,27.50,62.10,963.00,0.00,'2026-11-15 23:25:29'),(109,27.50,62.10,952.00,0.00,'2026-11-15 23:25:31'),(110,27.41,63.88,805.00,15.00,'2026-11-16 06:38:28'),(111,29.00,62.50,959.00,0.00,'2026-11-15 23:40:54'),(112,29.00,62.50,571.00,0.00,'2026-11-15 23:40:56'),(113,29.00,62.40,730.00,0.00,'2026-11-15 23:40:59'),(114,29.00,62.50,1400.00,0.00,'2026-11-15 23:41:01'),(115,29.00,62.70,1398.00,0.00,'2026-11-15 23:41:03'),(116,29.00,62.80,1402.00,0.00,'2026-11-15 23:41:06'),(117,29.00,62.80,1399.00,0.00,'2026-11-15 23:41:08'),(118,29.10,62.80,1396.00,0.00,'2026-11-15 23:41:11'),(119,29.10,62.70,1398.00,0.00,'2026-11-15 23:41:14'),(120,29.10,62.70,1398.00,0.00,'2026-11-15 23:41:16'),(121,29.10,62.60,1398.00,0.00,'2026-11-15 23:41:18'),(122,29.10,62.50,1399.00,0.00,'2026-11-15 23:41:21'),(123,29.10,62.40,1396.00,0.00,'2026-11-15 23:41:23'),(124,29.10,62.30,1399.00,0.00,'2026-11-15 23:41:26'),(125,29.10,62.20,1399.00,0.00,'2026-11-15 23:41:28'),(126,29.10,62.10,1403.00,0.00,'2026-11-15 23:41:31'),(127,29.10,62.10,1397.00,0.00,'2026-11-15 23:41:33'),(128,29.10,62.60,1389.00,0.00,'2026-11-15 23:41:36'),(129,29.10,63.70,1124.00,1.00,'2026-11-15 23:41:39'),(130,29.20,64.20,1322.00,0.00,'2026-11-15 23:41:41'),(131,29.20,66.70,1360.00,4.00,'2026-11-15 23:41:43'),(132,29.30,70.80,1396.00,0.00,'2026-11-15 23:41:46'),(133,29.40,74.50,1395.00,0.00,'2026-11-15 23:41:48'),(134,29.50,77.80,1397.00,0.00,'2026-11-15 23:41:51'),(135,29.70,80.60,1396.00,0.00,'2026-11-15 23:41:53'),(136,29.80,82.90,1396.00,0.00,'2026-11-15 23:41:56'),(137,29.90,85.00,1399.00,0.00,'2026-11-15 23:41:59'),(138,29.90,85.90,1395.00,0.00,'2026-11-15 23:42:01'),(139,30.00,83.20,1396.00,0.00,'2026-11-15 23:42:03'),(140,30.00,80.80,1396.00,0.00,'2026-11-15 23:42:06'),(141,30.00,78.30,1236.00,0.00,'2026-11-15 23:42:08'),(142,30.10,76.00,492.00,0.00,'2026-11-15 23:42:11'),(143,30.10,74.00,854.00,0.00,'2026-11-15 23:42:14'),(144,30.10,72.20,364.00,0.00,'2026-11-15 23:42:16'),(145,30.10,70.80,0.00,0.00,'2026-11-15 23:42:18'),(146,30.10,69.60,1104.00,0.00,'2026-11-15 23:42:21'),(147,30.20,68.50,837.00,0.00,'2026-11-15 23:42:23'),(148,30.20,67.50,836.00,0.00,'2026-11-15 23:42:26'),(149,30.20,66.60,843.00,0.00,'2026-11-15 23:42:28'),(150,30.20,65.80,844.00,0.00,'2026-11-15 23:42:31'),(151,30.20,64.80,213.00,0.00,'2026-11-15 23:42:33'),(152,30.20,64.20,204.00,0.00,'2026-11-15 23:42:36'),(153,30.20,63.70,205.00,0.00,'2026-11-15 23:42:38'),(154,30.20,63.30,807.00,0.00,'2026-11-15 23:42:41'),(155,30.20,62.90,814.00,0.00,'2026-11-15 23:42:43'),(156,30.10,62.60,811.00,0.00,'2026-11-15 23:42:46'),(157,30.20,62.30,820.00,0.00,'2026-11-15 23:42:48'),(158,30.20,62.00,826.00,0.00,'2026-11-15 23:42:51'),(159,30.20,61.80,821.00,0.00,'2026-11-15 23:42:53'),(160,30.20,61.50,185.00,0.00,'2026-11-15 23:42:56'),(161,30.20,61.30,503.00,0.00,'2026-11-15 23:42:59'),(162,30.20,61.10,184.00,0.00,'2026-11-15 23:43:01'),(163,30.20,61.10,599.00,0.00,'2026-11-15 23:43:03'),(164,30.10,61.10,825.00,0.00,'2026-11-15 23:43:06'),(165,30.10,61.00,827.00,0.00,'2026-11-15 23:43:08'),(166,30.10,61.00,833.00,0.00,'2026-11-15 23:43:11'),(167,30.10,60.90,824.00,0.00,'2026-11-15 23:43:13'),(168,30.10,60.80,826.00,0.00,'2026-11-15 23:43:16'),(169,30.10,60.70,827.00,0.00,'2026-11-15 23:43:18'),(170,30.10,60.60,827.00,0.00,'2026-11-15 23:43:21'),(171,30.10,60.60,837.00,0.00,'2026-11-15 23:43:23'),(172,30.10,60.60,830.00,0.00,'2026-11-15 23:43:26'),(173,30.10,60.40,840.00,0.00,'2026-11-15 23:43:28'),(174,30.10,60.30,803.00,0.00,'2026-11-15 23:43:31'),(175,30.10,60.20,854.00,0.00,'2026-11-15 23:43:33'),(176,30.10,60.10,693.00,0.00,'2026-11-15 23:43:36'),(177,30.10,60.10,841.00,0.00,'2026-11-15 23:43:38'),(178,30.10,60.10,818.00,0.00,'2026-11-15 23:43:41'),(179,30.10,60.20,841.00,0.00,'2026-11-15 23:43:44'),(180,30.10,60.40,838.00,0.00,'2026-11-15 23:43:46'),(181,30.10,60.50,836.00,0.00,'2026-11-15 23:43:48'),(182,30.10,60.50,835.00,0.00,'2026-11-15 23:43:51'),(183,30.10,60.40,836.00,0.00,'2026-11-15 23:43:53'),(184,30.10,60.40,837.00,0.00,'2026-11-15 23:43:57'),(185,30.10,60.40,854.00,0.00,'2026-11-15 23:43:59'),(186,30.10,60.30,854.00,0.00,'2026-11-15 23:44:01'),(187,30.10,60.40,854.00,0.00,'2026-11-15 23:44:03'),(188,30.10,60.40,854.00,0.00,'2026-11-15 23:44:06'),(189,30.10,60.40,860.00,0.00,'2026-11-15 23:44:11'),(190,30.10,60.30,854.00,0.00,'2026-11-15 23:44:14'),(191,30.10,60.30,854.00,0.00,'2026-11-15 23:44:14'),(192,30.10,60.30,854.00,0.00,'2026-11-15 23:44:16'),(193,30.10,60.30,841.00,0.00,'2026-11-15 23:44:19'),(194,30.10,60.30,854.00,0.00,'2026-11-15 23:44:21'),(195,30.10,60.20,861.00,0.00,'2026-11-15 23:44:24'),(196,30.10,60.20,854.00,0.00,'2026-11-15 23:44:26'),(197,30.10,60.20,854.00,0.00,'2026-11-15 23:44:28'),(198,30.10,60.10,854.00,0.00,'2026-11-15 23:44:31'),(199,30.00,60.10,854.00,0.00,'2026-11-15 23:44:34'),(200,30.10,60.00,854.00,0.00,'2026-11-15 23:44:36'),(201,30.10,60.00,843.00,0.00,'2026-11-15 23:44:38'),(202,30.10,59.90,854.00,0.00,'2026-11-15 23:44:41'),(203,30.10,59.90,854.00,0.00,'2026-11-15 23:44:44'),(204,30.10,60.00,842.00,0.00,'2026-11-15 23:44:46'),(205,30.10,59.90,285.00,0.00,'2026-11-15 23:44:49'),(206,30.10,59.90,254.00,0.00,'2026-11-15 23:44:51'),(207,30.00,59.90,854.00,0.00,'2026-11-15 23:44:53'),(208,30.10,60.00,842.00,0.00,'2026-11-15 23:44:56'),(209,30.00,60.00,854.00,0.00,'2026-11-15 23:44:59'),(210,30.10,60.20,843.00,0.00,'2026-11-15 23:45:01'),(211,30.00,60.30,854.00,0.00,'2026-11-15 23:45:03'),(212,30.00,60.20,854.00,0.00,'2026-11-15 23:45:06'),(213,30.00,60.20,854.00,0.00,'2026-11-15 23:45:13'),(214,30.00,60.10,854.00,0.00,'2026-11-15 23:45:13'),(215,30.00,60.10,854.00,0.00,'2026-11-15 23:45:15'),(216,30.00,60.00,835.00,0.00,'2026-11-15 23:45:16'),(217,30.00,60.00,838.00,0.00,'2026-11-15 23:45:18'),(218,30.00,59.90,779.00,0.00,'2026-11-15 23:45:21'),(219,30.00,60.00,769.00,0.00,'2026-11-15 23:45:23'),(220,30.00,60.10,782.00,0.00,'2026-11-15 23:45:27'),(221,30.00,60.10,797.00,0.00,'2026-11-15 23:45:32'),(222,30.00,60.10,800.00,0.00,'2026-11-15 23:45:32'),(223,30.00,60.10,809.00,0.00,'2026-11-15 23:45:33'),(224,30.00,60.10,796.00,0.00,'2026-11-15 23:45:36'),(225,30.00,60.00,804.00,0.00,'2026-11-15 23:45:38');
/*!40000 ALTER TABLE `data_sensor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jadwal_pakan`
--

DROP TABLE IF EXISTS `jadwal_pakan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jadwal_pakan` (
  `id` int NOT NULL AUTO_INCREMENT,
  `waktu` time NOT NULL,
  `jumlah` decimal(8,2) NOT NULL DEFAULT '2.50',
  `hari` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Semua Hari',
  `catatan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jadwal_pakan`
--

LOCK TABLES `jadwal_pakan` WRITE;
/*!40000 ALTER TABLE `jadwal_pakan` DISABLE KEYS */;
INSERT INTO `jadwal_pakan` VALUES (101,'06:00:00',2.50,'Semua Hari','Pakan 1',1,'2026-10-22 07:46:48'),(102,'16:00:00',2.50,'Semua Hari','Pakan 2',1,'2026-10-22 07:46:48'),(104,'19:28:00',0.00,'Semua Hari','Pakan Sore',1,'2026-10-27 12:27:31'),(105,'08:00:00',0.00,'Semua Hari','Pakan Pagi',1,'2026-10-27 13:08:11'),(106,'08:00:00',2.50,'Semua Hari','z',1,'2026-11-02 06:40:43');
/*!40000 ALTER TABLE `jadwal_pakan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_harian`
--

DROP TABLE IF EXISTS `log_harian`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_harian` (
  `id` int NOT NULL AUTO_INCREMENT,
  `waktu` time NOT NULL,
  `suhu` decimal(5,2) NOT NULL,
  `kelembaban` decimal(5,2) NOT NULL,
  `cahaya` decimal(8,2) DEFAULT '1240.00',
  `level_air` decimal(5,2) DEFAULT '72.00',
  `pakan` decimal(8,2) unsigned DEFAULT NULL,
  `minum` decimal(8,2) unsigned DEFAULT NULL,
  `lampu` enum('Hidup','Mati') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Mati',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_harian`
--

LOCK TABLES `log_harian` WRITE;
/*!40000 ALTER TABLE `log_harian` DISABLE KEYS */;
INSERT INTO `log_harian` VALUES (121,'05:00:00',24.00,71.00,270.00,72.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(122,'06:00:00',25.00,70.00,201.00,76.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(123,'07:00:00',26.00,68.00,805.00,72.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(124,'08:00:00',27.00,66.00,788.00,69.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(125,'09:00:00',28.00,64.00,1156.00,77.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(126,'10:00:00',29.00,63.00,1452.00,78.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(127,'11:00:00',30.00,61.00,1417.00,84.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(128,'12:00:00',30.00,60.00,1832.00,83.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(129,'13:00:00',31.00,59.00,1380.00,83.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(130,'14:00:00',31.00,58.00,1784.00,70.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(131,'15:00:00',30.00,60.00,1035.00,76.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(132,'16:00:00',29.00,62.00,823.00,75.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(133,'17:00:00',28.00,64.00,1119.00,72.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(134,'18:00:00',27.00,66.00,342.00,74.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(135,'19:00:00',27.00,67.00,156.00,83.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(136,'20:00:00',26.00,68.00,0.00,75.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(137,'21:00:00',26.00,69.00,0.00,72.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(138,'22:00:00',25.00,70.00,0.00,81.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(139,'23:00:00',25.00,71.00,0.00,84.00,7.50,0.00,'Mati','2026-05-19 03:01:53'),(140,'06:43:47',28.70,61.60,378.00,86.00,7.50,0.00,'Mati','2026-06-02 04:43:47'),(141,'06:16:33',26.80,73.80,323.00,72.00,7.50,0.00,'Mati','2026-06-03 04:16:33'),(142,'13:19:56',31.00,73.20,1373.00,69.00,7.50,0.00,'Mati','2026-09-04 11:19:56'),(143,'01:08:07',31.20,62.20,0.00,70.00,7.50,0.00,'Mati','2026-09-28 23:08:07'),(144,'07:03:31',29.80,60.00,1038.00,69.00,7.50,0.00,'Mati','2026-10-22 05:03:31'),(145,'09:45:29',27.10,73.90,1071.00,81.00,7.50,0.00,'Mati','2026-10-25 08:45:29'),(146,'01:33:26',29.50,73.50,1240.00,72.00,7.50,0.00,'Mati','2026-10-26 01:33:26'),(147,'23:27:08',26.80,68.80,1240.00,72.00,7.50,0.00,'Mati','2026-10-26 23:27:08'),(148,'06:39:19',27.10,74.00,1240.00,72.00,7.50,0.00,'Mati','2026-11-02 06:39:19'),(149,'06:51:33',27.80,72.10,1240.00,72.00,7.50,0.00,'Mati','2026-11-06 06:51:33'),(150,'06:55:08',30.60,59.00,1240.00,72.00,7.50,0.00,'Mati','2026-11-10 06:55:08'),(151,'03:27:26',31.20,68.00,1240.00,72.00,7.50,0.00,'Mati','2026-11-16 03:27:26');
/*!40000 ALTER TABLE `log_harian` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_pemberian_pakan`
--

DROP TABLE IF EXISTS `log_pemberian_pakan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_pemberian_pakan` (
  `id` int NOT NULL AUTO_INCREMENT,
  `jadwal_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `waktu` datetime NOT NULL,
  `metode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Otomatis',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Berhasil',
  `keterangan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_log_pakan_jadwal` (`jadwal_id`),
  KEY `fk_log_pakan_user` (`user_id`),
  CONSTRAINT `fk_log_pakan_jadwal` FOREIGN KEY (`jadwal_id`) REFERENCES `jadwal_pakan` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_log_pakan_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_pemberian_pakan`
--

LOCK TABLES `log_pemberian_pakan` WRITE;
/*!40000 ALTER TABLE `log_pemberian_pakan` DISABLE KEYS */;
INSERT INTO `log_pemberian_pakan` VALUES (1,NULL,NULL,'2026-10-25 16:00:00','Otomatis','Berhasil','Pemberian pakan sore sesuai jadwal','2026-10-25 13:04:19'),(2,NULL,NULL,'2026-10-25 12:00:00','Otomatis','Berhasil','Pemberian pakan siang sesuai jadwal','2026-10-25 13:04:19'),(3,NULL,NULL,'2026-10-25 08:30:00','Manual','Berhasil','Pemberian pakan manual via dispenser','2026-10-25 13:04:19'),(4,NULL,NULL,'2026-10-25 06:00:00','Otomatis','Berhasil','Pemberian pakan pagi sesuai jadwal','2026-10-25 13:04:19'),(5,NULL,NULL,'2026-10-24 16:00:00','Otomatis','Berhasil','Pemberian pakan sore sesuai jadwal','2026-10-25 13:04:19'),(6,NULL,NULL,'2026-10-24 12:00:00','Otomatis','Berhasil','Pemberian pakan siang sesuai jadwal','2026-10-25 13:04:19'),(7,NULL,NULL,'2026-10-24 06:00:00','Otomatis','Berhasil','Pemberian pakan pagi sesuai jadwal','2026-10-25 13:04:19'),(8,NULL,NULL,'2026-10-25 20:26:31','Manual','Berhasil','Pemberian pakan manual via dispenser','2026-10-25 13:26:31'),(9,NULL,NULL,'2026-10-26 14:21:33','Manual','Berhasil','Pemberian pakan manual via dispenser','2026-10-26 07:21:33'),(10,NULL,NULL,'2026-10-27 19:26:59','Manual','Berhasil','Pemberian pakan manual via dispenser','2026-10-27 12:26:59'),(11,NULL,NULL,'2026-11-02 13:40:15','Manual','Berhasil','Pemberian pakan manual via dispenser','2026-11-02 06:40:15'),(12,NULL,NULL,'2026-11-02 13:40:16','Manual','Berhasil','Pemberian pakan manual via dispenser','2026-11-02 06:40:16'),(13,NULL,NULL,'2026-11-10 14:03:48','Manual','Berhasil','Pemberian pakan manual via dispenser','2026-11-10 07:03:48'),(14,NULL,NULL,'2026-11-16 13:28:06','Manual','Berhasil','Pemberian pakan manual via dispenser','2026-11-16 06:28:06'),(15,NULL,NULL,'2026-11-16 13:28:13','Manual','Berhasil','Pemberian pakan manual via dispenser','2026-11-16 06:28:13'),(16,NULL,NULL,'2026-11-16 14:57:24','Manual','Berhasil','Pemberian pakan manual via dispenser','2026-11-16 07:57:24'),(17,NULL,NULL,'2026-11-16 14:57:26','Manual','Berhasil','Pemberian pakan manual via dispenser','2026-11-16 07:57:26');
/*!40000 ALTER TABLE `log_pemberian_pakan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifikasi`
--

DROP TABLE IF EXISTS `notifikasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifikasi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `pesan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipe` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'success',
  `waktu_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_notifikasi_user` (`user_id`),
  CONSTRAINT `fk_notifikasi_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifikasi`
--

LOCK TABLES `notifikasi` WRITE;
/*!40000 ALTER TABLE `notifikasi` DISABLE KEYS */;
INSERT INTO `notifikasi` VALUES (1,NULL,'ESP32 terhubung','success','08:07 - 10 Okt 2026',1,'2026-10-22 07:56:48'),(2,NULL,'Suhu kembali normal','success','12:15 - 10 Okt 2026',1,'2026-10-22 07:56:48'),(3,NULL,'Level air mulai rendah (72%)','warning','14:32 - 10 Okt 2026',1,'2026-10-22 07:56:48'),(4,NULL,'Pakan diberikan otomatis','success','16:00 - 10 Okt 2026',1,'2026-10-22 07:56:48'),(5,NULL,'Kipas diubah ke Menyala','info','09:46 - 25 Okt 2026',1,'2026-10-25 08:46:29'),(6,NULL,'Kipas diubah ke Mati','info','09:46 - 25 Okt 2026',1,'2026-10-25 08:46:32'),(7,NULL,'Motor Pakan diubah ke Jadwal Aktif','info','10:15 - 25 Okt 2026',1,'2026-10-25 09:15:08'),(8,NULL,'Motor Pakan diubah ke Jadwal Aktif','info','10:15 - 25 Okt 2026',1,'2026-10-25 09:15:11'),(9,NULL,'Motor Pakan diubah ke Mati','info','11:36 - 25 Okt 2026',1,'2026-10-25 10:36:20'),(10,NULL,'Motor Pakan diubah ke Jadwal Aktif','info','11:36 - 25 Okt 2026',1,'2026-10-25 10:36:20'),(11,NULL,'Lampu diubah ke Menyala','info','11:36 - 25 Okt 2026',1,'2026-10-25 10:36:24'),(12,NULL,'Lampu diubah ke Mati','info','11:36 - 25 Okt 2026',1,'2026-10-25 10:36:25'),(13,NULL,'Lampu diubah ke Menyala','info','11:36 - 25 Okt 2026',1,'2026-10-25 10:36:25'),(14,NULL,'Lampu diubah ke Mati','info','11:36 - 25 Okt 2026',1,'2026-10-25 10:36:26'),(15,NULL,'Lampu diubah ke Menyala','info','11:36 - 25 Okt 2026',1,'2026-10-25 10:36:26'),(16,NULL,'Lampu diubah ke Mati','info','11:36 - 25 Okt 2026',1,'2026-10-25 10:36:27'),(17,NULL,'Lampu diubah ke Menyala','info','11:36 - 25 Okt 2026',1,'2026-10-25 10:36:27'),(18,NULL,'Lampu diubah ke Mati','info','11:36 - 25 Okt 2026',1,'2026-10-25 10:36:27'),(19,NULL,'Lampu diubah ke Menyala','info','11:36 - 25 Okt 2026',1,'2026-10-25 10:36:27'),(20,NULL,'Lampu diubah ke Mati','info','11:36 - 25 Okt 2026',1,'2026-10-25 10:36:27'),(21,NULL,'Lampu diubah ke Menyala','info','11:36 - 25 Okt 2026',1,'2026-10-25 10:36:27'),(22,NULL,'Lampu diubah ke Mati','info','11:36 - 25 Okt 2026',1,'2026-10-25 10:36:28'),(23,NULL,'Motor Pakan diubah ke Jadwal Aktif','info','12:29 - 25 Okt 2026',1,'2026-10-25 11:29:19'),(24,NULL,'Motor Pakan diubah ke Jadwal Aktif','info','12:29 - 25 Okt 2026',1,'2026-10-25 11:29:22'),(25,NULL,'Semua aktuator dinyalakan secara manual','info','13:01 - 25 Okt 2026',1,'2026-10-25 12:01:36'),(26,NULL,'Semua aktuator dinyalakan secara manual','info','13:01 - 25 Okt 2026',1,'2026-10-25 12:01:36'),(27,NULL,'Semua aktuator dinyalakan secara manual','info','13:01 - 25 Okt 2026',1,'2026-10-25 12:01:38'),(28,NULL,'Aktuator disinkronkan kembali ke mode otomasi mikroklimat','info','13:01 - 25 Okt 2026',1,'2026-10-25 12:01:40'),(29,NULL,'Aktuator disinkronkan kembali ke mode otomasi mikroklimat','info','13:01 - 25 Okt 2026',1,'2026-10-25 12:01:41'),(30,NULL,'Kipas Ventilasi diubah ke Mati','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:45'),(31,NULL,'Kipas Ventilasi diubah ke Mati','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:47'),(32,NULL,'Heater Pemanas diubah ke Mati','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:48'),(33,NULL,'Lampu Penerangan diubah ke Mati','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:49'),(34,NULL,'Motor Pakan diubah ke Mati','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:50'),(35,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:53'),(36,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:54'),(37,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:54'),(38,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:54'),(39,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:55'),(40,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:55'),(41,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:55'),(42,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:55'),(43,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:55'),(44,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:56'),(45,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:56'),(46,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:56'),(47,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:56'),(48,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:56'),(49,NULL,'Semua aktuator dinyalakan secara manual','info','13:02 - 25 Okt 2026',1,'2026-10-25 12:02:56'),(50,NULL,'Semua aktuator dinyalakan secara manual','info','13:03 - 25 Okt 2026',1,'2026-10-25 12:03:00'),(51,NULL,'Kipas Ventilasi diubah ke Menyala','info','13:03 - 25 Okt 2026',1,'2026-10-25 12:03:02'),(52,NULL,'Heater Pemanas diubah ke Mati','info','13:03 - 25 Okt 2026',1,'2026-10-25 12:03:02'),(53,NULL,'Kipas Ventilasi diubah ke Menyala','info','13:03 - 25 Okt 2026',1,'2026-10-25 12:03:04'),(54,NULL,'Heater Pemanas diubah ke Mati','info','13:03 - 25 Okt 2026',1,'2026-10-25 12:03:04'),(55,NULL,'Semua aktuator berhasil dimatikan','info','13:03 - 25 Okt 2026',1,'2026-10-25 12:03:06'),(56,NULL,'Heater Pemanas diubah ke Mati','info','13:03 - 25 Okt 2026',1,'2026-10-25 12:03:09'),(57,NULL,'Kipas Ventilasi diubah ke Menyala','info','13:03 - 25 Okt 2026',1,'2026-10-25 12:03:09'),(58,NULL,'Heater Pemanas diubah ke Menyala','info','13:04 - 25 Okt 2026',1,'2026-10-25 12:04:44'),(59,NULL,'Heater Pemanas diubah ke Mati','info','13:04 - 25 Okt 2026',1,'2026-10-25 12:04:45'),(60,NULL,'Motor Pakan diubah ke Menyala','info','13:04 - 25 Okt 2026',1,'2026-10-25 12:04:50'),(61,NULL,'Motor Pakan diubah ke Mati','info','13:04 - 25 Okt 2026',1,'2026-10-25 12:04:51'),(62,NULL,'Lampu Penerangan diubah ke Menyala','info','13:04 - 25 Okt 2026',1,'2026-10-25 12:04:52'),(63,NULL,'Lampu Penerangan diubah ke Mati','info','13:04 - 25 Okt 2026',1,'2026-10-25 12:04:52'),(64,NULL,'Motor Pakan diubah ke Menyala','info','13:58 - 25 Okt 2026',1,'2026-10-25 12:58:27'),(65,NULL,'Semua aktuator berhasil dimatikan','info','14:01 - 25 Okt 2026',1,'2026-10-25 13:01:02'),(66,NULL,'Kipas Ventilasi diubah ke Menyala','info','14:01 - 25 Okt 2026',1,'2026-10-25 13:01:26'),(67,NULL,'Kipas Ventilasi diubah ke Mati','info','14:01 - 25 Okt 2026',1,'2026-10-25 13:01:31'),(68,NULL,'Heater Pemanas diubah ke Menyala','info','14:01 - 25 Okt 2026',1,'2026-10-25 13:01:32'),(69,NULL,'Heater Pemanas diubah ke Mati','info','14:01 - 25 Okt 2026',1,'2026-10-25 13:01:34'),(70,NULL,'Heater Pemanas diubah ke Menyala','info','14:01 - 25 Okt 2026',1,'2026-10-25 13:01:44'),(71,NULL,'Motor Pakan diubah ke Menyala','info','14:26 - 25 Okt 2026',1,'2026-10-25 13:26:31'),(72,NULL,'Motor Pakan diubah ke Menyala','info','07:21 - 26 Okt 2026',1,'2026-10-26 07:21:33'),(73,NULL,'Semua aktuator berhasil dimatikan','info','07:27 - 26 Okt 2026',1,'2026-10-26 07:27:08'),(74,NULL,'Semua aktuator berhasil dimatikan','info','07:27 - 26 Okt 2026',1,'2026-10-26 07:27:10'),(75,NULL,'Semua aktuator berhasil dimatikan','info','07:27 - 26 Okt 2026',1,'2026-10-26 07:27:11'),(76,NULL,'Semua aktuator berhasil dimatikan','info','07:27 - 26 Okt 2026',1,'2026-10-26 07:27:13'),(77,NULL,'Semua aktuator berhasil dimatikan','info','07:27 - 26 Okt 2026',1,'2026-10-26 07:27:14'),(78,NULL,'Semua aktuator berhasil dimatikan','info','07:27 - 26 Okt 2026',1,'2026-10-26 07:27:15'),(79,NULL,'Kipas Ventilasi diubah ke Menyala','info','11:52 - 27 Okt 2026',1,'2026-10-27 11:52:12'),(80,NULL,'Kipas Ventilasi diubah ke Mati','info','11:52 - 27 Okt 2026',1,'2026-10-27 11:52:13'),(81,NULL,'Motor Pakan diubah ke Menyala','info','12:26 - 27 Okt 2026',0,'2026-10-27 12:26:59'),(82,NULL,'Kipas Ventilasi diubah ke Mati','info','12:28 - 27 Okt 2026',0,'2026-10-27 12:28:33'),(83,NULL,'Lampu Penerangan diubah ke Mati','info','12:28 - 27 Okt 2026',0,'2026-10-27 12:28:35'),(84,NULL,'Motor Pakan diubah ke Mati','info','12:28 - 27 Okt 2026',0,'2026-10-27 12:28:36'),(85,NULL,'Lampu Penerangan diubah ke Mati','info','12:28 - 27 Okt 2026',0,'2026-10-27 12:28:38'),(86,NULL,'Semua aktuator berhasil dimatikan','info','12:28 - 27 Okt 2026',0,'2026-10-27 12:28:39'),(87,NULL,'Semua aktuator berhasil dimatikan','info','12:28 - 27 Okt 2026',0,'2026-10-27 12:28:42'),(88,NULL,'Kipas Ventilasi diubah ke Menyala','info','06:40 - 2 Nov 2026',0,'2026-11-02 06:40:11'),(89,NULL,'Kipas Ventilasi diubah ke Mati','info','06:40 - 2 Nov 2026',0,'2026-11-02 06:40:11'),(90,NULL,'Lampu Penerangan diubah ke Menyala','info','06:40 - 2 Nov 2026',0,'2026-11-02 06:40:13'),(91,NULL,'Lampu Penerangan diubah ke Mati','info','06:40 - 2 Nov 2026',0,'2026-11-02 06:40:13'),(92,NULL,'Motor Pakan diubah ke Menyala','info','06:40 - 2 Nov 2026',0,'2026-11-02 06:40:15'),(93,NULL,'Motor Pakan diubah ke Mati','info','06:40 - 2 Nov 2026',0,'2026-11-02 06:40:15'),(94,NULL,'Motor Pakan diubah ke Menyala','info','06:40 - 2 Nov 2026',0,'2026-11-02 06:40:16'),(95,NULL,'Motor Pakan diubah ke Mati','info','06:40 - 2 Nov 2026',0,'2026-11-02 06:40:18'),(96,NULL,'Kipas Ventilasi diubah ke Menyala','info','07:00 - 10 Nov 2026',0,'2026-11-10 07:00:29'),(97,NULL,'Lampu Penerangan diubah ke Menyala','info','07:00 - 10 Nov 2026',0,'2026-11-10 07:00:31'),(98,NULL,'Motor Pakan diubah ke Menyala','info','07:03 - 10 Nov 2026',0,'2026-11-10 07:03:48'),(99,NULL,'Kipas Ventilasi diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:05'),(100,NULL,'Lampu Penerangan diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:07'),(101,NULL,'Motor Pakan diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:08'),(102,NULL,'Motor Pakan diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:11'),(103,NULL,'Lampu Penerangan diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:12'),(104,NULL,'Kipas Ventilasi diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:14'),(105,NULL,'Kipas Ventilasi diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:15'),(106,NULL,'Lampu Penerangan diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:16'),(107,NULL,'Motor Pakan diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:17'),(108,NULL,'Kipas Ventilasi diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:19'),(109,NULL,'Lampu Penerangan diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:22'),(110,NULL,'Motor Pakan diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:23'),(111,NULL,'Semua aktuator berhasil dimatikan','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:26'),(112,NULL,'Semua aktuator dinyalakan secara manual','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:28'),(113,NULL,'Semua aktuator berhasil dimatikan','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:29'),(114,NULL,'Semua aktuator berhasil dimatikan','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:31'),(115,NULL,'Kipas Ventilasi diubah ke Menyala','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:33'),(116,NULL,'Lampu Penerangan diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:34'),(117,NULL,'Lampu Penerangan diubah ke Menyala','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:35'),(118,NULL,'Lampu Penerangan diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:35'),(119,NULL,'Motor Pakan diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:38'),(120,NULL,'Kipas Ventilasi diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:39'),(121,NULL,'Lampu Penerangan diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:41'),(122,NULL,'Motor Pakan diubah ke Mati','info','07:04 - 10 Nov 2026',0,'2026-11-10 07:04:43'),(123,NULL,'Semua aktuator dinyalakan secara manual','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:01'),(124,NULL,'Semua aktuator berhasil dimatikan','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:02'),(125,NULL,'Semua aktuator berhasil dimatikan','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:04'),(126,NULL,'Semua aktuator berhasil dimatikan','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:07'),(127,NULL,'Semua aktuator dinyalakan secara manual','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:08'),(128,NULL,'Semua aktuator berhasil dimatikan','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:09'),(129,NULL,'Semua aktuator dinyalakan secara manual','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:12'),(130,NULL,'Semua aktuator berhasil dimatikan','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:13'),(131,NULL,'Kipas Ventilasi diubah ke Menyala','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:16'),(132,NULL,'Aktuator disinkronkan kembali ke mode otomasi mikroklimat','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:18'),(133,NULL,'Aktuator disinkronkan kembali ke mode otomasi mikroklimat','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:19'),(134,NULL,'Semua aktuator berhasil dimatikan','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:21'),(135,NULL,'Semua aktuator berhasil dimatikan','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:23'),(136,NULL,'Semua aktuator berhasil dimatikan','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:23'),(137,NULL,'Semua aktuator berhasil dimatikan','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:24'),(138,NULL,'Semua aktuator berhasil dimatikan','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:27'),(139,NULL,'Semua aktuator berhasil dimatikan','info','07:11 - 10 Nov 2026',0,'2026-11-10 07:11:29'),(140,NULL,'Motor Pakan diubah ke Menyala','info','06:28 - 16 Nov 2026',0,'2026-11-16 06:28:06'),(141,NULL,'Motor Pakan diubah ke Menyala','info','06:28 - 16 Nov 2026',0,'2026-11-16 06:28:13'),(142,NULL,'Motor Pakan diubah ke Mati','info','06:28 - 16 Nov 2026',0,'2026-11-16 06:28:35'),(143,NULL,'Motor Pakan diubah ke Mati','info','06:28 - 16 Nov 2026',0,'2026-11-16 06:28:44'),(144,NULL,'Kipas Ventilasi diubah ke Mati','info','06:28 - 16 Nov 2026',0,'2026-11-16 06:28:50'),(145,NULL,'Lampu Penerangan diubah ke Mati','info','06:28 - 16 Nov 2026',0,'2026-11-16 06:28:52'),(146,NULL,'PERINGATAN: Level air tandon kritis (1%). Segera isi ulang!','danger','Baru saja',0,'2026-11-16 06:41:39'),(147,NULL,'Lampu Penerangan diubah ke Menyala','info','07:57 - 16 Nov 2026',0,'2026-11-16 07:57:20'),(148,NULL,'Motor Pakan diubah ke Menyala','info','07:57 - 16 Nov 2026',0,'2026-11-16 07:57:24'),(149,NULL,'Motor Pakan diubah ke Mati','info','07:57 - 16 Nov 2026',0,'2026-11-16 07:57:25'),(150,NULL,'Motor Pakan diubah ke Menyala','info','07:57 - 16 Nov 2026',0,'2026-11-16 07:57:26'),(151,NULL,'Motor Pakan diubah ke Mati','info','07:57 - 16 Nov 2026',0,'2026-11-16 07:57:27'),(152,NULL,'Lampu Penerangan diubah ke Mati','info','07:57 - 16 Nov 2026',0,'2026-11-16 07:57:31'),(153,NULL,'Kipas Ventilasi diubah ke Mati','info','07:57 - 16 Nov 2026',0,'2026-11-16 07:57:33');
/*!40000 ALTER TABLE `notifikasi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `user_id` (`user_id`),
  KEY `token_2` (`token`),
  CONSTRAINT `fk_password_resets_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
INSERT INTO `password_resets` VALUES (3,1,'210fb51bfac1101d585b7996f5b865f92aa1bec09268d90e76c9b4aea92c6244','2026-10-26 16:55:04','2026-10-26 15:55:18','2026-10-26 08:55:04');
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pengaturan_kandang`
--

DROP TABLE IF EXISTS `pengaturan_kandang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pengaturan_kandang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nama_kandang` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Kandang 1 - Utama',
  `tanggal_masuk_ayam` date DEFAULT '2026-10-07',
  `suhu_min` decimal(5,2) NOT NULL DEFAULT '24.00',
  `suhu_maks` decimal(5,2) NOT NULL DEFAULT '34.00',
  `kelembaban_min` decimal(5,2) NOT NULL DEFAULT '55.00',
  `kelembaban_maks` decimal(5,2) NOT NULL DEFAULT '75.00',
  `cahaya_min` decimal(8,2) NOT NULL DEFAULT '500.00',
  `level_air_min` decimal(5,2) NOT NULL DEFAULT '50.00',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pengaturan_kandang`
--

LOCK TABLES `pengaturan_kandang` WRITE;
/*!40000 ALTER TABLE `pengaturan_kandang` DISABLE KEYS */;
INSERT INTO `pengaturan_kandang` VALUES (1,'Kandang 1 - Utama','2026-10-07',24.00,34.00,55.00,75.00,500.00,50.00,'2026-10-22 06:59:29');
/*!40000 ALTER TABLE `pengaturan_kandang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nama_lengkap` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Bima Apriliansyah',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'admin',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','Bima Apriliansyah','admin@chickguard.local','$2y$10$UeUjnUBkCbR9tOokwPCmHeedzMFEq91pbOFo2HjpdvUihlBpMsij.','admin','2026-05-05 12:36:45');
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

-- Dump completed on 2026-11-17  9:57:11

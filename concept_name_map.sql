-- MySQL dump 10.13  Distrib 5.1.67, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: migration_database
-- ------------------------------------------------------
-- Server version	5.1.67-0ubuntu0.10.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `concept_name_map`
--

DROP TABLE IF EXISTS `concept_name_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `concept_name_map` (
  `drug_id` int(11) DEFAULT NULL,
  `bart_one_concept_name` varchar(255) DEFAULT NULL,
  `bart_two_concept_name` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `concept_name_map`
--

LOCK TABLES `concept_name_map` WRITE;
/*!40000 ALTER TABLE `concept_name_map` DISABLE KEYS */;
INSERT INTO `concept_name_map` VALUES (1,'Snake bites','Snake bite'), (2,'Intestinal worms','Worms, intestinal'),(3,'Diabetis','Diabetes'),(4,'Absess','Abscess'),(5,'Arthlagia','Arthralgia'),(6,'Mylagia','Myalgia'),(7,'Mylagia','Myalgia'),(8,'Septic Arthritis','Septic athritis'), (9,'Sexually transmitted infections','Sexually transmitted infection'), (10,'Typhoid','Typhoid fever'), (11,'Peripheral Neuritis/Neuropathy','Peripheral neuropathy'), (12,'Diarrhoea disease(non-bloody)','Diarrhoea diseases'), (13, 'Soft Tissue Injury (Excluding Joints)', 'Soft Tissue Injury'), (14,'Sprains (Joint Soft Tissue Injury)','Soft Tissue Injury'), (14,'Upper respiratory infection','Recurrent upper respiratory infection'), (15, 'Juvinile Arthritis','Juvenile rheumatoid arthritis'), (16, 'Road Traffic Accidents','Road traffic accident'), (17, 'Other Animal Bites','Bite, animal'), (18, 'Other skin conditions','Other skin condition'), (19, '397','Clinical malaria'), (20,'Sprains','Sprain'), (21,'Folic','Folic acid'),(22,'Chloramphonicol','Chloramphenicol'),(23,'Doxycline','Doxycycline'),(24,'Isosorbide','Isosorbide Dinitrate'),(25,'Isosorbide','Isosorbide Dinitrate'),(26,'Isosorbide','Isosorbide Dinitrate'),(27,'Morphine','Morphine sulphate'),(28,'Magnesium','IMagnesium trisilicate'),(29,'Nalidixic','Nalidixic acid'),(30,'Lumefantrine/Artemether','Artemether and Lumefantrine'), (31,'Propantheline','Propantheline bromide'), (32,'Premethazine','Promethazine');
/*!40000 ALTER TABLE `concept_name_map` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-02-07 10:39:32

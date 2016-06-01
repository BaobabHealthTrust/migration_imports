CREATE DATABASE  IF NOT EXISTS `hotline_intermediate_bare_bones` /*!40100 DEFAULT CHARACTER SET big5 */;
USE `hotline_intermediate_bare_bones`;
-- MySQL dump 10.13  Distrib 5.5.47, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: hotline_intermediate_bare_bones
-- ------------------------------------------------------
-- Server version	5.5.47-0ubuntu0.14.04.1

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
-- Table structure for table `baby_delivery_encounters`
--

DROP TABLE IF EXISTS `baby_delivery_encounters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `baby_delivery_encounters`(
`id` int NOT NULL AUTO_INCREMENT,
`visit_encounter_id` int NOT NULL,
`old_enc_id` int NOT NULL,
`patient_id` int NOT NULL,
`delivered` varchar(255),
`call_id` varchar(255),
`health_facility_name` varchar(255),
`delivery_date`date,
`delivery_location` varchar(255),
`location` varchar(255),
`encounter_datetime` date NOT NULL,
`date_created` date NOT NULL,
`creator` varchar(255),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=big5;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `baby_delivery_encounters`
--

LOCK TABLES `baby_delivery_encounters` WRITE;
/*!40000 ALTER TABLE `baby_delivery_encounters` DISABLE KEYS */;
/*!40000 ALTER TABLE `baby_delivery_encounters` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

--
-- Table structure for table `anc_visit_encounters`
--

DROP TABLE IF EXISTS `anc_visit_encounters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anc_visit_encounters`(
`id` int NOT NULL AUTO_INCREMENT,
`visit_encounter_id` int NOT NULL,
`old_enc_id` int NOT NULL,
`patient_id` int NOT NULL,
`antenatal_clinic_patient_appointment` varchar(255),
`call_id` varchar(255),
`reason_for_not_attending_anc` varchar(255),
`last_anc_visit_date` date,
`next_anc_visit_date` date,
`location` varchar(255),
`encounter_datetime` date NOT NULL,
`date_created` date NOT NULL,
`creator` varchar(255),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=big5;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `anc_visit_encounters`
--

LOCK TABLES `anc_visit_encounters` WRITE;
/*!40000 ALTER TABLE `anc_visit_encounters` DISABLE KEYS */;
/*!40000 ALTER TABLE `anc_visit_encounters` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

--
-- Table structure for table `birth_plan_encounters`
--

DROP TABLE IF EXISTS `birth_plan_encounters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `birth_plan_encounters`(
`id` int NOT NULL AUTO_INCREMENT,
`visit_encounter_id` int NOT NULL,
`old_enc_id` int NOT NULL,
`patient_id` int NOT NULL,
`go_to_hospital_date`  date,
`call_id`  varchar(255),
`delivery_location` varchar(255),
`birth_plan` varchar(255),
`location` varchar(255),
`encounter_datetime` date NOT NULL,
`date_created` date NOT NULL,
`creator` varchar(255),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=big5;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `birth_plan_encounters`
--

LOCK TABLES `birth_plan_encounters` WRITE;
/*!40000 ALTER TABLE `birth_plan_encounters` DISABLE KEYS */;
/*!40000 ALTER TABLE `birth_plan_encounters` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

--
-- Table structure for table `child_health_symptoms_encounters`
--

DROP TABLE IF EXISTS `child_health_symptoms_encounters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `child_health_symptoms_encounters`(
`id` int NOT NULL AUTO_INCREMENT,
`visit_encounter_id` int NOT NULL,
`old_enc_id` int NOT NULL,
`patient_id` int NOT NULL,
`diarrhea` varchar(255),
`cough` varchar(255),
`fast_breathing` varchar(255),
`skin_dryness` varchar(255),
`eye_infection` varchar(255),
`fever` varchar(255),
`vomiting` varchar(255),
`other` varchar(255),
`crying` varchar(255),
`not_eating` varchar(255),
`very_sleepy` varchar(255),
`unconscious` varchar(255),
`sleeping` varchar(255),
`feeding_problems` varchar(255),
`bowel_movements` varchar(255),
`skin_infections` varchar(255),
`umbilicus_infection` varchar(255),
`growth_milestones` varchar(255),
`accessing_healthcare_services` varchar(255),
`fever_of_7_days_or_more` varchar(255),
`diarrhea_for_14_days_or_more` varchar(255),
`blood_in_stool` varchar(255),
`cough_for_21_days_or_more` varchar(255),
`not_eating_or_drinking_anything` varchar(255),
`red_eye_for_4_days_or_more_with_visual_problems` varchar(255),
`potential_chest_indrawing` varchar(255),
`call_id` varchar(255),
`very_sleepy_or_unconscious` varchar(255),
`convulsions_sign` varchar(255),
`convulsions_symptom` varchar(255),
`skin_rashes` varchar(255),
`vomiting_everything` varchar(255),
`swollen_hands_or_feet_sign` varchar(255),
`severity_of_fever` varchar(255),
`severity_of_cough` varchar(255),
`severity_of_red_eye` varchar(255),
`severity_of_diarrhea` varchar(255),
`visual_problems` varchar(255),
`gained_or_lost_weight` varchar(255),
`location` varchar(255),
`encounter_datetime` date NOT NULL,
`date_created` date NOT NULL,
`creator` varchar(255),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=big5;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `child_health_symptoms_encounters`
--

LOCK TABLES `child_health_symptoms_encounters` WRITE;
/*!40000 ALTER TABLE `child_health_symptoms_encounters` DISABLE KEYS */;
/*!40000 ALTER TABLE `child_health_symptoms_encounters` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;


--
-- Table structure for table `maternal_health_symptoms_encounters`
--

DROP TABLE IF EXISTS `maternal_health_symptoms_encounters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `maternal_health_symptoms_encounters`(
`id` int NOT NULL AUTO_INCREMENT,
`visit_encounter_id` int NOT NULL,
`old_enc_id` int NOT NULL,
`patient_id` int NOT NULL,
`abdominal_pain` varchar(255),
`method_of_family_planning` varchar(255),
`patient_using_family_planning` varchar(255),
`current_complaints_or_symptoms` varchar(255),
`family_planning` varchar(255),
`other` varchar(255),
`infertility` varchar(255),
`acute_abdominal_pain` varchar(255),
`vaginal_bleeding_during_pregnancy` varchar(255),
`postnatal_bleeding` varchar(255),
`healthcare_visits` varchar(255),
`nutrition` varchar(255),
`body_changes` varchar(255),
`discomfort` varchar(255),
`concerns` varchar(255),
`emotions` varchar(255),
`warning_signs` varchar(255),
`routines` varchar(255),
`beliefs` varchar(255),
`babys_growth` varchar(255),
`milestones` varchar(255),
`prevention` varchar(255),
`heavy_vaginal_bleeding_during_pregnancy` varchar(255),
`excessive_postnatal_bleeding` varchar(255),
`severe_headache` varchar(255),
`call_id` varchar(255),
`fever_during_pregnancy_sign` varchar(255),
`fever_during_pregnancy_symptom` varchar(255),
`postnatal_fever_sign` varchar(255),
`postnatal_fever_symptom` varchar(255),
`headaches` varchar(255),
`fits_or_convulsions_sign` varchar(255),
`fits_or_convulsions_symptom` varchar(255),
`swollen_hands_or_feet_sign` varchar(255),
`swollen_hands_or_feet_symptom` varchar(255),
`paleness_of_the_skin_and_tiredness_sign` varchar(255),
`paleness_of_the_skin_and_tiredness_symptom` varchar(255),
`no_fetal_movements_sign` varchar(255),
`no_fetal_movements_symptom` varchar(255),
`water_breaks_sign` varchar(255),
`water_breaks_symptom` varchar(255),
`postnatal_discharge_bad_smell` varchar(255),
`problems_with_monthly_periods` varchar(255),
`frequent_miscarriages` varchar(255),
`vaginal_bleeding_not_during_pregnancy` varchar(255),
`vaginal_itching` varchar(255),
`birth_planning_male` varchar(255),
`birth_planning_female` varchar(255),
`satisfied_with_family_planning_method` varchar(255),
`require_information_on_family_planning` varchar(255),
`problems_with_family_planning_method` varchar(255),
`location` varchar(255),
`encounter_datetime` date NOT NULL,
`date_created` date NOT NULL,
`creator` varchar(255),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=big5;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maternal_health_symptoms_encounters`
--

LOCK TABLES `maternal_health_symptoms_encounters` WRITE;
/*!40000 ALTER TABLE `maternal_health_symptoms_encounters` DISABLE KEYS */;
/*!40000 ALTER TABLE `maternal_health_symptoms_encounters` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;


--
-- Table structure for table `pregnancy_status_encounters`
--

DROP TABLE IF EXISTS `pregnancy_status_encounters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pregnancy_status_encounters`(
`id` int NOT NULL AUTO_INCREMENT,
`visit_encounter_id` int NOT NULL,
`old_enc_id` int NOT NULL,
`patient_id` int NOT NULL,
`pregnancy_status` varchar(255),
`call_id` varchar(255),
`pregnancy_due_date` date,
`delivery_date` date,
`location` varchar(255),
`encounter_datetime` date NOT NULL,
`date_created` date NOT NULL,
`creator` varchar(255),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=big5;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pregnancy_status_encounters`
--

LOCK TABLES `pregnancy_status_encounters` WRITE;
/*!40000 ALTER TABLE `pregnancy_status_encounters` DISABLE KEYS */;
/*!40000 ALTER TABLE `pregnancy_status_encounters` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;


--
-- Table structure for table `registration_encounters`
--

DROP TABLE IF EXISTS `registration_encounters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `registration_encounters`(
`id` int NOT NULL AUTO_INCREMENT,
`visit_encounter_id` int NOT NULL,
`old_enc_id` int NOT NULL,
`patient_id` int NOT NULL,
`call_id` varchar(255),
`location` varchar(255),
`encounter_datetime` date NOT NULL,
`date_created` date NOT NULL,
`creator` varchar(255) ,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=big5;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registration_encounters`
--

LOCK TABLES `registration_encounters` WRITE;
/*!40000 ALTER TABLE `registration_encounters` DISABLE KEYS */;
/*!40000 ALTER TABLE `registration_encounters` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;


--
-- Table structure for table `tips_and_reminders_encounters`
--

DROP TABLE IF EXISTS `tips_and_reminders_encounters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tips_and_reminders_encounters`(
`id` int NOT NULL AUTO_INCREMENT,
`visit_encounter_id` int NOT NULL,
`old_enc_id` int NOT NULL,
`patient_id` int NOT NULL,
`telephone_number` varchar(255),
`telephone_number_type` varchar(255),
`who_is_present_as_quardian` varchar(255),
`call_id` varchar(255),
`on_tips_and_reminders` varchar(255),
`type_of_message` varchar(255),
`language_preference` varchar(255),
`type_of_message_content` varchar(255),
`location` varchar(255),
`encounter_datetime` date NOT NULL,
`date_created` date NOT NULL,
`creator` varchar(255),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=big5;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tips_and_reminders_encounters`
--

LOCK TABLES `tips_and_reminders_encounters` WRITE;
/*!40000 ALTER TABLE `tips_and_reminders_encounters` DISABLE KEYS */;
/*!40000 ALTER TABLE `tips_and_reminders_encounters` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

--
-- Table structure for table `update_outcomes_encounters`
--

DROP TABLE IF EXISTS `update_outcomes_encounters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `update_outcomes_encounters`(
`id` int NOT NULL AUTO_INCREMENT,
`visit_encounter_id`  int NOT NULL,
`old_enc_id` int NOT NULL,
`patient_id` int NOT NULL,
`outcome` varchar(255),
`call_id` varchar(255),
`health_facility_name` varchar(255),
`reason_for_referral` varchar(255),
`secondary_outcome` varchar(255),
`location` varchar(255),
`encounter_datetime` date NOT NULL,
`date_created` date NOT NULL,
`creator`  varchar(255),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=big5;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `update_outcomes_encounters`
--

LOCK TABLES `update_outcomes_encounters` WRITE;
/*!40000 ALTER TABLE `update_outcomes_encounters` DISABLE KEYS */;
/*!40000 ALTER TABLE `update_outcomes_encounters` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

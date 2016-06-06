-- MySQL dump 10.13  Distrib 5.1.53, for apple-darwin10.3.0 (i386)
--
-- Host: localhost    Database: bart2_development
-- ------------------------------------------------------
-- Server version	5.1.53

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


-- Table structure for table `call_log'
DROP TABLE IF EXISTS `call_log`;

CREATE TABLE `call_log` (
  `call_log_id` int(11) NOT NULL DEFAULT '0',
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `call_type` int(1),
  `person_id` int(11),
  `district` int(11),
  `creator` int(11),
  PRIMARY KEY (`call_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Table structure for table `call_log_update'
DROP TABLE IF EXISTS call_log_update;

CREATE TABLE call_log_update (
    call_id int(11),
    creator_id int(11)
);

-- Table structure for table `clinic_schedule'
DROP TABLE IF EXISTS `clinic_schedule`;

CREATE TABLE `clinic_schedule` (
	`clinic_schedule_id` int(11) NOT NULL AUTO_INCREMENT,
	`location_id` int(11) NOT NULL DEFAULT '0',
	`clinic_name_id` int(11) NOT NULL DEFAULT '0',
	`clinic_day_id` int(11) NOT NULL DEFAULT '0',
	`created_by` int(11) NOT NULL DEFAULT '0',
	`date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
	`changed_by` int(11) DEFAULT NULL,
	`date_changed` datetime DEFAULT NULL,
	`voided` tinyint(1) NOT NULL DEFAULT '0',
	`voided_by` int(11) DEFAULT NULL,
	`date_voided` datetime DEFAULT NULL,
	`void_reason` varchar(255) DEFAULT NULL,
	PRIMARY KEY (`clinic_schedule_id`),
	KEY `locations` (`location_id`),
	KEY `clinic_days` (`clinic_day_id`),
	KEY `clinic_names` (`clinic_name_id`),
	KEY `clinic_schedule_creators` (`created_by`),
	KEY `clinic_schedule_mutators` (`changed_by`),
	KEY `clinic_schedule_destructors` (`voided_by`),
	CONSTRAINT `locations` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`),
	CONSTRAINT `clinic_days` FOREIGN KEY (`clinic_day_id`) REFERENCES `concept` (`concept_id`),
	CONSTRAINT `clinic_names` FOREIGN KEY (`clinic_name_id`) REFERENCES `concept` (`concept_id`),
	CONSTRAINT `clinic_schedule_creators` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`),
	CONSTRAINT `clinic_schedule_mutators` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
	CONSTRAINT `clinic_schedule_destructors` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`))
	ENGINE=InnoDB DEFAULT CHARSET=utf8

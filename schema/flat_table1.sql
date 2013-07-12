-- MySQL dump 10.13  Distrib 5.5.29, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: bart_triggers
-- ------------------------------------------------------
-- Server version	5.5.29-0ubuntu0.12.04.2

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
-- Table structure for table `flat_table1`
--

DROP TABLE IF EXISTS `flat_table1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flat_table1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` int(11) NOT NULL,
  `given_name` varchar(50) DEFAULT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `family_name` varchar(50) DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `dob_estimated` varchar(255) DEFAULT NULL,
  `ta` varchar(50) DEFAULT NULL,
  `current_address` varchar(255) DEFAULT NULL,
  `home_district` varchar(255) DEFAULT NULL,
  `landmark` varchar(255) DEFAULT NULL,
  `cellphone_number` varchar(255) DEFAULT NULL,
  `home_phone_number` varchar(255) DEFAULT NULL,
  `office_phone_number` varchar(255) DEFAULT NULL,
  `occupation` varchar(255) DEFAULT NULL,
  `nat_id` varchar(255) DEFAULT NULL,
  `arv_number` varchar(255) DEFAULT NULL,
  `pre_art_number` varchar(255) DEFAULT NULL,
  `tb_number` varchar(255) DEFAULT NULL,
  `legacy_id` varchar(255) DEFAULT NULL,
  `legacy_id2` varchar(255) DEFAULT NULL,
  `legacy_id3` varchar(255) DEFAULT NULL,
  `new_nat_id` varchar(255) DEFAULT NULL,
  `prev_art_number` varchar(255) DEFAULT NULL,
  `filing_number` varchar(255) DEFAULT NULL,
  `archived_filing_number` varchar(255) DEFAULT NULL,
  `ever_received_art` varchar(255) DEFAULT NULL,
  `earliest_start_date` date default NULL,
  `date_art_last_taken` date DEFAULT NULL,
  `taken_art_in_last_two_months` varchar(255) DEFAULT NULL,
  `taken_art_in_last_two_weeks` varchar(255) DEFAULT NULL,
  `last_art_drugs_taken` varchar(255) DEFAULT NULL,
  `ever_registered_at_art_clinic` varchar(255) DEFAULT NULL,
  `has_transfer_letter` varchar(255) DEFAULT NULL,
  `location_of_art_initialization` varchar(255) DEFAULT NULL,
  `art_start_date_estimation` varchar(255) DEFAULT NULL,
  `date_started_art` date DEFAULT NULL,
  `cd4_count_location` varchar(255) DEFAULT NULL,
  `cd4_count` int(11) DEFAULT NULL,
  `cd4_count_modifier` varchar(255) DEFAULT NULL,
  `cd4_count_percent` float DEFAULT NULL,
  `cd4_count_datetime` date DEFAULT NULL,
  `cd4_percent_less_than_25` varchar(255) DEFAULT NULL,
  `cd4_count_less_than_250` varchar(255) DEFAULT NULL,
  `cd4_count_less_than_350` varchar(255) DEFAULT NULL,
  `lymphocyte_count_date` date DEFAULT NULL,
  `lymphocyte_count` int(11) DEFAULT NULL,
  `asymptomatic` varchar(255) DEFAULT NULL,
  `persistent_generalized_lymphadenopathy` varchar(255) DEFAULT NULL,
  `unspecified_stage_1_cond` varchar(255) DEFAULT NULL,
  `molluscumm_contagiosum` varchar(255) DEFAULT NULL,
  `wart_virus_infection_extensive` varchar(255) DEFAULT NULL,
  `oral_ulcerations_recurrent` varchar(255) DEFAULT NULL,
  `parotid_enlargement_persistent_unexplained` varchar(255) DEFAULT NULL,
  `lineal_gingival_erythema` varchar(255) DEFAULT NULL,
  `herpes_zoster` varchar(255) DEFAULT NULL,
  `respiratory_tract_infections_recurrent` varchar(255) DEFAULT NULL,
  `unspecified_stage2_condition` varchar(255) DEFAULT NULL,
  `angular_chelitis` varchar(255) DEFAULT NULL,
  `papular_pruritic_eruptions` varchar(255) DEFAULT NULL,
  `hepatosplenomegaly_unexplained` varchar(255) DEFAULT NULL,
  `oral_hairy_leukoplakia` varchar(255) DEFAULT NULL,
  `severe_weight_loss` varchar(255) DEFAULT NULL,
  `fever_persistent_unexplained` varchar(255) DEFAULT NULL,
  `pulmonary_tuberculosis` varchar(255) DEFAULT NULL,
  `pulmonary_tuberculosis_last_2_years` varchar(255) DEFAULT NULL,
  `severe_bacterial_infection` varchar(255) DEFAULT NULL,
  `bacterial_pnuemonia` varchar(255) DEFAULT NULL,
  `symptomatic_lymphoid_interstitial_pnuemonitis` varchar(255) DEFAULT NULL,
  `chronic_hiv_assoc_lung_disease` varchar(255) DEFAULT NULL,
  `unspecified_stage3_condition` varchar(255) DEFAULT NULL,
  `aneamia` varchar(255) DEFAULT NULL,
  `neutropaenia` varchar(255) DEFAULT NULL,
  `thrombocytopaenia_chronic` varchar(255) DEFAULT NULL,
  `diarhoea` varchar(255) DEFAULT NULL,
  `oral_candidiasis` varchar(255) DEFAULT NULL,
  `acute_necrotizing_ulcerative_gingivitis` varchar(255) DEFAULT NULL,
  `lymph_node_tuberculosis` varchar(255) DEFAULT NULL,
  `toxoplasmosis_of_the_brain` varchar(255) DEFAULT NULL,
  `cryptococcal_meningitis` varchar(255) DEFAULT NULL,
  `progressive_multifocal_leukoencephalopathy` varchar(255) DEFAULT NULL,
  `disseminated_mycosis` varchar(255) DEFAULT NULL,
  `candidiasis_of_oesophagus` varchar(255) DEFAULT NULL,
  `extrapulmonary_tuberculosis` varchar(255) DEFAULT NULL,
  `cerebral_non_hodgkin_lymphoma` varchar(255) DEFAULT NULL,
  `hiv_encephalopathy` varchar(255) DEFAULT NULL,
  `bacterial_infections_severe_recurrent` varchar(255) DEFAULT NULL,
  `unspecified_stage_4_condition` varchar(255) DEFAULT NULL,
  `pnuemocystis_pnuemonia` varchar(255) DEFAULT NULL,
  `disseminated_non_tuberculosis_mycobacterial_infection` varchar(255) DEFAULT NULL,
  `cryptosporidiosis` varchar(255) DEFAULT NULL,
  `isosporiasis` varchar(255) DEFAULT NULL,
  `symptomatic_hiv_associated_nephropathy` varchar(255) DEFAULT NULL,
  `chronic_herpes_simplex_infection` varchar(255) DEFAULT NULL,
  `cytomegalovirus_infection` varchar(255) DEFAULT NULL,
  `toxoplasomis_of_the_brain_1month` varchar(255) DEFAULT NULL,
  `recto_vaginal_fitsula` varchar(255) DEFAULT NULL,
  `moderate_weight_loss_less_than_or_equal_to_10_percent_unexpl` varchar(255) DEFAULT NULL,
  `seborrhoeic_dermatitis` varchar(255) DEFAULT NULL,
  `hepatitis_b_or_c_infection` varchar(255) DEFAULT NULL,
  `kaposis_sarcoma` varchar(255) DEFAULT NULL,
  `non_typhoidal_salmonella_bacteraemia_recurrent` varchar(255) DEFAULT NULL,
  `leishmaniasis_atypical_disseminated` varchar(255) DEFAULT NULL,
  `cerebral_or_b_cell_non_hodgkin_lymphoma` varchar(255) DEFAULT NULL,
  `invasive_cancer_of_cervix` varchar(255) DEFAULT NULL,
  `reason_for_eligibility` varchar(255) DEFAULT NULL,
  `who_stage` varchar(255) DEFAULT NULL,
  `send_sms` varchar(255) DEFAULT NULL,
  `agrees_to_followup` varchar(255) DEFAULT NULL,
  `type_of_confirmatory_hiv_test` varchar(255) DEFAULT NULL,
  `confirmatory_hiv_test_location` varchar(255) DEFAULT NULL,
  `confirmatory_hiv_test_date` varchar(255) DEFAULT NULL,
  `date_created` date DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `extrapulmonary_tuberculosis_v_date` DATE DEFAULT NULL,
  `pulmonary_tuberculosis_v_date` DATE DEFAULT NULL,
  `pulmonary_tuberculosis_last_2_years_v_date` DATE DEFAULT NULL,
  `kaposis_sarcoma_v_date` DATE DEFAULT NULL,
  `reason_for_starting_v_date` DATE DEFAULT NULL,
  `ever_registered_at_art_v_date` DATE DEFAULT NULL,
  `date_art_last_taken_v_date` DATE DEFAULT NULL,
  `taken_art_in_last_two_months_v_date` DATE DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flat_table1`
--

LOCK TABLES `flat_table1` WRITE;
/*!40000 ALTER TABLE `flat_table1` DISABLE KEYS */;
/*!40000 ALTER TABLE `flat_table1` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-03-26 11:22:11

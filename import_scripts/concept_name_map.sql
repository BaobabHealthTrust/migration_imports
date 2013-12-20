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
  `concept_id` int(11) DEFAULT NULL,
  `bart_one_concept_name` varchar(255) DEFAULT NULL,
  `bart_two_concept_name` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `concept_name_map`
--

LOCK TABLES `concept_name_map` WRITE;
/*!40000 ALTER TABLE `concept_name_map` DISABLE KEYS */;
INSERT INTO `concept_name_map` VALUES (1,'Snake bites','Snake bite'), (2,'Intestinal worms','Worms, intestinal'),(3,'Diabetis','Diabetes'),(4,'Absess','Abscess'),(5,'Arthlagia','Arthralgia'),(7,'Mylagia','Myalgia'),(8,'Septic Arthritis','Septic athritis'), (9,'Sexually transmitted infections','Sexually transmitted infection'), (10,'Typhoid','Typhoid fever'), (11,'Peripheral Neuritis/Neuropathy','Peripheral neuropathy'), (12,'Diarrhoea disease(non-bloody)','Diarrhoea diseases'), (13, 'Soft Tissue Injury (Excluding Joints)', 'Soft Tissue Injury'), (14,'Sprains (Joint Soft Tissue Injury)','Soft Tissue Injury'), (14,'Upper respiratory infection','Recurrent upper respiratory infection'), (15, 'Juvinile Arthritis','Juvenile rheumatoid arthritis'), (16, 'Road Traffic Accidents','Road traffic accident'), (17, 'Other Animal Bites','Bite, animal'), (18, 'Other skin conditions','Other skin condition'), (19, '397','Clinical malaria'), (20,'Sprains','Sprain'), (21,'Folic','Folic acid'),(22,'Chloramphonicol','Chloramphenicol'),(23,'Doxycline','Doxycycline'),(24,'Isosorbide','Isosorbide Dinitrate'),(27,'Morphine','Morphine sulphate'),(28,'Magnesium','IMagnesium trisilicate'),(29,'Nalidixic','Nalidixic acid'),(30,'Lumefantrine/Artemether','Artemether and Lumefantrine'), (31,'Propantheline','Propantheline bromide'), (32,'Premethazine','Promethazine'),(34,'Height','Height (cm)'),(38,'CD4 percentage','CD4 percent'),(35,'Date of positive HIV test','CONFIRMATORY HIV TEST DATE'),(36,'Location of first positive HIV test','CONFIRMATORY HIV TEST LOCATION'),(48,'Kaposi\'s sarcoma', 'KAPOSIS SARCOMA'),(54,'CD4 Count < 250','CD4 count <= 250'),(57,'CD4 percentage available','CD4 count available'),(58,'CD4 test date','CD4 count datetime'),(71,'ARV number at that site','ART number at previous location'),(89,'CD4 Count < 350','CD4 count <= 350'),(90,'CD4 Count < 750','CD4 count <= 750'),(41,'Date of ART initiation','ART initiation date'),(42,'Persistent generalised lymphadenopathy','persistent generalized lymphadenopathy'),(46,'Extrapulmonary tuberculosis','extrapulmonary tuberculosis (EPTB)'),(45,'Candidiasis of oesophagus, trachea, bronchi or lungs','candidiasis of oseophagus'),(43,'HIV wasting syndrome (severe weight loss + persistent fever or severe loss + chronic diarrhoea)','HIV wasting syndrome (severe weight loss + persistent fever or severe weight loss + chronic diarrhoea)'),(50,'Bacterial infections, severe recurrent (empyema, pyomyositis, bone/joint, meningitis, but excluding pneumonia)','recurrent severe presumed bacterial infections'),(47,'Cerebral or B-cell non-Hodgkin lymphoma','cerebral or B-cell non Hodgkin lymphoma'),(51,'Severe weight loss >10% and/or BMI <18.5kg/m(squared), unexplained','severe weight loss >10% and/or BMI <18.5kg/m^2, unexplained'),(54,'Bacterial pneumonia, recurrent severe','Bacterial pneumonia, severe recurrent'),(53,'Unexplained anaemia, neutropenia or thrombocytopenia','neutropaenia, unexplained < 500 /mm(cubed)'),(53,'Recurrent upper respiratory tract infections (ie, bacterial sinusitis)','recurrent upper respiratory infection'),(66,'Continue treatment at current clinic','Continue treatment at current location'),(86,'Number of condoms given','Number of Condoms dispensed'),(87,'Prescribed Depo provera','Depo-Provera given'),(60,'Prescribe Cotrimoxazole (CPT)','Prescribe cotramoxazole'),(37,'ARV regimen','ARV regimen type'),(55,'Pregnant','patient_pregnant'),(62,'Whole tablets remaining and brought to clinic','Amount of drug brought to clinic'),(63,'Whole tablets remaining but not brought to clinic','Amount of drug remaining at home'),(73,'Vomit','Vomiting'),(84,'Date last ARVs taken','Date ART last taken'),(85,'Taken ARVs in last 2 months','Has the patient taken ART in the last two months'),(69,'Taken ART in last 2 weeks','Has the patient taken ART in the last two weeks'),(70,'Site transferred from','Transfer in from'),(76,'Candidiasis of oesophagus','Candidiasis esophageal'),(77,'Acute necrotizing ulcerative stomatitis gingivitis or periodontitis',' Acute necrotizing ulcerative stomatitis, gingivitis or periodontitis'),(78,'Moderate unexplained wasting / malnutrition not responding to treatment (weight-for-height/ -age 70-79% or MUAC 11-12cm)','Moderate unexplained wasting/malnutrition not responding to treatment (weight-for-height/ -age 70-79% or muac 11-12 cm)'),(79,'Lymph node tuberclosis','lymph node tuberculosis'),(80,'Disseminated non-tuberclosis mycobacterial infection','disseminated non-tuberculosis mycobacterial infection'),(81,'Cryptosporidiosis, chronic with diarrhoea','cryptosporidiosis'),(82,'Cytomegalovirus infection (retinitis or infection of other organs)','Cytomegalovirus infection (retinitis or infection or other organs)'),(61,'Prescribe Insecticide Treated Net (ITN)','Have long-lasting insecticidal nets for malaria been given?'),(39,'Is able to walk unaided','Is able to walk unaided?'),(40,'Is at work/school','Is at work or school?'),(44,'Herpes simplex infection, mucocutaneous for longer than  1 month or visceral','Herpes simplex infection, mucocutaneous for longer than 1 month or visceral'),(49,'Severe unexplained wasting / malnutrition not responding to treatment(weight-for-height/ -age less than 70% or MUAC less than 11cm or oedema)','Severe unexplained wasting or malnutrition not responding to treatment (weight-for-height/ -age <70% or MUAC less than 11cm or oedema)'),(52,'Fever, persistent unexplained (intermittent or constant, > 1 month)','Fever, persistent unexplained, intermittent or constant, >1 month'),(55,'Symptomatic lymphoid interstitial pneumonitis','Symptomatic lymphoid interstitial pneumonia'),(56,'Chronic HIV-associated lung disease including bronchiectasis','Chronic HIV-associated lung disease, including bronchiectasis'),(57,'HIV-associated cardiomyopathy','HIV associated cardiomyopathy'),(58,'HIV-associated nephropathy','HIV associated nephropathy'),(60,'Respiratory tract infections, recurrent(sinusitis, tonsillitis, otitis media, pharyngitis)','Respiratory tract infections, recurrent (sinusitis, tonsilitus, otitis media, pharyngitis)'),(61,'Fungal nail infections','Fungal nail infection'),(52,'Moderate weight loss <10%, unexplained','Moderate weight loss less than or equal to 10 percent, unexplained'),(59,'Unexplained persistent hepatomegaly and splenomegaly','Unexplained persistant heptomegaly and splenomegaly'),(91,'Minor mucocutaneous manifestations (seborrheic dermatitis, prurigo, fungal nail infections, recurrent oral ulcerations, angular cheilitis)','Minor mucocutaneous manifestations (seborrheic dermatitis, prurigo, fungal nail infections, recurrent oral ulcerations, angular chelitis)'),(59,'CD4 percentage < 25','CD4 percent less than 25'),(75,'First positive HIV Test','First positive test'),(83,'Pregnant when art was started','Patient pregnant'), (773, 'Acute Haematogenous Osteomylitis', 'Acute Haematogenous Osteomyelitis'),(780, 'All other surgical condition', 'All other surgical conditions'),(721, 'Bone Tumours', 'Bone Tumor'),(715, 'Chronic Osteomylitis', 'Chronic Osteomyelitis'),(561, 'Chronic psychiatric disorders', 'Chronic psychiatric disorder'),(755, 'Compartment Syndrome', 'Compartment Syndrome'),(720, 'Congenital and Developmental Disorders', 'Congenital and Developmental Disorders'),(771, 'De gloving Wounds', 'Degloving Wounds'),(774, 'Dislocation - Elbow', 'Elbow dislocation'),(757, 'Dislocation - Hip', 'Hip dislocation'),(776, 'Dislocation - Phalanges', 'Phalanges dislocation'),(756, 'Epiphyseal Injury', 'Epiphyseal Injury'),(763, 'Excluding Joints', 'Excluding Joints'),(764, 'Foreign Bodies In the Extremities', 'Foreign body'),(767, 'Nectrotising Fascitis', 'Necrotizing Fasciitis'),(728, 'Osgood Schlaters Disease','Osgood Schlatter disease'),(753, 'Fractures Clavicle', 'Clavicle'),(746, 'Fractures Malleoral', 'Malleolar'),(743, 'Fractures Metacarpals', 'Metacarpal'),(745, 'Fractures Metatarsal', 'Metatarsal'),(751, 'Fractures Spine', 'Spine'),(750, 'Fractures Pelvis', 'Pelvis'),(748, 'Fractures Femur', 'Femur'),(742, 'Fractures Humerus', 'Humerus'),(744, 'Fractures Phalanges', 'Phalanges'),(741, 'Fractures Radius/ulna', 'Radius/ulna'),(747, 'Fractures Tibia/Fibula', 'Tibia/Fibula'),(739, 'Ganglion Cyst', 'Ganglion Cyst'),(760, 'Human Bites', 'Bite, human'),(766, 'Multiple Injuries', 'Multiple Injuries'),(738, 'Muscula Dystrophy', 'Muscular Dystrophy'),(770, 'Muscular skeletal Conditions', 'Other musculoskeletal condition'),(731, 'Myositis Ossificans', 'Myositis ossificans'),(517, 'Neo-natal tetanus', 'Neonatal tetanus'),(735, 'Neurofibromatosis', 'Neurofibromatosis'),(527, 'non-bloody', 'non-bloody'),(754, 'Open Fracture', 'Open fracture' ),(905, 'Osteitis Descans','Osteochondritis dissecans'), (737, 'Osteochondritis',  'Osteochondritis dissecans'),(740, 'Osteochondroma',  'Osteochondroma'),(734, 'Osteoporosis', 'Osteoporosis'),(725, 'Polyarthritis',  'Polyarthritis'),(786, 'Postpartum haemorrhage',  'Postpartum hemorrhage'),(791, 'Severe anaemia in pregnacy','Severe anaemia in pregnancy'),(758, 'Subluxations', 'Subluxation'),(703, 'TB Episode type', 'Tuberculosis'),(769, 'Traumatic Haemarthrosis', 'Traumatic Haemarthrosis'), (1589, 'Traumatic Haemathrosis', 'Traumatic Haemarthrosis');
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

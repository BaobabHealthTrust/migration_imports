# This procedure imports patients first visit encounters from intermediate tables to ART2 OpenMRS database
# ASSUMPTION
# ==========
# The assumption here is your source database name is `bart1_intermediate_bare_bones`
# and the destination any name you prefer.
# This has been necessary because there seems to be no way to use dynamic database 
# names in procedures yet

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_first_visit_encounters`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_first_visit_encounters`(
    IN in_patient_id INT(11)
)
BEGIN
    
    # Declare condition for exiting loop
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE id INT(11);
    DECLARE visit_encounter_id INT(11);
    DECLARE patient_id INT(11);
    DECLARE agrees_to_follow_up VARCHAR(40);
    DECLARE date_of_hiv_pos_test DATE;
    DECLARE date_of_hiv_pos_test_estimated DATE;
    DECLARE location_of_hiv_pos_test VARCHAR(255);
    DECLARE arv_number_at_that_site VARCHAR(255);
    DECLARE location_of_art_initiation VARCHAR(255);
    DECLARE taken_arvs_in_last_two_months VARCHAR(255);
    DECLARE taken_arvs_in_last_two_weeks VARCHAR(255);
    DECLARE has_transfer_letter VARCHAR(255);
    DECLARE site_transferred_from VARCHAR(255);
    DECLARE date_of_art_initiation DATE;
    DECLARE ever_registered_at_art VARCHAR(255);
    DECLARE ever_received_arv VARCHAR(255);
    DECLARE last_arv_regimen VARCHAR(255);
    DECLARE date_last_arv_taken DATE;
    DECLARE date_last_arv_taken_estimated DATE;
    DECLARE voided TINYINT(1);
    DECLARE void_reason VARCHAR(255);
    DECLARE date_voided DATE;
    DECLARE voided_by INT(11);
    DECLARE date_created DATE;
    DECLARE creator INT(11);
    DECLARE visit_id INT(11);
    DECLARE visit_date DATE;
    DECLARE visit_patient_id INT(11);
    
    # Declare and initialise cursor for looping through the table
    DECLARE cur CURSOR FOR SELECT DISTINCT `bart1_intermediate_bare_bones`.`first_visit_encounters`.visit_encounter_id, `bart1_intermediate_bare_bones`.`first_visit_encounters`.patient_id, `bart1_intermediate_bare_bones`.`first_visit_encounters`.agrees_to_follow_up, `bart1_intermediate_bare_bones`.`first_visit_encounters`.date_of_hiv_pos_test, `bart1_intermediate_bare_bones`.`first_visit_encounters`.date_of_hiv_pos_test_estimated, `bart1_intermediate_bare_bones`.`first_visit_encounters`.location_of_hiv_pos_test, `bart1_intermediate_bare_bones`.`first_visit_encounters`.arv_number_at_that_site, `bart1_intermediate_bare_bones`.`first_visit_encounters`.location_of_art_initiation, `bart1_intermediate_bare_bones`.`first_visit_encounters`.taken_arvs_in_last_two_months, `bart1_intermediate_bare_bones`.`first_visit_encounters`.taken_arvs_in_last_two_weeks, `bart1_intermediate_bare_bones`.`first_visit_encounters`.has_transfer_letter, `bart1_intermediate_bare_bones`.`first_visit_encounters`.site_transferred_from, `bart1_intermediate_bare_bones`.`first_visit_encounters`.date_of_art_initiation, `bart1_intermediate_bare_bones`.`first_visit_encounters`.ever_registered_at_art, `bart1_intermediate_bare_bones`.`first_visit_encounters`.ever_received_arv, `bart1_intermediate_bare_bones`.`first_visit_encounters`.last_arv_regimen, `bart1_intermediate_bare_bones`.`first_visit_encounters`.date_last_arv_taken, `bart1_intermediate_bare_bones`.`first_visit_encounters`.date_last_arv_taken_estimated, `bart1_intermediate_bare_bones`.`first_visit_encounters`.voided, `bart1_intermediate_bare_bones`.`first_visit_encounters`.void_reason, `bart1_intermediate_bare_bones`.`first_visit_encounters`.date_voided, `bart1_intermediate_bare_bones`.`first_visit_encounters`.voided_by, `bart1_intermediate_bare_bones`.`first_visit_encounters`.date_created, `bart1_intermediate_bare_bones`.`first_visit_encounters`.creator, COALESCE(`bart1_intermediate_bare_bones`.`visit_encounters`.visit_date, `bart1_intermediate_bare_bones`.`first_visit_encounters`.date_created) FROM `bart1_intermediate_bare_bones`.`first_visit_encounters` 
        LEFT OUTER JOIN bart1_intermediate_bare_bones.visit_encounters ON 
        visit_encounter_id = bart1_intermediate_bare_bones.visit_encounters.id 
        WHERE `bart1_intermediate_bare_bones`.`first_visit_encounters`.`patient_id` = in_patient_id;

    # Declare loop position check
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    # Disable system checks and indexing to speed up processing
    # SET FOREIGN_KEY_CHECKS = 0;
    # SET UNIQUE_CHECKS = 0;
    # SET AUTOCOMMIT = 0;

    # Open cursor
    OPEN cur;
    
    # Declare loop for traversing through the records
    read_loop: LOOP
    
        # Get the fields into the variables declared earlier
        FETCH cur INTO  
            visit_encounter_id, 
            patient_id, 
            agrees_to_follow_up, 
            date_of_hiv_pos_test, 
            date_of_hiv_pos_test_estimated, 
            location_of_hiv_pos_test, 
            arv_number_at_that_site, 
            location_of_art_initiation, 
            taken_arvs_in_last_two_months, 
            taken_arvs_in_last_two_weeks, 
            has_transfer_letter, 
            site_transferred_from, 
            date_of_art_initiation, 
            ever_registered_at_art, 
            ever_received_arv, 
            last_arv_regimen, 
            date_last_arv_taken, 
            date_last_arv_taken_estimated, 
            voided, 
            void_reason, 
            date_voided, 
            voided_by, 
            date_created, 
            creator,  
            visit_date;
        
        # Check if we are done and exit loop if done
        IF done THEN
        
            LEAVE read_loop;
        
        END IF;
    
        # Not done, process the parameters
        
        # Map destination user to source user
        SET @creator = COALESCE((SELECT user_id FROM users WHERE user_id = creator), 1);
    
        # Get id of encounter type
        SET @encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = "HIV CLINIC REGISTRATION");
    
        # Create encounter
        INSERT INTO encounter (encounter_id, encounter_type, patient_id, provider_id, encounter_datetime, creator, date_created, uuid)
        VALUES (visit_encounter_id, @encounter_type, patient_id, @creator, visit_date, @creator, date_created, (SELECT UUID()));
    
        # Check if the field is not empty
        IF NOT ISNULL(agrees_to_follow_up) THEN
        
            # Get concept_id
            SET @agrees_to_follow_up_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Agrees to followup" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @agrees_to_follow_up_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = agrees_to_follow_up AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @agrees_to_follow_up_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = agrees_to_follow_up AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @agrees_to_follow_up_concept_id, visit_encounter_id, visit_date, @agrees_to_follow_up_value_coded, @agrees_to_follow_up_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Check if the field is not empty
        IF NOT ISNULL(date_of_hiv_pos_test) THEN
        
            # Get concept_id
            SET @date_of_hiv_pos_test_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Confirmatory HIV test date" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_datetime, creator, date_created, uuid)
            VALUES (patient_id, @date_of_hiv_pos_test_concept_id, visit_encounter_id, visit_date, date_of_hiv_pos_test, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Check if the field is not empty
        IF NOT ISNULL(location_of_hiv_pos_test) THEN
        
            # Get concept_id
            SET @location_of_hiv_pos_test_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "CONFIRMATORY HIV TEST LOCATION" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
            VALUES (patient_id, @location_of_hiv_pos_test_concept_id, visit_encounter_id, visit_date, location_of_hiv_pos_test, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Check if the field is not empty
        IF NOT ISNULL(arv_number_at_that_site) THEN
        
            # Get concept_id
            SET @arv_number_at_that_site_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "ART number at previous location" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
            VALUES (patient_id, @arv_number_at_that_site_concept_id, visit_encounter_id, visit_date, arv_number_at_that_site, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Check if the field is not empty
        IF NOT ISNULL(location_of_art_initiation) THEN
        
            # Get concept_id
            SET @location_of_art_initiation_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Location of art initialization" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
            VALUES (patient_id, @location_of_art_initiation_concept_id, visit_encounter_id, visit_date, location_of_art_initiation, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Check if the field is not empty
        IF NOT ISNULL(taken_arvs_in_last_two_months) THEN
        
            # Get concept_id
            SET @taken_arvs_in_last_two_months_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Has the patient taken ART in the last two months" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @taken_arvs_in_last_two_months_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = agrees_to_follow_up AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @taken_arvs_in_last_two_months_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = agrees_to_follow_up AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @taken_arvs_in_last_two_months_concept_id, visit_encounter_id, visit_date, @taken_arvs_in_last_two_months_value_coded, @taken_arvs_in_last_two_months_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Check if the field is not empty
        IF NOT ISNULL(taken_arvs_in_last_two_weeks) THEN
        
            # Get concept_id
            SET @taken_arvs_in_last_two_weeks_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Has the patient taken ART in the last two weeks" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @taken_arvs_in_last_two_weeks_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = agrees_to_follow_up AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @taken_arvs_in_last_two_weeks_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = agrees_to_follow_up AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @taken_arvs_in_last_two_weeks_concept_id, visit_encounter_id, visit_date, @taken_arvs_in_last_two_weeks_value_coded, @taken_arvs_in_last_two_weeks_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Check if the field is not empty
        IF NOT ISNULL(has_transfer_letter) THEN
        
            # Get concept_id
            SET @has_transfer_letter_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Has transfer letter" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @has_transfer_letter_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = agrees_to_follow_up AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @has_transfer_letter_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = agrees_to_follow_up AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @has_transfer_letter_concept_id, visit_encounter_id, visit_date, @has_transfer_letter_value_coded, @has_transfer_letter_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Check if the field is not empty
        IF NOT ISNULL(site_transferred_from) THEN
        
            # Get concept_id
            SET @site_transferred_from_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Transferred from" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
            VALUES (patient_id, @site_transferred_from_concept_id, visit_encounter_id, visit_date, site_transferred_from, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Check if the field is not empty
        IF NOT ISNULL(date_of_art_initiation) THEN
        
            # Get concept_id
            SET @date_of_art_initiation_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "ART initiation date" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_datetime, creator, date_created, uuid)
            VALUES (patient_id, @date_of_art_initiation_concept_id, visit_encounter_id, visit_date, date_of_art_initiation, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Check if the field is not empty
        IF NOT ISNULL(ever_registered_at_art) THEN
        
            # Get concept_id
            SET @ever_registered_at_art_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Ever registered at ART clinic" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @ever_registered_at_art_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = agrees_to_follow_up AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @ever_registered_at_art_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = agrees_to_follow_up AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @ever_registered_at_art_concept_id, visit_encounter_id, visit_date, @ever_registered_at_art_value_coded, @ever_registered_at_art_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Check if the field is not empty
        IF NOT ISNULL(ever_received_arv) THEN
        
            # Get concept_id
            SET @ever_received_arv_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Ever received ART" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @ever_received_arv_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = agrees_to_follow_up AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @ever_received_arv_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = agrees_to_follow_up AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @ever_received_arv_concept_id, visit_encounter_id, visit_date, @ever_received_arv_value_coded, @ever_received_arv_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Check if the field is not empty
        IF NOT ISNULL(last_arv_regimen) THEN
        
            # Get concept_id
            SET @last_arv_regimen_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Last ART drugs taken" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
            VALUES (patient_id, @last_arv_regimen_concept_id, visit_encounter_id, visit_date, last_arv_regimen, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Check if the field is not empty
        IF NOT ISNULL(date_last_arv_taken) THEN
        
            # Get concept_id
            SET @date_last_arv_taken_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Date ART last taken" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_datetime, creator, date_created, uuid)
            VALUES (patient_id, @date_last_arv_taken_concept_id, visit_encounter_id, visit_date, date_last_arv_taken, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
    END LOOP;

    # SET UNIQUE_CHECKS = 1;
    # SET FOREIGN_KEY_CHECKS = 1;
    # COMMIT;
    # SET AUTOCOMMIT = 1;

END$$

DELIMITER ;


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
    
        SET @encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = "HIV CLINIC REGISTRATION");
    
        INSERT INTO encounter (encounter_id, encounter_type, patient_id, provider_id, encounter_datetime, creator, date_created, uuid)
        VALUES (visit_encounter_id, @encounter_type, patient_id, @creator, visit_date, @creator, date_created, (SELECT UUID()));
    
    END LOOP;

    # SET UNIQUE_CHECKS = 1;
    # SET FOREIGN_KEY_CHECKS = 1;
    # COMMIT;
    # SET AUTOCOMMIT = 1;

END$$

DELIMITER ;


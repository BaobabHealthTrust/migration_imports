# This procedure imports hiv reception encounters from intermediate tables to ART2 OpenMRS database
# I decided to use default values / hardcoded values to reduce reads

# encounter_type ====> 51
# gurdian_present ====> 6794
# patient_present ====> 1805
# Yes => value_coded: 1065, value_coded_name_id: 1102
# No => value_coded: 1066, value_coded_name_id: 1103

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_hiv_reception`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_hiv_reception`(
    IN in_patient_id INT(11)
)
BEGIN
    
    # Declare condition for exiting loop
    DECLARE done INT DEFAULT FALSE;
    
    # Declare fields to hold our values for our patients
    DECLARE patient_id INT(11);
    DECLARE encounter_id INT(11);
    DECLARE guardian_present VARCHAR(3);
    DECLARE patient_present VARCHAR(3);   
    DECLARE guardian INT(11);
    DECLARE voided TINYINT(1);
    DECLARE void_reason VARCHAR(255);
    DECLARE date_voided DATE;
    DECLARE voided_by INT(11);
    DECLARE date_created DATE;
    DECLARE creator INT(11);
    
    # Declare and initialise cursor for looping through the table
    DECLARE cur CURSOR FOR SELECT * FROM `bart1_intermediate_bare_bones`.`hiv_reception_encounters` 
        WHERE `bart1_intermediate_bare_bones`.`hiv_reception_encounters`.`patient_id` = in_patient_id;

    # Declare loop position check
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    # Open cursor
    OPEN cur;
    
    # Declare loop for traversing through the records
    read_loop: LOOP
    
        # Get the fields into the variables declared earlier
        FETCH cur INTO patient_id, encounter_id, guardian_present, patient_present, guardian, voided, void_reason, date_voided, voided_by, date_created, creator;
    
        # Check if we are done and exit loop if done
        IF done THEN
        
            LEAVE read_loop;
        
        END IF;
    

        # Map destination user to source user
        SET @creator = COALESCE((SELECT user_id FROM users WHERE user_id = creator), 1);
        # Map destination user to source voided_by
        SET @voided_by = COALESCE((SELECT user_id FROM users WHERE user_id = voided_by), 1);
    
        # Create encounter object in destination
        INSERT INTO encounter (patient_id, provider_id, encounter_type,location_id, encounter_datetime, creator, date_created, voided, voided_by, date_voided, void_reason, uuid)
        VALUES (patient_id,1,1,51, date_created, creator, voided, @voided_by, date_voided, void_reason,(SELECT UUID()));

        # Get the latest encounter created
    	SET @encounter_id = (SELECT LAST_INSERT_ID());
    
        # Create Observations if patient has a guardian present
        IF COALESCE(guardian_present, "") != "" THEN
            IF guardian_present = 'Yes' THEN
                INSERT INTO obs (person_id,concept_id,encounter_id, obs_datetime,location_id, value_coded, value_coded_name_id,creator, voided, voided_by, date_voided, void_reason, uuid)
                VALUES (patient_id, 6794, @encounter_id, date_created, 1, 1065, 1102, @creator, voided, @voided_by, date_voided, void_reason, (SELECT UUID()));
            ELSE
                INSERT INTO obs (person_id,concept_id,encounter_id, obs_datetime,location_id, value_coded, value_coded_name_id,creator, voided, voided_by, date_voided, void_reason, uuid)
                VALUES (patient_id, 6794, @encounter_id, date_created, 1, 1066, 1103, @creator, voided, @voided_by, date_voided, void_reason, (SELECT UUID()));
            END IF;
        
        END IF;
        # Create Observation for Patient Present 
        IF COALESCE(patient_present, "") != "" THEN
            IF (patient_present) = 'Yes' THEN
                INSERT INTO obs (person_id,concept_id,encounter_id, obs_datetime,location_id, value_coded, value_coded_name_id,creator, voided, voided_by, date_voided, void_reason, uuid)
                VALUES (patient_id, 1805, @encounter_id, date_created, 1, 1065, 1102, @creator, voided, @voided_by, date_voided, void_reason, (SELECT UUID()));
            ELSE
                INSERT INTO obs (person_id,concept_id,encounter_id, obs_datetime,location_id, value_coded, value_coded_name_id,creator, voided, voided_by, date_voided, void_reason, uuid)
                VALUES (patient_id, 1805, @encounter_id, date_created, 1, 1066, 1103, @creator, voided, @voided_by, date_voided, void_reason, (SELECT UUID()));
            END IF;
        
        END IF;
            
    END LOOP;

END$$

DELIMITER ;

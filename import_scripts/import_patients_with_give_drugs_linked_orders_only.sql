# This procedure imports patients hiv_staging encounters from intermediate tables to ART2 OpenMRS database
# ASSUMPTION
# ==========
# The assumption here is your source database name is `bart1_intermediate_bare_bones`
# and the destination any name you prefer.
# This has been necessary because there seems to be no way to use dynamic database 
# names in procedures yet

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_patients_with_give_drugs_linked_to_orders_only`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_patients_with_give_drugs_linked_to_orders_only`(
#--IN in_patient_id INT(11)
)

BEGIN
    
    # Declare condition for exiting loop
    DECLARE done INT DEFAULT FALSE;

    DECLARE  patient_id int(11);
    
    # Declare and initialise cursor for looping through the table
    DECLARE cur CURSOR FOR SELECT DISTINCT `bart1_intermediate_bare_bones`.`give_drugs_encounters`.patient_id 
    FROM `bart1_intermediate_bare_bones`.`give_drugs_encounters`;
    # Declare loop position check
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
        
    # Disable system checks and indexing to speed up processing
    SET FOREIGN_KEY_CHECKS = 0;
    SET UNIQUE_CHECKS = 0;
    SET AUTOCOMMIT = 0;

    # Open cursor
    OPEN cur;
    
    # Declare loop for traversing through the records
    read_loop: LOOP
    
        # Get the fields into the variables declared earlier
        FETCH cur INTO patient_id;
    
        # Check if we are done and exit loop if done
        IF done THEN
        
            LEAVE read_loop;
        
        END IF;
    
        # Not done, process the parameters
        
        # Map destination user to source user
       
        #--SET @creator = COALESCE((SELECT user_id FROM users WHERE username = creator), 1);
        #--IF ISNULL(dob_estimated) THEN
        #--  SET @date_of_birth_estimated = (false);
        #--ELSE
        #--  SET @date_of_birth_estimated = (dob_estimated);
        #--END IF;

        #--IF ISNULL(dead) THEN
        #--  SET @patient_dead = (0);
        #--ELSE
        #--  SET @patient_dead = (dead);
        #--END IF;

        SET @person_id = (patient_id);

        select patient_id;
        
        select "give_drugs_encounter";        
        CALL proc_import_give_drugs_encounters_linked_to_orders_only(@person_id);                      # good
        
        select patient_id;

    END LOOP;

    SET UNIQUE_CHECKS = 1;
    SET FOREIGN_KEY_CHECKS = 1;
    COMMIT;
    SET AUTOCOMMIT = 1;

END$$

DELIMITER ;


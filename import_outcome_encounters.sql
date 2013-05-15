# This procedure imports outcome encounters from intermediate tables to ART2 OpenMRS database
# I decided to use default values / hardcoded values to reduce database reads

# encounter_type ====> 40
# states :  pre-art             =>  1
#           died                =>  3
#           transfered_out      =>  2
#           treatment_stopped   =>  6
#           on_art              =>  7
#
#  mapping explained    
    -- On Art   => Add a state On_Art 
    -- died     => update person, set died = true and date_died -- This is a terminal state
    -- transfered out   => Update program, set it closed, add state -- This is a terminal state
    -- pre_art  => Add state 
    -- treatment_stopped => Update state -- This is a terminal state

    # Terminal states
    -- Create an Exit from care encounter (119) with associated observations 
#  end mapping

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_outcome_encounter`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_outcome_encounter`(
	IN in_patient_id INT(11)
)
BEGIN
    # Declare condition for exiting loop
    DECLARE done INT DEFAULT FALSE;
    
    # Declare fields to hold our values for our patients
    DECLARE id int(11);
    DECLARE visit_encounter_id int(11);
    DECLARE old_enc_id int(11);
    DECLARE patient_id int(11);
    DECLARE state VARCHAR(255);
    DECLARE outcome_date DATE; 
    DECLARE transfer_out_location VARCHAR(255);
    DECLARE location VARCHAR(255);
    DECLARE voided INT(11);
    DECLARE void_reason VARCHAR(255);
    DECLARE date_voided DATE;
    DECLARE voided_by INT(11);
    DECLARE date_created DATETIME;
    DECLARE creator INT(11);
    
    # Declare and initialise cursor for looping through the table
    DECLARE cur CURSOR FOR SELECT * FROM `bart1_intermediate_bare_bones`.`outcome_encounters`
                           WHERE `bart1_intermediate_bare_bones`.`outcome_encounters`.`patient_id` = in_patient_id;

    # Declare loop position check
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    # Open cursor
    OPEN cur;

    # Declare loop for traversing through the records
    read_loop: LOOP
        # Get the fields into the variables declared earlier
        FETCH cur INTO id, visit_encounter_id, old_enc_id, patient_id, state, outcome_date, transfer_out_location, 
                        location, voided, void_reason, date_voided, voided_by, date_created, creator;
    
        # Check if we are done and exit loop if done
        IF done THEN
        
            LEAVE read_loop;
        
        END IF;

        # Map destination user to source user
        SET @creator = COALESCE((SELECT user_id FROM users WHERE user_id = creator), 1);
        
        # Map destination user to source voided_by
        SET @voided_by = (SELECT user_id FROM users WHERE user_id = voided_by LIMIT 1);
        
        # Map location to source location
        SET @location_id = COALESCE((SELECT location_id FROM location WHERE name = location LIMIT 1), 1);
        
        IF NOT ISNULL() THEN
        ELSE
        END IF;

        # Map encounter_id to source
        SET @encounter_type_id =(SELECT encounter_type_id 
                                            FROM encounter_type 
                                            WHERE name = 'UPDATE OUTCOME' LIMIT 1);
        
        
 
    END LOOP;

END$$

DELIMITER ;


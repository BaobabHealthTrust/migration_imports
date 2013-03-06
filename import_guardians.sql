# This procedure imports patients from intermediate tables to ART2 OpenMRS database
# ASSUMPTION
# ==========
# The assumption here is your source database name is `final_bart1_intermediate_bare_bones`
# and the destination any name you prefer.
# This has been necessary because there seems to be no way to use dynamic database 
# names in procedures yet

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_guardians`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_guardians`(

	)
BEGIN
    
    # Declare condition for exiting loop
    DECLARE done INT DEFAULT FALSE;
    
    # Declare fields to hold our values for our patients
    DECLARE id int(11);
    DECLARE patient_id int(11);
    DECLARE name varchar(255);
    DECLARE relationship varchar(255);
    DECLARE family_name varchar(255);
    DECLARE gender varchar(255);
    DECLARE voided TINYINT(1);
    DECLARE void_reason VARCHAR(255);
    DECLARE date_voided DATE;
    DECLARE voided_by INT(11);
    DECLARE date_created DATE;
    DECLARE creator INT(11);
    DECLARE guardian_id INT(11);
    
    # Declare and initialise cursor for looping through the table
    DECLARE cur CURSOR FOR SELECT `final_bart1_intermediate_bare_bones`.`guardians`.`id`,        `final_bart1_intermediate_bare_bones`.`guardians`.`patient_id`,                              `final_bart1_intermediate_bare_bones`.`guardians`.`name`,                              `final_bart1_intermediate_bare_bones`.`guardians`.`relationship`,                             `final_bart1_intermediate_bare_bones`.`guardians`.`family_name`,                             `final_bart1_intermediate_bare_bones`.`guardians`.`gender`,                 `final_bart1_intermediate_bare_bones`.`guardians`.`voided`,                  `final_bart1_intermediate_bare_bones`.`guardians`.`void_reason`,  `final_bart1_intermediate_bare_bones`.`guardians`.`date_voided`,    `final_bart1_intermediate_bare_bones`.`guardians`.`voided_by`,  `final_bart1_intermediate_bare_bones`.`guardians`.`date_created`,      `final_bart1_intermediate_bare_bones`.`guardians`.`creator`,           `final_bart1_intermediate_bare_bones`.`patients`.guardian_id
                           FROM `final_bart1_intermediate_bare_bones`.`guardians`
                           LEFT OUTER JOIN `final_bart1_intermediate_bare_bones`.`patients`
                           ON `final_bart1_intermediate_bare_bones`.`guardians`.`patient_id` = `final_bart1_intermediate_bare_bones`.`patients`.`patient_id`;

	# Declare loop position check
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	# Open cursor
	OPEN cur;

	# Declare loop for traversing through the records
	read_loop: LOOP

		# Get the fields into the variables declared earlier
		FETCH cur INTO
			id, patient_id, name, relationship, family_name, gender, voided, void_reason, date_voided, voided_by, date_created, creator, guardian_id;

		# Check if we are done and exit loop if done
		IF done THEN

			LEAVE read_loop;

		END IF;

	# Not done, process the parameters

	# Map destination user to source user
	SET @creator = COALESCE((SELECT user_id FROM users WHERE user_id = creator), 1);


  IF (relationship = 'Sister/brother') THEN
    SET @relationship = 'Sibling';
  ELSE
    SET @relationship = relationship;
  END IF;

  SET @relationship_type = (SELECT relationship_type_id FROM relationship_type WHERE a_is_to_b = @relationship);
    
  INSERT INTO relationship (person_a, relationship, person_b, creator, date_created, uuid)
  VALUES (patient_id, @relationship_type, guardian_id, @creator, date_created, (SELECT UUID()));

    END LOOP;

    SET UNIQUE_CHECKS = 1;
    SET FOREIGN_KEY_CHECKS = 1;
    COMMIT;
    SET AUTOCOMMIT = 1;

END$$

DELIMITER ;


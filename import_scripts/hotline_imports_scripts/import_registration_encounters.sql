# This procedure imports data from `hotline_intermediate_bare_bones` to `migration_database`

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_registration_encounters`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_registration_encounters`(
	IN in_patient_id INT(11)
)
BEGIN

	# Declare condition for exiting loop
	DECLARE done INT DEFAULT FALSE;

	DECLARE id int(11);
	DECLARE visit_encounter_id int(11);
	DECLARE old_enc_id int(11);
	DECLARE patient_id int(11);
	DECLARE call_id varchar(255);
	DECLARE location varchar(255);
	DECLARE encounter_datetime datetime;
	DECLARE date_created datetime;
	DECLARE creator varchar(255);
	DECLARE visit_date DATE;

	# Declare and initialise cursor for looping through the table
DECLARE cur CURSOR FOR SELECT DISTINCT `hotline_intermediate_bare_bones`.`registration_encounters`.`id`,
                                       `hotline_intermediate_bare_bones`.`registration_encounters`.`visit_encounter_id`,
																			 `hotline_intermediate_bare_bones`.`registration_encounters`.`old_enc_id`,
																			 `hotline_intermediate_bare_bones`.`registration_encounters`.`patient_id`,
																			 `hotline_intermediate_bare_bones`.`registration_encounters`.`call_id`,
																			 `hotline_intermediate_bare_bones`.`registration_encounters`.`location`,
																			 `hotline_intermediate_bare_bones`.`registration_encounters`.`encounter_datetime`,
																			 `hotline_intermediate_bare_bones`.`registration_encounters`.`date_created`,
																			 `hotline_intermediate_bare_bones`.`registration_encounters`.`creator`, COALESCE(`hotline_intermediate_bare_bones`.`visit_encounters`.visit_date, `hotline_intermediate_bare_bones`.`registration_encounters`.date_created) FROM `hotline_intermediate_bare_bones`.`registration_encounters` LEFT OUTER JOIN `hotline_intermediate_bare_bones`.`visit_encounters` ON
        visit_encounter_id = `hotline_intermediate_bare_bones`.`visit_encounters`.`id`
        WHERE `hotline_intermediate_bare_bones`.`registration_encounters`.`patient_id` = in_patient_id;

	# Declare loop position check
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	# Open cursor
	OPEN cur;

	# Declare loop for traversing through the records
	read_loop: LOOP

		# Get the fields into the variables declared earlier
		FETCH cur INTO
			id,
			visit_encounter_id,
			old_enc_id,
			patient_id,
			call_id,
			location,
			encounter_datetime,
			date_created,
			creator,
			visit_date;

		# Check if we are done and exit loop if done
		IF done THEN

			LEAVE read_loop;

		END IF;

	# Not done, process the parameters

	# Map destination user to source user
	SET @creator = COALESCE((SELECT user_id FROM users WHERE username = creator LIMIT 1), 1);

	# Map destination user to source user
	SET @provider = COALESCE((SELECT person_id FROM users WHERE user_id = @creator LIMIT 1), 1);

	# Get location id
	SET @location_id = (SELECT location_id FROM location WHERE name = location LIMIT 1);

	# Get id of encounter type
	SET @encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = 'Registration' LIMIT 1);

	# Create encounter
	INSERT INTO encounter (encounter_id, encounter_type, patient_id, provider_id, location_id, encounter_datetime, creator, date_created, uuid) VALUES (old_enc_id, @encounter_type, patient_id, @provider, @location_id, encounter_datetime, @creator, date_created, (SELECT UUID())) ON DUPLICATE KEY UPDATE encounter_id = old_enc_id;


  # Check if the field is not empty
  IF NOT ISNULL(call_id) THEN

	  # Get concept_id
	  SET @callID_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
	                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
	                        WHERE name = 'Call ID' AND voided = 0 AND retired = 0 LIMIT 1);

	  # Create observation
	  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_text, creator, date_created, uuid)
	  VALUES (patient_id, @callID_concept_id, old_enc_id, encounter_datetime, @location_id , call_id, @creator, date_created, (SELECT UUID()));

	  # Get last obs id for association later to other records
	  SET @call_id_id = (SELECT LAST_INSERT_ID());

  END IF;

	END LOOP;

END$$

DELIMITER ;

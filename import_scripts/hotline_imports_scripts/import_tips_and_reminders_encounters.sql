# This procedure imports data from `hotline_intermediate_bare_bones` to `migration_database`

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_tips_and_reminders_encounters`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_tips_and_reminders_encounters`(
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
  DECLARE telephone_number  varchar(255);
  DECLARE telephone_number_type varchar(255);
  DECLARE who_is_present_as_quardian varchar(255);
  DECLARE on_tips_and_reminders varchar(255);
  DECLARE type_of_message varchar(255);
  DECLARE language_preference varchar(255);
  DECLARE type_of_message_content varchar(255);
	DECLARE location varchar(255);
	DECLARE encounter_datetime datetime;
	DECLARE date_created datetime;
	DECLARE creator varchar(255);
	DECLARE visit_date DATE;

	# Declare and initialise cursor for looping through the table
DECLARE cur CURSOR FOR SELECT DISTINCT `hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`id`,
`hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`visit_encounter_id`,
`hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`old_enc_id`,
`hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`patient_id`,
`hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`call_id`,
`hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`telephone_number`,
`hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`telephone_number_type`,
`hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`who_is_present_as_quardian`,
`hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`on_tips_and_reminders`,
`hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`type_of_message`,
`hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`language_preference`,
`hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`type_of_message_content`,
`hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`location`,
`hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`encounter_datetime`, `hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`date_created`, `hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`creator`,
                                       COALESCE(`hotline_intermediate_bare_bones`.`visit_encounters`.visit_date, `hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.date_created) FROM `hotline_intermediate_bare_bones`.`tips_and_reminders_encounters` LEFT OUTER JOIN `hotline_intermediate_bare_bones`.`visit_encounters` ON
        visit_encounter_id = `hotline_intermediate_bare_bones`.`visit_encounters`.`id`
        WHERE `hotline_intermediate_bare_bones`.`tips_and_reminders_encounters`.`patient_id` = in_patient_id;

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
      telephone_number,
      telephone_number_type,
      who_is_present_as_quardian,
      on_tips_and_reminders,
      type_of_message,
      language_preference,
      type_of_message_content,
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
    	SET @encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = 'Tips and reminders' LIMIT 1);

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

			# Check if the field is not empty
      IF NOT ISNULL(telephone_number) THEN
        # Get concept_id
        SET @telephone_number_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                              LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                              WHERE name = 'Telephone number' AND voided = 0 AND retired = 0 LIMIT 1);

        # Create observation
        INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_text, creator, date_created, uuid)
        VALUES (patient_id, @telephone_number_concept_id, old_enc_id, encounter_datetime, @location_id , telephone_number, @creator, date_created, (SELECT UUID()));

        # Get last obs id for association later to other records
        SET @telephone_number_id = (SELECT LAST_INSERT_ID());
      END IF;


			# Check if the field is not empty
      IF NOT ISNULL(telephone_number_type) THEN
        # Get concept_id
        SET @telephone_number_type_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                              LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                              WHERE name = 'phone type' AND voided = 0 AND retired = 0 LIMIT 1);

        # Get value_coded idWHO stage
        SET @telephone_number_type_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = telephone_number_type AND voided = 0 AND retired = 0 LIMIT 1);

				# Get value_coded_name_id
        SET @telephone_number_type_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = telephone_number_type AND voided = 0 AND retired = 0 LIMIT 1);

        # Create observation
        INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
        VALUES (patient_id, @telephone_number_type_concept_id, old_enc_id, encounter_datetime, @location_id , @telephone_number_type_value_coded, @telephone_number_type_value_coded_name_id
, @creator, date_created, (SELECT UUID()));

        # Get last obs id for association later to other records
        SET @telephone_number_type_id = (SELECT LAST_INSERT_ID());
      END IF;

			# Check if the field is not empty
      IF NOT ISNULL(who_is_present_as_quardian) THEN
        # Get concept_id
        SET @who_is_present_as_quardian_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                              LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                              WHERE name = 'Who is present as guardian?' AND voided = 0 AND retired = 0 LIMIT 1);

        # Get value_coded idWHO stage
        SET @who_is_present_as_quardian_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = who_is_present_as_quardian AND voided = 0 AND retired = 0 LIMIT 1);

				# Get value_coded_name_id
        SET @who_is_present_as_quardian_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = who_is_present_as_quardian AND voided = 0 AND retired = 0 LIMIT 1);

        # Create observation
        INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
        VALUES (patient_id, @who_is_present_as_quardian_concept_id, old_enc_id, encounter_datetime, @location_id , @who_is_present_as_quardian_value_coded, @who_is_present_as_quardian_value_coded_name_id
, @creator, date_created, (SELECT UUID()));

        # Get last obs id for association later to other records
        SET @who_is_present_as_quardian_id = (SELECT LAST_INSERT_ID());
      END IF;

			# Check if the field is not empty
      IF NOT ISNULL(on_tips_and_reminders) THEN
        # Get concept_id
        SET @on_tips_and_reminders_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                              LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                              WHERE name = 'On tips and reminders program' AND voided = 0 AND retired = 0 LIMIT 1);

        # Get value_coded idWHO stage
        SET @on_tips_and_reminders_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = on_tips_and_reminders AND voided = 0 AND retired = 0 LIMIT 1);

				# Get value_coded_name_id
        SET @on_tips_and_reminders_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = on_tips_and_reminders AND voided = 0 AND retired = 0 LIMIT 1);

        # Create observation
        INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
        VALUES (patient_id, @on_tips_and_reminders_concept_id, old_enc_id, encounter_datetime, @location_id , @on_tips_and_reminders_value_coded, @on_tips_and_reminders_value_coded_name_id
, @creator, date_created, (SELECT UUID()));

        # Get last obs id for association later to other records
        SET @on_tips_and_reminders_id = (SELECT LAST_INSERT_ID());
      END IF;

			# Check if the field is not empty
      IF NOT ISNULL(type_of_message) THEN
        # Get concept_id
        SET @type_of_message_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                              LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                              WHERE name = 'message type' AND voided = 0 AND retired = 0 LIMIT 1);

        # Get value_coded idWHO stage
        SET @type_of_message_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = type_of_message AND voided = 0 AND retired = 0 LIMIT 1);

				# Get value_coded_name_id
        SET @type_of_message_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = type_of_message AND voided = 0 AND retired = 0 LIMIT 1);

        # Create observation
        INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
        VALUES (patient_id, @type_of_message_concept_id, old_enc_id, encounter_datetime, @location_id , @type_of_message_value_coded, @type_of_message_value_coded_name_id
, @creator, date_created, (SELECT UUID()));

        # Get last obs id for association later to other records
        SET @type_of_message_id = (SELECT LAST_INSERT_ID());
      END IF;

			# Check if the field is not empty
      IF NOT ISNULL(language_preference) THEN
        # Get concept_id
        SET @language_preference_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                              LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                              WHERE name = 'Language preference' AND voided = 0 AND retired = 0 LIMIT 1);

        # Get value_coded idWHO stage
        SET @language_preference_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = language_preference AND voided = 0 AND retired = 0 LIMIT 1);

				# Get value_coded_name_id
        SET @language_preference_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = language_preference AND voided = 0 AND retired = 0 LIMIT 1);

        # Create observation
        INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
        VALUES (patient_id, @language_preference_concept_id, old_enc_id, encounter_datetime, @location_id , @language_preference_value_coded, @language_preference_value_coded_name_id
, @creator, date_created, (SELECT UUID()));

        # Get last obs id for association later to other records
        SET @language_preference_id = (SELECT LAST_INSERT_ID());
      END IF;

      # Check if the field is not empty
      IF NOT ISNULL(type_of_message_content) THEN

        # Get concept_id
        SET @type_of_message_content_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                              LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                              WHERE name = 'Type of message content' AND voided = 0 AND retired = 0 LIMIT 1);

        # Get value_coded idWHO stage
        SET @type_of_message_content_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = type_of_message_content AND voided = 0 AND retired = 0 LIMIT 1);

				# Get value_coded_name_id
        SET @type_of_message_content_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = type_of_message_content AND voided = 0 AND retired = 0 LIMIT 1);

        # Create observation
        INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
        VALUES (patient_id, @type_of_message_content_concept_id, old_enc_id, encounter_datetime, @location_id , @type_of_message_content_value_coded, @type_of_message_content_value_coded_name_id
, @creator, date_created, (SELECT UUID()));

        # Get last obs id for association later to other records
        SET @type_of_message_content_id = (SELECT LAST_INSERT_ID());

      END IF;

	END LOOP;

END$$

DELIMITER ;

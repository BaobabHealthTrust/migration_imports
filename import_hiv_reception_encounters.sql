# This procedure imports data from `gabriel_intermediate_bare_bones` to `bart2`

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_hiv_reception_encounters`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_hiv_reception_encounters`(
IN in_patient_id INT(11)
)

BEGIN


	# Declare condition for exiting loop
	DECLARE done INT DEFAULT FALSE;

	DECLARE id int(11);
	DECLARE visit_encounter_id int(11);
	DECLARE old_enc_id int(11);
	DECLARE patient_id int(11);
	DECLARE guardian int(11);
	DECLARE patient_present varchar(255);
	DECLARE guardian_present varchar(255);
	DECLARE location varchar(255);
	DECLARE voided tinyint(1);
	DECLARE void_reason varchar(255);
	DECLARE date_voided date;
	DECLARE voided_by int(11);
	DECLARE date_created datetime;
	DECLARE creator int(11);
	DECLARE visit_date DATE;

	# Declare and initialise cursor for looping through the table
DECLARE cur CURSOR FOR SELECT DISTINCT `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`id`, `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`visit_encounter_id`, `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`old_enc_id`, `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`patient_id`, `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`guardian`, `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`patient_present`, `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`guardian_present`, `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`location`, `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`voided`, `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`void_reason`, `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`date_voided`, `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`voided_by`, `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`date_created`, `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`creator`, COALESCE(`gabriel_intermediate_bare_bones`.`visit_encounters`.visit_date, `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.date_created) FROM `gabriel_intermediate_bare_bones`.`hiv_reception_encounters` LEFT OUTER JOIN `gabriel_intermediate_bare_bones`.`visit_encounters` ON
        visit_encounter_id = `gabriel_intermediate_bare_bones`.`visit_encounters`.`id`
        WHERE `gabriel_intermediate_bare_bones`.`hiv_reception_encounters`.`patient_id` = in_patient_id;

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
			guardian,
			patient_present,
			guardian_present,
			location,
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

  SET @migrated_encounter_id = COALESCE((SELECT encounter_id FROM openmrs_st_gabriel_migration_database.encounter
                                WHERE encounter_id = old_enc_id), 0);
  IF @migrated_encounter_id = 455434 THEN

	# Not done, process the parameters

	# Map destination user to source user
	SET @creator = COALESCE((SELECT user_id FROM users WHERE user_id = creator), 1);

	# Get location id
	SET @location_id = (SELECT location_id FROM location WHERE name = location);

	# Get id of encounter type
	SET @encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = 'HIV RECEPTION');

	# Create encounter
	INSERT INTO encounter (encounter_id, encounter_type, patient_id, provider_id, location_id, encounter_datetime, creator, date_created, uuid) VALUES (old_enc_id, @encounter_type, patient_id, @creator, @location_id, visit_date, @creator, date_created, (SELECT UUID())) ON DUPLICATE KEY UPDATE encounter_id = old_enc_id;

	
        # Check if the field is not empty
        IF NOT ISNULL(guardian) THEN

            # Get concept_id
            SET @guardian_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'guardian' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @guardian_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = guardian AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @guardian_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = guardian AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @guardian_concept_id, old_enc_id, visit_date, @location_id , @guardian_value_coded, @guardian_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @guardian_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(patient_present) THEN

            # Get concept_id
            SET @patient_present_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'patient present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @patient_present_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = patient_present AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @patient_present_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = patient_present AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @patient_present_concept_id, old_enc_id, visit_date, @location_id , @patient_present_value_coded, @patient_present_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @patient_present_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(guardian_present) THEN

            # Get concept_id
            SET @guardian_present_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'guardian present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @guardian_present_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = guardian_present AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @guardian_present_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = guardian_present AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @guardian_present_concept_id, old_enc_id, visit_date, @location_id , @guardian_present_value_coded, @guardian_present_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @guardian_present_id = (SELECT LAST_INSERT_ID());

        END IF;
      Select patient_id, old_enc_id;
     ELSE
      Select patient_id;
     END IF;
        
	END LOOP;

END$$

DELIMITER ;

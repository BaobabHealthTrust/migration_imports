# This procedure imports data from `hotline_intermediate_bare_bones` to `migration_database`

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_child_health_symptoms_encounters`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_child_health_symptoms_encounters`(
	IN in_patient_id INT(11)
)
BEGIN
	# Declare condition for exiting loop
	DECLARE done INT DEFAULT FALSE;

	# Declare fields to hold our values for our patients
	DECLARE id  int(11);
	DECLARE visit_encounter_id  int(11);
	DECLARE old_enc_id  int(11);
	DECLARE patient_id  int(11);
	DECLARE diarrhea varchar(255);
	DECLARE cough varchar(255);
	DECLARE fast_breathing varchar(255);
	DECLARE skin_dryness varchar(255);
	DECLARE eye_infection varchar(255);
	DECLARE fever varchar(255);
	DECLARE vomiting varchar(255);
	DECLARE other varchar(255);
	DECLARE crying varchar(255);
	DECLARE not_eating varchar(255);
	DECLARE very_sleepy varchar(255);
	DECLARE unconscious varchar(255);
	DECLARE sleeping varchar(255);
	DECLARE feeding_problems varchar(255);
	DECLARE bowel_movements varchar(255);
	DECLARE skin_infections varchar(255);
	DECLARE umbilicus_infection varchar(255);
	DECLARE growth_milestones varchar(255);
	DECLARE accessing_healthcare_services varchar(255);
	DECLARE fever_of_7_days_or_more varchar(255);
	DECLARE diarrhea_for_14_days_or_more varchar(255);
	DECLARE blood_in_stool varchar(255);
	DECLARE cough_for_21_days_or_more varchar(255);
	DECLARE not_eating_or_drinking_anything varchar(255);
	DECLARE red_eye_for_4_days_or_more_with_visual_problems varchar(255);
	DECLARE potential_chest_indrawing varchar(255);
	DECLARE call_id varchar(255);
	DECLARE very_sleepy_or_unconscious varchar(255);
	DECLARE convulsions_sign varchar(255);
	DECLARE convulsions_symptom varchar(255);
	DECLARE skin_rashes varchar(255);
	DECLARE vomiting_everything varchar(255);
	DECLARE swollen_hands_or_feet_sign varchar(255);
	DECLARE severity_of_fever  int(11);
	DECLARE severity_of_cough  int(11);
	DECLARE severity_of_red_eye  int(11);
	DECLARE severity_of_diarrhea  int(11);
	DECLARE visual_problems varchar(255);
	DECLARE gained_or_lost_weight varchar(255);
	DECLARE location varchar(255);
	DECLARE encounter_datetime DATETIME;
	DECLARE date_created varchar(255);
	DECLARE creator varchar(255);
	DECLARE visit_date DATE;
	
	# Declare and initialise cursor for looping through the table
DECLARE cur CURSOR FOR SELECT DISTINCT `hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`id`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`visit_encounter_id`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`old_enc_id`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`patient_id`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`diarrhea`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`cough`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`fast_breathing`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`skin_dryness`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`eye_infection`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`fever`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`vomiting`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`other`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`crying`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`not_eating`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`very_sleepy`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`unconscious`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`sleeping`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`feeding_problems`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`bowel_movements`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`skin_infections`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`umbilicus_infection`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`growth_milestones`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`accessing_healthcare_services`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`fever_of_7_days_or_more`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`diarrhea_for_14_days_or_more`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`blood_in_stool`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`cough_for_21_days_or_more`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`not_eating_or_drinking_anything`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`red_eye_for_4_days_or_more_with_visual_problems`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`potential_chest_indrawing`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`call_id`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`very_sleepy_or_unconscious`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`convulsions_sign`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`convulsions_symptom`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`skin_rashes`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`vomiting_everything`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`swollen_hands_or_feet_sign`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`severity_of_fever`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`severity_of_cough`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`severity_of_red_eye`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`severity_of_diarrhea`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`visual_problems`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`gained_or_lost_weight`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`location`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`encounter_datetime`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`date_created`,
`hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`creator`,
COALESCE(`hotline_intermediate_bare_bones`.`visit_encounters`.visit_date, `hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.date_created)
FROM `hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`
  LEFT OUTER JOIN `hotline_intermediate_bare_bones`.`visit_encounters` ON
        visit_encounter_id = `hotline_intermediate_bare_bones`.`visit_encounters`.`id`
WHERE `hotline_intermediate_bare_bones`.`child_health_symptoms_encounters`.`patient_id` = in_patient_id;

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
			diarrhea,
			cough,
			fast_breathing,
			skin_dryness,
			eye_infection,
			fever,
			vomiting,
			other,
			crying,
			not_eating,
			very_sleepy,
			unconscious,
			sleeping,
			feeding_problems,
			bowel_movements,
			skin_infections,
			umbilicus_infection,
			growth_milestones,
			accessing_healthcare_services,
			fever_of_7_days_or_more,
			diarrhea_for_14_days_or_more,
			blood_in_stool,
			cough_for_21_days_or_more,
			not_eating_or_drinking_anything,
			red_eye_for_4_days_or_more_with_visual_problems,
			potential_chest_indrawing,
			call_id,
			very_sleepy_or_unconscious,
			convulsions_sign,
			convulsions_symptom,
			skin_rashes,
			vomiting_everything,
			swollen_hands_or_feet_sign,
			severity_of_fever,
			severity_of_cough,
			severity_of_red_eye,
			severity_of_diarrhea,
			visual_problems,
			gained_or_lost_weight,
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
    	SET @encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = 'Child Health symptoms' LIMIT 1);

    	# Create encounter
    	INSERT INTO encounter (encounter_id, encounter_type, patient_id, provider_id, location_id, encounter_datetime, creator, date_created, uuid)
			VALUES (old_enc_id, @encounter_type, patient_id, @provider, @location_id, encounter_datetime, @creator, date_created, (SELECT UUID())) ON DUPLICATE KEY UPDATE encounter_id = old_enc_id;

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
			IF NOT ISNULL(diarrhea) THEN
			  # Get concept_id
			  SET @diarrhea_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Diarrhea' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @diarrhea_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = diarrhea AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @diarrhea_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = diarrhea AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @diarrhea_concept_id, old_enc_id, encounter_datetime, @location_id , @diarrhea_value_coded, @diarrhea_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to other records
			  SET @diarrhea_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(cough) THEN
			  # Get concept_id
			  SET @cough_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Cough' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @cough_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = cough AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @cough_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = cough AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @cough_concept_id, old_enc_id, encounter_datetime, @location_id , @cough_value_coded, @cough_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to other records
			  SET @cough_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(fast_breathing) THEN
			  # Get concept_id
			  SET @fast_breathing_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Fast breathing' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @fast_breathing_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = fast_breathing AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @fast_breathing_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = fast_breathing AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @fast_breathing_concept_id, old_enc_id, encounter_datetime, @location_id , @fast_breathing_value_coded, @fast_breathing_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to other records
			  SET @fast_breathing_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(skin_dryness) THEN
			  # Get concept_id
			  SET @skin_dryness_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Skin dryness' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @skin_dryness_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = skin_dryness AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @skin_dryness_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = skin_dryness AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @skin_dryness_concept_id, old_enc_id, encounter_datetime, @location_id , @skin_dryness_value_coded, @skin_dryness_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to other records
			  SET @skin_dryness_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(eye_infection) THEN
			  # Get concept_id
			  SET @eye_infection_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Eye infection' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @eye_infection_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = eye_infection AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @eye_infection_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = eye_infection AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @eye_infection_concept_id, old_enc_id, encounter_datetime, @location_id , @eye_infection_value_coded, @eye_infection_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to other records
			  SET @eye_infection_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(fever) THEN
			  # Get concept_id
			  SET @fever_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Fever' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @fever_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = fever AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @fever_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = fever AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @fever_concept_id, old_enc_id, encounter_datetime, @location_id , @fever_value_coded, @fever_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to other records
			  SET @fever_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(vomiting) THEN
			  # Get concept_id
			  SET @vomiting_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Vomiting' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @vomiting_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = vomiting AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @vomiting_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = vomiting AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @vomiting_concept_id, old_enc_id, encounter_datetime, @location_id , @vomiting_value_coded, @vomiting_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to other records
			  SET @vomiting_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(other) THEN
			  # Get concept_id
			  SET @other_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Other' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @other_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = other AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @other_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = other AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @other_concept_id, old_enc_id, encounter_datetime, @location_id , @other_value_coded, @other_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to other records
			  SET @other_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(crying) THEN
			  # Get concept_id
			  SET @crying_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'crying' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @crying_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = crying AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @crying_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = crying AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @crying_concept_id, old_enc_id, encounter_datetime, @location_id , @crying_value_coded, @crying_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to crying records
			  SET @crying_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(not_eating) THEN
			  # Get concept_id
			  SET @not_eating_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Not eating' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @not_eating_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = not_eating AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @not_eating_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = not_eating AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @not_eating_concept_id, old_enc_id, encounter_datetime, @location_id , @not_eating_value_coded, @not_eating_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to not_eating records
			  SET @not_eating_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(very_sleepy) THEN
			  # Get concept_id
			  SET @very_sleepy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Very sleepy' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @very_sleepy_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = very_sleepy AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @very_sleepy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = very_sleepy AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @very_sleepy_concept_id, old_enc_id, encounter_datetime, @location_id , @very_sleepy_value_coded, @very_sleepy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to very_sleepy records
			  SET @very_sleepy_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(unconscious) THEN
			  # Get concept_id
			  SET @unconscious_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Unconscious' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @unconscious_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = unconscious AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @unconscious_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = unconscious AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @unconscious_concept_id, old_enc_id, encounter_datetime, @location_id , @unconscious_value_coded, @unconscious_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to unconscious records
			  SET @unconscious_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(sleeping) THEN
			  # Get concept_id
			  SET @sleeping_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Sleeping' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @sleeping_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = sleeping AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @sleeping_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = sleeping AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @sleeping_concept_id, old_enc_id, encounter_datetime, @location_id , @sleeping_value_coded, @sleeping_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to sleeping records
			  SET @sleeping_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(feeding_problems) THEN
			  # Get concept_id
			  SET @feeding_problems_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Feeding problems' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @feeding_problems_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = feeding_problems AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @feeding_problems_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = feeding_problems AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @feeding_problems_concept_id, old_enc_id, encounter_datetime, @location_id , @feeding_problems_value_coded, @feeding_problems_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to feeding_problems records
			  SET @feeding_problems_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(bowel_movements) THEN
			  # Get concept_id
			  SET @bowel_movements_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Bowel movements' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @bowel_movements_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = bowel_movements AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @bowel_movements_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = bowel_movements AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @bowel_movements_concept_id, old_enc_id, encounter_datetime, @location_id , @bowel_movements_value_coded, @bowel_movements_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to bowel_movements records
			  SET @bowel_movements_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(skin_infections) THEN
			  # Get concept_id
			  SET @skin_infections_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Skin infections' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @skin_infections_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = skin_infections AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @skin_infections_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = skin_infections AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @skin_infections_concept_id, old_enc_id, encounter_datetime, @location_id , @skin_infections_value_coded, @skin_infections_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to skin_infections records
			  SET @skin_infections_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(umbilicus_infection) THEN
			  # Get concept_id
			  SET @umbilicus_infection_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Umbilicus infection' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @umbilicus_infection_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = umbilicus_infection AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @umbilicus_infection_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = umbilicus_infection AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @umbilicus_infection_concept_id, old_enc_id, encounter_datetime, @location_id , @umbilicus_infection_value_coded, @umbilicus_infection_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to umbilicus_infection records
			  SET @umbilicus_infection_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(growth_milestones) THEN
			  # Get concept_id
			  SET @growth_milestones_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Growth milestones' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @growth_milestones_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = growth_milestones AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @growth_milestones_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = growth_milestones AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @growth_milestones_concept_id, old_enc_id, encounter_datetime, @location_id , @growth_milestones_value_coded, @growth_milestones_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to growth_milestones records
			  SET @growth_milestones_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(accessing_healthcare_services) THEN
			  # Get concept_id
			  SET @accessing_healthcare_services_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Accessing healthcare services' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @accessing_healthcare_services_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = accessing_healthcare_services AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @accessing_healthcare_services_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = accessing_healthcare_services AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @accessing_healthcare_services_concept_id, old_enc_id, encounter_datetime, @location_id , @accessing_healthcare_services_value_coded, @accessing_healthcare_services_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to accessing_healthcare_services records
			  SET @accessing_healthcare_services_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(fever_of_7_days_or_more) THEN
			  # Get concept_id
			  SET @fever_of_7_days_or_more_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Fever of 7 days or more' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @fever_of_7_days_or_more_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = fever_of_7_days_or_more AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @fever_of_7_days_or_more_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = fever_of_7_days_or_more AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @fever_of_7_days_or_more_concept_id, old_enc_id, encounter_datetime, @location_id , @fever_of_7_days_or_more_value_coded, @fever_of_7_days_or_more_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to fever_of_7_days_or_more records
			  SET @fever_of_7_days_or_more_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(diarrhea_for_14_days_or_more) THEN
			  # Get concept_id
			  SET @diarrhea_for_14_days_or_more_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Diarrhea for 14 days or more' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @diarrhea_for_14_days_or_more_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = diarrhea_for_14_days_or_more AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @diarrhea_for_14_days_or_more_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = diarrhea_for_14_days_or_more AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @diarrhea_for_14_days_or_more_concept_id, old_enc_id, encounter_datetime, @location_id , @diarrhea_for_14_days_or_more_value_coded, @diarrhea_for_14_days_or_more_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to diarrhea_for_14_days_or_more records
			  SET @diarrhea_for_14_days_or_more_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(blood_in_stool) THEN
			  # Get concept_id
			  SET @blood_in_stool_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Blood in stool' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @blood_in_stool_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = blood_in_stool AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @blood_in_stool_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = blood_in_stool AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @blood_in_stool_concept_id, old_enc_id, encounter_datetime, @location_id , @blood_in_stool_value_coded, @blood_in_stool_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to blood_in_stool records
			  SET @blood_in_stool_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(cough_for_21_days_or_more) THEN
			  # Get concept_id
			  SET @cough_for_21_days_or_more_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Cough for 21 days or more' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @cough_for_21_days_or_more_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = cough_for_21_days_or_more AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @cough_for_21_days_or_more_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = cough_for_21_days_or_more AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @cough_for_21_days_or_more_concept_id, old_enc_id, encounter_datetime, @location_id , @cough_for_21_days_or_more_value_coded, @cough_for_21_days_or_more_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to cough_for_21_days_or_more records
			  SET @cough_for_21_days_or_more_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(not_eating_or_drinking_anything) THEN
			  # Get concept_id
			  SET @not_eating_or_drinking_anything_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Not eating or drinking anything' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @not_eating_or_drinking_anything_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = not_eating_or_drinking_anything AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @not_eating_or_drinking_anything_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = not_eating_or_drinking_anything AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @not_eating_or_drinking_anything_concept_id, old_enc_id, encounter_datetime, @location_id , @not_eating_or_drinking_anything_value_coded, @not_eating_or_drinking_anything_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to not_eating_or_drinking_anything records
			  SET @not_eating_or_drinking_anything_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(red_eye_for_4_days_or_more_with_visual_problems) THEN
			  # Get concept_id
			  SET @red_eye_for_4_days_or_more_with_visual_problems_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Red eye for 4 days or more with visual problems' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @red_eye_for_4_days_or_more_with_visual_problems_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = red_eye_for_4_days_or_more_with_visual_problems AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @red_eye_for_4_days_or_more_with_visual_problems_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = red_eye_for_4_days_or_more_with_visual_problems AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @red_eye_for_4_days_or_more_with_visual_problems_concept_id, old_enc_id, encounter_datetime, @location_id , @red_eye_for_4_days_or_more_with_visual_problems_value_coded, @red_eye_for_4_days_or_more_with_visual_problems_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to red_eye_for_4_days_or_more_with_visual_problems records
			  SET @red_eye_for_4_days_or_more_with_visual_problems_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(potential_chest_indrawing) THEN
			  # Get concept_id
			  SET @potential_chest_indrawing_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Very sleepy or unconscious' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @potential_chest_indrawing_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = potential_chest_indrawing AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @potential_chest_indrawing_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = potential_chest_indrawing AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @potential_chest_indrawing_concept_id, old_enc_id, encounter_datetime, @location_id , @potential_chest_indrawing_value_coded, @potential_chest_indrawing_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to potential_chest_indrawing records
			  SET @potential_chest_indrawing_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(very_sleepy_or_unconscious) THEN
			  # Get concept_id
			  SET @very_sleepy_or_unconscious_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Very sleepy or unconscious' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @very_sleepy_or_unconscious_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = very_sleepy_or_unconscious AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @very_sleepy_or_unconscious_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = very_sleepy_or_unconscious AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @very_sleepy_or_unconscious_concept_id, old_enc_id, encounter_datetime, @location_id , @very_sleepy_or_unconscious_value_coded, @very_sleepy_or_unconscious_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to very_sleepy_or_unconscious records
			  SET @very_sleepy_or_unconscious_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(convulsions_sign) THEN
			  # Get concept_id
			  SET @convulsions_sign_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Convulsions sign' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @convulsions_sign_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = convulsions_sign AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @convulsions_sign_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = convulsions_sign AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @convulsions_sign_concept_id, old_enc_id, encounter_datetime, @location_id , @convulsions_sign_value_coded, @convulsions_sign_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to convulsions_sign records
			  SET @convulsions_sign_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(convulsions_symptom) THEN
			  # Get concept_id
			  SET @convulsions_symptom_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Convulsions symptom' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @convulsions_symptom_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = convulsions_symptom AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @convulsions_symptom_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = convulsions_symptom AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @convulsions_symptom_concept_id, old_enc_id, encounter_datetime, @location_id , @convulsions_symptom_value_coded, @convulsions_symptom_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to convulsions_symptom records
			  SET @convulsions_symptom_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(skin_rashes) THEN
			  # Get concept_id
			  SET @skin_rashes_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Skin rashes' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @skin_rashes_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = skin_rashes AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @skin_rashes_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = skin_rashes AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @skin_rashes_concept_id, old_enc_id, encounter_datetime, @location_id , @skin_rashes_value_coded, @skin_rashes_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to skin_rashes records
			  SET @skin_rashes_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(vomiting_everything) THEN
			  # Get concept_id
			  SET @vomiting_everything_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Vomiting everything' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @vomiting_everything_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = vomiting_everything AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @vomiting_everything_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = vomiting_everything AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @vomiting_everything_concept_id, old_enc_id, encounter_datetime, @location_id , @vomiting_everything_value_coded, @vomiting_everything_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to vomiting_everything records
			  SET @vomiting_everything_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(swollen_hands_or_feet_sign) THEN
			  # Get concept_id
			  SET @swollen_hands_or_feet_sign_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Swollen hands or feet sign' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @swollen_hands_or_feet_sign_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = swollen_hands_or_feet_sign AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @swollen_hands_or_feet_sign_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = swollen_hands_or_feet_sign AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @swollen_hands_or_feet_sign_concept_id, old_enc_id, encounter_datetime, @location_id , @swollen_hands_or_feet_sign_value_coded, @swollen_hands_or_feet_sign_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to swollen_hands_or_feet_sign records
			  SET @swollen_hands_or_feet_sign_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(gained_or_lost_weight) THEN
			  # Get concept_id
			  SET @gained_or_lost_weight_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Gained or lost weight' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @gained_or_lost_weight_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = gained_or_lost_weight AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @gained_or_lost_weight_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = gained_or_lost_weight AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @gained_or_lost_weight_concept_id, old_enc_id, encounter_datetime, @location_id , @gained_or_lost_weight_value_coded, @gained_or_lost_weight_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to gained_or_lost_weight records
			  SET @gained_or_lost_weight_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(visual_problems) THEN
			  # Get concept_id
			  SET @visual_problems_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Visual problems' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded idWHO stage
			  SET @visual_problems_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = visual_problems AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @visual_problems_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = visual_problems AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @visual_problems_concept_id, old_enc_id, encounter_datetime, @location_id , @visual_problems_value_coded, @visual_problems_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to visual_problems records
			  SET @visual_problems_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(severity_of_fever) THEN
			  # Get concept_id
			  SET @severity_of_fever_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Severity of fever' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_numeric, creator, date_created, uuid)
			  VALUES (patient_id, @severity_of_fever_concept_id, old_enc_id, encounter_datetime, @location_id , severity_of_fever, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to severity_of_fever records
			  SET @severity_of_fever_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(severity_of_cough) THEN
			  # Get concept_id
			  SET @severity_of_cough_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Severity of cough' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_numeric, creator, date_created, uuid)
			  VALUES (patient_id, @severity_of_cough_concept_id, old_enc_id, encounter_datetime, @location_id , severity_of_cough, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to severity_of_cough records
			  SET @severity_of_cough_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(severity_of_red_eye) THEN
			  # Get concept_id
			  SET @severity_of_red_eye_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Severity of red eye' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_numeric, creator, date_created, uuid)
			  VALUES (patient_id, @severity_of_red_eye_concept_id, old_enc_id, encounter_datetime, @location_id , severity_of_red_eye, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to severity_of_red_eye records
			  SET @severity_of_red_eye_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(severity_of_diarrhea) THEN
			  # Get concept_id
			  SET @severity_of_diarrhea_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                        WHERE name = 'Severity of diarrhea' AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_numeric, creator, date_created, uuid)
			  VALUES (patient_id, @severity_of_diarrhea_concept_id, old_enc_id, encounter_datetime, @location_id , severity_of_diarrhea, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to severity_of_diarrhea records
			  SET @severity_of_diarrhea_id = (SELECT LAST_INSERT_ID());
			END IF;
	END LOOP;

END$$

DELIMITER ;

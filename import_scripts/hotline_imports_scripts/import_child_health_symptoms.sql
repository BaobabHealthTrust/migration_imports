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

	# Declare and initialise cursor for looping through the table
DECLARE cur CURSOR FOR SELECT DISTINCT `hotline_intermediate_bare_bones`.`anc_visit_encounters`.`id`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`visit_encounter_id`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`old_enc_id`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`patient_id`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`diarrhea`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`cough`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`fast_breathing`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`skin_dryness`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`eye_infection`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`fever`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`vomiting`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`other`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`crying`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`not_eating`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`very_sleepy`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`unconscious`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`sleeping`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`feeding_problems`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`bowel_movements`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`skin_infections`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`umbilicus_infection`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`growth_milestones`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`accessing_healthcare_services`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`fever_of_7_days_or_more`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`diarrhea_for_14_days_or_more`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`blood_in_stool`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`cough_for_21_days_or_more`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`not_eating_or_drinking_anything`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`red_eye_for_4_days_or_more_with_visual_problems`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`potential_chest_indrawing`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`call_id`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`very_sleepy_or_unconscious`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`convulsions_sign`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`convulsions_symptom`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`skin_rashes`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`vomiting_everything`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`swollen_hands_or_feet_sign`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`severity_of_fever`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`severity_of_cough`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`severity_of_red_eye`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`severity_of_diarrhea`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`visual_problems`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`gained_or_lost_weight`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`location`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`encounter_datetime`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`date_created`,
`hotline_intermediate_bare_bones`.`anc_visit_encounters`.`creator`,
COALESCE(`hotline_intermediate_bare_bones`.`visit_encounters`.visit_date, `hotline_intermediate_bare_bones`.`anc_visit_encounters`.date_created)
FROM `hotline_intermediate_bare_bones`.`anc_visit_encounters`
  LEFT OUTER JOIN `hotline_intermediate_bare_bones`.`visit_encounters` ON
        visit_encounter_id = `hotline_intermediate_bare_bones`.`visit_encounters`.`id`
WHERE `hotline_intermediate_bare_bones`.`anc_visit_encounters`.`patient_id` = in_patient_id;

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


	END LOOP;

END$$

DELIMITER ;

# This procedure imports data from `hotline_intermediate_bare_bones` to `migration_database`

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_maternal_health_symptoms_encounters`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_maternal_health_symptoms_encounters`(
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
	DECLARE abdominal_pain varchar(255);
	DECLARE method_of_family_planning varchar(255);
	DECLARE patient_using_family_planning varchar(255);
	DECLARE current_complaints_or_symptoms varchar(255);
	DECLARE family_planning varchar(255);
	DECLARE other varchar(255);
	DECLARE infertility varchar(255);
	DECLARE acute_abdominal_pain varchar(255);
	DECLARE vaginal_bleeding_during_pregnancy varchar(255);
	DECLARE postnatal_bleeding varchar(255);
	DECLARE healthcare_visits varchar(255);
	DECLARE nutrition varchar(255);
	DECLARE body_changes varchar(255);
	DECLARE discomfort varchar(255);
	DECLARE concerns varchar(255);
	DECLARE emotions varchar(255);
	DECLARE warning_signs varchar(255);
	DECLARE routines varchar(255);
	DECLARE beliefs varchar(255);
	DECLARE babys_growth varchar(255);
	DECLARE milestones varchar(255);
	DECLARE prevention varchar(255);
	DECLARE heavy_vaginal_bleeding_during_pregnancy varchar(255);
	DECLARE excessive_postnatal_bleeding varchar(255);
	DECLARE severe_headache varchar(255);
	DECLARE call_id varchar(255);
	DECLARE fever_during_pregnancy_sign varchar(255);
	DECLARE fever_during_pregnancy_symptom varchar(255);
	DECLARE postnatal_fever_sign varchar(255);
	DECLARE postnatal_fever_symptom varchar(255);
	DECLARE headaches varchar(255);
	DECLARE fits_or_convulsions_sign varchar(255);
	DECLARE fits_or_convulsions_symptom varchar(255);
	DECLARE swollen_hands_or_feet_sign varchar(255);
	DECLARE swollen_hands_or_feet_symptom varchar(255);
	DECLARE paleness_of_the_skin_and_tiredness_sign varchar(255);
	DECLARE paleness_of_the_skin_and_tiredness_symptom varchar(255);
	DECLARE no_fetal_movements_sign varchar(255);
	DECLARE no_fetal_movements_symptom varchar(255);
	DECLARE water_breaks_sign varchar(255);
	DECLARE water_breaks_symptom varchar(255);
	DECLARE postnatal_discharge_bad_smell varchar(255);
	DECLARE problems_with_monthly_periods varchar(255);
	DECLARE frequent_miscarriages varchar(255);
	DECLARE vaginal_bleeding_not_during_pregnancy varchar(255);
	DECLARE vaginal_itching varchar(255);
	DECLARE birth_planning_male varchar(255);
	DECLARE birth_planning_female varchar(255);
	DECLARE satisfied_with_family_planning_method varchar(255);
	DECLARE require_information_on_family_planning varchar(255);
	DECLARE problems_with_family_planning_method varchar(255);
	DECLARE location varchar(255);
	DECLARE encounter_datetime datetime;
	DECLARE date_created varchar(255);
	DECLARE creator varchar(255);
	DECLARE visit_date DATE;

	# Declare and initialise cursor for looping through the table
DECLARE cur CURSOR FOR SELECT DISTINCT `hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`id`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`visit_encounter_id`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`old_enc_id`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`patient_id`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`abdominal_pain`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`method_of_family_planning`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`patient_using_family_planning`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`current_complaints_or_symptoms`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`family_planning`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`other`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`infertility`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`acute_abdominal_pain`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`vaginal_bleeding_during_pregnancy`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`postnatal_bleeding`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`healthcare_visits`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`nutrition`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`body_changes`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`discomfort`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`concerns`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`emotions`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`warning_signs`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`routines`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`beliefs`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`babys_growth`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`milestones`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`prevention`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`heavy_vaginal_bleeding_during_pregnancy`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`excessive_postnatal_bleeding`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`severe_headache`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`call_id`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`fever_during_pregnancy_sign`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`fever_during_pregnancy_symptom`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`postnatal_fever_sign`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`postnatal_fever_symptom`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`headaches`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`fits_or_convulsions_sign`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`fits_or_convulsions_symptom`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`swollen_hands_or_feet_sign`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`swollen_hands_or_feet_symptom`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`paleness_of_the_skin_and_tiredness_sign`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`paleness_of_the_skin_and_tiredness_symptom`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`no_fetal_movements_sign`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`no_fetal_movements_symptom`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`water_breaks_sign`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`water_breaks_symptom`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`postnatal_discharge_bad_smell`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`problems_with_monthly_periods`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`frequent_miscarriages`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`vaginal_bleeding_not_during_pregnancy`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`vaginal_itching`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`birth_planning_male`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`birth_planning_female`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`satisfied_with_family_planning_method`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`require_information_on_family_planning`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`problems_with_family_planning_method`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`location`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`encounter_datetime`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`date_created`,
`hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`creator`,
COALESCE(`hotline_intermediate_bare_bones`.`visit_encounters`.visit_date, `hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.date_created)
FROM `hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`
  LEFT OUTER JOIN `hotline_intermediate_bare_bones`.`visit_encounters` ON
        visit_encounter_id = `hotline_intermediate_bare_bones`.`visit_encounters`.`id`
WHERE `hotline_intermediate_bare_bones`.`maternal_health_symptoms_encounters`.`patient_id` = in_patient_id;

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
			abdominal_pain,
			method_of_family_planning,
			patient_using_family_planning,
			current_complaints_or_symptoms,
			family_planning,
			other,
			infertility,
			acute_abdominal_pain,
			vaginal_bleeding_during_pregnancy,
			postnatal_bleeding,
			healthcare_visits,
			nutrition,
			body_changes,
			discomfort,
			concerns,
			emotions,
			warning_signs,
			routines,
			beliefs,
			babys_growth,
			milestones,
			prevention,
			heavy_vaginal_bleeding_during_pregnancy,
			excessive_postnatal_bleeding,
			severe_headache,
			call_id,
			fever_during_pregnancy_sign,
			fever_during_pregnancy_symptom,
			postnatal_fever_sign,
			postnatal_fever_symptom,
			headaches,
			fits_or_convulsions_sign,
			fits_or_convulsions_symptom,
			swollen_hands_or_feet_sign,
			swollen_hands_or_feet_symptom,
			paleness_of_the_skin_and_tiredness_sign,
			paleness_of_the_skin_and_tiredness_symptom,
			no_fetal_movements_sign,
			no_fetal_movements_symptom,
			water_breaks_sign,
			water_breaks_symptom,
			postnatal_discharge_bad_smell,
			problems_with_monthly_periods,
			frequent_miscarriages,
			vaginal_bleeding_not_during_pregnancy,
			vaginal_itching,
			birth_planning_male,
			birth_planning_female,
			satisfied_with_family_planning_method,
			require_information_on_family_planning,
			problems_with_family_planning_method,
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
    	SET @encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = 'Maternal Health symptoms' LIMIT 1);

			SET @maternal_health_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
														LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
														WHERE name = 'maternal health symptoms' AND voided = 0 AND retired = 0 LIMIT 1);
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
			IF NOT ISNULL(abdominal_pain) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @abdominal_pain_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "abdominal pain" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @abdominal_pain_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "abdominal pain" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @abdominal_pain_concept_id, @abdominal_pain_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to abdominal_pain records
			  SET @abdominal_pain_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(method_of_family_planning) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @method_of_family_planning_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "method of family planning" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @method_of_family_planning_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "method of family planning" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @method_of_family_planning_concept_id, @method_of_family_planning_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to method_of_family_planning records
			  SET @method_of_family_planning_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(patient_using_family_planning) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @patient_using_family_planning_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "patient using family planning" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @patient_using_family_planning_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "patient using family planning" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @patient_using_family_planning_concept_id, @patient_using_family_planning_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to patient_using_family_planning records
			  SET @patient_using_family_planning_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(current_complaints_or_symptoms) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @current_complaints_or_symptoms_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "current complaints or symptoms" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @current_complaints_or_symptoms_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "current complaints or symptoms" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @current_complaints_or_symptoms_concept_id, @current_complaints_or_symptoms_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to current_complaints_or_symptoms records
			  SET @current_complaints_or_symptoms_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(family_planning) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @family_planning_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "family planning" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @family_planning_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "family planning" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @family_planning_concept_id, @family_planning_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to family_planning records
			  SET @family_planning_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(other) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @other_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "other" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @other_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "other" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @other_concept_id, @other_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to other records
			  SET @other_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(infertility) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @infertility_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "infertility" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @infertility_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "infertility" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @infertility_concept_id, @infertility_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to infertility records
			  SET @infertility_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(acute_abdominal_pain) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @acute_abdominal_pain_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "acute abdominal pain" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @acute_abdominal_pain_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "acute abdominal pain" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @acute_abdominal_pain_concept_id, @acute_abdominal_pain_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to acute_abdominal_pain records
			  SET @acute_abdominal_pain_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(vaginal_bleeding_during_pregnancy) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @vaginal_bleeding_during_pregnancy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "vaginal bleeding during pregnancy" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @vaginal_bleeding_during_pregnancy_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "vaginal bleeding during pregnancy" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @vaginal_bleeding_during_pregnancy_concept_id, @vaginal_bleeding_during_pregnancy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to vaginal_bleeding_during_pregnancy records
			  SET @vaginal_bleeding_during_pregnancy_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(postnatal_bleeding) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @postnatal_bleeding_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "postnatal bleeding" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @postnatal_bleeding_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "postnatal bleeding" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @postnatal_bleeding_concept_id, @postnatal_bleeding_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to postnatal_bleeding records
			  SET @postnatal_bleeding_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(healthcare_visits) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @healthcare_visits_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "healthcare visits" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @healthcare_visits_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "healthcare visits" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @healthcare_visits_concept_id, @healthcare_visits_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to healthcare_visits records
			  SET @healthcare_visits_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(nutrition) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @nutrition_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "nutrition" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @nutrition_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "nutrition" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @nutrition_concept_id, @nutrition_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to nutrition records
			  SET @nutrition_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(discomfort) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @discomfort_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "discomfort" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @discomfort_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "discomfort" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @discomfort_concept_id, @discomfort_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to discomfort records
			  SET @discomfort_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(concerns) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @concerns_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "concerns" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @concerns_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "concerns" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @concerns_concept_id, @concerns_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to concerns records
			  SET @concerns_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(emotions) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @emotions_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "emotions" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @emotions_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "emotions" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @emotions_concept_id, @emotions_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to emotions records
			  SET @emotions_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(routines) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @routines_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "routines" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @routines_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "routines" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @routines_concept_id, @routines_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to routines records
			  SET @routines_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(beliefs) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @beliefs_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "beliefs" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @beliefs_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "beliefs" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @beliefs_concept_id, @beliefs_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to beliefs records
			  SET @beliefs_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(milestones) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @milestones_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "milestones" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @milestones_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "milestones" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @milestones_concept_id, @milestones_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to milestones records
			  SET @milestones_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(prevention) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @prevention_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "prevention" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @prevention_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "prevention" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @prevention_concept_id, @prevention_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to prevention records
			  SET @prevention_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(body_changes) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @body_changes_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "body changes" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @body_changes_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "body changes" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @body_changes_concept_id, @body_changes_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to body_changes records
			  SET @body_changes_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(warning_signs) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @warning_signs_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "warning signs" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @warning_signs_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "warning signs" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @warning_signs_concept_id, @warning_signs_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to warning_signs records
			  SET @warning_signs_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(heavy_vaginal_bleeding_during_pregnancy) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @heavy_vaginal_bleeding_during_pregnancy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "heavy vaginal bleeding during pregnancy" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @heavy_vaginal_bleeding_during_pregnancy_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "heavy vaginal bleeding during pregnancy" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @heavy_vaginal_bleeding_during_pregnancy_concept_id, @heavy_vaginal_bleeding_during_pregnancy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to heavy_vaginal_bleeding_during_pregnancy records
			  SET @heavy_vaginal_bleeding_during_pregnancy_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(excessive_postnatal_bleeding) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @excessive_postnatal_bleeding_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "excessive postnatal bleeding" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @excessive_postnatal_bleeding_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "excessive postnatal bleeding" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @excessive_postnatal_bleeding_concept_id, @excessive_postnatal_bleeding_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to excessive_postnatal_bleeding records
			  SET @excessive_postnatal_bleeding_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(severe_headache) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @severe_headache_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "severe headache" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @severe_headache_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "severe headache" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @severe_headache_concept_id, @severe_headache_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to severe_headache records
			  SET @severe_headache_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(fever_during_pregnancy_sign) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @fever_during_pregnancy_sign_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "fever during pregnancy sign" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @fever_during_pregnancy_sign_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "fever during pregnancy sign" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @fever_during_pregnancy_sign_concept_id, @fever_during_pregnancy_sign_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to fever_during_pregnancy_sign records
			  SET @fever_during_pregnancy_sign_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(fever_during_pregnancy_symptom) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @fever_during_pregnancy_symptom_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "fever during pregnancy symptom" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @fever_during_pregnancy_symptom_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "fever during pregnancy symptom" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @fever_during_pregnancy_symptom_concept_id, @fever_during_pregnancy_symptom_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to fever_during_pregnancy_symptom records
			  SET @fever_during_pregnancy_symptom_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(postnatal_fever_sign) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @postnatal_fever_sign_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "postnatal fever sign" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @postnatal_fever_sign_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "postnatal fever sign" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @postnatal_fever_sign_concept_id, @postnatal_fever_sign_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to postnatal_fever_sign records
			  SET @postnatal_fever_sign_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(postnatal_fever_symptom) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @postnatal_fever_symptom_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "postnatal fever symptom" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @postnatal_fever_symptom_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "postnatal fever symptom" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @postnatal_fever_symptom_concept_id, @postnatal_fever_symptom_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to postnatal_fever_symptom records
			  SET @postnatal_fever_symptom_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(headaches) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @headaches_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "headaches" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @headaches_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "headaches" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @headaches_concept_id, @headaches_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to headaches records
			  SET @headaches_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(fits_or_convulsions_sign) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @fits_or_convulsions_sign_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "fits or convulsions sign" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @fits_or_convulsions_sign_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "fits or convulsions sign" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @fits_or_convulsions_sign_concept_id, @fits_or_convulsions_sign_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to fits_or_convulsions_sign records
			  SET @fits_or_convulsions_sign_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(fits_or_convulsions_symptom) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @fits_or_convulsions_symptom_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "fits or convulsions symptom" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @fits_or_convulsions_symptom_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "fits or convulsions symptom" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @fits_or_convulsions_symptom_concept_id, @fits_or_convulsions_symptom_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to fits_or_convulsions_symptom records
			  SET @fits_or_convulsions_symptom_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(swollen_hands_or_feet_sign) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @swollen_hands_or_feet_sign_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "swollen hands or feet sign" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @swollen_hands_or_feet_sign_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "swollen hands or feet sign" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @swollen_hands_or_feet_sign_concept_id, @swollen_hands_or_feet_sign_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to swollen_hands_or_feet_sign records
			  SET @swollen_hands_or_feet_sign_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(swollen_hands_or_feet_symptom) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @swollen_hands_or_feet_symptom_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "swollen hands or feet symptom" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @swollen_hands_or_feet_symptom_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "swollen hands or feet symptom" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @swollen_hands_or_feet_symptom_concept_id, @swollen_hands_or_feet_symptom_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to swollen_hands_or_feet_symptom records
			  SET @swollen_hands_or_feet_symptom_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(paleness_of_the_skin_and_tiredness_sign) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @paleness_of_the_skin_and_tiredness_sign_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "paleness of the skin and tiredness sign" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @paleness_of_the_skin_and_tiredness_sign_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "paleness of the skin and tiredness sign" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @paleness_of_the_skin_and_tiredness_sign_concept_id, @paleness_of_the_skin_and_tiredness_sign_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to paleness_of_the_skin_and_tiredness_sign records
			  SET @paleness_of_the_skin_and_tiredness_sign_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(paleness_of_the_skin_and_tiredness_symptom) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @paleness_of_the_skin_and_tiredness_symptom_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "paleness of the skin and tiredness symptom" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @paleness_of_the_skin_and_tiredness_symptom_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "paleness of the skin and tiredness symptom" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @paleness_of_the_skin_and_tiredness_symptom_concept_id, @paleness_of_the_skin_and_tiredness_symptom_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to paleness_of_the_skin_and_tiredness_symptom records
			  SET @paleness_of_the_skin_and_tiredness_symptom_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(no_fetal_movements_sign) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @no_fetal_movements_sign_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "no fetal movements sign" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @no_fetal_movements_sign_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "no fetal movements sign" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @no_fetal_movements_sign_concept_id, @no_fetal_movements_sign_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to no_fetal_movements_sign records
			  SET @no_fetal_movements_sign_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(no_fetal_movements_symptom) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @no_fetal_movements_symptom_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "no fetal movements symptom" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @no_fetal_movements_symptom_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "no fetal movements symptom" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @no_fetal_movements_symptom_concept_id, @no_fetal_movements_symptom_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to no_fetal_movements_symptom records
			  SET @no_fetal_movements_symptom_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(water_breaks_sign) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @water_breaks_sign_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "water breaks sign" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @water_breaks_sign_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "water breaks sign" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @water_breaks_sign_concept_id, @water_breaks_sign_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to water_breaks_sign records
			  SET @water_breaks_sign_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(water_breaks_symptom) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @water_breaks_symptom_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "water breaks symptom" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @water_breaks_symptom_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "water breaks symptom" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @water_breaks_symptom_concept_id, @water_breaks_symptom_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to water_breaks_symptom records
			  SET @water_breaks_symptom_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(postnatal_discharge_bad_smell) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @postnatal_discharge_bad_smell_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "postnatal discharge bad smell" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @postnatal_discharge_bad_smell_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "postnatal discharge bad smell" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @postnatal_discharge_bad_smell_concept_id, @postnatal_discharge_bad_smell_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to postnatal_discharge_bad_smell records
			  SET @postnatal_discharge_bad_smell_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(problems_with_monthly_periods) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @problems_with_monthly_periods_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "problems with monthly periods" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @problems_with_monthly_periods_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "problems with monthly periods" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @problems_with_monthly_periods_concept_id, @problems_with_monthly_periods_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to problems_with_monthly_periods records
			  SET @problems_with_monthly_periods_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(frequent_miscarriages) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @frequent_miscarriages_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "frequent miscarriages" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @frequent_miscarriages_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "frequent miscarriages" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @frequent_miscarriages_concept_id, @frequent_miscarriages_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to frequent_miscarriages records
			  SET @frequent_miscarriages_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(vaginal_bleeding_not_during_pregnancy) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @vaginal_bleeding_not_during_pregnancy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "vaginal bleeding not during pregnancy" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @vaginal_bleeding_not_during_pregnancy_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "vaginal bleeding not during pregnancy" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @vaginal_bleeding_not_during_pregnancy_concept_id, @vaginal_bleeding_not_during_pregnancy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to vaginal_bleeding_not_during_pregnancy records
			  SET @vaginal_bleeding_not_during_pregnancy_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(vaginal_itching) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @vaginal_itching_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "vaginal itching" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @vaginal_itching_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "vaginal itching" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @vaginal_itching_concept_id, @vaginal_itching_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to vaginal_itching records
			  SET @vaginal_itching_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(birth_planning_male) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @birth_planning_male_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "birth planning male" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @birth_planning_male_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "birth planning male" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @birth_planning_male_concept_id, @birth_planning_male_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to birth_planning_male records
			  SET @birth_planning_male_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(birth_planning_female) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @birth_planning_female_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "birth planning female" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @birth_planning_female_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "birth planning female" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @birth_planning_female_concept_id, @birth_planning_female_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to birth_planning_female records
			  SET @birth_planning_female_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(satisfied_with_family_planning_method) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @satisfied_with_family_planning_method_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "satisfied with family planning method" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @satisfied_with_family_planning_method_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "satisfied with family planning method" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @satisfied_with_family_planning_method_concept_id, @satisfied_with_family_planning_method_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to satisfied_with_family_planning_method records
			  SET @satisfied_with_family_planning_method_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(require_information_on_family_planning) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @require_information_on_family_planning_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "require information on family planning" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @require_information_on_family_planning_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "require information on family planning" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @require_information_on_family_planning_concept_id, @require_information_on_family_planning_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to require_information_on_family_planning records
			  SET @require_information_on_family_planning_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(problems_with_family_planning_method) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @problems_with_family_planning_method_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "problems with family planning method" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @problems_with_family_planning_method_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "problems with family planning method" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @problems_with_family_planning_method_concept_id, @problems_with_family_planning_method_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to problems_with_family_planning_method records
			  SET @problems_with_family_planning_method_id = (SELECT LAST_INSERT_ID());
			END IF;

			# Check if the field is not empty
			IF NOT ISNULL(babys_growth) THEN
			  # Get concept_id
			  # Get value_coded id WHO stage
			  SET @babys_growth_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "baby\'s_growth" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Get value_coded_name_id
			  SET @babys_growth_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
			                  LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
			                  WHERE name = "baby\'s_growth" AND voided = 0 AND retired = 0 LIMIT 1);

			  # Create observation
			  INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
			  VALUES (patient_id, @maternal_health_concept_id, old_enc_id, encounter_datetime, @location_id , @babys_growth_concept_id, @babys_growth_value_coded_name_id, @creator, date_created, (SELECT UUID()));

			  # Get last obs id for association later to babys_growth records
			  SET @babys_growth_id = (SELECT LAST_INSERT_ID());
			END IF;
	END LOOP;

END$$

DELIMITER ;

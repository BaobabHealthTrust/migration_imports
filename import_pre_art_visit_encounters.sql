# This procedure imports data from `bart1_intermediate_bare_bones` to `bart2`

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_pre_art_visit_encounters`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_pre_art_visit_encounters`(
	IN in_patient_id INT(11)
)
BEGIN


	# Declare condition for exiting loop
	DECLARE done INT DEFAULT FALSE;

	DECLARE id int(11);
	DECLARE visit_encounter_id int(11);
	DECLARE patient_id int(11);
	DECLARE patient_pregnant varchar(25);
	DECLARE patient_breast_feeding varchar(25);
	DECLARE abdominal_pains varchar(25);
	DECLARE using_family_planning_method varchar(25);
	DECLARE family_planning_method_in_use varchar(255);
	DECLARE anorexia varchar(25);
	DECLARE cough varchar(25);
	DECLARE diarrhoea varchar(25);
	DECLARE fever varchar(25);
	DECLARE jaundice varchar(25);
	DECLARE leg_pain_numbness varchar(25);
	DECLARE vomit varchar(25);
	DECLARE weight_loss varchar(25);
	DECLARE peripheral_neuropathy varchar(25);
	DECLARE hepatitis varchar(25);
	DECLARE anaemia varchar(25);
	DECLARE lactic_acidosis varchar(25);
	DECLARE lipodystrophy varchar(25);
	DECLARE skin_rash varchar(25);
	DECLARE drug_induced_abdominal_pains varchar(25);
	DECLARE drug_induced_anorexia varchar(25);
	DECLARE drug_induced_diarrhoea varchar(25);
	DECLARE drug_induced_jaundice varchar(25);
	DECLARE drug_induced_leg_pain_numbness varchar(25);
	DECLARE drug_induced_vomit varchar(25);
	DECLARE drug_induced_peripheral_neuropathy varchar(25);
	DECLARE drug_induced_hepatitis varchar(25);
	DECLARE drug_induced_anaemia varchar(25);
	DECLARE drug_induced_lactic_acidosis varchar(25);
	DECLARE drug_induced_lipodystrophy varchar(25);
	DECLARE drug_induced_skin_rash varchar(25);
	DECLARE drug_induced_other_symptom varchar(25);
	DECLARE tb_status varchar(255);
	DECLARE refer_to_clinician varchar(25);
	DECLARE prescribe_cpt varchar(25);
	DECLARE number_of_condoms_given int(11);
	DECLARE prescribe_ipt varchar(25);
	DECLARE date_created datetime;
	DECLARE location varchar(255);
	DECLARE creator int(11);
	DECLARE visit_date DATE;

	# Declare and initialise cursor for looping through the table
DECLARE cur CURSOR FOR SELECT DISTINCT `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`id`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`visit_encounter_id`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`patient_id`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`patient_pregnant`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`patient_breast_feeding`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`abdominal_pains`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`using_family_planning_method`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`family_planning_method_in_use`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`anorexia`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`cough`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`diarrhoea`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`fever`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`jaundice`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`leg_pain_numbness`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`vomit`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`weight_loss`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`peripheral_neuropathy`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`hepatitis`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`anaemia`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`lactic_acidosis`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`lipodystrophy`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`skin_rash`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`drug_induced_abdominal_pains`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`drug_induced_anorexia`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`drug_induced_diarrhoea`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`drug_induced_jaundice`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`drug_induced_leg_pain_numbness`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`drug_induced_vomit`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`drug_induced_peripheral_neuropathy`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`drug_induced_hepatitis`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`drug_induced_anaemia`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`drug_induced_lactic_acidosis`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`drug_induced_lipodystrophy`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`drug_induced_skin_rash`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`drug_induced_other_symptom`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`tb_status`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`refer_to_clinician`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`prescribe_cpt`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`number_of_condoms_given`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`prescribe_ipt`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`date_created`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`location`, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`creator`, COALESCE(`bart1_intermediate_bare_bones`.`visit_encounters`.visit_date, `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.date_created) FROM `bart1_intermediate_bare_bones`.`pre_art_visit_encounters` LEFT OUTER JOIN `bart1_intermediate_bare_bones`.`visit_encounters` ON
        visit_encounter_id = `bart1_intermediate_bare_bones`.`visit_encounters`.`id`
        WHERE `bart1_intermediate_bare_bones`.`pre_art_visit_encounters`.`patient_id` = in_patient_id;

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
			patient_id,
			patient_pregnant,
			patient_breast_feeding,
			abdominal_pains,
			using_family_planning_method,
			family_planning_method_in_use,
			anorexia,
			cough,
			diarrhoea,
			fever,
			jaundice,
			leg_pain_numbness,
			vomit,
			weight_loss,
			peripheral_neuropathy,
			hepatitis,
			anaemia,
			lactic_acidosis,
			lipodystrophy,
			skin_rash,
			drug_induced_abdominal_pains,
			drug_induced_anorexia,
			drug_induced_diarrhoea,
			drug_induced_jaundice,
			drug_induced_leg_pain_numbness,
			drug_induced_vomit,
			drug_induced_peripheral_neuropathy,
			drug_induced_hepatitis,
			drug_induced_anaemia,
			drug_induced_lactic_acidosis,
			drug_induced_lipodystrophy,
			drug_induced_skin_rash,
			drug_induced_other_symptom,
			tb_status,
			refer_to_clinician,
			prescribe_cpt,
			number_of_condoms_given,
			prescribe_ipt,
			date_created,
			location,
			creator,
			visit_date;

		# Check if we are done and exit loop if done
		IF done THEN

			LEAVE read_loop;

		END IF;

	# Not done, process the parameters

	# Map destination user to source user
	SET @creator = COALESCE((SELECT user_id FROM users WHERE user_id = creator), 1);

	# Get location id
	SET @location_id = (SELECT location_id FROM location WHERE name = location);

	# Get id of encounter type
	SET @encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = 'HIV CLINIC CONSULTATION');

	# Create encounter
	INSERT INTO encounter (encounter_id, encounter_type, patient_id, provider_id, location_id, encounter_datetime, creator, date_created, uuid) VALUES (old_enc_id, @encounter_type, patient_id, @creator, @location_id, visit_date, @creator, date_created, (SELECT UUID())) ON DUPLICATE KEY UPDATE encounter_id = old_enc_id;

	
        # Check if the field is not empty
        IF NOT ISNULL(patient_pregnant) THEN

            # Get concept_id
            SET @patient_pregnant_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Is patient pregnant?' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @patient_pregnant_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = patient_pregnant AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @patient_pregnant_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = patient_pregnant AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @patient_pregnant_concept_id, old_enc_id, visit_date, @location_id , @patient_pregnant_value_coded, @patient_pregnant_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @patient_pregnant_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(patient_breast_feeding) THEN

            # Get concept_id
            SET @patient_breast_feeding_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Breastfeeding' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @patient_breast_feeding_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = patient_breast_feeding AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @patient_breast_feeding_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = patient_breast_feeding AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @patient_breast_feeding_concept_id, old_enc_id, visit_date, @location_id , @patient_breast_feeding_value_coded, @patient_breast_feeding_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @patient_breast_feeding_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(abdominal_pains) THEN

            # Get concept_id
            SET @abdominal_pains_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @abdominal_pains_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = abdominal_pains AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @abdominal_pains_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = abdominal_pains AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @abdominal_pains_concept_id, old_enc_id, visit_date, @location_id , @abdominal_pains_value_coded, @abdominal_pains_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @abdominal_pains_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(using_family_planning_method) THEN

            # Get concept_id
            SET @using_family_planning_method_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Currently using family planning method' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @using_family_planning_method_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = using_family_planning_method AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @using_family_planning_method_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = using_family_planning_method AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @using_family_planning_method_concept_id, old_enc_id, visit_date, @location_id , @using_family_planning_method_value_coded, @using_family_planning_method_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @using_family_planning_method_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(family_planning_method_in_use) THEN

            # Get concept_id
            SET @family_planning_method_in_use_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Method of family planning' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @family_planning_method_in_use_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = family_planning_method_in_use AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @family_planning_method_in_use_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = family_planning_method_in_use AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @family_planning_method_in_use_concept_id, old_enc_id, visit_date, @location_id , @family_planning_method_in_use_value_coded, @family_planning_method_in_use_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @family_planning_method_in_use_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(anorexia) THEN

            # Get concept_id
            SET @anorexia_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @anorexia_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = anorexia AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @anorexia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = anorexia AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @anorexia_concept_id, old_enc_id, visit_date, @location_id , @anorexia_value_coded, @anorexia_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @anorexia_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(cough) THEN

            # Get concept_id
            SET @cough_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @cough_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cough AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @cough_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cough AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @cough_concept_id, old_enc_id, visit_date, @location_id , @cough_value_coded, @cough_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @cough_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(diarrhoea) THEN

            # Get concept_id
            SET @diarrhoea_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @diarrhoea_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = diarrhoea AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @diarrhoea_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = diarrhoea AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @diarrhoea_concept_id, old_enc_id, visit_date, @location_id , @diarrhoea_value_coded, @diarrhoea_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @diarrhoea_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(fever) THEN

            # Get concept_id
            SET @fever_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @fever_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = fever AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @fever_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = fever AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @fever_concept_id, old_enc_id, visit_date, @location_id , @fever_value_coded, @fever_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @fever_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(jaundice) THEN

            # Get concept_id
            SET @jaundice_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @jaundice_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = jaundice AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @jaundice_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = jaundice AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @jaundice_concept_id, old_enc_id, visit_date, @location_id , @jaundice_value_coded, @jaundice_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @jaundice_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(leg_pain_numbness) THEN

            # Get concept_id
            SET @leg_pain_numbness_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @leg_pain_numbness_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = leg_pain_numbness AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @leg_pain_numbness_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = leg_pain_numbness AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @leg_pain_numbness_concept_id, old_enc_id, visit_date, @location_id , @leg_pain_numbness_value_coded, @leg_pain_numbness_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @leg_pain_numbness_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(vomit) THEN

            # Get concept_id
            SET @vomit_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @vomit_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = vomit AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @vomit_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = vomit AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @vomit_concept_id, old_enc_id, visit_date, @location_id , @vomit_value_coded, @vomit_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @vomit_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(weight_loss) THEN

            # Get concept_id
            SET @weight_loss_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @weight_loss_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = weight_loss AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @weight_loss_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = weight_loss AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @weight_loss_concept_id, old_enc_id, visit_date, @location_id , @weight_loss_value_coded, @weight_loss_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @weight_loss_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(peripheral_neuropathy) THEN

            # Get concept_id
            SET @peripheral_neuropathy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @peripheral_neuropathy_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = peripheral_neuropathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @peripheral_neuropathy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = peripheral_neuropathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @peripheral_neuropathy_concept_id, old_enc_id, visit_date, @location_id , @peripheral_neuropathy_value_coded, @peripheral_neuropathy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @peripheral_neuropathy_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(hepatitis) THEN

            # Get concept_id
            SET @hepatitis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @hepatitis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = hepatitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @hepatitis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = hepatitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @hepatitis_concept_id, old_enc_id, visit_date, @location_id , @hepatitis_value_coded, @hepatitis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @hepatitis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(anaemia) THEN

            # Get concept_id
            SET @anaemia_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @anaemia_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = anaemia AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @anaemia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = anaemia AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @anaemia_concept_id, old_enc_id, visit_date, @location_id , @anaemia_value_coded, @anaemia_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @anaemia_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(lactic_acidosis) THEN

            # Get concept_id
            SET @lactic_acidosis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @lactic_acidosis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = lactic_acidosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @lactic_acidosis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = lactic_acidosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @lactic_acidosis_concept_id, old_enc_id, visit_date, @location_id , @lactic_acidosis_value_coded, @lactic_acidosis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @lactic_acidosis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(lipodystrophy) THEN

            # Get concept_id
            SET @lipodystrophy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @lipodystrophy_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = lipodystrophy AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @lipodystrophy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = lipodystrophy AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @lipodystrophy_concept_id, old_enc_id, visit_date, @location_id , @lipodystrophy_value_coded, @lipodystrophy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @lipodystrophy_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(skin_rash) THEN

            # Get concept_id
            SET @skin_rash_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @skin_rash_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = skin_rash AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @skin_rash_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = skin_rash AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @skin_rash_concept_id, old_enc_id, visit_date, @location_id , @skin_rash_value_coded, @skin_rash_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @skin_rash_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(drug_induced_abdominal_pains) THEN

            # Get concept_id
            SET @drug_induced_abdominal_pains_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Symptom present' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @drug_induced_abdominal_pains_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_abdominal_pains AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @drug_induced_abdominal_pains_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_abdominal_pains AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @drug_induced_abdominal_pains_concept_id, old_enc_id, visit_date, @location_id , @drug_induced_abdominal_pains_value_coded, @drug_induced_abdominal_pains_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @drug_induced_abdominal_pains_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(drug_induced_anorexia) THEN

            # Get concept_id
            SET @drug_induced_anorexia_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Drug induced' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @drug_induced_anorexia_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_anorexia AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @drug_induced_anorexia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_anorexia AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @drug_induced_anorexia_concept_id, old_enc_id, visit_date, @location_id , @drug_induced_anorexia_value_coded, @drug_induced_anorexia_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @drug_induced_anorexia_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(drug_induced_diarrhoea) THEN

            # Get concept_id
            SET @drug_induced_diarrhoea_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Drug induced' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @drug_induced_diarrhoea_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_diarrhoea AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @drug_induced_diarrhoea_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_diarrhoea AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @drug_induced_diarrhoea_concept_id, old_enc_id, visit_date, @location_id , @drug_induced_diarrhoea_value_coded, @drug_induced_diarrhoea_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @drug_induced_diarrhoea_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(drug_induced_jaundice) THEN

            # Get concept_id
            SET @drug_induced_jaundice_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Drug induced' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @drug_induced_jaundice_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_jaundice AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @drug_induced_jaundice_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_jaundice AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @drug_induced_jaundice_concept_id, old_enc_id, visit_date, @location_id , @drug_induced_jaundice_value_coded, @drug_induced_jaundice_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @drug_induced_jaundice_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(drug_induced_leg_pain_numbness) THEN

            # Get concept_id
            SET @drug_induced_leg_pain_numbness_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Drug induced' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @drug_induced_leg_pain_numbness_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_leg_pain_numbness AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @drug_induced_leg_pain_numbness_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_leg_pain_numbness AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @drug_induced_leg_pain_numbness_concept_id, old_enc_id, visit_date, @location_id , @drug_induced_leg_pain_numbness_value_coded, @drug_induced_leg_pain_numbness_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @drug_induced_leg_pain_numbness_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(drug_induced_vomit) THEN

            # Get concept_id
            SET @drug_induced_vomit_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Drug induced' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @drug_induced_vomit_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_vomit AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @drug_induced_vomit_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_vomit AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @drug_induced_vomit_concept_id, old_enc_id, visit_date, @location_id , @drug_induced_vomit_value_coded, @drug_induced_vomit_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @drug_induced_vomit_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(drug_induced_peripheral_neuropathy) THEN

            # Get concept_id
            SET @drug_induced_peripheral_neuropathy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Drug induced' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @drug_induced_peripheral_neuropathy_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_peripheral_neuropathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @drug_induced_peripheral_neuropathy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_peripheral_neuropathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @drug_induced_peripheral_neuropathy_concept_id, old_enc_id, visit_date, @location_id , @drug_induced_peripheral_neuropathy_value_coded, @drug_induced_peripheral_neuropathy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @drug_induced_peripheral_neuropathy_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(drug_induced_hepatitis) THEN

            # Get concept_id
            SET @drug_induced_hepatitis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Drug induced' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @drug_induced_hepatitis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_hepatitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @drug_induced_hepatitis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_hepatitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @drug_induced_hepatitis_concept_id, old_enc_id, visit_date, @location_id , @drug_induced_hepatitis_value_coded, @drug_induced_hepatitis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @drug_induced_hepatitis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(drug_induced_anaemia) THEN

            # Get concept_id
            SET @drug_induced_anaemia_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Drug induced' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @drug_induced_anaemia_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_anaemia AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @drug_induced_anaemia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_anaemia AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @drug_induced_anaemia_concept_id, old_enc_id, visit_date, @location_id , @drug_induced_anaemia_value_coded, @drug_induced_anaemia_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @drug_induced_anaemia_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(drug_induced_lactic_acidosis) THEN

            # Get concept_id
            SET @drug_induced_lactic_acidosis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Drug induced' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @drug_induced_lactic_acidosis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_lactic_acidosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @drug_induced_lactic_acidosis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_lactic_acidosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @drug_induced_lactic_acidosis_concept_id, old_enc_id, visit_date, @location_id , @drug_induced_lactic_acidosis_value_coded, @drug_induced_lactic_acidosis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @drug_induced_lactic_acidosis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(drug_induced_lipodystrophy) THEN

            # Get concept_id
            SET @drug_induced_lipodystrophy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Drug induced' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @drug_induced_lipodystrophy_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_lipodystrophy AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @drug_induced_lipodystrophy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_lipodystrophy AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @drug_induced_lipodystrophy_concept_id, old_enc_id, visit_date, @location_id , @drug_induced_lipodystrophy_value_coded, @drug_induced_lipodystrophy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @drug_induced_lipodystrophy_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(drug_induced_skin_rash) THEN

            # Get concept_id
            SET @drug_induced_skin_rash_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Drug induced' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @drug_induced_skin_rash_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_skin_rash AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @drug_induced_skin_rash_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_skin_rash AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @drug_induced_skin_rash_concept_id, old_enc_id, visit_date, @location_id , @drug_induced_skin_rash_value_coded, @drug_induced_skin_rash_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @drug_induced_skin_rash_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(drug_induced_other_symptom) THEN

            # Get concept_id
            SET @drug_induced_other_symptom_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Drug induced' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @drug_induced_other_symptom_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_other_symptom AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @drug_induced_other_symptom_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = drug_induced_other_symptom AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @drug_induced_other_symptom_concept_id, old_enc_id, visit_date, @location_id , @drug_induced_other_symptom_value_coded, @drug_induced_other_symptom_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @drug_induced_other_symptom_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(tb_status) THEN

            # Get concept_id
            SET @tb_status_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'tb status' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @tb_status_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = tb_status AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @tb_status_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = tb_status AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @tb_status_concept_id, old_enc_id, visit_date, @location_id , @tb_status_value_coded, @tb_status_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @tb_status_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(refer_to_clinician) THEN

            # Get concept_id
            SET @refer_to_clinician_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'refer to clinician' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @refer_to_clinician_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = refer_to_clinician AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @refer_to_clinician_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = refer_to_clinician AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @refer_to_clinician_concept_id, old_enc_id, visit_date, @location_id , @refer_to_clinician_value_coded, @refer_to_clinician_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @refer_to_clinician_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(prescribe_cpt) THEN

            # Get concept_id
            SET @prescribe_cpt_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Prescribe cotramoxazole' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @prescribe_cpt_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = prescribe_cpt AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @prescribe_cpt_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = prescribe_cpt AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @prescribe_cpt_concept_id, old_enc_id, visit_date, @location_id , @prescribe_cpt_value_coded, @prescribe_cpt_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @prescribe_cpt_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(number_of_condoms_given) THEN

            # Get concept_id
            SET @number_of_condoms_given_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Number of Condoms dispensed' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @number_of_condoms_given_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = number_of_condoms_given AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @number_of_condoms_given_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = number_of_condoms_given AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @number_of_condoms_given_concept_id, old_enc_id, visit_date, @location_id , @number_of_condoms_given_value_coded, @number_of_condoms_given_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @number_of_condoms_given_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(prescribe_ipt) THEN

            # Get concept_id
            SET @prescribe_ipt_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Isoniazid' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @prescribe_ipt_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = prescribe_ipt AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @prescribe_ipt_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = prescribe_ipt AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @prescribe_ipt_concept_id, old_enc_id, visit_date, @location_id , @prescribe_ipt_value_coded, @prescribe_ipt_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @prescribe_ipt_id = (SELECT LAST_INSERT_ID());

        END IF;
        
	END LOOP;

END$$

DELIMITER ;
# This procedure imports data from `bart1_intermediate_bare_bones` to `migration_database`

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_hiv_staging_encounters_llh`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_hiv_staging_encounters_llh`(
IN in_patient_id INT(11)
)
BEGIN


	# Declare condition for exiting loop
	DECLARE done INT DEFAULT FALSE;

	DECLARE id int(11);
	DECLARE visit_encounter_id int(11);
	DECLARE old_enc_id int(11);
	DECLARE patient_id int(11);
	DECLARE patient_pregnant varchar(25);
	DECLARE patient_breast_feeding varchar(25);
	DECLARE cd4_count_available varchar(25);
	DECLARE cd4_count int(11);
	DECLARE cd4_count_modifier varchar(5);
	DECLARE cd4_count_percentage double;
	DECLARE date_of_cd4_count date;
	DECLARE asymptomatic varchar(25);
	DECLARE persistent_generalized_lymphadenopathy varchar(25);
	DECLARE unspecified_stage_1_cond varchar(25);
	DECLARE molluscumm_contagiosum varchar(25);
	DECLARE wart_virus_infection_extensive varchar(25);
	DECLARE oral_ulcerations_recurrent varchar(25);
	DECLARE parotid_enlargement_persistent_unexplained varchar(25);
	DECLARE lineal_gingival_erythema varchar(25);
	DECLARE herpes_zoster varchar(25);
	DECLARE respiratory_tract_infections_recurrent varchar(25);
	DECLARE unspecified_stage2_condition varchar(25);
	DECLARE angular_chelitis varchar(25);
	DECLARE papular_prurtic_eruptions varchar(25);
	DECLARE hepatosplenomegaly_unexplained varchar(25);
	DECLARE oral_hairy_leukoplakia varchar(25);
	DECLARE severe_weight_loss varchar(25);
	DECLARE fever_persistent_unexplained varchar(25);
	DECLARE pulmonary_tuberculosis varchar(25);
	DECLARE pulmonary_tuberculosis_last_2_years varchar(25);
	DECLARE severe_bacterial_infection varchar(25);
	DECLARE bacterial_pnuemonia varchar(25);
	DECLARE symptomatic_lymphoid_interstitial_pnuemonitis varchar(25);
	DECLARE chronic_hiv_assoc_lung_disease varchar(25);
	DECLARE unspecified_stage3_condition varchar(25);
	DECLARE aneamia varchar(25);
	DECLARE neutropaenia varchar(25);
	DECLARE thrombocytopaenia_chronic varchar(25);
	DECLARE diarhoea varchar(25);
	DECLARE oral_candidiasis varchar(25);
	DECLARE acute_necrotizing_ulcerative_gingivitis varchar(25);
	DECLARE lymph_node_tuberculosis varchar(25);
	DECLARE toxoplasmosis_of_brain varchar(25);
	DECLARE cryptococcal_meningitis varchar(25);
	DECLARE progressive_multifocal_leukoencephalopathy varchar(25);
	DECLARE disseminated_mycosis varchar(25);
	DECLARE candidiasis_of_oesophagus varchar(25);
	DECLARE extrapulmonary_tuberculosis varchar(25);
	DECLARE cerebral_non_hodgkin_lymphoma varchar(25);
	DECLARE kaposis varchar(25);
	DECLARE hiv_encephalopathy varchar(25);
	DECLARE bacterial_infections_severe_recurrent varchar(25);
	DECLARE unspecified_stage_4_condition varchar(25);
	DECLARE pnuemocystis_pnuemonia varchar(25);
	DECLARE disseminated_non_tuberculosis_mycobactierial_infection varchar(25);
	DECLARE cryptosporidiosis varchar(25);
	DECLARE isosporiasis varchar(25);
	DECLARE symptomatic_hiv_asscoiated_nephropathy varchar(25);
	DECLARE chronic_herpes_simplex_infection varchar(25);
	DECLARE cytomegalovirus_infection varchar(25);
	DECLARE toxoplasomis_of_the_brain_1month varchar(25);
	DECLARE recto_vaginal_fitsula varchar(25);
	DECLARE hiv_wasting_syndrome varchar(25);
  DECLARE cryptococcal_meningitis_or_other_eptb_cryptococcosis varchar(25);
  DECLARE candidiasis_of_oesophagus_trachea_bronchi_or_lungs varchar(25);
  DECLARE severe_unexplained_wasting_malnutrition varchar(25);
  DECLARE diarrhoea_chronic_less_1_month_unexplained varchar(25);
  DECLARE moderate_weight_loss_10_unexplained varchar(25);
  DECLARE cd4_percentage_available varchar(25);
  DECLARE acute_necrotizing_ulcerative_stomatitis_gingivitis_or_period varchar(25);
  DECLARE moderate_unexplained_wasting_malnutrition varchar(25);
  DECLARE diarrhoea_persistent_unexplained_14_days_or_more varchar(25);
  DECLARE acute_ulcerative_mouth_infections varchar(25);
  DECLARE anaemia_unexplained_8_g_dl varchar(25);
  DECLARE atypical_mycobacteriosis_disseminated_or_lung varchar(25);
  DECLARE bacterial_infections_sev_recurrent_excluding_pneumonia varchar(25);
  DECLARE cancer_cervix varchar(25);
  DECLARE chronic_herpes_simplex_infection_genital varchar(25);
  DECLARE cryptosporidiosis_chronic_with_diarrhoea varchar(25);
  DECLARE cytomegalovirus_infection_retinitis_or_other_organ varchar(25);
  DECLARE cytomegalovirus_of_an_organ_other_than_liver varchar(25);
  DECLARE fungal_nail_infections varchar(25);
  DECLARE herpes_simplex_infection_mucocutaneous_visceral varchar(25);
  DECLARE hiv_associated_cardiomyopathy varchar(25);
  DECLARE hiv_associated_nephropathy varchar(25);
  DECLARE invasive_cancer_cervix varchar(25);
  DECLARE isosporiasis_1_month varchar(25);
  DECLARE leishmaniasis_atypical_disseminated varchar(25);
  DECLARE minor_mucocutaneous_manifestations_seborrheic_dermatitis varchar(25);
  DECLARE moderate_unexplained_malnutrition varchar(25);
  DECLARE molluscum_contagiosum_extensive varchar(25);
  DECLARE non_typhoidal_salmonella_bacteraemia_recurrent varchar(25);
  DECLARE oral_candidiasis_from_age_2_months varchar(25);
  DECLARE oral_thrush varchar(25);
  DECLARE perform_extended_staging varchar(25);
  DECLARE pneumocystis_carinii_pneumonia varchar(25);
  DECLARE pneumonia_severe varchar(25);
  DECLARE recurrent_bacteraemia_or_sepsis_with_nts varchar(25);
  DECLARE recurrent_severe_presumed_pneumonia varchar(25);
  DECLARE recurrent_upper_respiratory_tract_bac_sinusitis varchar(25);
  DECLARE seborrhoeic_dermatitis varchar(25);
  DECLARE sepsis_severe varchar(25);
  DECLARE tb_lymphadenopathy varchar(25);
  DECLARE unexplained_anaemia_neutropenia_or_thrombocytopenia varchar(25);
  DECLARE visceral_leishmaniasis varchar(25);
	DECLARE reason_for_starting_art varchar(255);
	DECLARE who_stage varchar(255);
	DECLARE location varchar(255);
	DECLARE voided tinyint(1);
	DECLARE void_reason varchar(255);
	DECLARE date_voided date;
	DECLARE voided_by int(11);
	DECLARE encounter_datetime datetime;
	DECLARE date_created datetime;
	DECLARE creator varchar(255);
	DECLARE visit_date DATE;

	# Declare and initialise cursor for looping through the table
DECLARE cur CURSOR FOR SELECT DISTINCT `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`id`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`visit_encounter_id`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`old_enc_id`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`patient_id`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`patient_pregnant`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`patient_breast_feeding`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`cd4_count_available`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`cd4_count`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`cd4_count_modifier`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`cd4_count_percentage`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`date_of_cd4_count`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`asymptomatic`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`persistent_generalized_lymphadenopathy`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`unspecified_stage_1_cond`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`molluscumm_contagiosum`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`wart_virus_infection_extensive`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`oral_ulcerations_recurrent`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`parotid_enlargement_persistent_unexplained`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`lineal_gingival_erythema`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`herpes_zoster`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`respiratory_tract_infections_recurrent`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`unspecified_stage2_condition`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`angular_chelitis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`papular_prurtic_eruptions`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`hepatosplenomegaly_unexplained`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`oral_hairy_leukoplakia`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`severe_weight_loss`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`fever_persistent_unexplained`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`pulmonary_tuberculosis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`pulmonary_tuberculosis_last_2_years`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`severe_bacterial_infection`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`bacterial_pnuemonia`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`symptomatic_lymphoid_interstitial_pnuemonitis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`chronic_hiv_assoc_lung_disease`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`unspecified_stage3_condition`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`aneamia`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`neutropaenia`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`thrombocytopaenia_chronic`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`diarhoea`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`oral_candidiasis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`acute_necrotizing_ulcerative_gingivitis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`lymph_node_tuberculosis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`toxoplasmosis_of_brain`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`cryptococcal_meningitis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`progressive_multifocal_leukoencephalopathy`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`disseminated_mycosis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`candidiasis_of_oesophagus`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`extrapulmonary_tuberculosis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`cerebral_non_hodgkin_lymphoma`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`kaposis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`hiv_encephalopathy`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`bacterial_infections_severe_recurrent`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`unspecified_stage_4_condition`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`pnuemocystis_pnuemonia`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`disseminated_non_tuberculosis_mycobactierial_infection`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`cryptosporidiosis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`isosporiasis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`symptomatic_hiv_asscoiated_nephropathy`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`chronic_herpes_simplex_infection`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`cytomegalovirus_infection`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`toxoplasomis_of_the_brain_1month`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`recto_vaginal_fitsula`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`hiv_wasting_syndrome`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`cryptococcal_meningitis_or_other_eptb_cryptococcosis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`candidiasis_of_oesophagus_trachea_bronchi_or_lungs`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`severe_unexplained_wasting_malnutrition`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`diarrhoea_chronic_less_1_month_unexplained`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`moderate_weight_loss_10_unexplained`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`cd4_percentage_available`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`acute_necrotizing_ulcerative_stomatitis_gingivitis_or_period`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`moderate_unexplained_wasting_malnutrition`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`diarrhoea_persistent_unexplained_14_days_or_more`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`acute_ulcerative_mouth_infections`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`anaemia_unexplained_8_g_dl`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`atypical_mycobacteriosis_disseminated_or_lung`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`bacterial_infections_sev_recurrent_excluding_pneumonia`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`cancer_cervix`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`chronic_herpes_simplex_infection_genital`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`cryptosporidiosis_chronic_with_diarrhoea`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`cytomegalovirus_infection_retinitis_or_other_organ`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`cytomegalovirus_of_an_organ_other_than_liver`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`fungal_nail_infections`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`herpes_simplex_infection_mucocutaneous_visceral`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`hiv_associated_cardiomyopathy`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`hiv_associated_nephropathy`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`invasive_cancer_cervix`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`isosporiasis_1_month`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`leishmaniasis_atypical_disseminated`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`minor_mucocutaneous_manifestations_seborrheic_dermatitis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`moderate_unexplained_malnutrition`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`molluscum_contagiosum_extensive`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`non_typhoidal_salmonella_bacteraemia_recurrent`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`oral_candidiasis_from_age_2_months`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`oral_thrush`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`perform_extended_staging`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`pneumocystis_carinii_pneumonia`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`pneumonia_severe`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`recurrent_bacteraemia_or_sepsis_with_nts`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`recurrent_severe_presumed_pneumonia`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`recurrent_upper_respiratory_tract_bac_sinusitis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`seborrhoeic_dermatitis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`sepsis_severe`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`tb_lymphadenopathy`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`unexplained_anaemia_neutropenia_or_thrombocytopenia`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`visceral_leishmaniasis`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`reason_for_starting_art`,  `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`who_stage`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`location`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`voided`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`void_reason`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`date_voided`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`voided_by`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`encounter_datetime`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`date_created`, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`creator`, COALESCE(`bart1_intermediate_bare_bones`.`visit_encounters`.visit_date, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.date_created) FROM `bart1_intermediate_bare_bones`.`hiv_staging_encounters` LEFT OUTER JOIN `bart1_intermediate_bare_bones`.`visit_encounters` ON
        visit_encounter_id = `bart1_intermediate_bare_bones`.`visit_encounters`.`id`
        WHERE `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`patient_id` = in_patient_id;

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
			patient_pregnant,
			patient_breast_feeding,
			cd4_count_available,
			cd4_count,
			cd4_count_modifier,
			cd4_count_percentage,
			date_of_cd4_count,
			asymptomatic,
			persistent_generalized_lymphadenopathy,
			unspecified_stage_1_cond,
			molluscumm_contagiosum,
			wart_virus_infection_extensive,
			oral_ulcerations_recurrent,
			parotid_enlargement_persistent_unexplained,
			lineal_gingival_erythema,
			herpes_zoster,
			respiratory_tract_infections_recurrent,
			unspecified_stage2_condition,
			angular_chelitis,
			papular_prurtic_eruptions,
			hepatosplenomegaly_unexplained,
			oral_hairy_leukoplakia,
			severe_weight_loss,
			fever_persistent_unexplained,
			pulmonary_tuberculosis,
			pulmonary_tuberculosis_last_2_years,
			severe_bacterial_infection,
			bacterial_pnuemonia,
			symptomatic_lymphoid_interstitial_pnuemonitis,
			chronic_hiv_assoc_lung_disease,
			unspecified_stage3_condition,
			aneamia,
			neutropaenia,
			thrombocytopaenia_chronic,
			diarhoea,
			oral_candidiasis,
			acute_necrotizing_ulcerative_gingivitis,
			lymph_node_tuberculosis,
			toxoplasmosis_of_brain,
			cryptococcal_meningitis,
			progressive_multifocal_leukoencephalopathy,
			disseminated_mycosis,
			candidiasis_of_oesophagus,
			extrapulmonary_tuberculosis,
			cerebral_non_hodgkin_lymphoma,
			kaposis,
			hiv_encephalopathy,
			bacterial_infections_severe_recurrent,
			unspecified_stage_4_condition,
			pnuemocystis_pnuemonia,
			disseminated_non_tuberculosis_mycobactierial_infection,
			cryptosporidiosis,
			isosporiasis,
			symptomatic_hiv_asscoiated_nephropathy,
			chronic_herpes_simplex_infection,
			cytomegalovirus_infection,
			toxoplasomis_of_the_brain_1month,
			recto_vaginal_fitsula,
			hiv_wasting_syndrome,
      cryptococcal_meningitis_or_other_eptb_cryptococcosis,
      candidiasis_of_oesophagus_trachea_bronchi_or_lungs,
      severe_unexplained_wasting_malnutrition,
      diarrhoea_chronic_less_1_month_unexplained,
      moderate_weight_loss_10_unexplained,
      cd4_percentage_available,
      acute_necrotizing_ulcerative_stomatitis_gingivitis_or_period,
      moderate_unexplained_wasting_malnutrition,
      diarrhoea_persistent_unexplained_14_days_or_more,
      acute_ulcerative_mouth_infections,
      anaemia_unexplained_8_g_dl,
      atypical_mycobacteriosis_disseminated_or_lung,
      bacterial_infections_sev_recurrent_excluding_pneumonia,
      cancer_cervix,
      chronic_herpes_simplex_infection_genital,
      cryptosporidiosis_chronic_with_diarrhoea,
      cytomegalovirus_infection_retinitis_or_other_organ,
      cytomegalovirus_of_an_organ_other_than_liver,
      fungal_nail_infections,
      herpes_simplex_infection_mucocutaneous_visceral,
      hiv_associated_cardiomyopathy,
      hiv_associated_nephropathy,
      invasive_cancer_cervix,
      isosporiasis_1_month,
      leishmaniasis_atypical_disseminated,
      minor_mucocutaneous_manifestations_seborrheic_dermatitis,
      moderate_unexplained_malnutrition,
      molluscum_contagiosum_extensive,
      non_typhoidal_salmonella_bacteraemia_recurrent,
      oral_candidiasis_from_age_2_months,
      oral_thrush,
      perform_extended_staging,
      pneumocystis_carinii_pneumonia,
      pneumonia_severe,
      recurrent_bacteraemia_or_sepsis_with_nts,
      recurrent_severe_presumed_pneumonia,
      recurrent_upper_respiratory_tract_bac_sinusitis,
      seborrhoeic_dermatitis,
      sepsis_severe,
      tb_lymphadenopathy,
      unexplained_anaemia_neutropenia_or_thrombocytopenia,
      visceral_leishmaniasis,			
			reason_for_starting_art,
			who_stage,
			location,
			voided,
			void_reason,
			date_voided,
			voided_by,
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
	SET @encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = 'hiv staging' LIMIT 1);

	# Create encounter
	INSERT INTO encounter (encounter_type, patient_id, provider_id, location_id, encounter_datetime, creator, date_created, uuid) VALUES (@encounter_type, patient_id, @provider, @location_id, encounter_datetime, @creator, date_created, (SELECT UUID())) ON DUPLICATE KEY UPDATE encounter_id = old_enc_id;

  SET @encounter_id = (SELECT LAST_INSERT_ID());
	
        # Check if the field is not empty
        IF NOT ISNULL(patient_pregnant) THEN

            # Get concept_id
            SET @patient_pregnant_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'patient pregnant' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded idWHO stage
            SET @patient_pregnant_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = patient_pregnant AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @patient_pregnant_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = patient_pregnant AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @patient_pregnant_concept_id, @encounter_id, encounter_datetime, @location_id , @patient_pregnant_value_coded, @patient_pregnant_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @patient_pregnant_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(patient_breast_feeding) THEN

            # Get concept_id
            SET @patient_breast_feeding_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'is patient breast feeding?' AND voided = 0 AND retired = 0 LIMIT 1);

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
            VALUES (patient_id, @patient_breast_feeding_concept_id, @encounter_id, encounter_datetime, @location_id , @patient_breast_feeding_value_coded, @patient_breast_feeding_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @patient_breast_feeding_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(cd4_count_available) THEN

            # Get concept_id
            SET @cd4_count_available_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'cd4 count available' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @cd4_count_available_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cd4_count_available AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @cd4_count_available_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cd4_count_available AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @cd4_count_available_concept_id, @encounter_id, encounter_datetime, @location_id , @cd4_count_available_value_coded, @cd4_count_available_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @cd4_count_available_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(cd4_count) THEN

            # Get concept_id
            SET @cd4_count_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'cd4 count' AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_numeric, creator, date_created, uuid)
            VALUES (patient_id, @cd4_count_concept_id, @encounter_id, encounter_datetime, @location_id , cd4_count, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @cd4_count_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(cd4_count_modifier) THEN

            # Get concept_id
            SET @cd4_count_modifier_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'cd4 count modifier' AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_text, creator, date_created, uuid)
            VALUES (patient_id, @cd4_count_modifier_concept_id, @encounter_id, encounter_datetime, @location_id , cd4_count_modifier, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @cd4_count_modifier_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(cd4_count_percentage) THEN

            # Get concept_id
            SET @cd4_count_percentage_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'cd4 percent' AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_numeric, creator, date_created, uuid)
            VALUES (patient_id, @cd4_count_percentage_concept_id, @encounter_id, encounter_datetime, @location_id , cd4_count_percentage, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @cd4_count_percentage_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(date_of_cd4_count) THEN

            # Get concept_id
            SET @date_of_cd4_count_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'cd4 count datetime' AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_datetime, creator, date_created, uuid)
            VALUES (patient_id, @date_of_cd4_count_concept_id, @encounter_id, encounter_datetime, @location_id , date_of_cd4_count, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @date_of_cd4_count_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(asymptomatic) THEN

            # Get concept_id
            SET @asymptomatic_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'asymptomatic' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @asymptomatic_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = asymptomatic AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @asymptomatic_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = asymptomatic AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @asymptomatic_concept_id, @encounter_id, encounter_datetime, @location_id , @asymptomatic_value_coded, @asymptomatic_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @asymptomatic_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(persistent_generalized_lymphadenopathy) THEN

            # Get concept_id
            SET @persistent_generalized_lymphadenopathy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'persistent generalized lymphadenopathy' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @persistent_generalized_lymphadenopathy_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = persistent_generalized_lymphadenopathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @persistent_generalized_lymphadenopathy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = persistent_generalized_lymphadenopathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @persistent_generalized_lymphadenopathy_concept_id, @encounter_id, encounter_datetime, @location_id , @persistent_generalized_lymphadenopathy_value_coded, @persistent_generalized_lymphadenopathy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @persistent_generalized_lymphadenopathy_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(unspecified_stage_1_cond) THEN

            # Get concept_id
            SET @unspecified_stage_1_cond_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'unspecified stage I condition' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @unspecified_stage_1_cond_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = unspecified_stage_1_cond AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @unspecified_stage_1_cond_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = unspecified_stage_1_cond AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @unspecified_stage_1_cond_concept_id, @encounter_id, encounter_datetime, @location_id , @unspecified_stage_1_cond_value_coded, @unspecified_stage_1_cond_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @unspecified_stage_1_cond_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        
        # Check if the field is not empty
        IF NOT ISNULL(molluscumm_contagiosum) THEN

            # Get concept_id
            SET @molluscumm_contagiosum_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'molluscum contagiosum' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @molluscumm_contagiosum_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = molluscumm_contagiosum AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @molluscumm_contagiosum_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = molluscumm_contagiosum AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @molluscumm_contagiosum_concept_id, @encounter_id, encounter_datetime, @location_id , @molluscumm_contagiosum_value_coded, @molluscumm_contagiosum_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @molluscumm_contagiosum_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(wart_virus_infection_extensive) THEN

            # Get concept_id
            SET @wart_virus_infection_extensive_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'wart virus infection, extensive' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @wart_virus_infection_extensive_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = wart_virus_infection_extensive AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @wart_virus_infection_extensive_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = wart_virus_infection_extensive AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @wart_virus_infection_extensive_concept_id, @encounter_id, encounter_datetime, @location_id , @wart_virus_infection_extensive_value_coded, @wart_virus_infection_extensive_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @wart_virus_infection_extensive_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(oral_ulcerations_recurrent) THEN

            # Get concept_id
            SET @oral_ulcerations_recurrent_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'oral ulcerations, recurrent' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @oral_ulcerations_recurrent_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = oral_ulcerations_recurrent AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @oral_ulcerations_recurrent_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = oral_ulcerations_recurrent AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @oral_ulcerations_recurrent_concept_id, @encounter_id, encounter_datetime, @location_id , @oral_ulcerations_recurrent_value_coded, @oral_ulcerations_recurrent_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @oral_ulcerations_recurrent_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(parotid_enlargement_persistent_unexplained) THEN

            # Get concept_id
            SET @parotid_enlargement_persistent_unexplained_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Parotid enlargement, persistent unexplained' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @parotid_enlargement_persistent_unexplained_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = parotid_enlargement_persistent_unexplained AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @parotid_enlargement_persistent_unexplained_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = parotid_enlargement_persistent_unexplained AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @parotid_enlargement_persistent_unexplained_concept_id, @encounter_id, encounter_datetime, @location_id , @parotid_enlargement_persistent_unexplained_value_coded, @parotid_enlargement_persistent_unexplained_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @parotid_enlargement_persistent_unexplained_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(lineal_gingival_erythema) THEN

            # Get concept_id
            SET @lineal_gingival_erythema_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'lineal gingival erythema' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @lineal_gingival_erythema_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = lineal_gingival_erythema AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @lineal_gingival_erythema_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = lineal_gingival_erythema AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @lineal_gingival_erythema_concept_id, @encounter_id, encounter_datetime, @location_id , @lineal_gingival_erythema_value_coded, @lineal_gingival_erythema_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @lineal_gingival_erythema_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(herpes_zoster) THEN

            # Get concept_id
            SET @herpes_zoster_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'herpes zoster' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @herpes_zoster_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = herpes_zoster AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @herpes_zoster_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = herpes_zoster AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @herpes_zoster_concept_id, @encounter_id, encounter_datetime, @location_id , @herpes_zoster_value_coded, @herpes_zoster_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @herpes_zoster_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(respiratory_tract_infections_recurrent) THEN

            # Get concept_id
            SET @respiratory_tract_infections_recurrent_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'recurrent upper respiratory infection' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @respiratory_tract_infections_recurrent_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = respiratory_tract_infections_recurrent AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @respiratory_tract_infections_recurrent_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = respiratory_tract_infections_recurrent AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @respiratory_tract_infections_recurrent_concept_id, @encounter_id, encounter_datetime, @location_id , @respiratory_tract_infections_recurrent_value_coded, @respiratory_tract_infections_recurrent_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @respiratory_tract_infections_recurrent_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(unspecified_stage2_condition) THEN

            # Get concept_id
            SET @unspecified_stage2_condition_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'unspecified stage II condition' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @unspecified_stage2_condition_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = unspecified_stage2_condition AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @unspecified_stage2_condition_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = unspecified_stage2_condition AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @unspecified_stage2_condition_concept_id, @encounter_id, encounter_datetime, @location_id , @unspecified_stage2_condition_value_coded, @unspecified_stage2_condition_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @unspecified_stage2_condition_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(angular_chelitis) THEN

            # Get concept_id
            SET @angular_chelitis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'angular cheilitis' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @angular_chelitis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = angular_chelitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @angular_chelitis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = angular_chelitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @angular_chelitis_concept_id, @encounter_id, encounter_datetime, @location_id , @angular_chelitis_value_coded, @angular_chelitis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @angular_chelitis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(papular_prurtic_eruptions) THEN

            # Get concept_id
            SET @papular_prurtic_eruptions_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'papular itchy skin eruptions' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @papular_prurtic_eruptions_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = papular_prurtic_eruptions AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @papular_prurtic_eruptions_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = papular_prurtic_eruptions AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @papular_prurtic_eruptions_concept_id, @encounter_id, encounter_datetime, @location_id , @papular_prurtic_eruptions_value_coded, @papular_prurtic_eruptions_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @papular_prurtic_eruptions_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(hepatosplenomegaly_unexplained) THEN

            # Get concept_id
            SET @hepatosplenomegaly_unexplained_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'hepatosplenomegaly persistent unexplained' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @hepatosplenomegaly_unexplained_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = hepatosplenomegaly_unexplained AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @hepatosplenomegaly_unexplained_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = hepatosplenomegaly_unexplained AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @hepatosplenomegaly_unexplained_concept_id, @encounter_id, encounter_datetime, @location_id , @hepatosplenomegaly_unexplained_value_coded, @hepatosplenomegaly_unexplained_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @hepatosplenomegaly_unexplained_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(oral_hairy_leukoplakia) THEN

            # Get concept_id
            SET @oral_hairy_leukoplakia_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'oral hairy leukoplakia' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @oral_hairy_leukoplakia_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = oral_hairy_leukoplakia AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @oral_hairy_leukoplakia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = oral_hairy_leukoplakia AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @oral_hairy_leukoplakia_concept_id, @encounter_id, encounter_datetime, @location_id , @oral_hairy_leukoplakia_value_coded, @oral_hairy_leukoplakia_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @oral_hairy_leukoplakia_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(severe_weight_loss) THEN

            # Get concept_id
            SET @severe_weight_loss_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'severe weight loss >10% and/or BMI <18.5kg/m^2, unexplained' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @severe_weight_loss_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = severe_weight_loss AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @severe_weight_loss_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = severe_weight_loss AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @severe_weight_loss_concept_id, @encounter_id, encounter_datetime, @location_id , @severe_weight_loss_value_coded, @severe_weight_loss_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @severe_weight_loss_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(fever_persistent_unexplained) THEN

            # Get concept_id
            SET @fever_persistent_unexplained_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Fever, persistent unexplained, intermittent or constant, >1 month' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @fever_persistent_unexplained_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = fever_persistent_unexplained AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @fever_persistent_unexplained_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = fever_persistent_unexplained AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @fever_persistent_unexplained_concept_id, @encounter_id, encounter_datetime, @location_id , @fever_persistent_unexplained_value_coded, @fever_persistent_unexplained_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @fever_persistent_unexplained_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(pulmonary_tuberculosis) THEN

            # Get concept_id
            SET @pulmonary_tuberculosis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Pulmonary tuberculosis (current)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @pulmonary_tuberculosis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = pulmonary_tuberculosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @pulmonary_tuberculosis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = pulmonary_tuberculosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @pulmonary_tuberculosis_concept_id, @encounter_id, encounter_datetime, @location_id , @pulmonary_tuberculosis_value_coded, @pulmonary_tuberculosis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @pulmonary_tuberculosis_id = (SELECT LAST_INSERT_ID());

        END IF;
        # Check if the field is not empty
        IF NOT ISNULL(pulmonary_tuberculosis_last_2_years) THEN
            # Get concept_id
            SET @pulmonary_tuberculosis_last_2_years_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'pulmonary tuberculosis within the last 2 years' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @pulmonary_tuberculosis_last_2_years_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = pulmonary_tuberculosis_last_2_years AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @pulmonary_tuberculosis_last_2_years_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = pulmonary_tuberculosis_last_2_years AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @pulmonary_tuberculosis_last_2_years_concept_id, @encounter_id, encounter_datetime, @location_id , @pulmonary_tuberculosis_last_2_years_value_coded, @pulmonary_tuberculosis_last_2_years_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @pulmonary_tuberculosis_last_2_years_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(severe_bacterial_infection) THEN

            # Get concept_id
            SET @severe_bacterial_infection_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'severe bacterial infections' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @severe_bacterial_infection_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = severe_bacterial_infection AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @severe_bacterial_infection_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = severe_bacterial_infection AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @severe_bacterial_infection_concept_id, @encounter_id, encounter_datetime, @location_id , @severe_bacterial_infection_value_coded, @severe_bacterial_infection_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @severe_bacterial_infection_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(bacterial_pnuemonia) THEN

            # Get concept_id
            SET @bacterial_pnuemonia_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Bacterial pneumonia, severe recurrent' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @bacterial_pnuemonia_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = bacterial_pnuemonia AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @bacterial_pnuemonia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = bacterial_pnuemonia AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @bacterial_pnuemonia_concept_id, @encounter_id, encounter_datetime, @location_id , @bacterial_pnuemonia_value_coded, @bacterial_pnuemonia_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @bacterial_pnuemonia_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(symptomatic_lymphoid_interstitial_pnuemonitis) THEN

            # Get concept_id
            SET @symptomatic_lymphoid_interstitial_pnuemonitis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'symptomatic lymphoid interstitial pneumonia' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @symptomatic_lymphoid_interstitial_pnuemonitis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = symptomatic_lymphoid_interstitial_pnuemonitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @symptomatic_lymphoid_interstitial_pnuemonitis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = symptomatic_lymphoid_interstitial_pnuemonitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @symptomatic_lymphoid_interstitial_pnuemonitis_concept_id, @encounter_id, encounter_datetime, @location_id , @symptomatic_lymphoid_interstitial_pnuemonitis_value_coded, @symptomatic_lymphoid_interstitial_pnuemonitis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @symptomatic_lymphoid_interstitial_pnuemonitis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(chronic_hiv_assoc_lung_disease) THEN

            # Get concept_id
            SET @chronic_hiv_assoc_lung_disease_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'chronic HIV lung disease' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @chronic_hiv_assoc_lung_disease_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = chronic_hiv_assoc_lung_disease AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @chronic_hiv_assoc_lung_disease_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = chronic_hiv_assoc_lung_disease AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @chronic_hiv_assoc_lung_disease_concept_id, @encounter_id, encounter_datetime, @location_id , @chronic_hiv_assoc_lung_disease_value_coded, @chronic_hiv_assoc_lung_disease_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @chronic_hiv_assoc_lung_disease_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(unspecified_stage3_condition) THEN

            # Get concept_id
            SET @unspecified_stage3_condition_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'unspecified stage III condition' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @unspecified_stage3_condition_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = unspecified_stage3_condition AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @unspecified_stage3_condition_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = unspecified_stage3_condition AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @unspecified_stage3_condition_concept_id, @encounter_id, encounter_datetime, @location_id , @unspecified_stage3_condition_value_coded, @unspecified_stage3_condition_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @unspecified_stage3_condition_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(aneamia) THEN

            # Get concept_id
            SET @aneamia_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Anemia' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @aneamia_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = aneamia AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @aneamia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = aneamia AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @aneamia_concept_id, @encounter_id, encounter_datetime, @location_id , @aneamia_value_coded, @aneamia_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @aneamia_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(neutropaenia) THEN

            # Get concept_id
            SET @neutropaenia_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'neutropaenia, unexplained < 500 /mm(cubed)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @neutropaenia_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = neutropaenia AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @neutropaenia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = neutropaenia AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @neutropaenia_concept_id, @encounter_id, encounter_datetime, @location_id , @neutropaenia_value_coded, @neutropaenia_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @neutropaenia_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(thrombocytopaenia_chronic) THEN

            # Get concept_id
            SET @thrombocytopaenia_chronic_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'thrombocytopaenia, chronic < 50,000 /mm(cubed)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @thrombocytopaenia_chronic_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = thrombocytopaenia_chronic AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @thrombocytopaenia_chronic_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = thrombocytopaenia_chronic AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @thrombocytopaenia_chronic_concept_id, @encounter_id, encounter_datetime, @location_id , @thrombocytopaenia_chronic_value_coded, @thrombocytopaenia_chronic_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @thrombocytopaenia_chronic_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(diarhoea) THEN

            # Get concept_id
            SET @diarhoea_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Diarrhea' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @diarhoea_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = diarhoea AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @diarhoea_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = diarhoea AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @diarhoea_concept_id, @encounter_id, encounter_datetime, @location_id , @diarhoea_value_coded, @diarhoea_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @diarhoea_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(oral_candidiasis) THEN

            # Get concept_id
            SET @oral_candidiasis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'oral candidiasis' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @oral_candidiasis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = oral_candidiasis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @oral_candidiasis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = oral_candidiasis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @oral_candidiasis_concept_id, @encounter_id, encounter_datetime, @location_id , @oral_candidiasis_value_coded, @oral_candidiasis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @oral_candidiasis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(acute_necrotizing_ulcerative_gingivitis) THEN

            # Get concept_id
            SET @acute_necrotizing_ulcerative_gingivitis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'acute necrotizing ulcerative gingivitis or periodontitis' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @acute_necrotizing_ulcerative_gingivitis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = acute_necrotizing_ulcerative_gingivitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @acute_necrotizing_ulcerative_gingivitis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = acute_necrotizing_ulcerative_gingivitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @acute_necrotizing_ulcerative_gingivitis_concept_id, @encounter_id, encounter_datetime, @location_id , @acute_necrotizing_ulcerative_gingivitis_value_coded, @acute_necrotizing_ulcerative_gingivitis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @acute_necrotizing_ulcerative_gingivitis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(lymph_node_tuberculosis) THEN

            # Get concept_id
            SET @lymph_node_tuberculosis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'lymph node tuberculosis' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @lymph_node_tuberculosis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = lymph_node_tuberculosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @lymph_node_tuberculosis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = lymph_node_tuberculosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @lymph_node_tuberculosis_concept_id, @encounter_id, encounter_datetime, @location_id , @lymph_node_tuberculosis_value_coded, @lymph_node_tuberculosis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @lymph_node_tuberculosis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(toxoplasmosis_of_brain) THEN

            # Get concept_id
            SET @toxoplasmosis_of_brain_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'toxoplasmosis of the brain' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @toxoplasmosis_of_brain_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = toxoplasmosis_of_brain AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @toxoplasmosis_of_brain_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = toxoplasmosis_of_brain AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @toxoplasmosis_of_brain_concept_id, @encounter_id, encounter_datetime, @location_id , @toxoplasmosis_of_brain_value_coded, @toxoplasmosis_of_brain_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @toxoplasmosis_of_brain_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(cryptococcal_meningitis) THEN

            # Get concept_id
            SET @cryptococcal_meningitis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'cryptococcal meningitis' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @cryptococcal_meningitis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cryptococcal_meningitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @cryptococcal_meningitis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cryptococcal_meningitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @cryptococcal_meningitis_concept_id, @encounter_id, encounter_datetime, @location_id , @cryptococcal_meningitis_value_coded, @cryptococcal_meningitis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @cryptococcal_meningitis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(progressive_multifocal_leukoencephalopathy) THEN

            # Get concept_id
            SET @progressive_multifocal_leukoencephalopathy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'progressive multifocal leukoencephalopathy' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @progressive_multifocal_leukoencephalopathy_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = progressive_multifocal_leukoencephalopathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @progressive_multifocal_leukoencephalopathy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = progressive_multifocal_leukoencephalopathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @progressive_multifocal_leukoencephalopathy_concept_id, @encounter_id, encounter_datetime, @location_id , @progressive_multifocal_leukoencephalopathy_value_coded, @progressive_multifocal_leukoencephalopathy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @progressive_multifocal_leukoencephalopathy_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(disseminated_mycosis) THEN

            # Get concept_id
            SET @disseminated_mycosis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'disseminated mycosis (coccidiomycosis or histoplasmosis)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @disseminated_mycosis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = disseminated_mycosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @disseminated_mycosis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = disseminated_mycosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @disseminated_mycosis_concept_id, @encounter_id, encounter_datetime, @location_id , @disseminated_mycosis_value_coded, @disseminated_mycosis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @disseminated_mycosis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(candidiasis_of_oesophagus) THEN

            # Get concept_id
            SET @candidiasis_of_oesophagus_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'candidiasis of oseophagus' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @candidiasis_of_oesophagus_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = candidiasis_of_oesophagus AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @candidiasis_of_oesophagus_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = candidiasis_of_oesophagus AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @candidiasis_of_oesophagus_concept_id, @encounter_id, encounter_datetime, @location_id , @candidiasis_of_oesophagus_value_coded, @candidiasis_of_oesophagus_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @candidiasis_of_oesophagus_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(extrapulmonary_tuberculosis) THEN

            # Get concept_id
            SET @extrapulmonary_tuberculosis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'extrapulmonary tuberculosis (EPTB)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @extrapulmonary_tuberculosis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = extrapulmonary_tuberculosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @extrapulmonary_tuberculosis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = extrapulmonary_tuberculosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @extrapulmonary_tuberculosis_concept_id, @encounter_id, encounter_datetime, @location_id , @extrapulmonary_tuberculosis_value_coded, @extrapulmonary_tuberculosis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @extrapulmonary_tuberculosis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(cerebral_non_hodgkin_lymphoma) THEN

            # Get concept_id
            SET @cerebral_non_hodgkin_lymphoma_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'cerebral or B-cell non Hodgkin lymphoma' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @cerebral_non_hodgkin_lymphoma_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cerebral_non_hodgkin_lymphoma AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @cerebral_non_hodgkin_lymphoma_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cerebral_non_hodgkin_lymphoma AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @cerebral_non_hodgkin_lymphoma_concept_id, @encounter_id, encounter_datetime, @location_id , @cerebral_non_hodgkin_lymphoma_value_coded, @cerebral_non_hodgkin_lymphoma_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @cerebral_non_hodgkin_lymphoma_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(kaposis) THEN

            # Get concept_id
            SET @kaposis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Kaposis sarcoma' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @kaposis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = kaposis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @kaposis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = kaposis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @kaposis_concept_id, @encounter_id, encounter_datetime, @location_id , @kaposis_value_coded, @kaposis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @kaposis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(hiv_encephalopathy) THEN

            # Get concept_id
            SET @hiv_encephalopathy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'HIV encephalopathy' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @hiv_encephalopathy_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = hiv_encephalopathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @hiv_encephalopathy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = hiv_encephalopathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @hiv_encephalopathy_concept_id, @encounter_id, encounter_datetime, @location_id , @hiv_encephalopathy_value_coded, @hiv_encephalopathy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @hiv_encephalopathy_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(bacterial_infections_severe_recurrent) THEN

            # Get concept_id
            SET @bacterial_infections_severe_recurrent_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'recurrent severe presumed bacterial infections' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @bacterial_infections_severe_recurrent_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = bacterial_infections_severe_recurrent AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @bacterial_infections_severe_recurrent_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = bacterial_infections_severe_recurrent AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @bacterial_infections_severe_recurrent_concept_id, @encounter_id, encounter_datetime, @location_id , @bacterial_infections_severe_recurrent_value_coded, @bacterial_infections_severe_recurrent_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @bacterial_infections_severe_recurrent_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(unspecified_stage_4_condition) THEN

            # Get concept_id
            SET @unspecified_stage_4_condition_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'unspecified stage IV condition' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @unspecified_stage_4_condition_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = unspecified_stage_4_condition AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @unspecified_stage_4_condition_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = unspecified_stage_4_condition AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @unspecified_stage_4_condition_concept_id, @encounter_id, encounter_datetime, @location_id , @unspecified_stage_4_condition_value_coded, @unspecified_stage_4_condition_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @unspecified_stage_4_condition_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(pnuemocystis_pnuemonia) THEN

            # Get concept_id
            SET @pnuemocystis_pnuemonia_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'pneumocystis pneumonia' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @pnuemocystis_pnuemonia_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = pnuemocystis_pnuemonia AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @pnuemocystis_pnuemonia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = pnuemocystis_pnuemonia AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @pnuemocystis_pnuemonia_concept_id, @encounter_id, encounter_datetime, @location_id , @pnuemocystis_pnuemonia_value_coded, @pnuemocystis_pnuemonia_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @pnuemocystis_pnuemonia_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(disseminated_non_tuberculosis_mycobactierial_infection) THEN

            # Get concept_id
            SET @disseminated_non_tuberculosis_mycobactierial_infection_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'disseminated non-tuberculosis mycobacterial infection' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @disseminated_non_tuberculosis_mycobactierial_infection_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = disseminated_non_tuberculosis_mycobactierial_infection AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @disseminated_non_tuberculosis_mycobactierial_infection_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = disseminated_non_tuberculosis_mycobactierial_infection AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @disseminated_non_tuberculosis_mycobactierial_infection_concept_id, @encounter_id, encounter_datetime, @location_id , @disseminated_non_tuberculosis_mycobactierial_infection_value_coded, @disseminated_non_tuberculosis_mycobactierial_infection_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @disseminated_non_tuberculosis_mycobactierial_infection_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(cryptosporidiosis) THEN

            # Get concept_id
            SET @cryptosporidiosis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'cryptosporidiosis' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @cryptosporidiosis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cryptosporidiosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @cryptosporidiosis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cryptosporidiosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @cryptosporidiosis_concept_id, @encounter_id, encounter_datetime, @location_id , @cryptosporidiosis_value_coded, @cryptosporidiosis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @cryptosporidiosis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(isosporiasis) THEN

            # Get concept_id
            SET @isosporiasis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Isosporiasis' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @isosporiasis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = isosporiasis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @isosporiasis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = isosporiasis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @isosporiasis_concept_id, @encounter_id, encounter_datetime, @location_id , @isosporiasis_value_coded, @isosporiasis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @isosporiasis_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(symptomatic_hiv_asscoiated_nephropathy) THEN

            # Get concept_id
            SET @symptomatic_hiv_asscoiated_nephropathy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'symptomatic HIV associated nephropathy or cardiomyopathy' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @symptomatic_hiv_asscoiated_nephropathy_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = symptomatic_hiv_asscoiated_nephropathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @symptomatic_hiv_asscoiated_nephropathy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = symptomatic_hiv_asscoiated_nephropathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @symptomatic_hiv_asscoiated_nephropathy_concept_id, @encounter_id, encounter_datetime, @location_id , @symptomatic_hiv_asscoiated_nephropathy_value_coded, @symptomatic_hiv_asscoiated_nephropathy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @symptomatic_hiv_asscoiated_nephropathy_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(chronic_herpes_simplex_infection) THEN

            # Get concept_id
            SET @chronic_herpes_simplex_infection_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'chonic herpes simplex' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @chronic_herpes_simplex_infection_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = chronic_herpes_simplex_infection AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @chronic_herpes_simplex_infection_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = chronic_herpes_simplex_infection AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @chronic_herpes_simplex_infection_concept_id, @encounter_id, encounter_datetime, @location_id , @chronic_herpes_simplex_infection_value_coded, @chronic_herpes_simplex_infection_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @chronic_herpes_simplex_infection_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(cytomegalovirus_infection) THEN

            # Get concept_id
            SET @cytomegalovirus_infection_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'cytomegalovirus infection' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @cytomegalovirus_infection_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cytomegalovirus_infection AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @cytomegalovirus_infection_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cytomegalovirus_infection AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @cytomegalovirus_infection_concept_id, @encounter_id, encounter_datetime, @location_id , @cytomegalovirus_infection_value_coded, @cytomegalovirus_infection_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @cytomegalovirus_infection_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(toxoplasomis_of_the_brain_1month) THEN

            # Get concept_id
            SET @toxoplasomis_of_the_brain_1month_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'toxoplasmosis of the brain (from age 1 month)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @toxoplasomis_of_the_brain_1month_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = toxoplasomis_of_the_brain_1month AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @toxoplasomis_of_the_brain_1month_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = toxoplasomis_of_the_brain_1month AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @toxoplasomis_of_the_brain_1month_concept_id, @encounter_id, encounter_datetime, @location_id , @toxoplasomis_of_the_brain_1month_value_coded, @toxoplasomis_of_the_brain_1month_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @toxoplasomis_of_the_brain_1month_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(recto_vaginal_fitsula) THEN

            # Get concept_id
            SET @recto_vaginal_fitsula_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'recto-vaginal fistula, HIV-associated' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @recto_vaginal_fitsula_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = recto_vaginal_fitsula AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @recto_vaginal_fitsula_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = recto_vaginal_fitsula AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @recto_vaginal_fitsula_concept_id, @encounter_id, encounter_datetime, @location_id , @recto_vaginal_fitsula_value_coded, @recto_vaginal_fitsula_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @recto_vaginal_fitsula_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(hiv_wasting_syndrome) THEN

            # Get concept_id
            SET @hiv_wasting_syndrome_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'HIV wasting syndrome (severe weight loss + persistent fever or severe weight loss + chronic diarrhoea)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @hiv_wasting_syndrome_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = hiv_wasting_syndrome AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @hiv_wasting_syndrome_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = hiv_wasting_syndrome AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @hiv_wasting_syndrome_concept_id, @encounter_id, encounter_datetime, @location_id , @hiv_wasting_syndrome_value_coded, @hiv_wasting_syndrome_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @hiv_wasting_syndrome_id = (SELECT LAST_INSERT_ID());

        END IF;

        
        # Check if the field is not empty
        IF NOT ISNULL(cryptococcal_meningitis_or_other_eptb_cryptococcosis) THEN

            # Get concept_id
            SET @cryptococcal_meningitis_or_other_eptb_cryptococcosis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Cryptococcal meningitis or other extrapulmonary cryptococcosis' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @cryptococcal_meningitis_or_other_eptb_cryptococcosis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cryptococcal_meningitis_or_other_eptb_cryptococcosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @cryptococcal_meningitis_or_other_eptb_cryptococcosis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cryptococcal_meningitis_or_other_eptb_cryptococcosis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @cryptococcal_meningitis_or_other_eptb_cryptococcosis_concept_id, @encounter_id, encounter_datetime, @location_id , @cryptococcal_meningitis_or_other_eptb_cryptococcosis_value_coded, @cryptococcal_meningitis_or_other_eptb_cryptococcosis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @cryptococcal_meningitis_or_other_eptb_cryptococcosis_id = (SELECT LAST_INSERT_ID());        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(candidiasis_of_oesophagus_trachea_bronchi_or_lungs) THEN

            # Get concept_id
            SET @candidiasis_of_oesophagus_trachea_bronchi_or_lungs_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Candidiasis of oseophagus, trachea and bronchi or lungs' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @candidiasis_of_oesophagus_trachea_bronchi_or_lungs_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = candidiasis_of_oesophagus_trachea_bronchi_or_lungs AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @candidiasis_of_oesophagus_trachea_bronchi_or_lungs_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = candidiasis_of_oesophagus_trachea_bronchi_or_lungs AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @candidiasis_of_oesophagus_trachea_bronchi_or_lungs_concept_id, @encounter_id, encounter_datetime, @location_id , @candidiasis_of_oesophagus_trachea_bronchi_or_lungs_value_coded, @candidiasis_of_oesophagus_trachea_bronchi_or_lungs_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @candidiasis_of_oesophagus_trachea_bronchi_or_lungs_id = (SELECT LAST_INSERT_ID());

        END IF;        
        
       # Check if the field is not empty
        IF NOT ISNULL(severe_unexplained_wasting_malnutrition) THEN

            # Get concept_id
            SET @severe_unexplained_wasting_malnutrition_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Severe unexplained wasting or malnutrition not responding to treatment (weight-for-height/ -age <70% or MUAC less than 11cm or oedema)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @severe_unexplained_wasting_malnutrition_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = severe_unexplained_wasting_malnutrition AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @severe_unexplained_wasting_malnutrition_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = severe_unexplained_wasting_malnutrition AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @severe_unexplained_wasting_malnutrition_concept_id, @encounter_id, encounter_datetime, @location_id , @severe_unexplained_wasting_malnutrition_value_coded, @severe_unexplained_wasting_malnutrition_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @severe_unexplained_wasting_malnutrition_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(diarrhoea_chronic_less_1_month_unexplained) THEN

            # Get concept_id
            SET @diarrhoea_chronic_less_1_month_unexplained_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Diarrhoea, chronic (>1 month) unexplained' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @diarrhoea_chronic_less_1_month_unexplained_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = diarrhoea_chronic_less_1_month_unexplained AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @diarrhoea_chronic_less_1_month_unexplained_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = diarrhoea_chronic_less_1_month_unexplained AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @diarrhoea_chronic_less_1_month_unexplained_concept_id, @encounter_id, encounter_datetime, @location_id , @diarrhoea_chronic_less_1_month_unexplained_value_coded, @diarrhoea_chronic_less_1_month_unexplained_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @diarrhoea_chronic_less_1_month_unexplained_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(moderate_weight_loss_10_unexplained) THEN

            # Get concept_id
            SET @moderate_weight_loss_10_unexplained_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Moderate weight loss less than or equal to 10 percent, unexplained' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @moderate_weight_loss_10_unexplained_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = moderate_weight_loss_10_unexplained AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @moderate_weight_loss_10_unexplained_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = moderate_weight_loss_10_unexplained AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @moderate_weight_loss_10_unexplained_concept_id, @encounter_id, encounter_datetime, @location_id , @moderate_weight_loss_10_unexplained_value_coded, @moderate_weight_loss_10_unexplained_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @moderate_weight_loss_10_unexplained_id = (SELECT LAST_INSERT_ID());

        END IF;   

       # Check if the field is not empty
        IF NOT ISNULL(acute_necrotizing_ulcerative_stomatitis_gingivitis_or_period) THEN

            # Get concept_id
            SET @acute_necrotizing_ulcerative_stomatitis_gingivitis_or_period_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name LIKE '%Acute necrotizing ulcerative stomatitis, gingivitis or periodontitis%' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @acute_necrotizing_ulcerative_stomatitis_gingivitis_or_period_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = acute_necrotizing_ulcerative_stomatitis_gingivitis_or_period AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @acute_necrotizing_ulcerative_stomatitis_gingivitis_or_period_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = acute_necrotizing_ulcerative_stomatitis_gingivitis_or_period AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @acute_necrotizing_ulcerative_stomatitis_gingivitis_or_period_concept_id, @encounter_id, encounter_datetime, @location_id , @acute_necrotizing_ulcerative_stomatitis_gingivitis_or_period_value_coded, @acute_necrotizing_ulcerative_stomatitis_gingivitis_or_period_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @acute_necrotizing_ulcerative_stomatitis_gingivitis_or_period_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(moderate_unexplained_wasting_malnutrition) THEN

            # Get concept_id
            SET @moderate_unexplained_wasting_malnutrition_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Moderate unexplained wasting/malnutrition not responding to treatment (weight-for-height/ -age 70-79% or muac 11-12 cm)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @moderate_unexplained_wasting_malnutrition_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = moderate_unexplained_wasting_malnutrition AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @moderate_unexplained_wasting_malnutrition_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = moderate_unexplained_wasting_malnutrition AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @moderate_unexplained_wasting_malnutrition_concept_id, @encounter_id, encounter_datetime, @location_id , @moderate_unexplained_wasting_malnutrition_value_coded, @moderate_unexplained_wasting_malnutrition_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @moderate_unexplained_wasting_malnutrition_id = (SELECT LAST_INSERT_ID());

        END IF;                     

       # Check if the field is not empty
        IF NOT ISNULL(diarrhoea_persistent_unexplained_14_days_or_more) THEN

            # Get concept_id
            SET @diarrhoea_persistent_unexplained_14_days_or_more_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Diarrhoea, persistent unexplained (14 days or more)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @diarrhoea_persistent_unexplained_14_days_or_more_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = diarrhoea_persistent_unexplained_14_days_or_more AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @diarrhoea_persistent_unexplained_14_days_or_more_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = diarrhoea_persistent_unexplained_14_days_or_more AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @diarrhoea_persistent_unexplained_14_days_or_more_concept_id, @encounter_id, encounter_datetime, @location_id , @diarrhoea_persistent_unexplained_14_days_or_more_value_coded, @diarrhoea_persistent_unexplained_14_days_or_more_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @diarrhoea_persistent_unexplained_14_days_or_more_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(acute_ulcerative_mouth_infections) THEN

            # Get concept_id
            SET @acute_ulcerative_mouth_infections_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Acute ulcerative mouth infections' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @acute_ulcerative_mouth_infections_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = acute_ulcerative_mouth_infections AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @acute_ulcerative_mouth_infections_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = acute_ulcerative_mouth_infections AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @acute_ulcerative_mouth_infections_concept_id, @encounter_id, encounter_datetime, @location_id , @acute_ulcerative_mouth_infections_value_coded, @acute_ulcerative_mouth_infections_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @acute_ulcerative_mouth_infections_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(anaemia_unexplained_8_g_dl) THEN

            # Get concept_id
            SET @anaemia_unexplained_8_g_dl_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Anaemia, unexplained < 8 g/dl' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @anaemia_unexplained_8_g_dl_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = anaemia_unexplained_8_g_dl AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @anaemia_unexplained_8_g_dl_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = anaemia_unexplained_8_g_dl AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @anaemia_unexplained_8_g_dl_concept_id, @encounter_id, encounter_datetime, @location_id , @anaemia_unexplained_8_g_dl_value_coded, @anaemia_unexplained_8_g_dl_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @anaemia_unexplained_8_g_dl_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(atypical_mycobacteriosis_disseminated_or_lung) THEN

            # Get concept_id
            SET @atypical_mycobacteriosis_disseminated_or_lung_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Atypical mycobacteriosis, disseminated or lung' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @atypical_mycobacteriosis_disseminated_or_lung_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = atypical_mycobacteriosis_disseminated_or_lung AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @atypical_mycobacteriosis_disseminated_or_lung_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = atypical_mycobacteriosis_disseminated_or_lung AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @atypical_mycobacteriosis_disseminated_or_lung_concept_id, @encounter_id, encounter_datetime, @location_id , @atypical_mycobacteriosis_disseminated_or_lung_value_coded, @atypical_mycobacteriosis_disseminated_or_lung_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @atypical_mycobacteriosis_disseminated_or_lung_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(bacterial_infections_sev_recurrent_excluding_pneumonia) THEN

            # Get concept_id
            SET @bacterial_infections_sev_recurrent_excluding_pneumonia_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Bacterial infections, severe recurrent  (empyema, pyomyositis, meningitis, bone/joint infections but EXCLUDING pneumonia)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @bacterial_infections_sev_recurrent_excluding_pneumonia_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = bacterial_infections_sev_recurrent_excluding_pneumonia AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @bacterial_infections_sev_recurrent_excluding_pneumonia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = bacterial_infections_sev_recurrent_excluding_pneumonia AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @bacterial_infections_sev_recurrent_excluding_pneumonia_concept_id, @encounter_id, encounter_datetime, @location_id , @bacterial_infections_sev_recurrent_excluding_pneumonia_value_coded, @bacterial_infections_sev_recurrent_excluding_pneumonia_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @bacterial_infections_sev_recurrent_excluding_pneumonia_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(cancer_cervix) THEN

            # Get concept_id
            SET @cancer_cervix_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Cancer cervix' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @cancer_cervix_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cancer_cervix AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @cancer_cervix_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cancer_cervix AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @cancer_cervix_concept_id, @encounter_id, encounter_datetime, @location_id , @cancer_cervix_value_coded, @cancer_cervix_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @cancer_cervix_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(chronic_herpes_simplex_infection_genital) THEN

            # Get concept_id
            SET @chronic_herpes_simplex_infection_genital_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Chronic herpes simplex infection(orolabial, genital / anorectal >1 month or visceral at any site)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @chronic_herpes_simplex_infection_genital_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = chronic_herpes_simplex_infection_genital AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @chronic_herpes_simplex_infection_genital_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = chronic_herpes_simplex_infection_genital AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @chronic_herpes_simplex_infection_genital_concept_id, @encounter_id, encounter_datetime, @location_id , @chronic_herpes_simplex_infection_genital_value_coded, @chronic_herpes_simplex_infection_genital_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @chronic_herpes_simplex_infection_genital_id = (SELECT LAST_INSERT_ID());

        END IF;                                                                             
        
       # Check if the field is not empty
        IF NOT ISNULL(cryptosporidiosis_chronic_with_diarrhoea) THEN

            # Get concept_id
            SET @cryptosporidiosis_chronic_with_diarrhoea_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Cryptosporidiosis, chronic with diarroea' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @cryptosporidiosis_chronic_with_diarrhoea_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cryptosporidiosis_chronic_with_diarrhoea AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @cryptosporidiosis_chronic_with_diarrhoea_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cryptosporidiosis_chronic_with_diarrhoea AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @cryptosporidiosis_chronic_with_diarrhoea_concept_id, @encounter_id, encounter_datetime, @location_id , @cryptosporidiosis_chronic_with_diarrhoea_value_coded, @cryptosporidiosis_chronic_with_diarrhoea_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @cryptosporidiosis_chronic_with_diarrhoea_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(cytomegalovirus_infection_retinitis_or_other_organ) THEN

            # Get concept_id
            SET @cytomegalovirus_infection_retinitis_or_other_organ_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Cytomegalovirus infection: rentinitis or other organ (from age 1 month)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @cytomegalovirus_infection_retinitis_or_other_organ_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cytomegalovirus_infection_retinitis_or_other_organ AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @cytomegalovirus_infection_retinitis_or_other_organ_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cytomegalovirus_infection_retinitis_or_other_organ AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @cytomegalovirus_infection_retinitis_or_other_organ_concept_id, @encounter_id, encounter_datetime, @location_id , @cytomegalovirus_infection_retinitis_or_other_organ_value_coded, @cytomegalovirus_infection_retinitis_or_other_organ_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @cytomegalovirus_infection_retinitis_or_other_organ_id = (SELECT LAST_INSERT_ID());

        END IF;                

       # Check if the field is not empty
        IF NOT ISNULL(cytomegalovirus_of_an_organ_other_than_liver) THEN

            # Get concept_id
            SET @cytomegalovirus_of_an_organ_other_than_liver_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Cytomegalovirus of an organ other than liver, spleen or lymph node' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @cytomegalovirus_of_an_organ_other_than_liver_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cytomegalovirus_of_an_organ_other_than_liver AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @cytomegalovirus_of_an_organ_other_than_liver_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = cytomegalovirus_of_an_organ_other_than_liver AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @cytomegalovirus_of_an_organ_other_than_liver_concept_id, @encounter_id, encounter_datetime, @location_id , @cytomegalovirus_of_an_organ_other_than_liver_value_coded, @cytomegalovirus_of_an_organ_other_than_liver_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @cytomegalovirus_of_an_organ_other_than_liver_id = (SELECT LAST_INSERT_ID());

        END IF;        

       # Check if the field is not empty
        IF NOT ISNULL(fungal_nail_infections) THEN

            # Get concept_id
            SET @fungal_nail_infections_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Fungal nail infection' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @fungal_nail_infections_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = fungal_nail_infections AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @fungal_nail_infections_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = fungal_nail_infections AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @fungal_nail_infections_concept_id, @encounter_id, encounter_datetime, @location_id , @fungal_nail_infections_value_coded, @fungal_nail_infections_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @fungal_nail_infections_id = (SELECT LAST_INSERT_ID());

        END IF;        

       # Check if the field is not empty
        IF NOT ISNULL(herpes_simplex_infection_mucocutaneous_visceral) THEN

            # Get concept_id
            SET @herpes_simplex_infection_mucocutaneous_visceral_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Herpes simplex infection, mucocutaneous for longer than 1 month or visceral' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @herpes_simplex_infection_mucocutaneous_visceral_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = herpes_simplex_infection_mucocutaneous_visceral AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @herpes_simplex_infection_mucocutaneous_visceral_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = herpes_simplex_infection_mucocutaneous_visceral AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @herpes_simplex_infection_mucocutaneous_visceral_concept_id, @encounter_id, encounter_datetime, @location_id , @herpes_simplex_infection_mucocutaneous_visceral_value_coded, @herpes_simplex_infection_mucocutaneous_visceral_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @herpes_simplex_infection_mucocutaneous_visceral_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(hiv_associated_cardiomyopathy) THEN

            # Get concept_id
            SET @hiv_associated_cardiomyopathy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'HIV associated cardiomyopathy' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @hiv_associated_cardiomyopathy_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = hiv_associated_cardiomyopathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @hiv_associated_cardiomyopathy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = hiv_associated_cardiomyopathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @hiv_associated_cardiomyopathy_concept_id, @encounter_id, encounter_datetime, @location_id , @hiv_associated_cardiomyopathy_value_coded, @hiv_associated_cardiomyopathy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @hiv_associated_cardiomyopathy_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(hiv_associated_nephropathy) THEN

            # Get concept_id
            SET @hiv_associated_nephropathy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'HIV associated nephropathy' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @hiv_associated_nephropathy_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = hiv_associated_nephropathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @hiv_associated_nephropathy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = hiv_associated_nephropathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @hiv_associated_nephropathy_concept_id, @encounter_id, encounter_datetime, @location_id , @hiv_associated_nephropathy_value_coded, @hiv_associated_nephropathy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @hiv_associated_nephropathy_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(invasive_cancer_cervix) THEN

            # Get concept_id
            SET @invasive_cancer_cervix_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Invasive cancer of cervix' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @invasive_cancer_cervix_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = invasive_cancer_cervix AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @invasive_cancer_cervix_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = invasive_cancer_cervix AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @invasive_cancer_cervix_concept_id, @encounter_id, encounter_datetime, @location_id , @invasive_cancer_cervix_value_coded, @invasive_cancer_cervix_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @invasive_cancer_cervix_id = (SELECT LAST_INSERT_ID());

        END IF;                                

       # Check if the field is not empty
        IF NOT ISNULL(isosporiasis_1_month) THEN

            # Get concept_id
            SET @isosporiasis_1_month_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Isosporiasis >1 month' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @isosporiasis_1_month_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = isosporiasis_1_month AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @isosporiasis_1_month_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = isosporiasis_1_month AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @isosporiasis_1_month_concept_id, @encounter_id, encounter_datetime, @location_id , @isosporiasis_1_month_value_coded, @isosporiasis_1_month_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @isosporiasis_1_month_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(leishmaniasis_atypical_disseminated) THEN

            # Get concept_id
            SET @leishmaniasis_atypical_disseminated_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Leishmaniasis, atypical disseminated' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @leishmaniasis_atypical_disseminated_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = leishmaniasis_atypical_disseminated AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @leishmaniasis_atypical_disseminated_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = leishmaniasis_atypical_disseminated AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @leishmaniasis_atypical_disseminated_concept_id, @encounter_id, encounter_datetime, @location_id , @leishmaniasis_atypical_disseminated_value_coded, @leishmaniasis_atypical_disseminated_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @leishmaniasis_atypical_disseminated_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(minor_mucocutaneous_manifestations_seborrheic_dermatitis) THEN

            # Get concept_id
            SET @minor_mucocutaneous_manifestations_seborrheic_dermatitis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Minor mucocutaneous manifestations (seborrheic dermatitis, prurigo, fungal nail infections, recurrent oral ulcerations, angular chelitis)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @minor_mucocutaneous_manifestations_seborrheic_dermatitis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = minor_mucocutaneous_manifestations_seborrheic_dermatitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @minor_mucocutaneous_manifestations_seborrheic_dermatitis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = minor_mucocutaneous_manifestations_seborrheic_dermatitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @minor_mucocutaneous_manifestations_seborrheic_dermatitis_concept_id, @encounter_id, encounter_datetime, @location_id , @minor_mucocutaneous_manifestations_seborrheic_dermatitis_value_coded, @minor_mucocutaneous_manifestations_seborrheic_dermatitis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @minor_mucocutaneous_manifestations_seborrheic_dermatitis_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(moderate_unexplained_malnutrition) THEN

            # Get concept_id
            SET @moderate_unexplained_malnutrition_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Moderate unexplained wasting/malnutrition not responding to treatment (weight-for-height/ -age 70-79% or muac 11-12 cm)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @moderate_unexplained_malnutrition_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = moderate_unexplained_malnutrition AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @moderate_unexplained_malnutrition_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = moderate_unexplained_malnutrition AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @moderate_unexplained_malnutrition_concept_id, @encounter_id, encounter_datetime, @location_id , @moderate_unexplained_malnutrition_value_coded, @moderate_unexplained_malnutrition_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @moderate_unexplained_malnutrition_id = (SELECT LAST_INSERT_ID());

        END IF;                                

       # Check if the field is not empty
        IF NOT ISNULL(molluscum_contagiosum_extensive) THEN

            # Get concept_id
            SET @molluscum_contagiosum_extensive_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Molluscum contagiosum, extensive' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @molluscum_contagiosum_extensive_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = molluscum_contagiosum_extensive AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @molluscum_contagiosum_extensive_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = molluscum_contagiosum_extensive AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @molluscum_contagiosum_extensive_concept_id, @encounter_id, encounter_datetime, @location_id , @molluscum_contagiosum_extensive_value_coded, @molluscum_contagiosum_extensive_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @molluscum_contagiosum_extensive_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(non_typhoidal_salmonella_bacteraemia_recurrent) THEN

            # Get concept_id
            SET @non_typhoidal_salmonella_bacteraemia_recurrent_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Non-typhoidal Salmonella bacteraemia, recurrent' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @non_typhoidal_salmonella_bacteraemia_recurrent_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = non_typhoidal_salmonella_bacteraemia_recurrent AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @non_typhoidal_salmonella_bacteraemia_recurrent_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = non_typhoidal_salmonella_bacteraemia_recurrent AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @non_typhoidal_salmonella_bacteraemia_recurrent_concept_id, @encounter_id, encounter_datetime, @location_id , @non_typhoidal_salmonella_bacteraemia_recurrent_value_coded, @non_typhoidal_salmonella_bacteraemia_recurrent_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @non_typhoidal_salmonella_bacteraemia_recurrent_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(oral_candidiasis_from_age_2_months) THEN

            # Get concept_id
            SET @oral_candidiasis_from_age_2_months_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Oral candidiasis (from age 2 months)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @oral_candidiasis_from_age_2_months_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = oral_candidiasis_from_age_2_months AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @oral_candidiasis_from_age_2_months_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = oral_candidiasis_from_age_2_months AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @oral_candidiasis_from_age_2_months_concept_id, @encounter_id, encounter_datetime, @location_id , @oral_candidiasis_from_age_2_months_value_coded, @oral_candidiasis_from_age_2_months_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @oral_candidiasis_from_age_2_months_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(oral_thrush) THEN

            # Get concept_id
            SET @oral_thrush_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Oral thrush' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @oral_thrush_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = oral_thrush AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @oral_thrush_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = oral_thrush AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @oral_thrush_concept_id, @encounter_id, encounter_datetime, @location_id , @oral_thrush_value_coded, @oral_thrush_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @oral_thrush_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(perform_extended_staging) THEN

            # Get concept_id
            SET @perform_extended_staging_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Perform extended staging' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @perform_extended_staging_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = perform_extended_staging AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @perform_extended_staging_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = perform_extended_staging AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @perform_extended_staging_concept_id, @encounter_id, encounter_datetime, @location_id , @perform_extended_staging_value_coded, @perform_extended_staging_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @perform_extended_staging_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(pneumocystis_carinii_pneumonia) THEN

            # Get concept_id
            SET @pneumocystis_carinii_pneumonia_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Pneumocystis carinii pneumonia' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @pneumocystis_carinii_pneumonia_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = pneumocystis_carinii_pneumonia AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @pneumocystis_carinii_pneumonia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = pneumocystis_carinii_pneumonia AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @pneumocystis_carinii_pneumonia_concept_id, @encounter_id, encounter_datetime, @location_id , @pneumocystis_carinii_pneumonia_value_coded, @pneumocystis_carinii_pneumonia_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @pneumocystis_carinii_pneumonia_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(pneumonia_severe) THEN

            # Get concept_id
            SET @pneumonia_severe_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Pneumonia, severe' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @pneumonia_severe_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = pneumonia_severe AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @pneumonia_severe_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = pneumonia_severe AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @pneumonia_severe_concept_id, @encounter_id, encounter_datetime, @location_id , @pneumonia_severe_value_coded, @pneumonia_severe_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @pneumonia_severe_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(recurrent_bacteraemia_or_sepsis_with_nts) THEN

            # Get concept_id
            SET @recurrent_bacteraemia_or_sepsis_with_nts_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Recurrent bacteraemia or sepsis with NTS' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @recurrent_bacteraemia_or_sepsis_with_nts_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = recurrent_bacteraemia_or_sepsis_with_nts AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @recurrent_bacteraemia_or_sepsis_with_nts_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = recurrent_bacteraemia_or_sepsis_with_nts AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @recurrent_bacteraemia_or_sepsis_with_nts_concept_id, @encounter_id, encounter_datetime, @location_id , @recurrent_bacteraemia_or_sepsis_with_nts_value_coded, @recurrent_bacteraemia_or_sepsis_with_nts_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @recurrent_bacteraemia_or_sepsis_with_nts_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(recurrent_severe_presumed_pneumonia) THEN

            # Get concept_id
            SET @recurrent_severe_presumed_pneumonia_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Recurrent severe presumed pneumonia' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @recurrent_severe_presumed_pneumonia_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = recurrent_severe_presumed_pneumonia AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @recurrent_severe_presumed_pneumonia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = recurrent_severe_presumed_pneumonia AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @recurrent_severe_presumed_pneumonia_concept_id, @encounter_id, encounter_datetime, @location_id , @recurrent_severe_presumed_pneumonia_value_coded, @recurrent_severe_presumed_pneumonia_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @recurrent_severe_presumed_pneumonia_id = (SELECT LAST_INSERT_ID());

        END IF;                                                                     

       # Check if the field is not empty
        IF NOT ISNULL(recurrent_upper_respiratory_tract_bac_sinusitis) THEN

            # Get concept_id
            SET @recurrent_upper_respiratory_tract_bac_sinusitis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Recurrent upper respiratory infection (ie, bacterial sinusitis)' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @recurrent_upper_respiratory_tract_bac_sinusitis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = recurrent_upper_respiratory_tract_bac_sinusitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @recurrent_upper_respiratory_tract_bac_sinusitis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = recurrent_upper_respiratory_tract_bac_sinusitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @recurrent_upper_respiratory_tract_bac_sinusitis_concept_id, @encounter_id, encounter_datetime, @location_id , @recurrent_upper_respiratory_tract_bac_sinusitis_value_coded, @recurrent_upper_respiratory_tract_bac_sinusitis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @recurrent_upper_respiratory_tract_bac_sinusitis_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(seborrhoeic_dermatitis) THEN

            # Get concept_id
            SET @seborrhoeic_dermatitis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Seborrhoeic dermatitis' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @seborrhoeic_dermatitis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = seborrhoeic_dermatitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @seborrhoeic_dermatitis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = seborrhoeic_dermatitis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @seborrhoeic_dermatitis_concept_id, @encounter_id, encounter_datetime, @location_id , @seborrhoeic_dermatitis_value_coded, @seborrhoeic_dermatitis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @seborrhoeic_dermatitis_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(sepsis_severe) THEN

            # Get concept_id
            SET @sepsis_severe_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Sepsis, severe' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @sepsis_severe_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = sepsis_severe AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @sepsis_severe_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = sepsis_severe AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @sepsis_severe_concept_id, @encounter_id, encounter_datetime, @location_id , @sepsis_severe_value_coded, @sepsis_severe_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @sepsis_severe_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(tb_lymphadenopathy) THEN

            # Get concept_id
            SET @tb_lymphadenopathy_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'TB lymphadenopathy' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @tb_lymphadenopathy_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = tb_lymphadenopathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @tb_lymphadenopathy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = tb_lymphadenopathy AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @tb_lymphadenopathy_concept_id, @encounter_id, encounter_datetime, @location_id , @tb_lymphadenopathy_value_coded, @tb_lymphadenopathy_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @tb_lymphadenopathy_id = (SELECT LAST_INSERT_ID());

        END IF;                                

       # Check if the field is not empty
        IF NOT ISNULL(unexplained_anaemia_neutropenia_or_thrombocytopenia) THEN

            # Get concept_id
            SET @unexplained_anaemia_neutropenia_or_thrombocytopenia_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Unexplained anaemia, neutropaenia, or throbocytopaenia' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @unexplained_anaemia_neutropenia_or_thrombocytopenia_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = unexplained_anaemia_neutropenia_or_thrombocytopenia AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @unexplained_anaemia_neutropenia_or_thrombocytopenia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = unexplained_anaemia_neutropenia_or_thrombocytopenia AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @unexplained_anaemia_neutropenia_or_thrombocytopenia_concept_id, @encounter_id, encounter_datetime, @location_id , @unexplained_anaemia_neutropenia_or_thrombocytopenia_value_coded, @unexplained_anaemia_neutropenia_or_thrombocytopenia_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @unexplained_anaemia_neutropenia_or_thrombocytopenia_id = (SELECT LAST_INSERT_ID());

        END IF;

       # Check if the field is not empty
        IF NOT ISNULL(visceral_leishmaniasis) THEN

            # Get concept_id
            SET @visceral_leishmaniasis_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Visceral leishmaniasis' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @visceral_leishmaniasis_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = visceral_leishmaniasis AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @visceral_leishmaniasis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = visceral_leishmaniasis AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @visceral_leishmaniasis_concept_id, @encounter_id, encounter_datetime, @location_id , @visceral_leishmaniasis_value_coded, @visceral_leishmaniasis_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @visceral_leishmaniasis_id = (SELECT LAST_INSERT_ID());

        END IF;


        # Check if the field is not empty
        IF NOT ISNULL(reason_for_starting_art) THEN
            IF (reason_for_starting_art = "WHO stage 1 adult") THEN
              SET reason_for_starting_art = "WHO stage I adult";
            ELSEIF (reason_for_starting_art = "WHO stage 2 adult") THEN
              SET reason_for_starting_art = "WHO stage II adult";
            ELSEIF (reason_for_starting_art = "WHO stage 3 adult") THEN
              SET reason_for_starting_art = "WHO stage III adult";
            ELSEIF (reason_for_starting_art = "WHO stage 4 adult") THEN
              SET reason_for_starting_art = "WHO stage IV adult";
            ELSEIF (reason_for_starting_art = "WHO stage 1 peds") THEN
              SET reason_for_starting_art = "WHO stage I peds";
            ELSEIF (reason_for_starting_art = "WHO stage 2 peds") THEN
              SET reason_for_starting_art = "WHO stage II peds";
            ELSEIF (reason_for_starting_art = "WHO stage 3 peds") THEN
              SET reason_for_starting_art = "WHO stage III peds";
            ELSEIF (reason_for_starting_art = "WHO stage 4 peds") THEN
              SET reason_for_starting_art = "WHO stage IV peds";
            ELSEIF (reason_for_starting_art = "CD4 Count < 250") THEN
              SET reason_for_starting_art = "CD4 count <= 250";
            ELSEIF (reason_for_starting_art = "CD4 Count < 350") THEN
              SET reason_for_starting_art = "CD4 count <= 350";
            ELSEIF (reason_for_starting_art = "CD4 Count < 750") THEN
              SET reason_for_starting_art = "CD4 count <= 750";
           ELSEIF (reason_for_starting_art = "Presumed HIV Disease") THEN
              SET reason_for_starting_art = "Presumed severe HIV criteria in infants";
           ELSEIF (reason_for_starting_art = "Child HIV positive") THEN
              SET reason_for_starting_art = "HIV infected";
           ELSEIF (reason_for_starting_art = "PCR Test") THEN
              SET reason_for_starting_art = "HIV DNA polymerase chain reaction";
           ELSEIF (reason_for_starting_art = "Pregnant") THEN
              SET reason_for_starting_art = "Patient pregnant";
           ELSE            
            SET reason_for_starting_art = reason_for_starting_art;
          END IF;

            # Get concept_id
            SET @reason_for_starting_art_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'Reason for ART eligibility' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @reason_for_starting_art_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = reason_for_starting_art AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @reason_for_starting_art_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = reason_for_starting_art AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @reason_for_starting_art_concept_id, @encounter_id,encounter_datetime, @location_id , @reason_for_starting_art_value_coded, @reason_for_starting_art_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @reason_for_starting_art_id = (SELECT LAST_INSERT_ID());

        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(who_stage) THEN

            # Get concept_id
            SET @who_stage_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'WHO stage' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @who_stage_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = who_stage AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @who_stage_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = who_stage AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @who_stage_concept_id, @encounter_id, encounter_datetime, @location_id , @who_stage_value_coded, @who_stage_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @who_stage_id = (SELECT LAST_INSERT_ID());

        END IF;
     #--select patient_id, "hiv_staging";

	END LOOP;

END$$

DELIMITER ;

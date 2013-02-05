# This procedure imports patients hiv_staging encounters from intermediate tables to ART2 OpenMRS database
# ASSUMPTION
# ==========
# The assumption here is your source database name is `bart1_intermediate_bare_bones`
# and the destination any name you prefer.
# This has been necessary because there seems to be no way to use dynamic database 
# names in procedures yet

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_first_visit_encounters`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_hiv_staging_encounters`(
    IN in_patient_id INT(11)
)
BEGIN
    
    # Declare condition for exiting loop
    DECLARE done INT DEFAULT FALSE;

    DECLARE id INT(11);
    DECLARE visit_encounter_id INT(11);
    DECLARE patient_id INT(11);
    DECLARE patient_pregnant VARCHAR(40);
    DECLARE patient_breast_feeding VARCHAR(40);
    DECLARE cd4_count_available VARCHAR(40);
    DECLARE cd4_count INT(11);
    DECLARE cd4_count_modifier VARCHAR(40);
    DECLARE cd4_count_percentage DOUBLE;
    DECLARE date_of_cd4_count DATE;
    DECLARE asymptomatic VARCHAR(40);
    DECLARE persistent_generalized_lymphadenopathy VARCHAR(40);
    DECLARE unspecified_stage_1_cond VARCHAR(40);
    DECLARE molluscumm_contagiosum VARCHAR(40);
    DECLARE wart_virus_infection_extensive VARCHAR(40);
    DECLARE oral_ulcerations_recurrent VARCHAR(40);
    DECLARE parotid_enlargement_persistent_unexplained VARCHAR(40);
    DECLARE lineal_gingival_erythema VARCHAR(40);
    DECLARE herpes_zoster VARCHAR(40);
    DECLARE respiratory_tract_infections_recurrent VARCHAR(40);
    DECLARE unspecified_stage2_condition VARCHAR(40);
    DECLARE angular_chelitis VARCHAR(40);
    DECLARE papular_prurtic_eruptions VARCHAR(40);
    DECLARE hepatosplenomegaly_unexplained VARCHAR(40);
    DECLARE oral_hairy_leukoplakia VARCHAR(40);
    DECLARE severe_weight_loss VARCHAR(40);
    DECLARE fever_persistent_unexplained VARCHAR(40);
    DECLARE pulmonary_tuberculosis VARCHAR(40);
    DECLARE pulmonary_tuberculosis_last_2_years VARCHAR(40);
    DECLARE severe_bacterial_infection VARCHAR(40);
    DECLARE bacterial_pnuemonia VARCHAR(40);
    DECLARE symptomatic_lymphoid_interstitial_pnuemonitis VARCHAR(40);
    DECLARE chronic_hiv_assoc_lung_disease VARCHAR(40);
    DECLARE unspecified_stage3_condition VARCHAR(40);
    DECLARE aneamia VARCHAR(40);
    DECLARE neutropaenia VARCHAR(40);
    DECLARE thrombocytopaenia_chronic VARCHAR(40);
    DECLARE diarhoea VARCHAR(40);
    DECLARE oral_candidiasis VARCHAR(40);
    DECLARE acute_necrotizing_ulcerative_gingivitis VARCHAR(40);
    DECLARE lymph_node_tuberculosis VARCHAR(40);
    DECLARE toxoplasmosis_of_brain VARCHAR(40);
    DECLARE cryptococcal_meningitis VARCHAR(40);
    DECLARE progressive_multifocal_leukoencephalopathy VARCHAR(40);
    DECLARE disseminated_mycosis VARCHAR(40);
    DECLARE candidiasis_of_oesophagus VARCHAR(40);
    DECLARE extrapulmonary_tuberculosis VARCHAR(40);
    DECLARE cerebral_non_hodgkin_lymphoma VARCHAR(40);
    DECLARE kaposis VARCHAR(40);
    DECLARE hiv_encephalopathy VARCHAR(40);
    DECLARE bacterial_infections_severe_recurrent VARCHAR(40);
    DECLARE unspecified_stage_4_condition VARCHAR(40);
    DECLARE pnuemocystis_pnuemonia VARCHAR(40);
    DECLARE disseminated_non_tuberculosis_mycobactierial_infection VARCHAR(40);
    DECLARE cryptosporidiosis VARCHAR(40);
    DECLARE isosporiasis VARCHAR(40);
    DECLARE symptomatic_hiv_asscoiated_nephropathy VARCHAR(40);
    DECLARE chronic_herpes_simplex_infection VARCHAR(40);
    DECLARE cytomegalovirus_infection VARCHAR(40);
    DECLARE toxoplasomis_of_the_brain_1month VARCHAR(40);
    DECLARE recto_vaginal_fitsula VARCHAR(40);
    DECLARE reason_for_starting_art VARCHAR(255);
    DECLARE who_stage VARCHAR(40);
    DECLARE voided TINYINT(1);
    DECLARE void_reason VARCHAR(255);
    DECLARE date_voided DATE;
    DECLARE voided_by INT(11);
    DECLARE date_created DATE;
    DECLARE creator INT(11);
    DECLARE visit_id INT(11);
    DECLARE visit_date DATE;
    DECLARE visit_patient_id INT(11);
    
    # Declare and initialise cursor for looping through the table
    DECLARE cur CURSOR FOR SELECT DISTINCT `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.visit_encounter_id, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.patient_id,
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.patient_pregnant, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.patient_breast_feeding, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.cd4_count_available, 
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.cd4_count, 
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.cd4_count_modifier, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.cd4_count_percentage, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.date_of_cd4_count, 
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.asymptomatic, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.persistent_generalized_lymphadenopathy, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.unspecified_stage_1_cond, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.molluscumm_contagiosum, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.wart_virus_infection_extensive, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.oral_ulcerations_recurrent, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.parotid_enlargement_persistent_unexplained, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.lineal_gingival_erythema, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.herpes_zoster, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.respiratory_tract_infections_recurrent, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.unspecified_stage2_condition, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.angular_chelitis, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.papular_prurtic_eruptions, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.hepatosplenomegaly_unexplained, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.oral_hairy_leukoplakia, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.severe_weight_loss,  `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.fever_persistent_unexplained,  `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.pulmonary_tuberculosis,  `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.pulmonary_tuberculosis_last_2_years,  `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.severe_bacterial_infection,  `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.bacterial_pnuemonia,  `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.symptomatic_lymphoid_interstitial_pnuemonitis,  `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.chronic_hiv_assoc_lung_disease, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.unspecified_stage3_condition, 
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.aneamia, 
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.neutropaenia, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.thrombocytopaenia_chronic, 
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.diarhoea, 
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.oral_candidiasis, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.acute_necrotizing_ulcerative_gingivitis, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.lymph_node_tuberculosis, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.toxoplasmosis_of_brain, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.cryptococcal_meningitis, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.progressive_multifocal_leukoencephalopathy, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.disseminated_mycosis, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.candidiasis_of_oesophagus, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.extrapulmonary_tuberculosis, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.cerebral_non_hodgkin_lymphoma, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.kaposis, 
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.hiv_encephalopathy, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.bacterial_infections_severe_recurrent, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.unspecified_stage_4_condition, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.pnuemocystis_pnuemonia, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.disseminated_non_tuberculosis_mycobactierial_infection, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.cryptosporidiosis, 
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.isosporiasis, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.symptomatic_hiv_asscoiated_nephropathy, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.chronic_herpes_simplex_infection, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.cytomegalovirus_infection, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.toxoplasomis_of_the_brain_1month, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.recto_vaginal_fitsula, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.reason_for_starting_art, 
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.who_stage, 
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.voided, 
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.void_reason, 
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.date_voided, 
`bart1_intermediate_bare_bones`.`hiv_staging_encounters`.voided_by, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.date_created,                                               `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.creator, COALESCE(`bart1_intermediate_bare_bones`.`visit_encounters`.visit_date, `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.date_created) FROM `bart1_intermediate_bare_bones`.`hiv_staging_encounters` 
        LEFT OUTER JOIN bart1_intermediate_bare_bones.visit_encounters ON 
        visit_encounter_id = bart1_intermediate_bare_bones.visit_encounters.id 
        WHERE `bart1_intermediate_bare_bones`.`hiv_staging_encounters`.`patient_id` = in_patient_id;

    # Declare loop position check
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    # Disable system checks and indexing to speed up processing
    # SET FOREIGN_KEY_CHECKS = 0;
    # SET UNIQUE_CHECKS = 0;
    # SET AUTOCOMMIT = 0;

    # Open cursor
    OPEN cur;
    
    # Declare loop for traversing through the records
    read_loop: LOOP
    
        # Get the fields into the variables declared earlier
        FETCH cur INTO  
             visit_encounter_id, 
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
             reason_for_starting_art,
             who_stage,
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
    
        # Not done, process the parameters
        
        # Map destination user to source user
        SET @creator = COALESCE((SELECT user_id FROM users WHERE user_id = creator), 1);
    
        # Get id of encounter type
        SET @encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = "HIV STAGING");
    
        # Create encounter
        INSERT INTO encounter (encounter_id, encounter_type, patient_id, provider_id, encounter_datetime, creator, date_created, uuid)
        VALUES (visit_encounter_id, @encounter_type, patient_id, @creator, visit_date, @creator, date_created, (SELECT UUID()));
    

      # Check if the field is not empty
        IF NOT ISNULL(patient_pregnant) THEN
        
            # Get concept_id
            SET @patient_pregnant_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Is patient pregnant?" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @patient_pregnant_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = patient_pregnant AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @patient_pregnant_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = patient_pregnant AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @patient_pregnant_concept_id, visit_encounter_id, visit_date, @patient_pregnant_value_coded, @patient_pregnant_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
      # Check if the field is not empty
        IF NOT ISNULL(patient_breast_feeding) THEN
        
            # Get concept_id
            SET @patient_breast_feeding_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Is patient breast feeding" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @patient_breast_feeding_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = patient_breast_feeding AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @patient_breast_feeding_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = patient_breast_feeding AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @patient_breast_feeding_concept_id, visit_encounter_id, visit_date, @patient_breast_feeding_value_coded, @patient_breast_feeding_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

        # Check if the field is not empty
        IF NOT ISNULL(cd4_count_percentage) THEN
        
            # Get concept_id
            SET @cd4_count_percentage_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "CD4 percent" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
            VALUES (patient_id, @cd4_count_percentage_concept_id, visit_encounter_id, visit_date, cd4_count, @creator, date_created, (SELECT UUID()));
        
        END IF;

        # Check if the field is not empty
        IF NOT ISNULL(cd4_count_modifier) THEN

            # Get concept_id
            SET @cd4_count_modifier_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "CD4 count modifier" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
            VALUES (patient_id, @cd4_count_modifier_concept_id, visit_encounter_id, visit_date, cd4_count, @creator, date_created, (SELECT UUID()));
        END IF;

        # Check if the field is not empty
        IF NOT ISNULL(date_of_cd4_count) THEN
        
            # Get concept_id
            SET @date_of_cd4_count_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Cd4 count datetime" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
            VALUES (patient_id, @date_of_cd4_count_concept_id, visit_encounter_id, visit_date, date_of_cd4_count, @creator, date_created, (SELECT UUID()));
        
        END IF;

        # Check if the field is not empty
        IF NOT ISNULL(cd4_count) THEN
        
            # Get concept_id
            SET @cd4_count_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "CD4 count" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
            VALUES (patient_id, @cd4_count_concept_id, visit_encounter_id, visit_date, cd4_count, @creator, date_created, (SELECT UUID()));
        
        END IF;

        # Check if the field is not empty
        IF NOT ISNULL(cd4_count_percentage) THEN
        
            # Get concept_id
            SET @cd4_count_percentage_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "CD4 percentage" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
            VALUES (patient_id, @cd4_count_percentage_concept_id, visit_encounter_id, visit_date, cd4_count, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(date_of_cd4_count) THEN
        
            # Get concept_id
            SET @date_of_cd4_count_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Cd4 count datetime" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
            VALUES (patient_id, @date_of_cd4_count_concept_id, visit_encounter_id, visit_date, date_of_cd4_count, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(asymptomatic) THEN
        
            # Get concept_id
            SET @asymptomatic_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Asymptomatic HIV infection" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @asymptomatic_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = asymptomatic AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @asymptomatic_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = asymptomatic AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @asymptomatic_concept_id, visit_encounter_id, visit_date, @asymptomatic_value_coded, @asymptomatic_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(persistent_generalized_lymphadenopathy) THEN
        
            # Get concept_id
            SET @persistent_generalized_lymphadenopathy_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Persistent generalized lymphadenopathy" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @persistent_generalized_lymphadenopathy_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = persistent_generalized_lymphadenopathy AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @asymptomatic_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = persistent_generalized_lymphadenopathy AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @persistent_generalized_lymphadenopathy_concept_id, visit_encounter_id, visit_date, @persistent_generalized_lymphadenopathy_value_coded, @persistent_generalized_lymphadenopathy_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
     
        # Check if the field is not empty
        IF NOT ISNULL(unspecified_stage_1_cond) THEN
        
            # Get concept_id
            SET @unspecified_stage_1_cond_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Unspecified stage I condition" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @unspecified_stage_1_cond_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = unspecified_stage_1_cond AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @unspecified_stage_1_cond_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = unspecified_stage_1_cond AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @unspecified_stage_1_cond_concept_id, visit_encounter_id, visit_date, @unspecified_stage_1_cond_value_coded, @unspecified_stage_1_cond_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(molluscumm_contagiosum) THEN
        
            # Get concept_id
            SET @molluscumm_contagiosum_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Molluscum contagiosum" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @molluscumm_contagiosum_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = molluscumm_contagiosum AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @molluscumm_contagiosum_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = molluscumm_contagiosum AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @molluscumm_contagiosum_cond_concept_id, visit_encounter_id, visit_date, @molluscumm_contagiosum_value_coded, @molluscumm_contagiosum_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(wart_virus_infection_extensive) THEN
        
            # Get concept_id
            SET @wart_virus_infection_extensive_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Wart virus infection, extensive" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @wart_virus_infection_extensive_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = wart_virus_infection_extensive AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @wart_virus_infection_extensive_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = wart_virus_infection_extensive AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @wart_virus_infection_extensive_concept_id, visit_encounter_id, visit_date, @wart_virus_infection_extensive_value_coded, @wart_virus_infection_extensive_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(oral_ulcerations_recurrent) THEN
        
            # Get concept_id
            SET @oral_ulcerations_recurrent_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Oral ulcerations, recurrent" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @oral_ulcerations_recurrent_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = oral_ulcerations_recurrent AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @oral_ulcerations_recurrent_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = oral_ulcerations_recurrent AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @oral_ulcerations_recurrent_concept_id, visit_encounter_id, visit_date, @oral_ulcerations_recurrent_value_coded, @oral_ulcerations_recurrent_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(parotid_enlargement_persistent_unexplained) THEN
        
            # Get concept_id
            SET @parotid_enlargement_persistent_unexplained_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Parotid enlargement, persistent unexplained " AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @parotid_enlargement_persistent_unexplained_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = parotid_enlargement_persistent_unexplained AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @parotid_enlargement_persistent_unexplained_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = parotid_enlargement_persistent_unexplained AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @parotid_enlargement_persistent_unexplained_concept_id, visit_encounter_id, visit_date, @parotid_enlargement_persistent_unexplained_value_coded, @parotid_enlargement_persistent_unexplained_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
       
      # Check if the field is not empty
        IF NOT ISNULL(lineal_gingival_erythema) THEN
        
            # Get concept_id
            SET @lineal_gingival_erythema_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Lineal gingival erythema" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @lineal_gingival_erythema_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = lineal_gingival_erythema AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @lineal_gingival_erythema_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = lineal_gingival_erythema AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @lineal_gingival_erythema_concept_id, visit_encounter_id, visit_date, @lineal_gingival_erythema_value_coded, @lineal_gingival_erythema_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(herpes_zoster) THEN
        
            # Get concept_id
            SET @herpes_zoster_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Herpes zoster" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @herpes_zoster_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = herpes_zoster AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @herpes_zoster_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = herpes_zoster AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @herpes_zoster_concept_id, visit_encounter_id, visit_date, @herpes_zoster_value_coded, @herpes_zoster_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(respiratory_tract_infections_recurrent) THEN
        
            # Get concept_id
            SET @respiratory_tract_infections_recurrent_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "WHO HIV - recurrent upper respiratory infections" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @respiratory_tract_infections_recurrent_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = respiratory_tract_infections_recurrent AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @respiratory_tract_infections_recurrent_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = respiratory_tract_infections_recurrent AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @respiratory_tract_infections_recurrent_concept_id, visit_encounter_id, visit_date, @respiratory_tract_infections_recurrent_value_coded, @respiratory_tract_infections_recurrent_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
           
      # Check if the field is not empty
        IF NOT ISNULL(unspecified_stage2_condition) THEN
        
            # Get concept_id
            SET @unspecified_stage2_condition_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Unspecified stage II condition" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @unspecified_stage2_condition_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = unspecified_stage2_condition AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @unspecified_stage2_condition_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = unspecified_stage2_condition AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @unspecified_stage2_condition_concept_id, visit_encounter_id, visit_date, @unspecified_stage2_condition_value_coded, @unspecified_stage2_condition_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
                          
      # Check if the field is not empty
        IF NOT ISNULL(angular_chelitis) THEN
        
            # Get concept_id
            SET @angular_chelitis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Angular cheilitis" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @angular_chelitis_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = angular_chelitis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @angular_chelitis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = angular_chelitis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @angular_chelitis_concept_id, visit_encounter_id, visit_date, @angular_chelitis_value_coded, @angular_chelitis_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
                                  
      # Check if the field is not empty
        IF NOT ISNULL(papular_prurtic_eruptions) THEN
        
            # Get concept_id
            SET @papular_prurtic_eruptions_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Papular pruritic eruptions" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @papular_prurtic_eruptions_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = papular_prurtic_eruptions AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @papular_prurtic_eruptions_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = papular_prurtic_eruptions AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @papular_prurtic_eruptions_concept_id, visit_encounter_id, visit_date, @papular_prurtic_eruptions_value_coded, @papular_prurtic_eruptions_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

                          
      # Check if the field is not empty
        IF NOT ISNULL(hepatosplenomegaly_unexplained) THEN
        
            # Get concept_id
            SET @hepatosplenomegaly_unexplained_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Hepatosplenomegaly, persistent unexplained" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @hepatosplenomegaly_unexplained_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = hepatosplenomegaly_unexplained AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @hepatosplenomegaly_unexplained_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = hepatosplenomegaly_unexplained AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @hepatosplenomegaly_unexplained_concept_id, visit_encounter_id, visit_date, @hepatosplenomegaly_unexplained_value_coded, @hepatosplenomegaly_unexplained_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        
      # Check if the field is not empty
        IF NOT ISNULL(oral_hairy_leukoplakia) THEN
        
            # Get concept_id
            SET @oral_hairy_leukoplakia_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Oral hairy leukoplakia" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @oral_hairy_leukoplakia_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = oral_hairy_leukoplakia AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @oral_hairy_leukoplakia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = oral_hairy_leukoplakia AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @oral_hairy_leukoplakia_concept_id, visit_encounter_id, visit_date, @oral_hairy_leukoplakia_value_coded, @oral_hairy_leukoplakia_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        
      # Check if the field is not empty
        IF NOT ISNULL(severe_weight_loss) THEN
        
            # Get concept_id
            SET @severe_weight_loss_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Severe weight loss >10% and/or BMI <18.5kg/m^2, unexplained" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @severe_weight_loss_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = severe_weight_loss AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @severe_weight_loss_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = severe_weight_loss AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @severe_weight_loss_concept_id, visit_encounter_id, visit_date, @severe_weight_loss_value_coded, @severe_weight_loss_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
      # Check if the field is not empty
        IF NOT ISNULL(fever_persistent_unexplained) THEN
        
            # Get concept_id
            SET @fever_persistent_unexplained_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Fever, persistent unexplained, intermittent or constant, >1 month" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @fever_persistent_unexplained_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = fever_persistent_unexplained AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @fever_persistent_unexplained_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = fever_persistent_unexplained AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @fever_persistent_unexplained_concept_id, visit_encounter_id, visit_date, @fever_persistent_unexplained_value_coded, @fever_persistent_unexplained_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(pulmonary_tuberculosis) THEN
        
            # Get concept_id
            SET @pulmonary_tuberculosis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Pulmonary tuberculosis" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @pulmonary_tuberculosis_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = pulmonary_tuberculosis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @pulmonary_tuberculosis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = pulmonary_tuberculosis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @pulmonary_tuberculosis_concept_id, visit_encounter_id, visit_date, @pulmonary_tuberculosis_value_coded, @pulmonary_tuberculosis_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
       IF NOT ISNULL(pulmonary_tuberculosis_last_2_years) THEN
        
            # Get concept_id
            SET @pulmonary_tuberculosis_last_2_years_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Pulmonary tuberculosis within the last 2 years" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @pulmonary_tuberculosis_last_2_years_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = pulmonary_tuberculosis_last_2_years AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @pulmonary_tuberculosis_last_2_years_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = pulmonary_tuberculosis_last_2_years AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @pulmonary_tuberculosis_last_2_years_concept_id, visit_encounter_id, visit_date, @pulmonary_tuberculosis_last_2_years_value_coded, @pulmonary_tuberculosis_last_2_years_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(severe_bacterial_infection) THEN
        
            # Get concept_id
            SET @severe_bacterial_infection_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Severe bacterial infections" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @severe_bacterial_infection_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = severe_bacterial_infection AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @severe_bacterial_infection_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = severe_bacterial_infection AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @severe_bacterial_infection_concept_id, visit_encounter_id, visit_date, @severe_bacterial_infection_value_coded, @severe_bacterial_infection_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(bacterial_pnuemonia) THEN
        
            # Get concept_id
            SET @bacterial_pnuemonia_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Bacterial pneumonia" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @bacterial_pnuemonia_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = bacterial_pnuemonia AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @bacterial_pnuemonia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = bacterial_pnuemonia AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @bacterial_pnuemonia_concept_id, visit_encounter_id, visit_date, @bacterial_pnuemonia_value_coded, @bacterial_pnuemonia_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(symptomatic_lymphoid_interstitial_pnuemonitis) THEN
        
            # Get concept_id
            SET @symptomatic_lymphoid_interstitial_pnuemonitis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Symptomatic lymphoid interstitial pneumonia" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @symptomatic_lymphoid_interstitial_pnuemonitis_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = symptomatic_lymphoid_interstitial_pnuemonitis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @symptomatic_lymphoid_interstitial_pnuemonitis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = symptomatic_lymphoid_interstitial_pnuemonitis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @symptomatic_lymphoid_interstitial_pnuemonitis_concept_id, visit_encounter_id, visit_date, @symptomatic_lymphoid_interstitial_pnuemonitis_value_coded, @symptomatic_lymphoid_interstitial_pnuemonitis_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(chronic_hiv_assoc_lung_disease) THEN
        
            # Get concept_id
            SET @chronic_hiv_assoc_lung_disease_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Chronic HIV lung disease, including bronchiectasis" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @chronic_hiv_assoc_lung_disease_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = chronic_hiv_assoc_lung_disease AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @chronic_hiv_assoc_lung_disease_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = chronic_hiv_assoc_lung_disease AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @chronic_hiv_assoc_lung_disease_concept_id, visit_encounter_id, visit_date, @chronic_hiv_assoc_lung_disease_value_coded, @chronic_hiv_assoc_lung_disease_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(unspecified_stage3_condition) THEN
        
            # Get concept_id
            SET @unspecified_stage3_condition_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Unspecified stage III condition" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @unspecified_stage3_condition_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = unspecified_stage3_condition AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @unspecified_stage3_condition_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = unspecified_stage3_condition AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @unspecified_stage3_condition_concept_id, visit_encounter_id, visit_date, @unspecified_stage3_condition_value_coded, @unspecified_stage3_condition_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(aneamia) THEN
        
            # Get concept_id
            SET @aneamia_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Anemia" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @aneamia_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = aneamia AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @aneamia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = aneamia AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @aneamia_concept_id, visit_encounter_id, visit_date, @aneamia_value_coded, @aneamia_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(neutropaenia) THEN
        
            # Get concept_id
            SET @neutropaenia_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Neutropaenia, unexplained < 500 /mm(cubed)" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @neutropaenia_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = neutropaenia AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @neutropaenia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = neutropaenia AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @neutropaenia_concept_id, visit_encounter_id, visit_date, @neutropaenia_value_coded, @neutropaenia_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(thrombocytopaenia_chronic) THEN
        
            # Get concept_id
            SET @thrombocytopaenia_chronic_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Thrombocytopaenia, chronic < 50,000 /mm(cubed)" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @thrombocytopaenia_chronic_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = thrombocytopaenia_chronic AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @thrombocytopaenia_chronic_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = thrombocytopaenia_chronic AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @thrombocytopaenia_chronic_concept_id, visit_encounter_id, visit_date, @thrombocytopaenia_chronic_value_coded, @thrombocytopaenia_chronic_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(diarhoea) THEN
        
            # Get concept_id
            SET @diarhoea_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Diarrhea" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @diarhoea_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = diarhoea AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @diarhoea_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = diarhoea AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @diarhoea_concept_id, visit_encounter_id, visit_date, @diarhoea_value_coded, @diarhoea_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(oral_candidiasis) THEN
        
            # Get concept_id
            SET @oral_candidiasis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Oral candidiasis" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @oral_candidiasis_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = oral_candidiasis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @oral_candidiasis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = oral_candidiasis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @oral_candidiasis_concept_id, visit_encounter_id, visit_date, @oral_candidiasis_value_coded, @oral_candidiasis_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        
      # Check if the field is not empty
        IF NOT ISNULL(acute_necrotizing_ulcerative_gingivitis) THEN
        
            # Get concept_id
            SET @acute_necrotizing_ulcerative_gingivitis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Acute necrotizing ulcerative stomatitis, gingivitis or periodontitis" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @acute_necrotizing_ulcerative_gingivitis_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = acute_necrotizing_ulcerative_gingivitis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @acute_necrotizing_ulcerative_gingivitis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = acute_necrotizing_ulcerative_gingivitis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @acute_necrotizing_ulcerative_gingivitis_concept_id, visit_encounter_id, visit_date, @acute_necrotizing_ulcerative_gingivitis_value_coded, @acute_necrotizing_ulcerative_gingivitis_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(lymph_node_tuberculosis) THEN
        
            # Get concept_id
            SET @lymph_node_tuberculosis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Tuberculosis lymphadenopathy" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @lymph_node_tuberculosis_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = lymph_node_tuberculosis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @lymph_node_tuberculosis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = lymph_node_tuberculosis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @lymph_node_tuberculosis_concept_id, visit_encounter_id, visit_date, @lymph_node_tuberculosis_value_coded, @lymph_node_tuberculosis_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(toxoplasmosis_of_brain) THEN
        
            # Get concept_id
            SET @toxoplasmosis_of_brain_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Toxoplasmosis of the brain" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @toxoplasmosis_of_brain_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = toxoplasmosis_of_brain AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @toxoplasmosis_of_brain_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = toxoplasmosis_of_brain AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @toxoplasmosis_of_brain_concept_id, visit_encounter_id, visit_date, @toxoplasmosis_of_brain_value_coded, @toxoplasmosis_of_brain_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(cryptococcal_meningitis) THEN
        
            # Get concept_id
            SET @cryptococcal_meningitis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Cryptococcal meningitis" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @cryptococcal_meningitis_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = cryptococcal_meningitis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @cryptococcal_meningitis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = cryptococcal_meningitis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @cryptococcal_meningitis_concept_id, visit_encounter_id, visit_date, @cryptococcal_meningitis_value_coded, @cryptococcal_meningitis_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(progressive_multifocal_leukoencephalopathy) THEN
        
            # Get concept_id
            SET @progressive_multifocal_leukoencephalopathy_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Progressive multifocal leukoencephalopathy" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @progressive_multifocal_leukoencephalopathy_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = progressive_multifocal_leukoencephalopathy AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @progressive_multifocal_leukoencephalopathy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = progressive_multifocal_leukoencephalopathy AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @progressive_multifocal_leukoencephalopathy_concept_id, visit_encounter_id, visit_date, @progressive_multifocal_leukoencephalopathy_value_coded, @progressive_multifocal_leukoencephalopathy_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(disseminated_mycosis) THEN
        
            # Get concept_id
            SET @disseminated_mycosis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Disseminated endemic mycosis" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @disseminated_mycosis_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = disseminated_mycosis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @disseminated_mycosis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = disseminated_mycosis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @disseminated_mycosis_concept_id, visit_encounter_id, visit_date, @disseminated_mycosis_value_coded, @disseminated_mycosis_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

      # Check if the field is not empty
        IF NOT ISNULL(candidiasis_of_oesophagus) THEN
        
            # Get concept_id
            SET @candidiasis_of_oesophagus_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Candidiasis of oseophagus" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @candidiasis_of_oesophagus_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = candidiasis_of_oesophagus AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @candidiasis_of_oesophagus_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = candidiasis_of_oesophagus AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @candidiasis_of_oesophagus_concept_id, visit_encounter_id, visit_date, @candidiasis_of_oesophagus_value_coded, @candidiasis_of_oesophagus_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(extrapulmonary_tuberculosis) THEN
        
            # Get concept_id
            SET @extrapulmonary_tuberculosis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Extrapulmonary tuberculosis (EPTB)" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @extrapulmonary_tuberculosis_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = extrapulmonary_tuberculosis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @extrapulmonary_tuberculosis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = extrapulmonary_tuberculosis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @extrapulmonary_tuberculosis_concept_id, visit_encounter_id, visit_date, @extrapulmonary_tuberculosis_value_coded, @extrapulmonary_tuberculosis_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(cerebral_non_hodgkin_lymphoma) THEN
        
            # Get concept_id
            SET @cerebral_non_hodgkin_lymphoma_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Cerebral or B-cell non Hodgkin lymphoma" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @cerebral_non_hodgkin_lymphoma_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = cerebral_non_hodgkin_lymphoma AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @cerebral_non_hodgkin_lymphoma_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = cerebral_non_hodgkin_lymphoma AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @cerebral_non_hodgkin_lymphoma_concept_id, visit_encounter_id, visit_date, @cerebral_non_hodgkin_lymphoma_value_coded, @cerebral_non_hodgkin_lymphoma_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(kaposis) THEN
        
            # Get concept_id
            SET @kaposis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Kaposis sarcoma" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @kaposis_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = kaposis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @kaposis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = kaposis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @kaposis_concept_id, visit_encounter_id, visit_date, @kaposis_value_coded, @kaposis_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(hiv_encephalopathy) THEN
        
            # Get concept_id
            SET @hiv_encephalopathy_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "HIV encephalopathy" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @hiv_encephalopathy_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = hiv_encephalopathy AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @hiv_encephalopathy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = hiv_encephalopathy AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @hiv_encephalopathy_concept_id, visit_encounter_id, visit_date, @hiv_encephalopathy_value_coded, @hiv_encephalopathy_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(bacterial_infections_severe_recurrent) THEN
        
            # Get concept_id
            SET @bacterial_infections_severe_recurrent_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Bacterial infections, severe recurrent  (empyema, pyomyositis, meningitis, bone/joint infections but EXCLUDING pneumonia)" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @bacterial_infections_severe_recurrent_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = bacterial_infections_severe_recurrent AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @bacterial_infections_severe_recurrent_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = bacterial_infections_severe_recurrent AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @bacterial_infections_severe_recurrent_concept_id, visit_encounter_id, visit_date, @bacterial_infections_severe_recurrent_value_coded, @bacterial_infections_severe_recurrent_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(unspecified_stage_4_condition) THEN
        
            # Get concept_id
            SET @unspecified_stage_4_condition_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Unspecified stage 4 condition" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @unspecified_stage_4_condition_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = unspecified_stage_4_condition AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @unspecified_stage_4_condition_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = unspecified_stage_4_condition AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @unspecified_stage_4_condition_concept_id, visit_encounter_id, visit_date, @unspecified_stage_4_condition_value_coded, @unspecified_stage_4_condition_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(pnuemocystis_pnuemonia) THEN
        
            # Get concept_id
            SET @pnuemocystis_pnuemonia_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Pneumocystis pneumonia" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @pnuemocystis_pnuemonia_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = pnuemocystis_pnuemonia AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @pnuemocystis_pnuemonia_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = pnuemocystis_pnuemonia AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @pnuemocystis_pnuemonia_concept_id, visit_encounter_id, visit_date, @pnuemocystis_pnuemonia_value_coded, @pnuemocystis_pnuemonia_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(disseminated_non_tuberculosis_mycobactierial_infection) THEN
        
            # Get concept_id
            SET @disseminated_non_tuberculosis_mycobactierial_infection_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Disseminated non-tuberculosis mycobacterial infection
             cryptosporidiosis, Cryptosporidiosis" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @disseminated_non_tuberculosis_mycobactierial_infection_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = disseminated_non_tuberculosis_mycobactierial_infection AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @disseminated_non_tuberculosis_mycobactierial_infection_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = disseminated_non_tuberculosis_mycobactierial_infection AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @disseminated_non_tuberculosis_mycobactierial_infection_concept_id, visit_encounter_id, visit_date, @disseminated_non_tuberculosis_mycobactierial_infection_value_coded, @disseminated_non_tuberculosis_mycobactierial_infection_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;

        # Check if the field is not empty
        IF NOT ISNULL(isosporiasis) THEN
        
            # Get concept_id
            SET @isosporiasis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Isosporiasis" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @isosporiasis_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = isosporiasis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @isosporiasis_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = isosporiasis AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @isosporiasis_concept_id, visit_encounter_id, visit_date, @isosporiasis_value_coded, @isosporiasis_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(symptomatic_hiv_asscoiated_nephropathy) THEN
        
            # Get concept_id
            SET @symptomatic_hiv_asscoiated_nephropathy_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Symptomatic HIV-associated nephropathy or cardiomyopathy" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @symptomatic_hiv_asscoiated_nephropathy_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = symptomatic_hiv_asscoiated_nephropathy AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @symptomatic_hiv_asscoiated_nephropathy_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = symptomatic_hiv_asscoiated_nephropathy AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @symptomatic_hiv_asscoiated_nephropathy_concept_id, visit_encounter_id, visit_date, @symptomatic_hiv_asscoiated_nephropathy_value_coded, @symptomatic_hiv_asscoiated_nephropathy_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(chronic_herpes_simplex_infection) THEN
        
            # Get concept_id
            SET @chronic_herpes_simplex_infection_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Chronic herpes simplex infection (orolabial, gential / anorectal >1 month or visceral at any site)" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @chronic_herpes_simplex_infection_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = chronic_herpes_simplex_infection AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @chronic_herpes_simplex_infection_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = chronic_herpes_simplex_infection AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @chronic_herpes_simplex_infection_concept_id, visit_encounter_id, visit_date, @chronic_herpes_simplex_infection_value_coded, @chronic_herpes_simplex_infection_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(cytomegalovirus_infection) THEN
        
            # Get concept_id
            SET @cytomegalovirus_infection_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "cytomegalovirus" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @cytomegalovirus_infection_value_coded = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = cytomegalovirus_infection AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @cytomegalovirus_infection_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = cytomegalovirus_infection AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @cytomegalovirus_infection_concept_id, visit_encounter_id, visit_date, @cytomegalovirus_infection_value_coded, @cytomegalovirus_infection_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(toxoplasomis_of_the_brain_1month) THEN
        
            # Get concept_id
            SET @toxoplasomis_of_the_brain_1month_concept_id = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Toxoplasmosis of the brain (from age 1 month)" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @toxoplasomis_of_the_brain_1month_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = toxoplasomis_of_the_brain_1month AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @toxoplasomis_of_the_brain_1month_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = toxoplasomis_of_the_brain_1month AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @toxoplasomis_of_the_brain_1month_concept_id, visit_encounter_id, visit_date, @toxoplasomis_of_the_brain_1month_value_coded, @toxoplasomis_of_the_brain_1month_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(recto_vaginal_fitsula) THEN
        
            # Get concept_id
            SET @recto_vaginal_fitsula_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Recto-vaginal fistula HIV-associated" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded id
            SET @recto_vaginal_fitsula_value_coded = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = recto_vaginal_fitsula AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Get value_coded_name_id
            SET @recto_vaginal_fitsula_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = recto_vaginal_fitsula AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @recto_vaginal_fitsula_concept_id, visit_encounter_id, visit_date, @recto_vaginal_fitsula_value_coded, @recto_vaginal_fitsula_value_coded_name_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        
        # Check if the field is not empty
        IF NOT ISNULL(reason_for_starting_art) THEN
        
            # Get concept_id
            SET @reason_for_starting_art_concept_id = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Reason for ART eligibility" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
            VALUES (patient_id, @reason_for_starting_art_concept_id, visit_encounter_id, visit_date, reason_for_starting_art, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Check if the field is not empty
        IF NOT ISNULL(who_stage) THEN
        
            # Get concept_id
            SET @who_stage_concept_id = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "WHO stage" AND voided = 0 AND retired = 0 LIMIT 1);
        
            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
            VALUES (patient_id, @who_stage_concept_id, visit_encounter_id, visit_date, who_stage, @creator, date_created, (SELECT UUID()));
        
        END IF;

    END LOOP;

    # SET UNIQUE_CHECKS = 1;
    # SET FOREIGN_KEY_CHECKS = 1;
    # COMMIT;
    # SET AUTOCOMMIT = 1;

END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `proc_insert_observations`$$

CREATE PROCEDURE `proc_insert_observations`(
    IN patient_id INT, 
    IN value_date DATE, 
    IN field_concept INT, 
    IN field_value_coded INT,
    IN field_value_coded_name_id INT,
    IN field_text VARCHAR(255),
    IN field_value_numeric DOUBLE,
    IN field_value_datetime DATETIME,
    IN field_value_modifier VARCHAR(255),
    IN visit_id INT,
    IN encounter_id INT
)
BEGIN

    SET @pregnant = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Is patient pregnant?" AND voided = 0 AND retired = 0 LIMIT 1);
    
    SET @pregnant2 = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "patient pregnant" AND voided = 0 AND retired = 0 LIMIT 1);
                        
    SET @breast_feeding = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Breast feeding" AND voided = 0 AND retired = 0 LIMIT 1);
                        
    SET @currently_using_family_planning_method = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Currently using family planning method" AND voided = 0 AND retired = 0 LIMIT 1);
                        
    SET @method_of_family_planning = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Method of family planning" AND voided = 0 AND retired = 0 LIMIT 1);
                        
    SET @symptom_present = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Symptom present" AND voided = 0 AND retired = 0 LIMIT 1);
                        
    SET @drug_induced = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Drug induced" AND voided = 0 AND retired = 0 LIMIT 1);
                        
    SET @routine_tb_screening = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Routine TB Screening" AND voided = 0 AND retired = 0 LIMIT 1);
                        
    SET @allergic_to_sulphur = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Allergic to sulphur" AND voided = 0 AND retired = 0 LIMIT 1);

    SET @tb_status = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "TB status" AND voided = 0 AND retired = 0 LIMIT 1);
                        
    SET @guardian_present = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Guardian Present" AND voided = 0 AND retired = 0 LIMIT 1);
                        
    SET @patient_present = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Patient Present" AND voided = 0 AND retired = 0 LIMIT 1);
                        
    SET @arv_regimen_type = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "What type of antiretroviral regimen" AND voided = 0 AND retired = 0 LIMIT 1);
                       
    SET @cpt_given = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "CPT given" AND voided = 0 AND retired = 0 LIMIT 1);
                         
    SET @ipt_given = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Isoniazid" AND voided = 0 AND retired = 0 LIMIT 1);
                         
    SET @prescribe_arvs = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Prescribe ARVs this visit" AND voided = 0 AND retired = 0 LIMIT 1);
                         
    SET @continue_existing_regimen = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Continue existing regimen" AND voided = 0 AND retired = 0 LIMIT 1);
                         
    SET @breastfeeding = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Breastfeeding" AND voided = 0 AND retired = 0 LIMIT 1);
                         
    SET @transfer_within_responsibility = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Transfer within responsibility" AND voided = 0 AND retired = 0 LIMIT 1);
                         
    SET @guardian_present = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Guardian Present" AND voided = 0 AND retired = 0 LIMIT 1);
                         
    SET @patient_present = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Patient present" AND voided = 0 AND retired = 0 LIMIT 1);
                
	SET @reason_for_eligibility = (SELECT concept_name.concept_id FROM concept_name
	                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
	                    WHERE name = 'Reason for ART eligibility' AND voided = 0 AND retired = 0 LIMIT 1);
			                    
	SET @who_stage = (SELECT concept_name.concept_id FROM concept_name
	                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
	                    WHERE name = 'WHO stage' AND voided = 0 AND retired = 0 LIMIT 1);

	SET @send_sms = (SELECT concept_name.concept_id FROM concept_name
	                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
	                    WHERE name = 'send sms' AND voided = 0 AND retired = 0 LIMIT 1);

	SET @agrees_to_followup = (SELECT concept_name.concept_id FROM concept_name
	                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
	                    WHERE name = 'Agrees to followup' AND voided = 0 AND retired = 0 LIMIT 1);

	SET @type_of_confirmatory_hiv_test = (SELECT concept_name.concept_id FROM concept_name
	                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
	                    WHERE name = 'Confirmatory HIV test type' AND voided = 0 AND retired = 0 LIMIT 1);

	SET @confirmatory_hiv_test_location = (SELECT concept_name.concept_id FROM concept_name
	                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
	                    WHERE name = 'confirmatory hiv test location' AND voided = 0 AND retired = 0 LIMIT 1);

	SET @cd4_count =  (SELECT concept_name.concept_id FROM concept_name concept_name 
		      LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
		      WHERE name = 'Cd4 count' AND voided = 0 AND retired = 0 LIMIT 1);                            
					                  

	SET @confirmatory_hiv_test_date = (SELECT concept_name.concept_id FROM concept_name
	                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
	                    WHERE name = 'Confirmatory HIV test date' AND voided = 0 AND retired = 0 LIMIT 1);
                          
    CASE field_concept
    
        WHEN @patient_present THEN
        
            CALL proc_insert_patient_present(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );
    
        WHEN @guardian_present THEN
        
            CALL proc_insert_guardian_present(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );
    
        WHEN @transfer_within_responsibility THEN
        
            CALL proc_insert_transfer_within_responsibility(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );
    
        WHEN @breastfeeding THEN
        
            CALL proc_insert_breastfeeding(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );
    
        WHEN @continue_existing_regimen THEN
        
            CALL proc_insert_continue_existing_regimen(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );
    
        WHEN @prescribe_arvs THEN
        
            CALL proc_insert_prescribe_arvs(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );
    
        WHEN @ipt_given THEN
        
            CALL proc_insert_ipt_given(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );
    
        WHEN @cpt_given THEN
        
            CALL proc_insert_cpt_given(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );
    
        WHEN @arv_regimen_type THEN
        
            CALL proc_insert_arv_regimen_type(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );
    
        WHEN @patient_present THEN
        
            CALL proc_insert_patient_present(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );
    
        WHEN @guardian_present THEN
        
            CALL proc_insert_guardian_present(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );
    
        WHEN @pregnant THEN
        
            CALL proc_insert_pregnant(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );
    
        WHEN @pregnant2 THEN
            
                CALL proc_insert_pregnant(
                    patient_id, 
                    value_date, 
                    field_concept, 
                    field_value_coded, 
                    field_value_coded_name_id, 
                    NULL,
                    visit_id,
                    encounter_id
                );
    
        WHEN @currently_using_family_planning_method THEN
        
            CALL proc_insert_currently_using_family_planning_method(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );       
    
        WHEN @method_of_family_planning THEN
        
            CALL proc_insert_method_of_family_planning(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );       
    
        WHEN @symptom_present THEN
        
            CALL proc_insert_symptom_present(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );       
    
        WHEN @drug_induced THEN
        
            CALL proc_insert_drug_induced(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );       
    
        WHEN @routine_tb_screening THEN
        
            CALL proc_insert_routine_tb_screening(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );       
    
        WHEN @allergic_to_sulphur THEN
        
            CALL proc_insert_allergic_to_sulphur(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );        
    
        WHEN @tb_status THEN
        
            CALL proc_insert_tb_status(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id, 
                NULL,
                visit_id,
                encounter_id
            );             

		WHEN @reason_for_eligibility THEN
		
			SET @answer = (SELECT concept_name.name FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE concept.concept_id = field_value_coded AND name <> " " AND voided = 0 AND retired = 0 LIMIT 1);
			
			UPDATE flat_table1 SET reason_for_eligibility = @answer, reason_for_starting_v_date = value_date WHERE flat_table1.patient_id = patient_id ;
		
		WHEN @who_stage THEN
		
			SET @stage = (SELECT concept_name.name FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE concept.concept_id = field_value_coded AND name <> " " AND voided = 0 AND retired = 0 LIMIT 1);
			
			UPDATE flat_table1 SET who_stage = @stage WHERE flat_table1.patient_id = patient_id ;
		
		WHEN @send_sms THEN
		
			SET @answer = (SELECT concept_name.name FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE concept.concept_id = field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);
			
			UPDATE flat_table1 SET send_sms = @answer WHERE flat_table1.patient_id = patient_id ;

		WHEN @agrees_to_followup THEN
		
			SET @answer = (SELECT concept_name.name FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE concept.concept_id = field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);
		
			UPDATE flat_table1 SET agrees_to_followup = @answer WHERE flat_table1.patient_id = patient_id ;

		WHEN @type_of_confirmatory_hiv_test THEN
		
		
			SET @answer = (SELECT concept_name.name FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE concept.concept_id = field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

		
			UPDATE flat_table1 SET type_of_confirmatory_hiv_test = @answer WHERE flat_table1.patient_id = patient_id ;
		    		
		WHEN @confirmatory_hiv_test_location THEN		
		
		 SET @answer = (SELECT name FROM location WHERE location_id = field_text);
				 
		 	IF @answer = NULL THEN 
   			UPDATE flat_table1 SET confirmatory_hiv_test_location = "Unknown" WHERE flat_table1.patient_id = patient_id ;
 			ELSE
 				UPDATE flat_table1 SET confirmatory_hiv_test_location = @answer WHERE flat_table1.patient_id = patient_id ;
			END IF;
		
		WHEN @confirmatory_hiv_test_date THEN
		
			UPDATE flat_table1 SET confirmatory_hiv_test_date = field_value_datetime WHERE flat_table1.patient_id = patient_id ;
		
		WHEN @cd4_count THEN

      UPDATE flat_table1 SET cd4_count = field_value_numeric WHERE flat_table1.patient_id = patient_id ;
      UPDATE flat_table1 SET cd4_count_modifier = field_value_modifier WHERE flat_table1.patient_id = patient_id ;
		
    ELSE
        
            CALL proc_insert_other_field(
                patient_id, 
                value_date, 
                field_concept, 
                field_value_coded, 
                field_value_coded_name_id,
                field_text,
                field_value_numeric,
                field_value_datetime,
                visit_id,
                encounter_id
            );       
            
    END CASE;

END$$

DELIMITER ;

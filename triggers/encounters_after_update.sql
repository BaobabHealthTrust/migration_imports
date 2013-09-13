DELIMITER $$
DROP TRIGGER IF EXISTS `encounters_after_update`$$
CREATE TRIGGER `encounters_after_update` AFTER UPDATE 
ON `encounter`
FOR EACH ROW
BEGIN

    # Declare condition for exiting loop
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE  var_person_id INT(11);
    DECLARE  var_concept_id INT(11);
    DECLARE  var_obs_datetime DATE;
    DECLARE  var_value_coded INT(11);
    DECLARE  var_value_coded_name_id INT(11);

    # Declare and initialise cursor for looping through the table
    DECLARE cur CURSOR FOR SELECT DISTINCT person_id, concept_id, DATE(obs_datetime) datetime, value_coded, value_coded_name_id 
        FROM obs WHERE encounter_id = OLD.encounter_id;   

    BEGIN
    
        SET @prescription_encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = "TREATMENT" LIMIT 1);
        SET @dispensation_encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = "DISPENSING" LIMIT 1);
    
        IF OLD.encounter_type = @prescription_encounter_type OR OLD.encounter_type = @dispensation_encounter_type THEN
    
            UPDATE flat_table2 SET drug_order_id1 = NULL, drug_order_id1_enc_id = NULL 
                    WHERE flat_table2.drug_order_id1_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_encounter_id1 = NULL, drug_encounter_id1_enc_id = NULL 
                    WHERE flat_table2.drug_encounter_id1_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_start_date1 = NULL, drug_start_date1_enc_id = NULL 
                    WHERE flat_table2.drug_start_date1_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_auto_expire_date1 = NULL, drug_auto_expire_date1_enc_id = NULL 
                    WHERE flat_table2.drug_auto_expire_date1_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_inventory_id1 = NULL, drug_inventory_id1_enc_id = NULL 
                    WHERE flat_table2.drug_inventory_id1_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_name1 = NULL, drug_name1_enc_id = NULL 
                    WHERE flat_table2.drug_name1_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_equivalent_daily_dose1 = NULL, drug_equivalent_daily_dose1_enc_id = NULL 
                    WHERE flat_table2.drug_equivalent_daily_dose1_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_dose1 = NULL, drug_dose1_enc_id = NULL 
                    WHERE flat_table2.drug_dose1_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_frequency1 = NULL, drug_frequency1_enc_id = NULL 
                    WHERE flat_table2.drug_frequency1_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_quantity1 = NULL, drug_quantity1_enc_id = NULL 
                    WHERE flat_table2.drug_quantity1_enc_id = OLD.encounter_id; 
        
            ###########################################################################
            
            UPDATE flat_table2 SET drug_order_id2 = NULL, drug_order_id2_enc_id = NULL 
                    WHERE flat_table2.drug_order_id2_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_encounter_id2 = NULL, drug_encounter_id2_enc_id = NULL 
                    WHERE flat_table2.drug_encounter_id2_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_start_date2 = NULL, drug_start_date2_enc_id = NULL 
                    WHERE flat_table2.drug_start_date2_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_auto_expire_date2 = NULL, drug_auto_expire_date2_enc_id = NULL 
                    WHERE flat_table2.drug_auto_expire_date2_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_inventory_id2 = NULL, drug_inventory_id2_enc_id = NULL 
                    WHERE flat_table2.drug_inventory_id2_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_name2 = NULL, drug_name2_enc_id = NULL 
                    WHERE flat_table2.drug_name2_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_equivalent_daily_dose2 = NULL, drug_equivalent_daily_dose2_enc_id = NULL 
                    WHERE flat_table2.drug_equivalent_daily_dose2_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_dose2 = NULL, drug_dose2_enc_id = NULL 
                    WHERE flat_table2.drug_dose2_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_frequency2 = NULL, drug_frequency2_enc_id = NULL 
                    WHERE flat_table2.drug_frequency2_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_quantity2 = NULL, drug_quantity2_enc_id = NULL 
                    WHERE flat_table2.drug_quantity2_enc_id = OLD.encounter_id; 
        
            ###########################################################################
            
            UPDATE flat_table2 SET drug_order_id3 = NULL, drug_order_id3_enc_id = NULL 
                    WHERE flat_table2.drug_order_id3_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_encounter_id3 = NULL, drug_encounter_id3_enc_id = NULL 
                    WHERE flat_table2.drug_encounter_id3_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_start_date3 = NULL, drug_start_date3_enc_id = NULL 
                    WHERE flat_table2.drug_start_date3_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_auto_expire_date3 = NULL, drug_auto_expire_date3_enc_id = NULL 
                    WHERE flat_table2.drug_auto_expire_date3_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_inventory_id3 = NULL, drug_inventory_id3_enc_id = NULL 
                    WHERE flat_table2.drug_inventory_id3_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_name3 = NULL, drug_name3_enc_id = NULL 
                    WHERE flat_table2.drug_name3_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_equivalent_daily_dose3 = NULL, drug_equivalent_daily_dose3_enc_id = NULL 
                    WHERE flat_table2.drug_equivalent_daily_dose3_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_dose3 = NULL, drug_dose3_enc_id = NULL 
                    WHERE flat_table2.drug_dose3_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_frequency3 = NULL, drug_frequency3_enc_id = NULL 
                    WHERE flat_table2.drug_frequency3_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_quantity3 = NULL, drug_quantity3_enc_id = NULL 
                    WHERE flat_table2.drug_quantity3_enc_id = OLD.encounter_id; 
        
            ##########################################################################
            
            UPDATE flat_table2 SET drug_order_id4 = NULL, drug_order_id4_enc_id = NULL 
                    WHERE flat_table2.drug_order_id4_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_encounter_id4 = NULL, drug_encounter_id4_enc_id = NULL 
                    WHERE flat_table2.drug_encounter_id4_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_start_date4 = NULL, drug_start_date4_enc_id = NULL 
                    WHERE flat_table2.drug_start_date4_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_auto_expire_date4 = NULL, drug_auto_expire_date4_enc_id = NULL 
                    WHERE flat_table2.drug_auto_expire_date4_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_inventory_id4 = NULL, drug_inventory_id4_enc_id = NULL 
                    WHERE flat_table2.drug_inventory_id4_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_name4 = NULL, drug_name4_enc_id = NULL 
                    WHERE flat_table2.drug_name4_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_equivalent_daily_dose4 = NULL, drug_equivalent_daily_dose4_enc_id = NULL 
                    WHERE flat_table2.drug_equivalent_daily_dose4_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_dose4 = NULL, drug_dose4_enc_id = NULL 
                    WHERE flat_table2.drug_dose4_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_frequency4 = NULL, drug_frequency4_enc_id = NULL 
                    WHERE flat_table2.drug_frequency4_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_quantity4 = NULL, drug_quantity4_enc_id = NULL 
                    WHERE flat_table2.drug_quantity4_enc_id = OLD.encounter_id; 
        
            ###########################################################################
            
            UPDATE flat_table2 SET drug_order_id5 = NULL, drug_order_id5_enc_id = NULL 
                    WHERE flat_table2.drug_order_id5_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_encounter_id5 = NULL, drug_encounter_id5_enc_id = NULL 
                    WHERE flat_table2.drug_encounter_id5_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_start_date5 = NULL, drug_start_date5_enc_id = NULL 
                    WHERE flat_table2.drug_start_date5_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_auto_expire_date5 = NULL, drug_auto_expire_date5_enc_id = NULL 
                    WHERE flat_table2.drug_auto_expire_date5_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_inventory_id5 = NULL, drug_inventory_id5_enc_id = NULL 
                    WHERE flat_table2.drug_inventory_id5_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_name5 = NULL, drug_name5_enc_id = NULL 
                    WHERE flat_table2.drug_name5_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_equivalent_daily_dose5 = NULL, drug_equivalent_daily_dose5_enc_id = NULL 
                    WHERE flat_table2.drug_equivalent_daily_dose5_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_dose5 = NULL, drug_dose5_enc_id = NULL 
                    WHERE flat_table2.drug_dose5_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_frequency5 = NULL, drug_frequency5_enc_id = NULL 
                    WHERE flat_table2.drug_frequency5_enc_id = OLD.encounter_id; 
        
            UPDATE flat_table2 SET drug_quantity5 = NULL, drug_quantity5_enc_id = NULL 
                    WHERE flat_table2.drug_quantity5_enc_id = OLD.encounter_id; 
        
        END IF;
        
    END;

    # Open cursor
    OPEN cur;
    BEGIN
        # Declare loop position check
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
        
        # Declare loop for traversing through the records
        read_loop: LOOP
        
            # Get the fields into the variables declared earlier
            FETCH cur INTO var_person_id, var_concept_id, var_obs_datetime, var_value_coded, var_value_coded_name_id;
                
            # Check if we are done and exit loop if done
            IF done THEN
            
                LEAVE read_loop;
            
            END IF;
        
            # Not done, process the parameters

            IF NEW.voided = 1 THEN
            
                SET @pregnant = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Patient pregnant" AND voided = 0 AND retired = 0 LIMIT 1);
                                
                SET @breast_feeding = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Breastfeeding" AND voided = 0 AND retired = 0 LIMIT 1);
                                    
                SET @currently_using_family_planning_method = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Currently using family planning method" AND voided = 0 AND retired = 0 LIMIT 1);
                                    
                SET @method_of_family_planning = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Method of family planning" AND voided = 0 AND retired = 0 LIMIT 1);
                                    
                SET @symptom_present = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Symptom present" AND voided = 0 AND retired = 0 LIMIT 1);
                                    
                SET @drug_induced = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Drug induced" AND voided = 0 AND retired = 0 LIMIT 1);
                                    
                SET @routine_tb_screening = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Routine TB Screening" AND voided = 0 AND retired = 0 LIMIT 1);
                                    
                SET @allergic_to_sulphur = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Allergic to sulphur" AND voided = 0 AND retired = 0 LIMIT 1);

                SET @tb_status = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "TB status" AND voided = 0 AND retired = 0 LIMIT 1);
                                    
                SET @guardian_present = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Guardian Present" AND voided = 0 AND retired = 0 LIMIT 1);
                                    
                SET @patient_present = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Patient Present" AND voided = 0 AND retired = 0 LIMIT 1);
                                    
                SET @arv_regimen_type = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "What type of antiretroviral regimen" AND voided = 0 AND retired = 0 LIMIT 1);
                                   
                SET @cpt_given = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "CPT given" AND voided = 0 AND retired = 0 LIMIT 1);
                                     
                SET @ipt_given = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Isoniazid" AND voided = 0 AND retired = 0 LIMIT 1);
                                     
                SET @prescribe_arvs = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Prescribe ARVs this visit" AND voided = 0 AND retired = 0 LIMIT 1);
                                     
                SET @continue_existing_regimen = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Continue existing regimen" AND voided = 0 AND retired = 0 LIMIT 1);
                                     
                SET @transfer_within_responsibility = (SELECT concept_name.concept_id FROM concept_name concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Transfer within responsibility" AND voided = 0 AND retired = 0 LIMIT 1);
                                   
                SET @Weight = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Weight" AND voided = 0 AND retired = 0 LIMIT 1);
            
                SET @Height = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Height (cm)" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @Temperature = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Temperature" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @BMI = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "BMI" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @systolic_blood_pressure = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Systolic blood pressure" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @diastolic_blood_pressure = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Diastolic blood pressure" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @weight_for_height = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Weight for height percent of median" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @weight_for_age = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Weight for age percent of median" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @height_for_age = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Height for age percent of median" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @regimen_category = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Regimen Category" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @transfer_out_location = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Transfer out to" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @appointment_date = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Appointment date" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @condoms = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Condoms" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @amount_of_drug_brought_to_clinic = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Amount of drug brought to clinic" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @amount_of_drug_remaining_at_home = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Amount of drug remaining at home" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @what_was_the_patient_adherence_for_this_drug = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "What was the patients adherence for this drug order" AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @missed_hiv_drug_construct = (SELECT concept_name.concept_id FROM concept_name 
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Missed HIV drug construct" AND voided = 0 AND retired = 0 LIMIT 1);
                     
                SET @reason_for_eligibility = (SELECT concept_name.concept_id FROM concept_name
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = 'Reason for ART eligibility' AND voided = 0 AND retired = 0 LIMIT 1);
				                        
			    SET @who_stage = (SELECT concept_name.concept_id FROM concept_name concept_name 
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
			                        WHERE name = 'Confirmatory HIV test location' AND voided = 0 AND retired = 0 LIMIT 1);
									                
			    SET @confirmatory_hiv_test_date = (SELECT concept_name.concept_id FROM concept_name
			                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
			                        WHERE name = 'Confirmatory HIV test date' AND voided = 0 AND retired = 0 LIMIT 1);
     
                CASE var_concept_id
                
                    WHEN @reason_for_eligibility THEN
							
						    UPDATE flat_table1 SET reason_for_eligibility = NULL WHERE flat_table1.patient_id = OLD.patient_id ;

				    WHEN @who_stage THEN
				
						    UPDATE flat_table1 SET who_stage = NULL WHERE flat_table1.patient_id = OLD.patient_id ;
			
				    WHEN @send_sms THEN
				
						    UPDATE flat_table1 SET send_sms = NULL WHERE flat_table1.patient_id = OLD.patient_id ;
	
				    WHEN @agrees_to_followup THEN
			
						    UPDATE flat_table1 SET agrees_to_followup = NULL WHERE flat_table1.patient_id = OLD.patient_id ;

				    WHEN @type_of_confirmatory_hiv_test THEN
					
						    UPDATE flat_table1 SET type_of_confirmatory_hiv_test = NULL WHERE flat_table1.patient_id = OLD.patient_id ;
									
				    WHEN @confirmatory_hiv_test_location THEN		
			
					    UPDATE flat_table1 SET confirmatory_hiv_test_location = NULL WHERE flat_table1.patient_id = OLD.patient_id ;
			
				    WHEN @confirmatory_hiv_test_date THEN
			
					    UPDATE flat_table1 SET confirmatory_hiv_test_date = NULL WHERE flat_table1.patient_id = OLD.patient_id ;

                    WHEN @missed_hiv_drug_construct THEN
                    
                        UPDATE flat_table2 SET missed_hiv_drug_construct1 = NULL, missed_hiv_drug_construct1_enc_id = NULL 
                            WHERE flat_table2.missed_hiv_drug_construct1_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET missed_hiv_drug_construct2 = NULL, missed_hiv_drug_construct2_enc_id = NULL 
                            WHERE flat_table2.missed_hiv_drug_construct2_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET missed_hiv_drug_construct3 = NULL, missed_hiv_drug_construct3_enc_id = NULL 
                            WHERE flat_table2.missed_hiv_drug_construct3_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET missed_hiv_drug_construct4 = NULL, missed_hiv_drug_construct4_enc_id = NULL 
                            WHERE flat_table2.missed_hiv_drug_construct4_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET missed_hiv_drug_construct5 = NULL, missed_hiv_drug_construct5_enc_id = NULL 
                            WHERE flat_table2.missed_hiv_drug_construct5_enc_id = OLD.encounter_id;
                
                    WHEN @what_was_the_patient_adherence_for_this_drug THEN
                    
                        UPDATE flat_table2 SET what_was_the_patient_adherence_for_this_drug1 = NULL, what_was_the_patient_adherence_for_this_drug1_enc_id = NULL 
                            WHERE flat_table2.what_was_the_patient_adherence_for_this_drug1_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET what_was_the_patient_adherence_for_this_drug2 = NULL, what_was_the_patient_adherence_for_this_drug2_enc_id = NULL 
                            WHERE flat_table2.what_was_the_patient_adherence_for_this_drug2_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET what_was_the_patient_adherence_for_this_drug3 = NULL, what_was_the_patient_adherence_for_this_drug3_enc_id = NULL 
                            WHERE flat_table2.what_was_the_patient_adherence_for_this_drug3_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET what_was_the_patient_adherence_for_this_drug4 = NULL, what_was_the_patient_adherence_for_this_drug4_enc_id = NULL 
                            WHERE flat_table2.what_was_the_patient_adherence_for_this_drug4_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET what_was_the_patient_adherence_for_this_drug5 = NULL, what_was_the_patient_adherence_for_this_drug5_enc_id = NULL 
                            WHERE flat_table2.what_was_the_patient_adherence_for_this_drug5_enc_id = OLD.encounter_id;
                
                    WHEN @amount_of_drug_remaining_at_home THEN
                    
                        UPDATE flat_table2 SET amount_of_drug1_remaining_at_home = NULL, amount_of_drug1_remaining_at_home_enc_id = NULL 
                            WHERE flat_table2.amount_of_drug1_remaining_at_home_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET amount_of_drug2_remaining_at_home = NULL, amount_of_drug2_remaining_at_home_enc_id = NULL 
                            WHERE flat_table2.amount_of_drug2_remaining_at_home_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET amount_of_drug3_remaining_at_home = NULL, amount_of_drug3_remaining_at_home_enc_id = NULL 
                            WHERE flat_table2.amount_of_drug3_remaining_at_home_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET amount_of_drug4_remaining_at_home = NULL, amount_of_drug4_remaining_at_home_enc_id = NULL 
                            WHERE flat_table2.amount_of_drug4_remaining_at_home_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET amount_of_drug5_remaining_at_home = NULL, amount_of_drug5_remaining_at_home_enc_id = NULL 
                            WHERE flat_table2.amount_of_drug5_remaining_at_home_enc_id = OLD.encounter_id;
                
                    WHEN @amount_of_drug_brought_to_clinic THEN
                    
                        UPDATE flat_table2 SET amount_of_drug1_brought_to_clinic = NULL, amount_of_drug1_brought_to_clinic_enc_id = NULL 
                            WHERE flat_table2.amount_of_drug1_brought_to_clinic_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET amount_of_drug2_brought_to_clinic = NULL, amount_of_drug2_brought_to_clinic_enc_id = NULL 
                            WHERE flat_table2.amount_of_drug2_brought_to_clinic_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET amount_of_drug3_brought_to_clinic = NULL, amount_of_drug3_brought_to_clinic_enc_id = NULL 
                            WHERE flat_table2.amount_of_drug3_brought_to_clinic_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET amount_of_drug4_brought_to_clinic = NULL, amount_of_drug4_brought_to_clinic_enc_id = NULL 
                            WHERE flat_table2.amount_of_drug4_brought_to_clinic_enc_id = OLD.encounter_id;
                
                        UPDATE flat_table2 SET amount_of_drug5_brought_to_clinic = NULL, amount_of_drug5_brought_to_clinic_enc_id = NULL 
                            WHERE flat_table2.amount_of_drug5_brought_to_clinic_enc_id = OLD.encounter_id;
                
                    WHEN @condoms THEN
                    
                        UPDATE flat_table2 SET condoms = NULL, condoms_enc_id = NULL WHERE flat_table2.condoms_enc_id = OLD.encounter_id;
                
                    WHEN @appointment_date THEN
                    
                        UPDATE flat_table2 SET appointment_date = NULL, appointment_date_enc_id = NULL WHERE flat_table2.appointment_date_enc_id = OLD.encounter_id;
                
                    WHEN @transfer_out_location THEN
                    
                        UPDATE flat_table2 SET transfer_out_location = NULL, transfer_out_location_enc_id = NULL WHERE flat_table2.transfer_out_location_enc_id = OLD.encounter_id;
                
                    WHEN @regimen_category THEN
                    
                        UPDATE flat_table2 SET regimen_category = NULL, regimen_category_enc_id = NULL WHERE flat_table2.regimen_category_enc_id = OLD.encounter_id;
                
                    WHEN @height_for_age THEN
                    
                        UPDATE flat_table2 SET height_for_age = NULL, height_for_age_enc_id = NULL WHERE flat_table2.height_for_age_enc_id = OLD.encounter_id;
                
                    WHEN @weight_for_age THEN
                    
                        UPDATE flat_table2 SET weight_for_age = NULL, weight_for_age_enc_id = NULL WHERE flat_table2.weight_for_age_enc_id = OLD.encounter_id;
                
                    WHEN @weight_for_height THEN
                    
                        UPDATE flat_table2 SET weight_for_height = NULL, weight_for_height_enc_id = NULL WHERE flat_table2.weight_for_height_enc_id = OLD.encounter_id;
                
                    WHEN @diastolic_blood_pressure THEN
                    
                        UPDATE flat_table2 SET diastolic_blood_pressure = NULL, diastolic_blood_pressure_enc_id = NULL WHERE flat_table2.diastolic_blood_pressure_enc_id = OLD.encounter_id;
                
                    WHEN @systolic_blood_pressure THEN
                    
                        UPDATE flat_table2 SET systolic_blood_pressure = NULL, systolic_blood_pressure_enc_id = NULL WHERE flat_table2.systolic_blood_pressure_enc_id = OLD.encounter_id;
                
                    WHEN @BMI THEN
                    
                        UPDATE flat_table2 SET BMI = NULL, BMI_enc_id = NULL WHERE flat_table2.BMI_enc_id = OLD.encounter_id;
                
                    WHEN @Temperature THEN
                    
                        UPDATE flat_table2 SET Temperature = NULL, Temperature_enc_id = NULL WHERE flat_table2.Temperature_enc_id = OLD.encounter_id;
                
                    WHEN @Height THEN
                    
                        UPDATE flat_table2 SET Height = NULL, Height_enc_id = NULL WHERE flat_table2.Height_enc_id = OLD.encounter_id;
                
                    WHEN @Weight THEN
                    
                        UPDATE flat_table2 SET Weight = NULL, Weight_enc_id = NULL WHERE flat_table2.Weight_enc_id = OLD.encounter_id;
                
                    WHEN @transfer_within_responsibility THEN
                    
                        UPDATE flat_table2 SET transfer_within_responsibility_yes = NULL, transfer_within_responsibility_no = NULL, transfer_within_responsibility_yes_enc_id = NULL, transfer_within_responsibility_no_enc_id = NULL WHERE flat_table2.transfer_within_responsibility_yes_enc_id = OLD.encounter_id OR flat_table2.transfer_within_responsibility_no_enc_id = OLD.encounter_id;
                
                    WHEN @continue_existing_regimen THEN
                    
                        UPDATE flat_table2 SET continue_existing_regimen_yes = NULL, continue_existing_regimen_no = NULL, continue_existing_regimen_yes_enc_id = NULL, continue_existing_regimen_no_enc_id = NULL WHERE flat_table2.continue_existing_regimen_yes_enc_id = OLD.encounter_id OR flat_table2.continue_existing_regimen_no_enc_id = OLD.encounter_id;
                
                    WHEN @prescribe_arvs THEN
                    
                        UPDATE flat_table2 SET prescribe_arvs_yes = NULL, prescribe_arvs_no = NULL, prescribe_arvs_yes_enc_id = NULL, prescribe_arvs_no_enc_id = NULL WHERE flat_table2.prescribe_arvs_yes_enc_id = OLD.encounter_id OR flat_table2.prescribe_arvs_no_enc_id = OLD.encounter_id;
                
                    WHEN @ipt_given THEN
                    
                        UPDATE flat_table2 SET ipt_given_yes = NULL, ipt_given_no = NULL, ipt_given_yes_enc_id = NULL, ipt_given_no_enc_id = NULL WHERE flat_table2.ipt_given_yes_enc_id = OLD.encounter_id OR flat_table2.ipt_given_no_enc_id = OLD.encounter_id;
                
                    WHEN @cpt_given THEN
                    
                        UPDATE flat_table2 SET cpt_given_yes = NULL, cpt_given_no = NULL, cpt_given_yes_enc_id = NULL, cpt_given_no_enc_id = NULL WHERE flat_table2.cpt_given_yes_enc_id = OLD.encounter_id OR flat_table2.cpt_given_no_enc_id = OLD.encounter_id;
                
                    WHEN @patient_present THEN
                    
                        UPDATE flat_table2 SET patient_present_yes = NULL, patient_present_no = NULL, patient_present_yes_enc_id = NULL, patient_present_no_enc_id = NULL WHERE flat_table2.patient_present_yes_enc_id = OLD.encounter_id OR flat_table2.patient_present_no_enc_id = OLD.encounter_id;
                
                    WHEN @guardian_present THEN
                    
                        UPDATE flat_table2 SET guardian_present_yes = NULL, guardian_present_no = NULL, guardian_present_yes_enc_id = NULL, guardian_present_no_enc_id = NULL WHERE flat_table2.guardian_present_yes_enc_id = OLD.encounter_id OR flat_table2.guardian_present_no_enc_id = OLD.encounter_id;
                
                    WHEN @allergic_to_sulphur THEN
                    
                        UPDATE flat_table2 SET allergic_to_sulphur_yes = NULL, allergic_to_sulphur_no = NULL, allergic_to_sulphur_yes_enc_id = NULL, allergic_to_sulphur_no_enc_id = NULL WHERE flat_table2.allergic_to_sulphur_yes_enc_id = OLD.encounter_id OR flat_table2.allergic_to_sulphur_no_enc_id = OLD.encounter_id;
                
                    WHEN @pregnant THEN
                    
                        UPDATE flat_table2 SET pregnant_yes = NULL, pregnant_no = NULL, pregnant_yes_enc_id = NULL, pregnant_no_enc_id = NULL WHERE flat_table2.pregnant_yes_enc_id = OLD.encounter_id OR flat_table2.pregnant_no_enc_id = OLD.encounter_id;
                
                    WHEN @breast_feeding THEN
                    
                        UPDATE flat_table2 SET breastfeeding_yes = NULL, breastfeeding_no = NULL, breastfeeding_yes_enc_id = NULL, breastfeeding_no_enc_id = NULL WHERE flat_table2.breastfeeding_yes_enc_id = OLD.encounter_id OR flat_table2.breastfeeding_no_enc_id = OLD.encounter_id;
                
                    WHEN @currently_using_family_planning_method THEN
                    
                        UPDATE flat_table2 SET currently_using_family_planning_method_yes = NULL, currently_using_family_planning_method_no = NULL, currently_using_family_planning_method_yes_enc_id = NULL, currently_using_family_planning_method_no_enc_id = NULL WHERE flat_table2.currently_using_family_planning_method_yes_enc_id = OLD.encounter_id OR flat_table2.currently_using_family_planning_method_no_enc_id = OLD.encounter_id;
                
                    WHEN @arv_regimen_type THEN                
                                         
                        SET @arv_regimen_type_unknown = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "UNKNOWN ANTIRETROVIRAL DRUG" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @arv_regimen_type_d4T_3TC_NVP = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "d4T/3TC/NVP" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @arv_regimen_type_triomune = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "triomune" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @arv_regimen_type_triomune_30 = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "triomune-30" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @arv_regimen_type_triomune_40 = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "triomune-40" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @arv_regimen_type_AZT_3TC_NVP = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "AZT/3TC/NVP" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @arv_regimen_type_AZT_3TC_LPV_r = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "AZT/3TC+LPV/r" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @arv_regimen_type_AZT_3TC_EFV = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "AZT/3TC+EFV" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @arv_regimen_type_d4T_3TC_EFV = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "d4T/3TC/EFV" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @arv_regimen_type_TDF_3TC_NVP = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "TDF/3TC+NVP" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @arv_regimen_type_TDF_3TC_EFV = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "TDF/3TC/EFV" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @arv_regimen_type_ABC_3TC_LPV_r = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "ABC/3TC+LPV/r" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @arv_regimen_type_TDF_3TC_LPV_r = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "TDF/3TC+LPV/r" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @arv_regimen_type_d4T_3TC_d4T_3TC_NVP = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "d4T/3TC + d4T/3TC/NVP (Starter pack)" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @arv_regimen_type_AZT_3TC_AZT_3TC_NVP = (SELECT concept_name.concept_name_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "AZT/3TC + AZT/3TC/NVP (Starter pack)" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        CASE var_value_coded_name_id
                                                                        
                            WHEN @arv_regimen_type_AZT_3TC_AZT_3TC_NVP THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_AZT_3TC_AZT_3TC_NVP =  NULL, 
                                    arv_regimen_type_AZT_3TC_AZT_3TC_NVP_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_AZT_3TC_AZT_3TC_NVP_enc_id = OLD.encounter_id;
                                                                       
                            WHEN @arv_regimen_type_d4T_3TC_d4T_3TC_NVP THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_d4T_3TC_d4T_3TC_NVP =  NULL, 
                                    arv_regimen_type_d4T_3TC_d4T_3TC_NVP_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_d4T_3TC_d4T_3TC_NVP_enc_id = OLD.encounter_id;
                                                                     
                            WHEN @arv_regimen_type_TDF_3TC_LPV_r THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_TDF_3TC_LPV_r =  NULL, 
                                    arv_regimen_type_TDF_3TC_LPV_r_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_TDF_3TC_LPV_r_enc_id = OLD.encounter_id;
                                                                          
                            WHEN @arv_regimen_type_ABC_3TC_LPV_r THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_ABC_3TC_LPV_r =  NULL, 
                                    arv_regimen_type_ABC_3TC_LPV_r_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_ABC_3TC_LPV_r_enc_id = OLD.encounter_id;
                                                                  
                            WHEN @arv_regimen_type_TDF_3TC_EFV THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_TDF_3TC_EFV =  NULL, 
                                    arv_regimen_type_TDF_3TC_EFV_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_TDF_3TC_EFV_enc_id = OLD.encounter_id;
                                                                       
                            WHEN @arv_regimen_type_TDF_3TC_NVP THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_TDF_3TC_NVP =  NULL, 
                                    arv_regimen_type_TDF_3TC_NVP_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_TDF_3TC_NVP_enc_id = OLD.encounter_id;
                                                                    
                            WHEN @arv_regimen_type_d4T_3TC_EFV THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_d4T_3TC_EFV =  NULL, 
                                    arv_regimen_type_d4T_3TC_EFV_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_d4T_3TC_EFV_enc_id = OLD.encounter_id;
                                                                   
                            WHEN @arv_regimen_type_AZT_3TC_EFV THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_AZT_3TC_EFV =  NULL, 
                                    arv_regimen_type_AZT_3TC_EFV_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_AZT_3TC_EFV_enc_id = OLD.encounter_id;
                                                                 
                            WHEN @arv_regimen_type_AZT_3TC_LPV_r THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_AZT_3TC_LPV_r =  NULL, 
                                    arv_regimen_type_AZT_3TC_LPV_r_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_AZT_3TC_LPV_r_enc_id = OLD.encounter_id;
                                                                
                            WHEN @arv_regimen_type_AZT_3TC_NVP THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_AZT_3TC_NVP =  NULL, 
                                    arv_regimen_type_AZT_3TC_NVP_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_AZT_3TC_NVP_enc_id = OLD.encounter_id;
                                                                
                            WHEN @arv_regimen_type_triomune_40 THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_triomune_40 =  NULL, 
                                    arv_regimen_type_triomune_40_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_triomune_40_enc_id = OLD.encounter_id;
                                                                  
                            WHEN @arv_regimen_type_triomune_30 THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_triomune_30 =  NULL, 
                                    arv_regimen_type_triomune_30_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_triomune_30_enc_id = OLD.encounter_id;
                                                             
                            WHEN @arv_regimen_type_triomune THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_triomune =  NULL, 
                                    arv_regimen_type_triomune_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_triomune_enc_id = OLD.encounter_id;
                                                        
                            WHEN @arv_regimen_type_d4T_3TC_NVP THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_d4T_3TC_NVP =  NULL, 
                                    arv_regimen_type_d4T_3TC_NVP_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_d4T_3TC_NVP_enc_id = OLD.encounter_id;
                                                            
                            WHEN @arv_regimen_type_unknown THEN
                            
                                UPDATE flat_table2 SET arv_regimen_type_unknown =  NULL, 
                                    arv_regimen_type_unknown_enc_id = NULL 
                                WHERE flat_table2.arv_regimen_type_unknown_enc_id = OLD.encounter_id;
                                                         
                        END CASE;                        
              
                    WHEN @tb_status THEN                
                                        
                        SET @tb_status_tb_not_suspected = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "TB NOT suspected" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @tb_status_tb_suspected = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "TB suspected" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @tb_status_confirmed_tb_not_on_treatment = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Confirmed TB NOT on treatment" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @tb_status_confirmed_tb_on_treatment = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Confirmed TB on treatment" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @tb_status_unknown = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Unknown" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
        
                        CASE var_value_coded
                                             
                            WHEN @tb_status_unknown THEN
                            
                                UPDATE flat_table2 SET tb_status_unknown =  NULL, 
                                    tb_status_unknown_enc_id = NULL 
                                WHERE flat_table2.tb_status_unknown_enc_id = OLD.encounter_id;
                                             
                            WHEN @tb_status_confirmed_tb_on_treatment THEN
                            
                                UPDATE flat_table2 SET tb_status_confirmed_tb_on_treatment =  NULL, 
                                    tb_status_confirmed_tb_on_treatment_enc_id = NULL 
                                WHERE flat_table2.tb_status_confirmed_tb_on_treatment_enc_id = OLD.encounter_id;
                                                   
                            WHEN @tb_status_confirmed_tb_not_on_treatment THEN
                            
                                UPDATE flat_table2 SET tb_status_confirmed_tb_not_on_treatment =  NULL, 
                                    tb_status_confirmed_tb_not_on_treatment_enc_id = NULL 
                                WHERE flat_table2.tb_status_confirmed_tb_not_on_treatment_enc_id = OLD.encounter_id;
                                                
                            WHEN @tb_status_tb_suspected THEN
                            
                                UPDATE flat_table2 SET tb_status_tb_suspected =  NULL, 
                                    tb_status_tb_suspected_enc_id = NULL 
                                WHERE flat_table2.tb_status_tb_suspected_enc_id = OLD.encounter_id;
                                                  
                            WHEN @tb_status_tb_not_suspected THEN
                            
                                UPDATE flat_table2 SET tb_status_tb_not_suspected =  NULL, 
                                    tb_status_tb_not_suspected_enc_id = NULL 
                                WHERE flat_table2.tb_status_tb_not_suspected_enc_id = OLD.encounter_id;
                                           
                        END CASE;                        
              
                    WHEN @routine_tb_screening THEN                
                                        
                        SET @routine_tb_screening_fever = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Fever" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @routine_tb_screening_night_sweats = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Night sweats" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @routine_tb_screening_cough_of_any_duration = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Cough of any duration" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @routine_tb_screening_weight_loss_failure = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Weight loss / Failure to thrive / malnutrition" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                    
                        CASE var_value_coded
                                                
                            WHEN @routine_tb_screening_fever THEN
                            
                                UPDATE flat_table2 SET routine_tb_screening_fever =  NULL, 
                                    routine_tb_screening_fever_enc_id = NULL 
                                WHERE flat_table2.routine_tb_screening_fever_enc_id = OLD.encounter_id;
                                                           
                            WHEN @routine_tb_screening_night_sweats THEN
                            
                                UPDATE flat_table2 SET routine_tb_screening_night_sweats =  NULL, 
                                    routine_tb_screening_night_sweats_enc_id = NULL 
                                WHERE flat_table2.routine_tb_screening_night_sweats_enc_id = OLD.encounter_id;
                                                           
                            WHEN @routine_tb_screening_cough_of_any_duration THEN
                            
                                UPDATE flat_table2 SET routine_tb_screening_cough_of_any_duration =  NULL, 
                                    routine_tb_screening_cough_of_any_duration_enc_id = NULL 
                                WHERE flat_table2.routine_tb_screening_cough_of_any_duration_enc_id = OLD.encounter_id;
                                                           
                            WHEN @routine_tb_screening_weight_loss_failure THEN
                            
                                UPDATE flat_table2 SET routine_tb_screening_weight_loss_failure =  NULL, 
                                    routine_tb_screening_weight_loss_failure_enc_id = NULL 
                                WHERE flat_table2.routine_tb_screening_weight_loss_failure_enc_id = OLD.encounter_id;
                                         
                        END CASE;                        
        
                    WHEN @drug_induced THEN                
                                        
                        SET @drug_induced_lipodystrophy = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Lipodystrophy" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @drug_induced_anemia = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Anemia" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @drug_induced_jaundice = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Jaundice" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @drug_induced_lactic_acidosis = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Lactic acidosis" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @drug_induced_fever = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Fever" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @drug_induced_skin_rash = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Skin rash" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @drug_induced_abdominal_pain = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Abdominal pain" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @drug_induced_anorexia = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Anorexia" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @drug_induced_cough = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Cough" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @drug_induced_diarrhea = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Diarrhea" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @drug_induced_hepatitis = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Hepatitis" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @drug_induced_leg_pain_numbness = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Leg pain / numbness" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @drug_induced_peripheral_neuropathy = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Peripheral neuropathy" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @drug_induced_vomiting = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Vomiting" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @drug_induced_other_symptom = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Other symptom" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                                            
                        CASE var_value_coded
                              
                            WHEN @drug_induced_abdominal_pain THEN
                            
                                UPDATE flat_table2 SET drug_induced_abdominal_pain =  NULL, 
                                    drug_induced_abdominal_pain_enc_id = NULL 
                                WHERE flat_table2.drug_induced_abdominal_pain_enc_id = OLD.encounter_id;
                                                          
                            WHEN @drug_induced_anorexia THEN
                            
                                UPDATE flat_table2 SET drug_induced_anorexia =  NULL, 
                                    drug_induced_anorexia_enc_id = NULL 
                                WHERE flat_table2.drug_induced_anorexia_enc_id = OLD.encounter_id;
                                                          
                            WHEN @drug_induced_diarrhea THEN
                            
                                UPDATE flat_table2 SET drug_induced_diarrhea =  NULL, 
                                    drug_induced_diarrhea_enc_id = NULL 
                                WHERE flat_table2.drug_induced_diarrhea_enc_id = OLD.encounter_id;
                                                          
                            WHEN @drug_induced_jaundice THEN
                            
                                UPDATE flat_table2 SET drug_induced_jaundice =  NULL, 
                                    drug_induced_jaundice_enc_id = NULL 
                                WHERE flat_table2.drug_induced_jaundice_enc_id = OLD.encounter_id;
                                                          
                            WHEN @drug_induced_leg_pain_numbness THEN
                            
                                UPDATE flat_table2 SET drug_induced_leg_pain_numbness =  NULL, 
                                    drug_induced_leg_pain_numbness_enc_id = NULL 
                                WHERE flat_table2.drug_induced_leg_pain_numbness_enc_id = OLD.encounter_id;
                                                          
                            WHEN @drug_induced_vomiting THEN
                            
                                UPDATE flat_table2 SET drug_induced_vomiting =  NULL, 
                                    drug_induced_vomiting_enc_id = NULL 
                                WHERE flat_table2.drug_induced_vomiting_enc_id = OLD.encounter_id;
                                                          
                            WHEN @drug_induced_peripheral_neuropathy THEN
                            
                                UPDATE flat_table2 SET drug_induced_peripheral_neuropathy =  NULL, 
                                    drug_induced_peripheral_neuropathy_enc_id = NULL 
                                WHERE flat_table2.drug_induced_peripheral_neuropathy_enc_id = OLD.encounter_id;
                                                          
                            WHEN @drug_induced_hepatitis THEN
                            
                                UPDATE flat_table2 SET drug_induced_hepatitis =  NULL, 
                                    drug_induced_hepatitis_enc_id = NULL 
                                WHERE flat_table2.drug_induced_hepatitis_enc_id = OLD.encounter_id;
                                                          
                            WHEN @drug_induced_anemia THEN
                            
                                UPDATE flat_table2 SET drug_induced_anemia =  NULL, 
                                    drug_induced_anemia_enc_id = NULL 
                                WHERE flat_table2.drug_induced_anemia_enc_id = OLD.encounter_id;
                                                          
                            WHEN @drug_induced_lactic_acidosis THEN
                            
                                UPDATE flat_table2 SET drug_induced_lactic_acidosis =  NULL, 
                                    drug_induced_lactic_acidosis_enc_id = NULL 
                                WHERE flat_table2.drug_induced_lactic_acidosis_enc_id = OLD.encounter_id;
                                                          
                            WHEN @drug_induced_lipodystrophy THEN
                            
                                UPDATE flat_table2 SET drug_induced_lipodystrophy =  NULL, 
                                    drug_induced_lipodystrophy_enc_id = NULL 
                                WHERE flat_table2.drug_induced_lipodystrophy_enc_id = OLD.encounter_id;
                                                          
                            WHEN @drug_induced_skin_rash THEN
                            
                                UPDATE flat_table2 SET drug_induced_skin_rash =  NULL, 
                                    drug_induced_skin_rash_enc_id = NULL 
                                WHERE flat_table2.drug_induced_skin_rash_enc_id = OLD.encounter_id;
                                                          
                            WHEN @drug_induced_other_symptom THEN
                            
                                UPDATE flat_table2 SET drug_induced_other_symptom =  NULL, 
                                    drug_induced_other_symptom_enc_id = NULL 
                                WHERE flat_table2.drug_induced_other_symptom_enc_id = OLD.encounter_id;
                                                          
                            WHEN @drug_induced_fever THEN
                            
                                UPDATE flat_table2 SET drug_induced_fever =  NULL, 
                                    drug_induced_fever_enc_id = NULL 
                                WHERE flat_table2.drug_induced_fever_enc_id = OLD.encounter_id;
                                                          
                            WHEN @drug_induced_cough THEN
                            
                                UPDATE flat_table2 SET drug_induced_cough =  NULL, 
                                    drug_induced_cough_enc_id = NULL 
                                WHERE flat_table2.drug_induced_cough_enc_id = OLD.encounter_id;
                             
                         END CASE;                        
        
                    WHEN @symptom_present THEN                
                                        
                        SET @symptom_present_lipodystrophy = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Lipodystrophy" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @symptom_present_anemia = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Anemia" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @symptom_present_jaundice = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Jaundice" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @symptom_present_lactic_acidosis = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Lactic acidosis" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @symptom_present_fever = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Fever" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @symptom_present_skin_rash = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Skin rash" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @symptom_present_abdominal_pain = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Abdominal pain" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @symptom_present_anorexia = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Anorexia" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @symptom_present_cough = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Cough" AND concept_name_type = "FULLY_SPECIFIED" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @symptom_present_diarrhea = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Diarrhea" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @symptom_present_hepatitis = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Hepatitis" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @symptom_present_leg_pain_numbness = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Leg pain / numbness" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @symptom_present_peripheral_neuropathy = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Peripheral neuropathy" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @symptom_present_vomiting = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Vomiting" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        SET @symptom_present_other_symptom = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Other symptom" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
                        
                        CASE var_value_coded
                                                            
                            WHEN @symptom_present_lipodystrophy THEN
                            
                                UPDATE flat_table2 SET symptom_present_lipodystrophy = NULL, 
                                    symptom_present_lipodystrophy_enc_id = NULL 
                                WHERE flat_table2.symptom_present_lipodystrophy_enc_id = OLD.encounter_id;
                                                          
                            WHEN @symptom_present_anemia THEN
                            
                                UPDATE flat_table2 SET symptom_present_anemia = NULL, 
                                    symptom_present_anemia_enc_id = NULL 
                                WHERE flat_table2.symptom_present_anemia_enc_id = OLD.encounter_id;
                                                            
                            WHEN @symptom_present_jaundice THEN
                            
                                UPDATE flat_table2 SET symptom_present_jaundice = NULL, 
                                    symptom_present_jaundice_enc_id = NULL 
                                WHERE flat_table2.symptom_present_jaundice_enc_id = OLD.encounter_id;
                                                    
                            WHEN @symptom_present_lactic_acidosis THEN
                            
                                UPDATE flat_table2 SET symptom_present_lactic_acidosis = NULL, 
                                    symptom_present_lactic_acidosis_enc_id = NULL 
                                WHERE flat_table2.symptom_present_lactic_acidosis_enc_id = OLD.encounter_id;
                                                       
                            WHEN @symptom_present_fever THEN
                            
                                UPDATE flat_table2 SET symptom_present_fever = NULL, 
                                    symptom_present_fever_enc_id = NULL 
                                WHERE flat_table2.symptom_present_fever_enc_id = OLD.encounter_id;
                                                             
                            WHEN @symptom_present_skin_rash THEN
                            
                                UPDATE flat_table2 SET symptom_present_skin_rash = NULL, 
                                    symptom_present_skin_rash_enc_id = NULL 
                                WHERE flat_table2.symptom_present_skin_rash_enc_id = OLD.encounter_id;
                                                                     
                            WHEN @symptom_present_abdominal_pain THEN
                            
                                UPDATE flat_table2 SET symptom_present_abdominal_pain = NULL, 
                                    symptom_present_abdominal_pain_enc_id = NULL 
                                WHERE flat_table2.symptom_present_abdominal_pain_enc_id = OLD.encounter_id;
                                                           
                            WHEN @symptom_present_anorexia THEN
                            
                                UPDATE flat_table2 SET symptom_present_anorexia = NULL, 
                                    symptom_present_anorexia_enc_id = NULL 
                                WHERE flat_table2.symptom_present_anorexia_enc_id = OLD.encounter_id;
                                                         
                            WHEN @symptom_present_cough THEN
                            
                                UPDATE flat_table2 SET symptom_present_cough = NULL, 
                                    symptom_present_cough_enc_id = NULL 
                                WHERE flat_table2.symptom_present_cough_enc_id = OLD.encounter_id;
                                                  
                            WHEN @symptom_present_diarrhea THEN
                            
                                UPDATE flat_table2 SET symptom_present_diarrhea = NULL, 
                                    symptom_present_diarrhea_enc_id = NULL 
                                WHERE flat_table2.symptom_present_diarrhea_enc_id = OLD.encounter_id;
                                                    
                            WHEN @symptom_present_hepatitis THEN
                            
                                UPDATE flat_table2 SET symptom_present_hepatitis = NULL, 
                                    symptom_present_hepatitis_enc_id = NULL 
                                WHERE flat_table2.symptom_present_hepatitis_enc_id = OLD.encounter_id;
                                                 
                            WHEN @symptom_present_leg_pain_numbness THEN
                            
                                UPDATE flat_table2 SET symptom_present_leg_pain_numbness = NULL, 
                                    symptom_present_leg_pain_numbness_enc_id = NULL 
                                WHERE flat_table2.symptom_present_leg_pain_numbness_enc_id = OLD.encounter_id;
                                                        
                            WHEN @symptom_present_peripheral_neuropathy THEN
                            
                                UPDATE flat_table2 SET symptom_present_peripheral_neuropathy = NULL, 
                                    symptom_present_peripheral_neuropathy_enc_id = NULL 
                                WHERE flat_table2.symptom_present_peripheral_neuropathy_enc_id = OLD.encounter_id;
                                                         
                            WHEN @symptom_present_vomiting THEN
                            
                                UPDATE flat_table2 SET symptom_present_vomiting = NULL, 
                                    symptom_present_vomiting_enc_id = NULL 
                                WHERE flat_table2.symptom_present_vomiting_enc_id = OLD.encounter_id;
                                                
                            WHEN @symptom_present_other_symptom THEN
                            
                                UPDATE flat_table2 SET symptom_present_other_symptom = NULL, 
                                    symptom_present_other_symptom_enc_id = NULL 
                                WHERE flat_table2.symptom_present_other_symptom_enc_id = OLD.encounter_id;
                               
                        END CASE;
        
                    WHEN @method_of_family_planning THEN
                    
                        SET @family_planning_method_oral_contraceptive_pills = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Oral contraceptive pills" AND voided = 0 AND retired = 0 LIMIT 1);
        
                        SET @family_planning_method_depo_provera = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Depo-provera" AND voided = 0 AND retired = 0 LIMIT 1);
                        
                        SET @family_planning_method_intrauterine_contraception = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Intrauterine contraception" AND voided = 0 AND retired = 0 LIMIT 1);
                        
                        SET @family_planning_method_contraceptive_implant = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Contraceptive implant" AND voided = 0 AND retired = 0 LIMIT 1);
                        
                        SET @family_planning_method_male_condoms = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Male condoms" AND voided = 0 AND retired = 0 LIMIT 1);
                        
                        SET @family_planning_method_female_condoms = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Female condoms" AND voided = 0 AND retired = 0 LIMIT 1);
                        
                        SET @family_planning_method__rythm_method = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Rhythm method" AND voided = 0 AND retired = 0 LIMIT 1);
                        
                        SET @family_planning_method_withdrawal = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Withdrawal method" AND voided = 0 AND retired = 0 LIMIT 1);
                        
                        SET @family_planning_method_abstinence = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Abstinence" AND voided = 0 AND retired = 0 LIMIT 1);
                        
                        SET @family_planning_method_tubal_ligation = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Tubal ligation" AND voided = 0 AND retired = 0 LIMIT 1);
                        
                        SET @family_planning_method_vasectomy = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Vasectomy" AND voided = 0 AND retired = 0 LIMIT 1);
                        
                        SET @family_planning_method_emergency__contraception = (SELECT concept_name.concept_id FROM concept_name 
                                LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                WHERE name = "Emergency contraception" AND voided = 0 AND retired = 0 LIMIT 1);
                
                        CASE var_value_coded
                        
                            WHEN @family_planning_method_emergency__contraception THEN
                            
                                UPDATE flat_table2 SET family_planning_method_emergency__contraception = NULL, 
                                    family_planning_method_emergency__contraception_enc_id = NULL 
                                WHERE flat_table2.family_planning_method_emergency__contraception_enc_id = OLD.encounter_id;
                        
                            WHEN @family_planning_method_vasectomy THEN
                            
                                UPDATE flat_table2 SET family_planning_method_vasectomy = NULL, 
                                    family_planning_method_vasectomy_enc_id = NULL 
                                WHERE flat_table2.family_planning_method_vasectomy_enc_id = OLD.encounter_id;
                        
                            WHEN @family_planning_method_tubal_ligation THEN
                            
                                UPDATE flat_table2 SET family_planning_method_tubal_ligation = NULL, 
                                    family_planning_method_tubal_ligation_enc_id = NULL 
                                WHERE flat_table2.family_planning_method_tubal_ligation_enc_id = OLD.encounter_id;
                        
                            WHEN @family_planning_method_abstinence THEN
                            
                                UPDATE flat_table2 SET family_planning_method_abstinence = NULL, 
                                    family_planning_method_abstinence_enc_id = NULL 
                                WHERE flat_table2.family_planning_method_abstinence_enc_id = OLD.encounter_id;
                        
                            WHEN @family_planning_method_withdrawal THEN
                            
                                UPDATE flat_table2 SET family_planning_method_withdrawal = NULL, 
                                    family_planning_method_withdrawal_enc_id = NULL 
                                WHERE flat_table2.family_planning_method_withdrawal_enc_id = OLD.encounter_id;
                        
                            WHEN @family_planning_method__rythm_method THEN
                            
                                UPDATE flat_table2 SET family_planning_method__rythm_method = NULL, 
                                    family_planning_method__rythm_method_enc_id = NULL 
                                WHERE flat_table2.family_planning_method__rythm_method_enc_id = OLD.encounter_id;
                        
                            WHEN @family_planning_method_female_condoms THEN
                            
                                UPDATE flat_table2 SET family_planning_method_female_condoms = NULL, 
                                    family_planning_method_female_condoms_enc_id = NULL 
                                WHERE flat_table2.family_planning_method_female_condoms_enc_id = OLD.encounter_id;
                        
                            WHEN @family_planning_method_male_condoms THEN
                            
                                UPDATE flat_table2 SET family_planning_method_male_condoms = NULL, 
                                    family_planning_method_male_condoms_enc_id = NULL 
                                WHERE flat_table2.family_planning_method_male_condoms_enc_id = OLD.encounter_id;
                        
                            WHEN @family_planning_method_contraceptive_implant THEN
                            
                                UPDATE flat_table2 SET family_planning_method_contraceptive_implant = NULL, 
                                    family_planning_method_contraceptive_implant_enc_id = NULL 
                                WHERE flat_table2.family_planning_method_contraceptive_implant_enc_id = OLD.encounter_id;
                        
                            WHEN @family_planning_method_intrauterine_contraception THEN
                            
                                UPDATE flat_table2 SET family_planning_method_intrauterine_contraception = NULL, 
                                    family_planning_method_intrauterine_contraception_enc_id = NULL 
                                WHERE flat_table2.family_planning_method_intrauterine_contraception_enc_id = OLD.encounter_id;
                        
                            WHEN @family_planning_method_depo_provera THEN
                            
                                UPDATE flat_table2 SET family_planning_method_depo_provera = NULL, 
                                    family_planning_method_depo_provera_enc_id = NULL 
                                WHERE flat_table2.family_planning_method_depo_provera_enc_id = OLD.encounter_id;
                        
                            WHEN @family_planning_method_oral_contraceptive_pills THEN
                            
                                UPDATE flat_table2 SET family_planning_method_oral_contraceptive_pills = NULL, 
                                    family_planning_method_oral_contraceptive_pills_enc_id = NULL 
                                WHERE flat_table2.family_planning_method_oral_contraceptive_pills_enc_id = OLD.encounter_id;
                        
                        END CASE;
                
                    ELSE
                    
                        CALL proc_update_other_field(var_person_id, var_concept_id, var_value_coded, OLD.encounter_id);
                
                END CASE;
        
            END IF;
            
        END LOOP;
    END;
    
END$$

DELIMITER ;

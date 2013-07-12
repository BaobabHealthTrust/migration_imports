DELIMITER $$
DROP TRIGGER IF EXISTS `flat_table2_after_update`$$
CREATE TRIGGER `flat_table2_after_update` AFTER UPDATE 
ON `flat_table2`
FOR EACH ROW
BEGIN

    
    # Get data into fields
    SELECT id, patient_id, gender, birthdate, earliest_start_date, 
        hiv_program_state, hiv_program_start_date, reason_for_starting, 
        ever_registered_at_art, date_art_last_taken, taken_art_in_last_two_months, 
        pregnant_yes,pregnant_no, death_date, drug_induced_abdominal_pain, drug_induced_anorexia, 
        drug_induced_diarrhea, drug_induced_jaundice, drug_induced_leg_pain_numbness, 
        drug_induced_vomiting, drug_induced_peripheral_neuropathy, drug_induced_hepatitis, 
        drug_induced_anemia, drug_induced_lactic_acidosis, drug_induced_lipodystrophy, 
        drug_induced_skin_rash, drug_induced_other_symptom, drug_induced_fever, 
        drug_induced_cough, tb_not_suspected, tb_suspected, confirmed_tb_not_on_treatment, 
        confirmed_tb_on_treatment, unknown_tb_status, extrapulmonary_tuberculosis, 
        pulmonary_tuberculosis, pulmonary_tuberculosis_last_2_years, kaposis_sarcoma, 
        what_was_the_patient_adherence_for_this_drug1, what_was_the_patient_adherence_for_this_drug2,
        what_was_the_patient_adherence_for_this_drug3, what_was_the_patient_adherence_for_this_drug4,
        what_was_the_patient_adherence_for_this_drug5, regimen_category, drug_name1, drug_name2, 
        drug_name3, drug_name4, drug_name5, drug_inventory_id1, drug_inventory_id2, 
        drug_inventory_id3, drug_inventory_id4, drug_inventory_id5, drug_auto_expire_date1, 
        drug_auto_expire_date2, drug_auto_expire_date3, drug_auto_expire_date4, 
        drug_auto_expire_date5, hiv_program_state_v_date, hiv_program_start_date_v_date, 
        current_tb_status_v_date, reason_for_starting_v_date, ever_registered_at_art_v_date, 
        date_art_last_taken_v_date, taken_art_in_last_two_months_v_date, pregnant_yes_v_date,pregnant_no_v_date,
        death_date_v_date, drug_induced_abdominal_pain_v_date, drug_induced_anorexia_v_date, 
        drug_induced_diarrhea_v_date, drug_induced_jaundice_v_date, drug_induced_leg_pain_numbness_v_date, 
        drug_induced_vomiting_v_date, drug_induced_peripheral_neuropathy_v_date, 
        drug_induced_hepatitis_v_date, drug_induced_anemia_v_date, drug_induced_lactic_acidosis_v_date, 
        drug_induced_lipodystrophy_v_date, drug_induced_skin_rash_v_date, drug_induced_other_symptom_v_date, 
        drug_induced_fever_v_date, drug_induced_cough_v_date, tb_not_suspected_v_date, 
        tb_suspected_v_date, confirmed_tb_not_on_treatment_v_date, confirmed_tb_on_treatment_v_date, 
        unknown_tb_status_v_date, extrapulmonary_tuberculosis_v_date, pulmonary_tuberculosis_v_date,
        pulmonary_tuberculosis_last_2_years_v_date, kaposis_sarcoma_v_date, 
        what_was_the_patient_adherence_for_this_drug1_v_date, 
        what_was_the_patient_adherence_for_this_drug2_v_date, 
        what_was_the_patient_adherence_for_this_drug3_v_date, 
        what_was_the_patient_adherence_for_this_drug4_v_date, 
        what_was_the_patient_adherence_for_this_drug5_v_date, regimen_category_v_date, 
        drug_name1_v_date, drug_name2_v_date, drug_name3_v_date, drug_name4_v_date, 
        drug_name5_v_date, drug_inventory_id1_v_date, drug_inventory_id2_v_date, 
        drug_inventory_id3_v_date, drug_inventory_id4_v_date, drug_inventory_id5_v_date, 
        drug_auto_expire_date1_v_date, drug_auto_expire_date2_v_date, drug_auto_expire_date3_v_date, 
        drug_auto_expire_date4_v_date, drug_auto_expire_date5_v_date 
        FROM flat_cohort_table WHERE patient_id = NEW.patient_id 
        AND QUARTER(NEW.visit_date) = QUARTER(DATE(earliest_start_date)) AND YEAR(NEW.visit_date) AND YEAR(DATE(earliest_start_date)) LIMIT 1
        INTO @id, @patient_id, @gender, @birthdate, @earliest_start_date, 
        @hiv_program_state, @hiv_program_start_date, 
        @reason_for_starting, @ever_registered_at_art, @date_art_last_taken, 
        @taken_art_in_last_two_months, @pregnant_yes ,@pregnant_no, @death_date, 
        @drug_induced_abdominal_pain, @drug_induced_anorexia, @drug_induced_diarrhea, 
        @drug_induced_jaundice, @drug_induced_leg_pain_numbness, @drug_induced_vomiting, 
        @drug_induced_peripheral_neuropathy, @drug_induced_hepatitis, @drug_induced_anemia, 
        @drug_induced_lactic_acidosis, @drug_induced_lipodystrophy, @drug_induced_skin_rash, 
        @drug_induced_other_symptom, @drug_induced_fever, @drug_induced_cough, 
        @tb_not_suspected, @tb_suspected, @confirmed_tb_not_on_treatment, 
        @confirmed_tb_on_treatment, @unknown_tb_status, @extrapulmonary_tuberculosis, 
        @pulmonary_tuberculosis, @pulmonary_tuberculosis_last_2_years, @kaposis_sarcoma,
        @what_was_the_patient_adherence_for_this_drug1, @what_was_the_patient_adherence_for_this_drug2,
        @what_was_the_patient_adherence_for_this_drug3, @what_was_the_patient_adherence_for_this_drug4,
        @what_was_the_patient_adherence_for_this_drug5, @regimen_category, @drug_name1, 
        @drug_name2, @drug_name3, @drug_name4, @drug_name5, @drug_inventory_id1, 
        @drug_inventory_id2, @drug_inventory_id3, @drug_inventory_id4, @drug_inventory_id5, 
        @drug_auto_expire_date1, @drug_auto_expire_date2, @drug_auto_expire_date3, 
        @drug_auto_expire_date4, @drug_auto_expire_date5, @hiv_program_state_v_date, 
        @hiv_program_start_date_v_date, @current_tb_status_v_date, @reason_for_starting_v_date,
        @ever_registered_at_art_v_date, @date_art_last_taken_v_date, @taken_art_in_last_two_months_v_date,
        @pregnant_yes_v_date, @pregnant_no_v_date, @death_date_v_date, @drug_induced_abdominal_pain_v_date, 
        @drug_induced_anorexia_v_date, @drug_induced_diarrhea_v_date, @drug_induced_jaundice_v_date,
        @drug_induced_leg_pain_numbness_v_date, @drug_induced_vomiting_v_date, 
        @drug_induced_peripheral_neuropathy_v_date, @drug_induced_hepatitis_v_date, 
        @drug_induced_anemia_v_date, @drug_induced_lactic_acidosis_v_date, 
        @drug_induced_lipodystrophy_v_date, @drug_induced_skin_rash_v_date, 
        @drug_induced_other_symptom_v_date, @drug_induced_fever_v_date, 
        @drug_induced_cough_v_date, @tb_not_suspected_v_date, @tb_suspected_v_date,
        @confirmed_tb_not_on_treatment_v_date, @confirmed_tb_on_treatment_v_date, 
        @unknown_tb_status_v_date, @extrapulmonary_tuberculosis_v_date, 
        @pulmonary_tuberculosis_v_date, @pulmonary_tuberculosis_last_2_years_v_date, 
        @kaposis_sarcoma_v_date, @what_was_the_patient_adherence_for_this_drug1_v_date,
        @what_was_the_patient_adherence_for_this_drug2_v_date, 
        @what_was_the_patient_adherence_for_this_drug3_v_date, 
        @what_was_the_patient_adherence_for_this_drug4_v_date, 
        @what_was_the_patient_adherence_for_this_drug5_v_date, @regimen_category_v_date, 
        @drug_name1_v_date, @drug_name2_v_date, @drug_name3_v_date, @drug_name4_v_date, 
        @drug_name5_v_date, @drug_inventory_id1_v_date, @drug_inventory_id2_v_date, 
        @drug_inventory_id3_v_date, @drug_inventory_id4_v_date, @drug_inventory_id5_v_date, 
        @drug_auto_expire_date1_v_date, @drug_auto_expire_date2_v_date, 
        @drug_auto_expire_date3_v_date, @drug_auto_expire_date4_v_date, @drug_auto_expire_date5_v_date;

    IF COALESCE(@id, "") != "" THEN
    
		  	IF (NEW.current_hiv_program_state IS NOT NULL) THEN

		      IF DATE(@hiv_program_state_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@hiv_program_state_v_date)  THEN
		      
		          UPDATE flat_cohort_table SET hiv_program_state = NEW.current_hiv_program_state,
		              hiv_program_start_date = NEW.current_hiv_program_start_date, 
		              hiv_program_state_v_date = NEW.visit_date WHERE id = @id;
		      
		      END IF;
		      
		      IF NEW.current_hiv_program_state = "died" OR NEW.current_hiv_program_state = "Patient died" THEN
		      
		          UPDATE flat_cohort_table SET death_date = NEW.current_hiv_program_start_date, 
		              death_date_v_date = NEW.visit_date WHERE id = @id;
		      
		      END IF;
		  
		  	END IF;
    
        IF DATE(@pregnant_yes_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@pregnant_yes_v_date) THEN
        
            UPDATE flat_cohort_table SET pregnant_yes = NEW.pregnant_yes,
                pregnant_yes_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;  
    
    
        IF DATE(@pregnant_no_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@pregnant_no_v_date) THEN
        
            UPDATE flat_cohort_table SET pregnant_no = NEW.pregnant_no,
                pregnant_no_v_date = NEW.visit_date WHERE id = @id;
        
        END IF; 
    
        IF DATE(@drug_induced_abdominal_pain_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_abdominal_pain_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_abdominal_pain = NEW.drug_induced_abdominal_pain,
                drug_induced_abdominal_pain_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_induced_anorexia_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_anorexia_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_anorexia = NEW.drug_induced_anorexia,
                drug_induced_anorexia_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_induced_diarrhea_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_diarrhea_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_diarrhea = NEW.drug_induced_diarrhea,
                drug_induced_diarrhea_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_induced_jaundice_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_jaundice_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_jaundice = NEW.drug_induced_jaundice,
                drug_induced_jaundice_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_induced_leg_pain_numbness_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_leg_pain_numbness_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_leg_pain_numbness = NEW.drug_induced_leg_pain_numbness,
                drug_induced_leg_pain_numbness_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_induced_vomiting_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_vomiting_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_vomiting = NEW.drug_induced_vomiting,
                drug_induced_vomiting_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_induced_peripheral_neuropathy_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_peripheral_neuropathy_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_peripheral_neuropathy = NEW.drug_induced_peripheral_neuropathy,
                drug_induced_peripheral_neuropathy_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_induced_hepatitis_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_hepatitis_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_hepatitis = NEW.drug_induced_hepatitis,
                drug_induced_hepatitis_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_induced_anemia_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_anemia_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_anemia = NEW.drug_induced_anemia,
                drug_induced_anemia_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_induced_lactic_acidosis_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_lactic_acidosis_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_lactic_acidosis = NEW.drug_induced_lactic_acidosis,
                drug_induced_lactic_acidosis_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_induced_lipodystrophy_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_lipodystrophy_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_lipodystrophy = NEW.drug_induced_lipodystrophy,
                drug_induced_lipodystrophy_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_induced_skin_rash_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_skin_rash_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_skin_rash = NEW.drug_induced_skin_rash,
                drug_induced_skin_rash_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_induced_other_symptom_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_other_symptom_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_other_symptom = NEW.drug_induced_other_symptom,
                drug_induced_other_symptom_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_induced_fever_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_fever_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_fever = NEW.drug_induced_fever,
                drug_induced_fever_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_induced_cough_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_induced_cough_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_induced_cough = NEW.drug_induced_cough,
                drug_induced_cough_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@tb_not_suspected_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@tb_not_suspected_v_date) THEN
        
            UPDATE flat_cohort_table SET tb_not_suspected = NEW.tb_status_tb_not_suspected,
                tb_not_suspected_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@tb_suspected_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@tb_suspected_v_date) THEN
        
            UPDATE flat_cohort_table SET tb_suspected = NEW.tb_status_tb_suspected,
                tb_suspected_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@confirmed_tb_not_on_treatment_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@confirmed_tb_not_on_treatment_v_date) THEN
        
            UPDATE flat_cohort_table SET confirmed_tb_not_on_treatment = NEW.tb_status_confirmed_tb_not_on_treatment,
                confirmed_tb_not_on_treatment_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@confirmed_tb_on_treatment_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@confirmed_tb_on_treatment_v_date) THEN
        
            UPDATE flat_cohort_table SET confirmed_tb_on_treatment = NEW.tb_status_confirmed_tb_on_treatment,
                confirmed_tb_on_treatment_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@unknown_tb_status_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@unknown_tb_status_v_date) THEN
        
            UPDATE flat_cohort_table SET unknown_tb_status = NEW.tb_status_unknown,
                unknown_tb_status_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@what_was_the_patient_adherence_for_this_drug1_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@what_was_the_patient_adherence_for_this_drug1_v_date) THEN
        
            UPDATE flat_cohort_table SET what_was_the_patient_adherence_for_this_drug1 = 
                NEW.what_was_the_patient_adherence_for_this_drug1,
                what_was_the_patient_adherence_for_this_drug1_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@what_was_the_patient_adherence_for_this_drug2_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@what_was_the_patient_adherence_for_this_drug2_v_date) THEN
        
            UPDATE flat_cohort_table SET what_was_the_patient_adherence_for_this_drug2 = 
                NEW.what_was_the_patient_adherence_for_this_drug2,
                what_was_the_patient_adherence_for_this_drug2_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@what_was_the_patient_adherence_for_this_drug3_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@what_was_the_patient_adherence_for_this_drug3_v_date) THEN
        
            UPDATE flat_cohort_table SET what_was_the_patient_adherence_for_this_drug3 = 
                NEW.what_was_the_patient_adherence_for_this_drug3,
                what_was_the_patient_adherence_for_this_drug3_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@what_was_the_patient_adherence_for_this_drug4_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@what_was_the_patient_adherence_for_this_drug4_v_date) THEN
        
            UPDATE flat_cohort_table SET what_was_the_patient_adherence_for_this_drug4 = 
                NEW.what_was_the_patient_adherence_for_this_drug4,
                what_was_the_patient_adherence_for_this_drug4_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@what_was_the_patient_adherence_for_this_drug5_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@what_was_the_patient_adherence_for_this_drug5_v_date) THEN
        
            UPDATE flat_cohort_table SET what_was_the_patient_adherence_for_this_drug5 = 
                NEW.what_was_the_patient_adherence_for_this_drug5,
                what_was_the_patient_adherence_for_this_drug5_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@regimen_category_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@regimen_category_v_date) THEN
        
            UPDATE flat_cohort_table SET regimen_category = 
                NEW.regimen_category,
                regimen_category_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_name1_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_name1_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_name1 = 
                NEW.drug_name1,
                drug_name1_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_name2_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_name2_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_name2 = 
                NEW.drug_name2,
                drug_name2_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_name3_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_name3_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_name3 = 
                NEW.drug_name3,
                drug_name3_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_name4_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_name4_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_name4 = 
                NEW.drug_name4,
                drug_name4_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_name5_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_name5_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_name5 = 
                NEW.drug_name5,
                drug_name5_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_inventory_id1_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_inventory_id1_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_inventory_id1 = 
                NEW.drug_inventory_id1,
                drug_inventory_id1_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_inventory_id2_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_inventory_id2_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_inventory_id2 = 
                NEW.drug_inventory_id2,
                drug_inventory_id2_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_inventory_id3_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_inventory_id3_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_inventory_id3 = 
                NEW.drug_inventory_id3,
                drug_inventory_id3_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_inventory_id4_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_inventory_id4_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_inventory_id4 = 
                NEW.drug_inventory_id4,
                drug_inventory_id4_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_inventory_id5_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_inventory_id5_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_inventory_id5 = 
                NEW.drug_inventory_id5,
                drug_inventory_id5_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_auto_expire_date1_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_auto_expire_date1_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_auto_expire_date1 = 
                NEW.drug_auto_expire_date1,
                drug_auto_expire_date1_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_auto_expire_date2_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_auto_expire_date2_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_auto_expire_date2 = 
                NEW.drug_auto_expire_date2,
                drug_auto_expire_date2_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_auto_expire_date3_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_auto_expire_date3_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_auto_expire_date3 = 
                NEW.drug_auto_expire_date3,
                drug_auto_expire_date3_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_auto_expire_date4_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_auto_expire_date4_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_auto_expire_date4 = 
                NEW.drug_auto_expire_date4,
                drug_auto_expire_date4_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
        IF DATE(@drug_auto_expire_date5_v_date) IS NULL OR DATE(NEW.visit_date) >= DATE(@drug_auto_expire_date5_v_date) THEN
        
            UPDATE flat_cohort_table SET drug_auto_expire_date5 = 
                NEW.drug_auto_expire_date5,
                drug_auto_expire_date5_v_date = NEW.visit_date WHERE id = @id;
        
        END IF;
    
    END IF;
    
END$$

DELIMITER ;

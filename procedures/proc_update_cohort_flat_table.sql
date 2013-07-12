DELIMITER $$

DROP PROCEDURE IF EXISTS `proc_update_cohort_flat_table`$$
	
CREATE PROCEDURE `proc_update_cohort_flat_table`(
				IN in_patient_id INT, 
				IN in_reason_for_eligibility VARCHAR(255), 
				IN in_ever_registered_at_art_clinic VARCHAR(255), 
				IN in_date_art_last_taken DATE, 
				IN in_taken_art_in_last_two_months VARCHAR(45), 
				IN in_extrapulmonary_tuberculosis VARCHAR(45), 
				IN in_pulmonary_tuberculosis VARCHAR(45), 
				IN in_pulmonary_tuberculosis_last_2_years VARCHAR(45), 
				IN in_kaposis_sarcoma VARCHAR(45),
				IN in_extrapulmonary_tuberculosis_v_date DATE,
				IN in_pulmonary_tuberculosis_v_date DATE, 
				IN in_pulmonary_tuberculosis_last_2_years_v_date DATE, 
				IN in_kaposis_sarcoma_v_date DATE, 
				IN in_reason_for_starting_v_date DATE, 
				IN in_ever_registered_at_art_v_date DATE, 
				IN in_date_art_last_taken_v_date DATE, 
				IN in_taken_art_in_last_two_months_v_date DATE
			)
	
	BEGIN
	
		SELECT extrapulmonary_tuberculosis_v_date, pulmonary_tuberculosis_v_date, pulmonary_tuberculosis_last_2_years_v_date, 
				 kaposis_sarcoma_v_date, reason_for_starting_v_date, ever_registered_at_art_v_date, date_art_last_taken_v_date,
				 taken_art_in_last_two_months_v_date FROM flat_table1 WHERE patient_id = in_patient_id INTO 		@var_extrapulmonary_tuberculosis_v_date, @var_pulmonary_tuberculosis_v_date,  				 @var_pulmonary_tuberculosis_last_2_years_v_date, @var_kaposis_sarcoma_v_date, @var_reason_for_starting_v_date, 				 @var_ever_registered_at_art_v_date, @var_date_art_last_taken_v_date, @var_taken_art_in_last_two_months_v_date;

		IF DATE(in_extrapulmonary_tuberculosis_v_date) > DATE(@var_extrapulmonary_tuberculosis_v_date)  THEN 
		
			UPDATE flat_cohort_table SET extrapulmonary_tuberculosis = in_extrapulmonary_tuberculosis , extrapulmonary_tuberculosis_v_date = in_extrapulmonary_tuberculosis_v_date WHERE patient_id = in_patient_id;
		
		END IF;
		
		IF DATE(in_pulmonary_tuberculosis_v_date) > DATE(@var_pulmonary_tuberculosis_v_date) THEN  
		
			UPDATE flat_cohort_table SET pulmonary_tuberculosis = in_pulmonary_tuberculosis , pulmonary_tuberculosis_v_date = in_pulmonary_tuberculosis_v_date WHERE patient_id = in_patient_id;
		
		END IF;
		
		IF DATE(in_pulmonary_tuberculosis_last_2_years_v_date) > DATE(@var_pulmonary_tuberculosis_last_2_years_v_date) THEN

			UPDATE flat_cohort_table SET pulmonary_tuberculosis_last_2_years = in_pulmonary_tuberculosis_last_2_years , pulmonary_tuberculosis_last_2_years_v_date = in_pulmonary_tuberculosis_last_2_years WHERE patient_id = in_patient_id;
		
		END IF;
		
		IF DATE(in_kaposis_sarcoma_v_date) > DATE(@var_kaposis_sarcoma_v_date) THEN 

			UPDATE flat_cohort_table SET kaposis_sarcoma = in_kaposis_sarcoma , kaposis_sarcoma_v_date = in_kaposis_sarcoma_v_date WHERE patient_id = in_patient_id;
		
		END IF;
		
		IF DATE(in_reason_for_starting_v_date) > DATE(@var_reason_for_starting_v_date) THEN 

			UPDATE flat_cohort_table SET reason_for_starting = in_reason_for_eligibility , reason_for_starting_v_date = in_reason_for_starting_v_date WHERE patient_id = in_patient_id;
		
		END IF;
		
		IF DATE(in_ever_registered_at_art_v_date) > DATE(@var_ever_registered_at_art_v_date) THEN 

			UPDATE flat_cohort_table SET ever_registered_at_art = in_ever_registered_at_art_clinic , ever_registered_at_art_v_date = in_ever_registered_at_art_v_date WHERE patient_id = in_patient_id;
		
		END IF;
		
		IF DATE(in_date_art_last_taken_v_date) > DATE(@var_date_art_last_taken_v_date) THEN 

			UPDATE flat_cohort_table SET date_art_last_taken = in_date_art_last_taken_v_date , date_art_last_taken_v_date = in_date_art_last_taken_v_date WHERE patient_id = in_patient_id;
		
		END IF;
		
		IF DATE(in_taken_art_in_last_two_months_v_date) > DATE(@var_taken_art_in_last_two_months_v_date) THEN

			UPDATE flat_cohort_table SET taken_art_in_last_two_months = in_taken_art_in_last_two_months , taken_art_in_last_two_months_v_date = in_taken_art_in_last_two_months_v_date WHERE patient_id = in_patient_id;
	
		END IF;
	
	END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `proc_insert_routine_tb_screening`$$

CREATE PROCEDURE `proc_insert_routine_tb_screening`(
    IN in_patient_id INT, 
    IN in_visit_date DATE, 
    IN in_field_concept INT, 
    IN in_field_value_coded INT,
    IN in_field_value_coded_name_id INT,
    IN in_field_other VARCHAR(25),
    IN in_visit_id INT,
    IN encounter_id INT
)
BEGIN

    SET @routine_tb_screening_fever = (SELECT concept_name.concept_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "Fever" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @routine_tb_screening_night_sweats = (SELECT concept_name.concept_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "Night sweats" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @routine_tb_screening_cough_of_any_duration = (SELECT concept_name.concept_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "Cough of any duration" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @routine_tb_screening_weight_loss_failure = (SELECT concept_name.concept_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "Weight loss / Failure to thrive / malnutrition" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    CASE in_field_value_coded
    
        WHEN @routine_tb_screening_fever THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, routine_tb_screening_fever, routine_tb_screening_fever_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET routine_tb_screening_fever = @value, routine_tb_screening_fever_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @routine_tb_screening_night_sweats THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, routine_tb_screening_night_sweats, routine_tb_screening_night_sweats_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET routine_tb_screening_night_sweats = @value, routine_tb_screening_night_sweats_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @routine_tb_screening_cough_of_any_duration THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, routine_tb_screening_cough_of_any_duration, routine_tb_screening_cough_of_any_duration_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET routine_tb_screening_cough_of_any_duration = @value, routine_tb_screening_cough_of_any_duration_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @routine_tb_screening_weight_loss_failure THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, routine_tb_screening_weight_loss_failure, routine_tb_screening_weight_loss_failure_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET routine_tb_screening_weight_loss_failure = @value, routine_tb_screening_weight_loss_failure_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
            
        ELSE
        
            SET @enc_id = encounter_id;                  
    
    END CASE;    
    
END$$

DELIMITER ;

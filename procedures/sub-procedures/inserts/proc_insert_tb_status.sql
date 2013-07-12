DELIMITER $$

DROP PROCEDURE IF EXISTS `proc_insert_tb_status`$$

CREATE PROCEDURE `proc_insert_tb_status`(
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

    SET @tb_status_tb_not_suspected = (SELECT concept_name.concept_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "TB NOT suspected" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @tb_status_tb_suspected = (SELECT concept_name.concept_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "TB suspected" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @tb_status_confirmed_tb_not_on_treatment = (SELECT concept_name.concept_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "Confirmed TB NOT on treatment" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @tb_status_confirmed_tb_on_treatment = (SELECT concept_name.concept_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "Confirmed TB on treatment" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @tb_status_unknown = (SELECT concept_name.concept_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "Unknown" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    CASE in_field_value_coded
    
        WHEN @tb_status_tb_not_suspected THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, tb_status_tb_not_suspected, tb_status_tb_not_suspected_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET tb_status_tb_not_suspected = @value, tb_status_tb_not_suspected_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @tb_status_tb_suspected THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, tb_status_tb_suspected, tb_status_tb_suspected_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET tb_status_tb_suspected = @value, tb_status_tb_suspected_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @tb_status_confirmed_tb_not_on_treatment THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, tb_status_confirmed_tb_not_on_treatment, tb_status_confirmed_tb_not_on_treatment_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET tb_status_confirmed_tb_not_on_treatment = @value, tb_status_confirmed_tb_not_on_treatment_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @tb_status_confirmed_tb_on_treatment THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, tb_status_confirmed_tb_on_treatment, tb_status_confirmed_tb_on_treatment_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET tb_status_confirmed_tb_on_treatment = @value, tb_status_confirmed_tb_on_treatment_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @tb_status_unknown THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, tb_status_unknown, tb_status_unknown_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET tb_status_unknown = @value, tb_status_unknown_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
            
        ELSE
        
            SET @enc_id = encounter_id;                  
    
    END CASE;    
    
END$$

DELIMITER ;

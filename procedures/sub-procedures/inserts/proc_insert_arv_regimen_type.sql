DELIMITER $$

DROP PROCEDURE IF EXISTS `proc_insert_arv_regimen_type`$$

CREATE PROCEDURE `proc_insert_arv_regimen_type`(
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

    SET @arv_regimen_type_unknown = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "UNKNOWN ANTIRETROVIRAL DRUG" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @arv_regimen_type_d4T_3TC_NVP = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "d4T/3TC/NVP" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @arv_regimen_type_triomune = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "triomune" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @arv_regimen_type_triomune_30 = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "triomune-30" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @arv_regimen_type_triomune_40 = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "triomune-40" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @arv_regimen_type_AZT_3TC_NVP = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "AZT/3TC/NVP" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @arv_regimen_type_AZT_3TC_LPV_r = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "AZT/3TC+LPV/r" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @arv_regimen_type_AZT_3TC_EFV = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "AZT/3TC+EFV" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @arv_regimen_type_d4T_3TC_EFV = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "d4T/3TC/EFV" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @arv_regimen_type_TDF_3TC_NVP = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "TDF/3TC+NVP" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @arv_regimen_type_TDF_3TC_EFV = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "TDF/3TC/EFV" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @arv_regimen_type_ABC_3TC_LPV_r = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "ABC/3TC+LPV/r" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @arv_regimen_type_TDF_3TC_LPV_r = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "TDF/3TC+LPV/r" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @arv_regimen_type_d4T_3TC_d4T_3TC_NVP = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "d4T/3TC + d4T/3TC/NVP (Starter pack)" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    SET @arv_regimen_type_AZT_3TC_AZT_3TC_NVP = (SELECT concept_name.concept_name_id FROM concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id WHERE name = "AZT/3TC + AZT/3TC/NVP (Starter pack)" AND voided = 0 AND retired = 0 ORDER BY concept_name.concept_id DESC LIMIT 1);
    
    CASE in_field_value_coded_name_id
    
        WHEN @arv_regimen_type_AZT_3TC_AZT_3TC_NVP THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_AZT_3TC_AZT_3TC_NVP, arv_regimen_type_AZT_3TC_AZT_3TC_NVP_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_AZT_3TC_AZT_3TC_NVP = @value, arv_regimen_type_AZT_3TC_AZT_3TC_NVP_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @arv_regimen_type_d4T_3TC_d4T_3TC_NVP THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_d4T_3TC_d4T_3TC_NVP, arv_regimen_type_d4T_3TC_d4T_3TC_NVP_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_d4T_3TC_d4T_3TC_NVP = @value, arv_regimen_type_d4T_3TC_d4T_3TC_NVP_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @arv_regimen_type_TDF_3TC_LPV_r THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_TDF_3TC_LPV_r, arv_regimen_type_TDF_3TC_LPV_r_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_TDF_3TC_LPV_r = @value, arv_regimen_type_TDF_3TC_LPV_r_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @arv_regimen_type_ABC_3TC_LPV_r THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_ABC_3TC_LPV_r, arv_regimen_type_ABC_3TC_LPV_r_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_ABC_3TC_LPV_r = @value, arv_regimen_type_ABC_3TC_LPV_r_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @arv_regimen_type_TDF_3TC_EFV THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_TDF_3TC_EFV, arv_regimen_type_TDF_3TC_EFV_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_TDF_3TC_EFV = @value, arv_regimen_type_TDF_3TC_EFV_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @arv_regimen_type_TDF_3TC_NVP THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_TDF_3TC_NVP, arv_regimen_type_TDF_3TC_NVP_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_TDF_3TC_NVP = @value, arv_regimen_type_TDF_3TC_NVP_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @arv_regimen_type_d4T_3TC_EFV THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_d4T_3TC_EFV, arv_regimen_type_d4T_3TC_EFV_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_d4T_3TC_EFV = @value, arv_regimen_type_d4T_3TC_EFV_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @arv_regimen_type_AZT_3TC_EFV THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_AZT_3TC_EFV, arv_regimen_type_AZT_3TC_EFV_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_AZT_3TC_EFV = @value, arv_regimen_type_AZT_3TC_EFV_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @arv_regimen_type_AZT_3TC_LPV_r THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_AZT_3TC_LPV_r, arv_regimen_type_AZT_3TC_LPV_r_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_AZT_3TC_LPV_r = @value, arv_regimen_type_AZT_3TC_LPV_r_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @arv_regimen_type_AZT_3TC_NVP THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_AZT_3TC_NVP, arv_regimen_type_AZT_3TC_NVP_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_AZT_3TC_NVP = @value, arv_regimen_type_AZT_3TC_NVP_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @arv_regimen_type_triomune_40 THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_triomune_40, arv_regimen_type_triomune_40_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_triomune_40 = @value, arv_regimen_type_triomune_40_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @arv_regimen_type_triomune_30 THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_triomune_30, arv_regimen_type_triomune_30_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_triomune_30 = @value, arv_regimen_type_triomune_30_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @arv_regimen_type_triomune THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_triomune, arv_regimen_type_triomune_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_triomune = @value, arv_regimen_type_triomune_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @arv_regimen_type_d4T_3TC_NVP THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_d4T_3TC_NVP, arv_regimen_type_d4T_3TC_NVP_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_d4T_3TC_NVP = @value, arv_regimen_type_d4T_3TC_NVP_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        WHEN @arv_regimen_type_unknown THEN
        
            SET @value = (SELECT name FROM concept_name WHERE concept_name_id = in_field_value_coded_name_id);
            
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, arv_regimen_type_unknown, arv_regimen_type_unknown_enc_id) VALUES (in_patient_id, in_visit_date, @value, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET arv_regimen_type_unknown = @value, arv_regimen_type_unknown_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;
    
        ELSE
        
            SET @enc_id = encounter_id;                  
    
    END CASE;
    
END$$

DELIMITER ;

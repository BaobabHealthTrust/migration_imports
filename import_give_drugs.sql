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
DROP PROCEDURE IF EXISTS `proc_import_give_drugs`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_give_drugs`(
    IN in_patient_id INT(11)
)
BEGIN
    
    # Declare condition for exiting loop
    DECLARE done INT DEFAULT FALSE;

    DECLARE  id int(11);
    DECLARE  visit_encounter_id int(11);
    DECLARE  patient_id int(11);
    DECLARE  pres_drug_name1 varchar(255);
    DECLARE  pres_dosage1 varchar(255);
    DECLARE  pres_frequency1 varchar(255);
    DECLARE  pres_drug_name2 varchar(255);
    DECLARE  pres_dosage2 varchar(255);
    DECLARE  pres_frequency2 varchar(255);
    DECLARE  pres_drug_name3 varchar(255);
    DECLARE  pres_dosage3 varchar(255);
    DECLARE  pres_frequency3 varchar(255);
    DECLARE  pres_drug_name4 varchar(255);
    DECLARE  pres_dosage4 varchar(255);
    DECLARE  pres_frequency4 varchar(255);
    DECLARE  pres_drug_name5 varchar(255);
    DECLARE  pres_dosage5 varchar(255);
    DECLARE  pres_frequency5 varchar(255);
    DECLARE  prescription_duration varchar(255);
    DECLARE  dispensed_drug_name1 varchar(255);
    DECLARE  dispensed_quantity1 int(11);
    DECLARE  dispensed_drug_name2 varchar(255);
    DECLARE  dispensed_quantity2 int(11);
    DECLARE  dispensed_drug_name3 varchar(255);
    DECLARE  dispensed_quantity3 int(11);
    DECLARE  dispensed_drug_name4 varchar(255);
    DECLARE  dispensed_quantity4 int(11);
    DECLARE  dispensed_drug_name5 varchar(255);
    DECLARE  dispensed_quantity5 int(11);
    DECLARE  location varchar(255);
    DECLARE  weight float;
    DECLARE  voided tinyint(1);
    DECLARE  void_reason varchar(255);
    DECLARE  date_voided date;
    DECLARE  voided_by int(11);
    DECLARE  date_created datetime;
    DECLARE  creator int(11);
    DECLARE  visit_id INT(11);
    DECLARE  visit_date DATE;
    DECLARE  visit_patient_id INT(11);
    
    # Declare and initialise cursor for looping through the table
    DECLARE cur CURSOR FOR SELECT DISTINCT `bart1_intermediate_bare_bones`.`give_drugs_encounters`.id, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.visit_encounter_id, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.patient_id, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_drug_name1, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_dosage1, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_frequency1, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_drug_name2, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_dosage2, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_frequency2, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_drug_name3, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_dosage3, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_frequency3, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_drug_name4, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_dosage4, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_frequency4, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_drug_name5, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_dosage5, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.pres_frequency5,                                                    `bart1_intermediate_bare_bones`.`give_drugs_encounters`.prescription_duration,                                                                     `bart1_intermediate_bare_bones`.`give_drugs_encounters`.dispensed_drug_name1, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.dispensed_quantity1, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.dispensed_drug_name2, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.dispensed_quantity2, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.dispensed_drug_name3, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.dispensed_quantity3, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.dispensed_drug_name4, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.dispensed_quantity4, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.dispensed_drug_name5, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.dispensed_quantity5, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.location,      `bart1_intermediate_bare_bones`.`vitals_encounters`.weight,       `bart1_intermediate_bare_bones`.`give_drugs_encounters`.voided, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.void_reason, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.date_voided, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.voided_by, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.date_created, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.creator,   COALESCE(`bart1_intermediate_bare_bones`.`visit_encounters`.visit_date, `bart1_intermediate_bare_bones`.`give_drugs_encounters`.date_created) FROM 
`bart1_intermediate_bare_bones`.`give_drugs_encounters` 
        LEFT OUTER JOIN bart1_intermediate_bare_bones.visit_encounters ON 
        visit_encounter_id = bart1_intermediate_bare_bones.visit_encounters.id
        LEFT OUTER JOIN bart1_intermediate_bare_bones.vitals_encounters
          ON bart1_intermediate_bare_bones.give_drugs_encounters.visit_encounter_id = bart1_intermediate_bare_bones.vitals_encounters.visit_encounter_id
        WHERE `bart1_intermediate_bare_bones`.`give_drugs_encounters`.`patient_id` = in_patient_id;

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
            id,
            visit_encounter_id,
            patient_id,
            pres_drug_name1,
            pres_dosage1,
            pres_frequency1,
            pres_drug_name2,
            pres_dosage2,
            pres_frequency2,
            pres_drug_name3,
            pres_dosage3,
            pres_frequency3,
            pres_drug_name4,
            pres_dosage4,
            pres_frequency4,
            pres_drug_name5,
            pres_dosage5,
            pres_frequency5,
            prescription_duration,
            dispensed_drug_name1,
            dispensed_quantity1,
            dispensed_drug_name2,
            dispensed_quantity2,
            dispensed_drug_name3,
            dispensed_quantity3,
            dispensed_drug_name4,
            dispensed_quantity4,
            dispensed_drug_name5,
            dispensed_quantity5,
            location,
            weight,
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
        SET @encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = "TREATMENT");

        # Create encounter
        SET @encounter_uuid = (SELECT UUID());
        
        INSERT INTO encounter (encounter_type, patient_id, provider_id, encounter_datetime, creator, date_created, uuid)
        VALUES (@encounter_type, patient_id, @creator, visit_date, @creator, date_created, @encounter_uuid);
       
        SET @encounter_id = (SELECT encounter_id FROM encounter WHERE uuid = @encounter_uuid);

        # Check if the field is not empty========================================================================================
        IF NOT ISNULL(pres_drug_name1) THEN
            SET @pres_drug_name1_bart2_name = (SELECT bart2_two_name FROM drug_map WHERE bart_one_name = pres_drug_name1 LIMIT 1);
            SET @pres_drug_name1_new_drug_id = (SELECT new_drug_id FROM drug_map WHERE bart2_two_name = @pres_drug_name1_bart2_name);
            SET @pres_drug_name1_concept_id = (SELECT concept_id  FROM drug WHERE drug_id = @pres_drug_name1_new_drug_id AND name = @pres_drug_name1_bart2_name);     
            
            IF (@pres_drug_name1_bart2_name = "Cotrimoxazole (480mg tablet)") THEN
              # Get concept_id
              SET @cpt_started_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "CPT started" AND voided = 0 AND retired = 0 LIMIT 1);
          
              # Get value_coded id
              SET @yes_concept_id = (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = "Yes" AND voided = 0 AND retired = 0 LIMIT 1);
          
              # Get value_coded_name_id
              SET @yes_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Yes" AND voided = 0 AND retired = 0 LIMIT 1);
            
              # Create observation
              
              SET @cpt_started_uuid = (SELECT UUID());

              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
              VALUES (patient_id, @cpt_started_concept_id, @encounter_id, visit_date, @yes_concept_id, @yes_concept_name_id, @creator, date_created, @cpt_started_uuid);

              SET @pres_drug1_obs_id = (SELECT obs_id FROM obs WHERE uuid = @cpt_started_uuid);
            ELSE
              IF NOT ISNULL(weight)THEN
                SET @regimen_category = ( SELECT regimen_index FROM regimen
                                          WHERE min_weight <= weight
                                          AND max_weight >= weight
                                          AND concept_id = @pres_drug_name1_concept_id);

              END IF;

              SET @regimen_category_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Regimen category" AND voided = 0 AND retired = 0 LIMIT 1);

              # create regimen category observation
              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
              VALUES (patient_id, @regimen_category_concept_id, @encounter_id, visit_date, @regimen_category,@creator, date_created,(SELECT UUID()));
              
              SET @what_type_of_antiretroviral_regime_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "What type of antiretroviral regimen" AND voided = 0 AND retired = 0 LIMIT 1);
              
              # Create observation
              SET @arv_regimen_type_uuid = (SELECT UUID());

              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, creator, date_created, uuid)
              VALUES (patient_id, @what_type_of_antiretroviral_regime_concept_id, @encounter_id,  visit_date, @pres_drug_name1_concept_id, @creator, date_created, @arv_regimen_type_uuid);
              
              SET @pres_drug1_obs_id = (SELECT obs_id FROM obs WHERE uuid = @arv_regimen_type_uuid);

            END IF;

            # create order
            SET @pres_drug_name1_uuid = (SELECT UUID());
           
            IF NOT ISNULL(prescription_duration) THEN
                  SET @auto_expire_date = (SELECT 
                       CASE WHEN TRIM(REPLACE(SUBSTRING(prescription_duration,INSTR(prescription_duration, ' ')),'s','')) = 'Month' THEN 
                        ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 30) + 2)) 
                        ELSE 
                          ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 7) + 2)) 
                        END AS prescription_duration_in_days);
            END IF;
            
            INSERT INTO orders (order_type_id, concept_id, orderer, encounter_id, patient_id, start_date, auto_expire_date, obs_id, creator, date_created, uuid)
              VALUES (1, @pres_drug_name1_concept_id, 1, @encounter_id, patient_id, visit_date, @auto_expire_date, @pres_drug1_obs_id, @creator,  date_created, @pres_drug_name1_uuid);

            SET @pres_drug1_order_id = (SELECT order_id FROM orders WHERE uuid = @pres_drug_name1_uuid);

            IF NOT ISNULL(dispensed_drug_name1) THEN
              
              # Get id of dispense encounter type
              SET @dispensing_encounter_type_id = (SELECT encounter_type_id FROM encounter_type WHERE name = "DISPENSING");

              # Create encounter
              SET @dispensing_encounter_uuid = (SELECT UUID());
              
              INSERT INTO encounter (encounter_type, patient_id, provider_id, encounter_datetime, creator, date_created, uuid)
              VALUES (@dispensing_encounter_type_id, patient_id, @creator, visit_date, @creator, date_created, @dispensing_encounter_uuid);
       
              SET @dispensing_encounter_id = (SELECT encounter_id FROM encounter WHERE uuid = @dispensing_encounter_uuid);
              
              
              #get the bart2_drug_names from drug_map table

              SET @dispensed_drug_name1_bart2_name = (SELECT bart2_two_name FROM drug_map WHERE bart_one_name = dispensed_drug_name1 LIMIT 1);

              SET @dispensed_drug_name1_concept_id = (SELECT new_drug_id  FROM drug_map WHERE bart2_two_name = @dispensed_drug_name1_bart2_name LIMIT 1);

              SET @amount_dispensed_concept_id = (SELECT concept_name.concept_id FROM concept_name
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Amount dispensed" AND voided = 0 AND retired = 0 LIMIT 1);
                            
              SET @arv_regimens_received_abstracted_construct_concept_id = (SELECT concept_name.concept_id FROM concept_name
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "ARV regimens received abstracted construct" AND voided = 0 AND retired = 0 LIMIT 1);
              
              # check if prescibed_drug equal dispensed
              IF (@dispensed_drug_name1_bart2_name = @pres_drug_name1_bart2_name) THEN

                #create drug_order with quantity
                  INSERT INTO drug_order (order_id, drug_inventory_id, dose, equivalent_daily_dose, frequency, quantity)
                  VALUES (@pres_drug1_order_id, @dispensed_drug_name1_concept_id, pres_dosage1, pres_dosage1, pres_frequency1, dispensed_quantity1);
                            
               # create amount_dispensed observation
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_drug, value_numeric, creator, date_created, uuid)
                VALUES (patient_id, @amount_dispensed_concept_id, @dispensing_encounter_id, @pres_drug1_order_id, visit_date, @dispensed_drug_name1_concept_id, dispensed_quantity1, @creator, date_created, (SELECT UUID()));
               
               # create arv_regimens_received_abstracted_construct observation         
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_coded, creator, date_created, uuid)
                VALUES (patient_id, @arv_regimens_received_abstracted_construct_concept_id, @dispensing_encounter_id,@pres_drug1_order_id, visit_date, @dispensed_drug_name1_concept_id, @creator, date_created, (SELECT UUID()));
              
              ELSEIF (@dispensed_drug_name1_bart2_name <> @pres_drug_name1_bart2_name) THEN
                
                # create dispensed_drug order
                SET @dispensed_order_uuid = (SELECT UUID());
                
                IF NOT ISNULL(prescription_duration) THEN
                  SET @auto_expire_date = (SELECT 
                       CASE WHEN TRIM(REPLACE(SUBSTRING(prescription_duration,INSTR(prescription_duration, ' ')),'s','')) = 'Month' THEN 
                        ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 30) + 2)) 
                        ELSE 
                          ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 7) + 2)) 
                        END AS prescription_duration_in_days);
                END IF;
                
                INSERT INTO orders (order_type_id, concept_id, orderer, encounter_id, patient_id, start_date, auto_expire_date, obs_id, creator, date_created, uuid)
                VALUES (1, @pres_drug_name1_concept_id, 1, @dispensing_encounter_id, patient_id, visit_date, @auto_expire_date,@pres_drug1_obs_id, @creator,  date_created, @dispensed_order_uuid);
                
                # get the dispensed_drug_order_id
                SET @dispensed_drug_order_id = (SELECT order_id FROM orders WHERE uuid = @dispensed_order_uuid);

                # create drug order with quantity
                INSERT INTO drug_order (order_id, drug_inventory_id, quantity)
                VALUES (@dispensed_drug_order_id, @dispensed_drug_name1_concept_id, dispensed_quantity1);
                
                # create amount_dispensed observation
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_drug, value_numeric, creator, date_created, uuid)
                VALUES (patient_id, @amount_dispensed_concept_id, @dispensing_encounter_id, @dispensed_drug_order_id, visit_date, @dispensed_drug_name1_concept_id, dispensed_quantity1, @creator, date_created, (SELECT UUID()));
               
               # create arv_regimens_received_abstracted_construct observation         
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_coded, creator, date_created, uuid)
                VALUES (patient_id, @arv_regimens_received_abstracted_construct_concept_id, @dispensing_encounter_id, @dispensed_drug_order_id, visit_date, @dispensed_drug_name1_concept_id, @creator, date_created, (SELECT UUID()));
              END IF;
             ELSE
              #create drug_order without quantity
                INSERT INTO drug_order (order_id, drug_inventory_id, dose, equivalent_daily_dose, frequency)
                VALUES (@pres_drug1_order_id, @pres_drug_name1_concept_id, pres_dosage1, pres_dosage1, pres_frequency1);
             END IF;
        END IF;

        # Check if the field is not empty========================================================================================
        IF NOT ISNULL(pres_drug_name2) THEN
            SET @pres_drug_name2_bart2_name = (SELECT bart2_two_name FROM drug_map WHERE bart_one_name = pres_drug_name2 LIMIT 1);
            SET @pres_drug_name2_new_drug_id = (SELECT new_drug_id FROM drug_map WHERE bart2_two_name = @pres_drug_name2_bart2_name);
            SET @pres_drug_name2_concept_id = (SELECT concept_id  FROM drug WHERE drug_id = @pres_drug_name2_new_drug_id AND name = @pres_drug_name2_bart2_name);     
            
            IF (@pres_drug_name2_bart2_name = "Cotrimoxazole (480mg tablet)") THEN
              # Get concept_id
              SET @cpt_started_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "CPT started" AND voided = 0 AND retired = 0 LIMIT 1);
          
              # Get value_coded id
              SET @yes_concept_id = (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = "Yes" AND voided = 0 AND retired = 0 LIMIT 1);
          
              # Get value_coded_name_id
              SET @yes_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Yes" AND voided = 0 AND retired = 0 LIMIT 1);
            
              # Create observation
              
              SET @cpt_started_uuid = (SELECT UUID());

              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
              VALUES (patient_id, @cpt_started_concept_id, @encounter_id, visit_date, @yes_concept_id, @yes_concept_name_id, @creator, date_created, @cpt_started_uuid);

              SET @pres_drug2_obs_id = (SELECT obs_id FROM obs WHERE uuid = @cpt_started_uuid);
            ELSE
              IF NOT ISNULL(weight)THEN
                SET @regimen_category = ( SELECT regimen_index FROM regimen
                                          WHERE min_weight <= weight
                                          AND max_weight >= weight
                                          AND concept_id = @pres_drug_name2_concept_id);

              END IF;

              SET @regimen_category_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Regimen category" AND voided = 0 AND retired = 0 LIMIT 1);

              # create regimen category observation
              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
              VALUES (patient_id, @regimen_category_concept_id, @encounter_id, visit_date, @regimen_category,@creator, date_created,(SELECT UUID()));
              
              SET @what_type_of_antiretroviral_regime_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "What type of antiretroviral regimen" AND voided = 0 AND retired = 0 LIMIT 1);
              
              # Create observation
              SET @arv_regimen_type_uuid = (SELECT UUID());

              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, creator, date_created, uuid)
              VALUES (patient_id, @what_type_of_antiretroviral_regime_concept_id, @encounter_id,  visit_date, @pres_drug_name2_concept_id, @creator, date_created, @arv_regimen_type_uuid);
              
              SET @pres_drug2_obs_id = (SELECT obs_id FROM obs WHERE uuid = @arv_regimen_type_uuid);

            END IF;

            # create order
            SET @pres_drug_name2_uuid = (SELECT UUID());
           
            IF NOT ISNULL(prescription_duration) THEN
                  SET @auto_expire_date = (SELECT 
                       CASE WHEN TRIM(REPLACE(SUBSTRING(prescription_duration,INSTR(prescription_duration, ' ')),'s','')) = 'Month' THEN 
                        ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 30) + 2)) 
                        ELSE 
                          ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 7) + 2)) 
                        END AS prescription_duration_in_days);
            END IF;
            
            INSERT INTO orders (order_type_id, concept_id, orderer, encounter_id, patient_id, start_date, auto_expire_date, obs_id, creator, date_created, uuid)
              VALUES (1, @pres_drug_name2_concept_id, 1, @encounter_id, patient_id, visit_date, @auto_expire_date, @pres_drug2_obs_id, @creator,  date_created, @pres_drug_name2_uuid);

            SET @pres_drug2_order_id = (SELECT order_id FROM orders WHERE uuid = @pres_drug_name2_uuid);

            IF NOT ISNULL(dispensed_drug_name2) THEN
              
              # Get id of dispense encounter type
              SET @dispensing_encounter_type_id = (SELECT encounter_type_id FROM encounter_type WHERE name = "DISPENSING");

              # Create encounter
              SET @dispensing_encounter_uuid = (SELECT UUID());
              
              INSERT INTO encounter (encounter_type, patient_id, provider_id, encounter_datetime, creator, date_created, uuid)
              VALUES (@dispensing_encounter_type_id, patient_id, @creator, visit_date, @creator, date_created, @dispensing_encounter_uuid);
       
              SET @dispensing_encounter_id = (SELECT encounter_id FROM encounter WHERE uuid = @dispensing_encounter_uuid);
              
              
              #get the bart2_drug_names from drug_map table

              SET @dispensed_drug_name2_bart2_name = (SELECT bart2_two_name FROM drug_map WHERE bart_one_name = dispensed_drug_name2 LIMIT 1);

              SET @dispensed_drug_name2_concept_id = (SELECT new_drug_id  FROM drug_map WHERE bart2_two_name = @dispensed_drug_name2_bart2_name LIMIT 1);

              SET @amount_dispensed_concept_id = (SELECT concept_name.concept_id FROM concept_name
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Amount dispensed" AND voided = 0 AND retired = 0 LIMIT 1);
                            
              SET @arv_regimens_received_abstracted_construct_concept_id = (SELECT concept_name.concept_id FROM concept_name
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "ARV regimens received abstracted construct" AND voided = 0 AND retired = 0 LIMIT 1);
              
              # check if prescibed_drug equal dispensed
              IF (@dispensed_drug_name2_bart2_name = @pres_drug_name2_bart2_name) THEN

                #create drug_order with quantity
                  INSERT INTO drug_order (order_id, drug_inventory_id, dose, equivalent_daily_dose, frequency, quantity)
                  VALUES (@pres_drug2_order_id, @dispensed_drug_name2_concept_id, pres_dosage2, pres_dosage2, pres_frequency2, dispensed_quantity2);
                            
               # create amount_dispensed observation
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_drug, value_numeric, creator, date_created, uuid)
                VALUES (patient_id, @amount_dispensed_concept_id, @dispensing_encounter_id, @pres_drug2_order_id, visit_date, @dispensed_drug_name2_concept_id, dispensed_quantity2, @creator, date_created, (SELECT UUID()));
               
               # create arv_regimens_received_abstracted_construct observation         
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_coded, creator, date_created, uuid)
                VALUES (patient_id, @arv_regimens_received_abstracted_construct_concept_id, @dispensing_encounter_id,@pres_drug2_order_id, visit_date, @dispensed_drug_name2_concept_id, @creator, date_created, (SELECT UUID()));
              
              ELSEIF (@dispensed_drug_name2_bart2_name <> @pres_drug_name2_bart2_name) THEN
                
                # create dispensed_drug order
                SET @dispensed_order_uuid = (SELECT UUID());
                
                IF NOT ISNULL(prescription_duration) THEN
                  SET @auto_expire_date = (SELECT 
                       CASE WHEN TRIM(REPLACE(SUBSTRING(prescription_duration,INSTR(prescription_duration, ' ')),'s','')) = 'Month' THEN 
                        ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 30) + 2)) 
                        ELSE 
                          ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 7) + 2)) 
                        END AS prescription_duration_in_days);
                END IF;
                
                INSERT INTO orders (order_type_id, concept_id, orderer, encounter_id, patient_id, start_date, auto_expire_date, obs_id, creator, date_created, uuid)
                VALUES (1, @pres_drug_name2_concept_id, 1, @dispensing_encounter_id, patient_id, visit_date, @auto_expire_date,@pres_drug2_obs_id, @creator,  date_created, @dispensed_order_uuid);
                
                # get the dispensed_drug_order_id
                SET @dispensed_drug_order_id = (SELECT order_id FROM orders WHERE uuid = @dispensed_order_uuid);

                # create drug order with quantity
                INSERT INTO drug_order (order_id, drug_inventory_id, quantity)
                VALUES (@dispensed_drug_order_id, @dispensed_drug_name2_concept_id, dispensed_quantity2);
                
                # create amount_dispensed observation
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_drug, value_numeric, creator, date_created, uuid)
                VALUES (patient_id, @amount_dispensed_concept_id, @dispensing_encounter_id, @dispensed_drug_order_id, visit_date, @dispensed_drug_name2_concept_id, dispensed_quantity2, @creator, date_created, (SELECT UUID()));
               
               # create arv_regimens_received_abstracted_construct observation         
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_coded, creator, date_created, uuid)
                VALUES (patient_id, @arv_regimens_received_abstracted_construct_concept_id, @dispensing_encounter_id, @dispensed_drug_order_id, visit_date, @dispensed_drug_name2_concept_id, @creator, date_created, (SELECT UUID()));
              END IF;
             ELSE
              #create drug_order without quantity
                INSERT INTO drug_order (order_id, drug_inventory_id, dose, equivalent_daily_dose, frequency)
                VALUES (@pres_drug2_order_id, @pres_drug_name2_concept_id, pres_dosage2, pres_dosage2, pres_frequency2);
             END IF;
        END IF;

        # Check if the field is not empty========================================================================================
        IF NOT ISNULL(pres_drug_name3) THEN
            SET @pres_drug_name3_bart2_name = (SELECT bart2_two_name FROM drug_map WHERE bart_one_name = pres_drug_name3 LIMIT 1);
            SET @pres_drug_name3_new_drug_id = (SELECT new_drug_id FROM drug_map WHERE bart2_two_name = @pres_drug_name3_bart2_name);
            SET @pres_drug_name3_concept_id = (SELECT concept_id  FROM drug WHERE drug_id = @pres_drug_name3_new_drug_id AND name = @pres_drug_name3_bart2_name);     
            
            IF (@pres_drug_name3_bart2_name = "Cotrimoxazole (480mg tablet)") THEN
              # Get concept_id
              SET @cpt_started_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "CPT started" AND voided = 0 AND retired = 0 LIMIT 1);
          
              # Get value_coded id
              SET @yes_concept_id = (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = "Yes" AND voided = 0 AND retired = 0 LIMIT 1);
          
              # Get value_coded_name_id
              SET @yes_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Yes" AND voided = 0 AND retired = 0 LIMIT 1);
            
              # Create observation
              
              SET @cpt_started_uuid = (SELECT UUID());

              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
              VALUES (patient_id, @cpt_started_concept_id, @encounter_id, visit_date, @yes_concept_id, @yes_concept_name_id, @creator, date_created, @cpt_started_uuid);

              SET @pres_drug3_obs_id = (SELECT obs_id FROM obs WHERE uuid = @cpt_started_uuid);
            ELSE
              IF NOT ISNULL(weight)THEN
                SET @regimen_category = ( SELECT regimen_index FROM regimen
                                          WHERE min_weight <= weight
                                          AND max_weight >= weight
                                          AND concept_id = @pres_drug_name3_concept_id);

              END IF;

              SET @regimen_category_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Regimen category" AND voided = 0 AND retired = 0 LIMIT 1);

              # create regimen category observation
              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
              VALUES (patient_id, @regimen_category_concept_id, @encounter_id, visit_date, @regimen_category,@creator, date_created,(SELECT UUID()));
              
              SET @what_type_of_antiretroviral_regime_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "What type of antiretroviral regimen" AND voided = 0 AND retired = 0 LIMIT 1);
              
              # Create observation
              SET @arv_regimen_type_uuid = (SELECT UUID());

              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, creator, date_created, uuid)
              VALUES (patient_id, @what_type_of_antiretroviral_regime_concept_id, @encounter_id,  visit_date, @pres_drug_name3_concept_id, @creator, date_created, @arv_regimen_type_uuid);
              
              SET @pres_drug3_obs_id = (SELECT obs_id FROM obs WHERE uuid = @arv_regimen_type_uuid);

            END IF;

            # create order
            SET @pres_drug_name3_uuid = (SELECT UUID());
           
            IF NOT ISNULL(prescription_duration) THEN
                  SET @auto_expire_date = (SELECT 
                       CASE WHEN TRIM(REPLACE(SUBSTRING(prescription_duration,INSTR(prescription_duration, ' ')),'s','')) = 'Month' THEN 
                        ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 30) + 2)) 
                        ELSE 
                          ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 7) + 2)) 
                        END AS prescription_duration_in_days);
            END IF;
            
            INSERT INTO orders (order_type_id, concept_id, orderer, encounter_id, patient_id, start_date, auto_expire_date, obs_id, creator, date_created, uuid)
              VALUES (1, @pres_drug_name3_concept_id, 1, @encounter_id, patient_id, visit_date, @auto_expire_date, @pres_drug3_obs_id, @creator,  date_created, @pres_drug_name3_uuid);

            SET @pres_drug3_order_id = (SELECT order_id FROM orders WHERE uuid = @pres_drug_name3_uuid);

            IF NOT ISNULL(dispensed_drug_name3) THEN
              
              # Get id of dispense encounter type
              SET @dispensing_encounter_type_id = (SELECT encounter_type_id FROM encounter_type WHERE name = "DISPENSING");

              # Create encounter
              SET @dispensing_encounter_uuid = (SELECT UUID());
              
              INSERT INTO encounter (encounter_type, patient_id, provider_id, encounter_datetime, creator, date_created, uuid)
              VALUES (@dispensing_encounter_type_id, patient_id, @creator, visit_date, @creator, date_created, @dispensing_encounter_uuid);
       
              SET @dispensing_encounter_id = (SELECT encounter_id FROM encounter WHERE uuid = @dispensing_encounter_uuid);
              
              
              #get the bart2_drug_names from drug_map table

              SET @dispensed_drug_name3_bart2_name = (SELECT bart2_two_name FROM drug_map WHERE bart_one_name = dispensed_drug_name3 LIMIT 1);

              SET @dispensed_drug_name3_concept_id = (SELECT new_drug_id  FROM drug_map WHERE bart2_two_name = @dispensed_drug_name3_bart2_name LIMIT 1);

              SET @amount_dispensed_concept_id = (SELECT concept_name.concept_id FROM concept_name
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Amount dispensed" AND voided = 0 AND retired = 0 LIMIT 1);
                            
              SET @arv_regimens_received_abstracted_construct_concept_id = (SELECT concept_name.concept_id FROM concept_name
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "ARV regimens received abstracted construct" AND voided = 0 AND retired = 0 LIMIT 1);
              
              # check if prescibed_drug equal dispensed
              IF (@dispensed_drug_name3_bart2_name = @pres_drug_name3_bart2_name) THEN

                #create drug_order with quantity
                  INSERT INTO drug_order (order_id, drug_inventory_id, dose, equivalent_daily_dose, frequency, quantity)
                  VALUES (@pres_drug3_order_id, @dispensed_drug_name3_concept_id, pres_dosage3, pres_dosage3, pres_frequency3, dispensed_quantity3);
                            
               # create amount_dispensed observation
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_drug, value_numeric, creator, date_created, uuid)
                VALUES (patient_id, @amount_dispensed_concept_id, @dispensing_encounter_id, @pres_drug3_order_id, visit_date, @dispensed_drug_name3_concept_id, dispensed_quantity3, @creator, date_created, (SELECT UUID()));
               
               # create arv_regimens_received_abstracted_construct observation         
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_coded, creator, date_created, uuid)
                VALUES (patient_id, @arv_regimens_received_abstracted_construct_concept_id, @dispensing_encounter_id,@pres_drug3_order_id, visit_date, @dispensed_drug_name3_concept_id, @creator, date_created, (SELECT UUID()));
              
              ELSEIF (@dispensed_drug_name3_bart2_name <> @pres_drug_name3_bart2_name) THEN
                
                # create dispensed_drug order
                SET @dispensed_order_uuid = (SELECT UUID());
                
                IF NOT ISNULL(prescription_duration) THEN
                  SET @auto_expire_date = (SELECT 
                       CASE WHEN TRIM(REPLACE(SUBSTRING(prescription_duration,INSTR(prescription_duration, ' ')),'s','')) = 'Month' THEN 
                        ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 30) + 2)) 
                        ELSE 
                          ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 7) + 2)) 
                        END AS prescription_duration_in_days);
                END IF;
                
                INSERT INTO orders (order_type_id, concept_id, orderer, encounter_id, patient_id, start_date, auto_expire_date, obs_id, creator, date_created, uuid)
                VALUES (1, @pres_drug_name3_concept_id, 1, @dispensing_encounter_id, patient_id, visit_date, @auto_expire_date,@pres_drug3_obs_id, @creator,  date_created, @dispensed_order_uuid);
                
                # get the dispensed_drug_order_id
                SET @dispensed_drug_order_id = (SELECT order_id FROM orders WHERE uuid = @dispensed_order_uuid);

                # create drug order with quantity
                INSERT INTO drug_order (order_id, drug_inventory_id, quantity)
                VALUES (@dispensed_drug_order_id, @dispensed_drug_name3_concept_id, dispensed_quantity3);
                
                # create amount_dispensed observation
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_drug, value_numeric, creator, date_created, uuid)
                VALUES (patient_id, @amount_dispensed_concept_id, @dispensing_encounter_id, @dispensed_drug_order_id, visit_date, @dispensed_drug_name3_concept_id, dispensed_quantity3, @creator, date_created, (SELECT UUID()));
               
               # create arv_regimens_received_abstracted_construct observation         
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_coded, creator, date_created, uuid)
                VALUES (patient_id, @arv_regimens_received_abstracted_construct_concept_id, @dispensing_encounter_id, @dispensed_drug_order_id, visit_date, @dispensed_drug_name3_concept_id, @creator, date_created, (SELECT UUID()));
              END IF;
             ELSE
              #create drug_order without quantity
                INSERT INTO drug_order (order_id, drug_inventory_id, dose, equivalent_daily_dose, frequency)
                VALUES (@pres_drug3_order_id, @pres_drug_name3_concept_id, pres_dosage3, pres_dosage3, pres_frequency3);
             END IF;
        END IF;

        # Check if the field is not empty========================================================================================
        IF NOT ISNULL(pres_drug_name4) THEN
            SET @pres_drug_name4_bart2_name = (SELECT bart2_two_name FROM drug_map WHERE bart_one_name = pres_drug_name4 LIMIT 1);
            SET @pres_drug_name4_new_drug_id = (SELECT new_drug_id FROM drug_map WHERE bart2_two_name = @pres_drug_name4_bart2_name);
            SET @pres_drug_name4_concept_id = (SELECT concept_id  FROM drug WHERE drug_id = @pres_drug_name4_new_drug_id AND name = @pres_drug_name4_bart2_name);     
            
            IF (@pres_drug_name4_bart2_name = "Cotrimoxazole (480mg tablet)") THEN
              # Get concept_id
              SET @cpt_started_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "CPT started" AND voided = 0 AND retired = 0 LIMIT 1);
          
              # Get value_coded id
              SET @yes_concept_id = (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = "Yes" AND voided = 0 AND retired = 0 LIMIT 1);
          
              # Get value_coded_name_id
              SET @yes_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Yes" AND voided = 0 AND retired = 0 LIMIT 1);
            
              # Create observation
              
              SET @cpt_started_uuid = (SELECT UUID());

              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
              VALUES (patient_id, @cpt_started_concept_id, @encounter_id, visit_date, @yes_concept_id, @yes_concept_name_id, @creator, date_created, @cpt_started_uuid);

              SET @pres_drug4_obs_id = (SELECT obs_id FROM obs WHERE uuid = @cpt_started_uuid);
            ELSE
              IF NOT ISNULL(weight)THEN
                SET @regimen_category = ( SELECT regimen_index FROM regimen
                                          WHERE min_weight <= weight
                                          AND max_weight >= weight
                                          AND concept_id = @pres_drug_name4_concept_id);

              END IF;

              SET @regimen_category_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Regimen category" AND voided = 0 AND retired = 0 LIMIT 1);

              # create regimen category observation
              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
              VALUES (patient_id, @regimen_category_concept_id, @encounter_id, visit_date, @regimen_category,@creator, date_created,(SELECT UUID()));
              
              SET @what_type_of_antiretroviral_regime_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "What type of antiretroviral regimen" AND voided = 0 AND retired = 0 LIMIT 1);
              
              # Create observation
              SET @arv_regimen_type_uuid = (SELECT UUID());

              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, creator, date_created, uuid)
              VALUES (patient_id, @what_type_of_antiretroviral_regime_concept_id, @encounter_id,  visit_date, @pres_drug_name4_concept_id, @creator, date_created, @arv_regimen_type_uuid);
              
              SET @pres_drug4_obs_id = (SELECT obs_id FROM obs WHERE uuid = @arv_regimen_type_uuid);

            END IF;

            # create order
            SET @pres_drug_name4_uuid = (SELECT UUID());
           
            IF NOT ISNULL(prescription_duration) THEN
                  SET @auto_expire_date = (SELECT 
                       CASE WHEN TRIM(REPLACE(SUBSTRING(prescription_duration,INSTR(prescription_duration, ' ')),'s','')) = 'Month' THEN 
                        ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 30) + 2)) 
                        ELSE 
                          ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 7) + 2)) 
                        END AS prescription_duration_in_days);
            END IF;
            
            INSERT INTO orders (order_type_id, concept_id, orderer, encounter_id, patient_id, start_date, auto_expire_date, obs_id, creator, date_created, uuid)
              VALUES (1, @pres_drug_name4_concept_id, 1, @encounter_id, patient_id, visit_date, @auto_expire_date, @pres_drug4_obs_id, @creator,  date_created, @pres_drug_name4_uuid);

            SET @pres_drug4_order_id = (SELECT order_id FROM orders WHERE uuid = @pres_drug_name4_uuid);

            IF NOT ISNULL(dispensed_drug_name4) THEN
              
              # Get id of dispense encounter type
              SET @dispensing_encounter_type_id = (SELECT encounter_type_id FROM encounter_type WHERE name = "DISPENSING");

              # Create encounter
              SET @dispensing_encounter_uuid = (SELECT UUID());
              
              INSERT INTO encounter (encounter_type, patient_id, provider_id, encounter_datetime, creator, date_created, uuid)
              VALUES (@dispensing_encounter_type_id, patient_id, @creator, visit_date, @creator, date_created, @dispensing_encounter_uuid);
       
              SET @dispensing_encounter_id = (SELECT encounter_id FROM encounter WHERE uuid = @dispensing_encounter_uuid);
              
              
              #get the bart2_drug_names from drug_map table

              SET @dispensed_drug_name4_bart2_name = (SELECT bart2_two_name FROM drug_map WHERE bart_one_name = dispensed_drug_name4 LIMIT 1);

              SET @dispensed_drug_name4_concept_id = (SELECT new_drug_id  FROM drug_map WHERE bart2_two_name = @dispensed_drug_name4_bart2_name LIMIT 1);

              SET @amount_dispensed_concept_id = (SELECT concept_name.concept_id FROM concept_name
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Amount dispensed" AND voided = 0 AND retired = 0 LIMIT 1);
                            
              SET @arv_regimens_received_abstracted_construct_concept_id = (SELECT concept_name.concept_id FROM concept_name
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "ARV regimens received abstracted construct" AND voided = 0 AND retired = 0 LIMIT 1);
              
              # check if prescibed_drug equal dispensed
              IF (@dispensed_drug_name4_bart2_name = @pres_drug_name4_bart2_name) THEN

                #create drug_order with quantity
                  INSERT INTO drug_order (order_id, drug_inventory_id, dose, equivalent_daily_dose, frequency, quantity)
                  VALUES (@pres_drug4_order_id, @dispensed_drug_name4_concept_id, pres_dosage4, pres_dosage4, pres_frequency4, dispensed_quantity4);
                            
               # create amount_dispensed observation
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_drug, value_numeric, creator, date_created, uuid)
                VALUES (patient_id, @amount_dispensed_concept_id, @dispensing_encounter_id, @pres_drug4_order_id, visit_date, @dispensed_drug_name4_concept_id, dispensed_quantity4, @creator, date_created, (SELECT UUID()));
               
               # create arv_regimens_received_abstracted_construct observation         
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_coded, creator, date_created, uuid)
                VALUES (patient_id, @arv_regimens_received_abstracted_construct_concept_id, @dispensing_encounter_id,@pres_drug4_order_id, visit_date, @dispensed_drug_name4_concept_id, @creator, date_created, (SELECT UUID()));
              
              ELSEIF (@dispensed_drug_name4_bart2_name <> @pres_drug_name4_bart2_name) THEN
                
                # create dispensed_drug order
                SET @dispensed_order_uuid = (SELECT UUID());
                
                IF NOT ISNULL(prescription_duration) THEN
                  SET @auto_expire_date = (SELECT 
                       CASE WHEN TRIM(REPLACE(SUBSTRING(prescription_duration,INSTR(prescription_duration, ' ')),'s','')) = 'Month' THEN 
                        ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 30) + 2)) 
                        ELSE 
                          ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 7) + 2)) 
                        END AS prescription_duration_in_days);
                END IF;
                
                INSERT INTO orders (order_type_id, concept_id, orderer, encounter_id, patient_id, start_date, auto_expire_date, obs_id, creator, date_created, uuid)
                VALUES (1, @pres_drug_name4_concept_id, 1, @dispensing_encounter_id, patient_id, visit_date, @auto_expire_date,@pres_drug4_obs_id, @creator,  date_created, @dispensed_order_uuid);
                
                # get the dispensed_drug_order_id
                SET @dispensed_drug_order_id = (SELECT order_id FROM orders WHERE uuid = @dispensed_order_uuid);

                # create drug order with quantity
                INSERT INTO drug_order (order_id, drug_inventory_id, quantity)
                VALUES (@dispensed_drug_order_id, @dispensed_drug_name4_concept_id, dispensed_quantity4);
                
                # create amount_dispensed observation
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_drug, value_numeric, creator, date_created, uuid)
                VALUES (patient_id, @amount_dispensed_concept_id, @dispensing_encounter_id, @dispensed_drug_order_id, visit_date, @dispensed_drug_name4_concept_id, dispensed_quantity4, @creator, date_created, (SELECT UUID()));
               
               # create arv_regimens_received_abstracted_construct observation         
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_coded, creator, date_created, uuid)
                VALUES (patient_id, @arv_regimens_received_abstracted_construct_concept_id, @dispensing_encounter_id, @dispensed_drug_order_id, visit_date, @dispensed_drug_name4_concept_id, @creator, date_created, (SELECT UUID()));
              END IF;
             ELSE
              #create drug_order without quantity
                INSERT INTO drug_order (order_id, drug_inventory_id, dose, equivalent_daily_dose, frequency)
                VALUES (@pres_drug4_order_id, @pres_drug_name4_concept_id, pres_dosage4, pres_dosage4, pres_frequency4);
             END IF;
        END IF;

        # Check if the field is not empty========================================================================================
        IF NOT ISNULL(pres_drug_name5) THEN
            SET @pres_drug_name5_bart2_name = (SELECT bart2_two_name FROM drug_map WHERE bart_one_name = pres_drug_name5 LIMIT 1);
            SET @pres_drug_name5_new_drug_id = (SELECT new_drug_id FROM drug_map WHERE bart2_two_name = @pres_drug_name5_bart2_name);
            SET @pres_drug_name5_concept_id = (SELECT concept_id  FROM drug WHERE drug_id = @pres_drug_name5_new_drug_id AND name = @pres_drug_name5_bart2_name);     
            
            IF (@pres_drug_name5_bart2_name = "Cotrimoxazole (480mg tablet)") THEN
              # Get concept_id
              SET @cpt_started_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "CPT started" AND voided = 0 AND retired = 0 LIMIT 1);
          
              # Get value_coded id
              SET @yes_concept_id = (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = "Yes" AND voided = 0 AND retired = 0 LIMIT 1);
          
              # Get value_coded_name_id
              SET @yes_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Yes" AND voided = 0 AND retired = 0 LIMIT 1);
            
              # Create observation
              
              SET @cpt_started_uuid = (SELECT UUID());

              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
              VALUES (patient_id, @cpt_started_concept_id, @encounter_id, visit_date, @yes_concept_id, @yes_concept_name_id, @creator, date_created, @cpt_started_uuid);

              SET @pres_drug5_obs_id = (SELECT obs_id FROM obs WHERE uuid = @cpt_started_uuid);
            ELSE
              IF NOT ISNULL(weight)THEN
                SET @regimen_category = ( SELECT regimen_index FROM regimen
                                          WHERE min_weight <= weight
                                          AND max_weight >= weight
                                          AND concept_id = @pres_drug_name5_concept_id);

              END IF;

              SET @regimen_category_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Regimen category" AND voided = 0 AND retired = 0 LIMIT 1);

              # create regimen category observation
              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
              VALUES (patient_id, @regimen_category_concept_id, @encounter_id, visit_date, @regimen_category,@creator, date_created,(SELECT UUID()));
              
              SET @what_type_of_antiretroviral_regime_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "What type of antiretroviral regimen" AND voided = 0 AND retired = 0 LIMIT 1);
              
              # Create observation
              SET @arv_regimen_type_uuid = (SELECT UUID());

              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, creator, date_created, uuid)
              VALUES (patient_id, @what_type_of_antiretroviral_regime_concept_id, @encounter_id,  visit_date, @pres_drug_name5_concept_id, @creator, date_created, @arv_regimen_type_uuid);
              
              SET @pres_drug5_obs_id = (SELECT obs_id FROM obs WHERE uuid = @arv_regimen_type_uuid);

            END IF;

            # create order
            SET @pres_drug_name5_uuid = (SELECT UUID());
           
            IF NOT ISNULL(prescription_duration) THEN
                  SET @auto_expire_date = (SELECT 
                       CASE WHEN TRIM(REPLACE(SUBSTRING(prescription_duration,INSTR(prescription_duration, ' ')),'s','')) = 'Month' THEN 
                        ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 30) + 2)) 
                        ELSE 
                          ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 7) + 2)) 
                        END AS prescription_duration_in_days);
            END IF;
            
            INSERT INTO orders (order_type_id, concept_id, orderer, encounter_id, patient_id, start_date, auto_expire_date, obs_id, creator, date_created, uuid)
              VALUES (1, @pres_drug_name5_concept_id, 1, @encounter_id, patient_id, visit_date, @auto_expire_date, @pres_drug5_obs_id, @creator,  date_created, @pres_drug_name5_uuid);

            SET @pres_drug5_order_id = (SELECT order_id FROM orders WHERE uuid = @pres_drug_name5_uuid);

            IF NOT ISNULL(dispensed_drug_name5) THEN
              
              # Get id of dispense encounter type
              SET @dispensing_encounter_type_id = (SELECT encounter_type_id FROM encounter_type WHERE name = "DISPENSING");

              # Create encounter
              SET @dispensing_encounter_uuid = (SELECT UUID());
              
              INSERT INTO encounter (encounter_type, patient_id, provider_id, encounter_datetime, creator, date_created, uuid)
              VALUES (@dispensing_encounter_type_id, patient_id, @creator, visit_date, @creator, date_created, @dispensing_encounter_uuid);
       
              SET @dispensing_encounter_id = (SELECT encounter_id FROM encounter WHERE uuid = @dispensing_encounter_uuid);
              
              
              #get the bart2_drug_names from drug_map table

              SET @dispensed_drug_name5_bart2_name = (SELECT bart2_two_name FROM drug_map WHERE bart_one_name = dispensed_drug_name5 LIMIT 1);

              SET @dispensed_drug_name5_concept_id = (SELECT new_drug_id  FROM drug_map WHERE bart2_two_name = @dispensed_drug_name5_bart2_name LIMIT 1);

              SET @amount_dispensed_concept_id = (SELECT concept_name.concept_id FROM concept_name
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "Amount dispensed" AND voided = 0 AND retired = 0 LIMIT 1);
                            
              SET @arv_regimens_received_abstracted_construct_concept_id = (SELECT concept_name.concept_id FROM concept_name
                                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                                    WHERE name = "ARV regimens received abstracted construct" AND voided = 0 AND retired = 0 LIMIT 1);
              
              # check if prescibed_drug equal dispensed
              IF (@dispensed_drug_name5_bart2_name = @pres_drug_name5_bart2_name) THEN

                #create drug_order with quantity
                  INSERT INTO drug_order (order_id, drug_inventory_id, dose, equivalent_daily_dose, frequency, quantity)
                  VALUES (@pres_drug5_order_id, @dispensed_drug_name5_concept_id, pres_dosage5, pres_dosage5, pres_frequency5, dispensed_quantity5);
                            
               # create amount_dispensed observation
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_drug, value_numeric, creator, date_created, uuid)
                VALUES (patient_id, @amount_dispensed_concept_id, @dispensing_encounter_id, @pres_drug5_order_id, visit_date, @dispensed_drug_name5_concept_id, dispensed_quantity5, @creator, date_created, (SELECT UUID()));
               
               # create arv_regimens_received_abstracted_construct observation         
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_coded, creator, date_created, uuid)
                VALUES (patient_id, @arv_regimens_received_abstracted_construct_concept_id, @dispensing_encounter_id,@pres_drug5_order_id, visit_date, @dispensed_drug_name5_concept_id, @creator, date_created, (SELECT UUID()));
              
              ELSEIF (@dispensed_drug_name5_bart2_name <> @pres_drug_name5_bart2_name) THEN
                
                # create dispensed_drug order
                SET @dispensed_order_uuid = (SELECT UUID());
                
                IF NOT ISNULL(prescription_duration) THEN
                  SET @auto_expire_date = (SELECT 
                       CASE WHEN TRIM(REPLACE(SUBSTRING(prescription_duration,INSTR(prescription_duration, ' ')),'s','')) = 'Month' THEN 
                        ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 30) + 2)) 
                        ELSE 
                          ADDDATE(visit_date,((LEFT(prescription_duration,INSTR(prescription_duration, ' ')) * 7) + 2)) 
                        END AS prescription_duration_in_days);
                END IF;
                
                INSERT INTO orders (order_type_id, concept_id, orderer, encounter_id, patient_id, start_date, auto_expire_date, obs_id, creator, date_created, uuid)
                VALUES (1, @pres_drug_name5_concept_id, 1, @dispensing_encounter_id, patient_id, visit_date, @auto_expire_date,@pres_drug5_obs_id, @creator,  date_created, @dispensed_order_uuid);
                
                # get the dispensed_drug_order_id
                SET @dispensed_drug_order_id = (SELECT order_id FROM orders WHERE uuid = @dispensed_order_uuid);

                # create drug order with quantity
                INSERT INTO drug_order (order_id, drug_inventory_id, quantity)
                VALUES (@dispensed_drug_order_id, @dispensed_drug_name5_concept_id, dispensed_quantity5);
                
                # create amount_dispensed observation
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_drug, value_numeric, creator, date_created, uuid)
                VALUES (patient_id, @amount_dispensed_concept_id, @dispensing_encounter_id, @dispensed_drug_order_id, visit_date, @dispensed_drug_name5_concept_id, dispensed_quantity5, @creator, date_created, (SELECT UUID()));
               
               # create arv_regimens_received_abstracted_construct observation         
                INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime, value_coded, creator, date_created, uuid)
                VALUES (patient_id, @arv_regimens_received_abstracted_construct_concept_id, @dispensing_encounter_id, @dispensed_drug_order_id, visit_date, @dispensed_drug_name5_concept_id, @creator, date_created, (SELECT UUID()));
              END IF;
             ELSE
              #create drug_order without quantity
                INSERT INTO drug_order (order_id, drug_inventory_id, dose, equivalent_daily_dose, frequency)
                VALUES (@pres_drug5_order_id, @pres_drug_name5_concept_id, pres_dosage5, pres_dosage5, pres_frequency5);
             END IF;
        END IF;

    END LOOP;

    # SET UNIQUE_CHECKS = 1;
    # SET FOREIGN_KEY_CHECKS = 1;
    # COMMIT;
    # SET AUTOCOMMIT = 1;

END$$

DELIMITER ;

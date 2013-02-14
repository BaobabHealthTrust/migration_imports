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
DROP PROCEDURE IF EXISTS `proc_import_outpatient_diagnosis_encounters`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_outpatient_diagnosis_encounters`(
    IN in_patient_id INT(11)
)
BEGIN

    # Declare condition for exiting loop
    DECLARE done INT DEFAULT FALSE;

    DECLARE  id int(11);
    DECLARE  visit_encounter_id int(11);
    DECLARE  patient_id int(11);
    DECLARE  refer_to_anotha_hosp varchar(255);
    DECLARE  pri_diagnosis varchar(255);
    DECLARE  sec_diagnosis varchar(255);
    DECLARE  treatment varchar(255);
    DECLARE  location varchar(255);
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
    DECLARE cur CURSOR FOR SELECT DISTINCT  `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.id, `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.visit_encounter_id, `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.patient_id, `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.refer_to_anotha_hosp, `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.pri_diagnosis, `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.sec_diagnosis, `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.treatment, `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.location, `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.voided, `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.void_reason, `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.date_voided, `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.voided_by, `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.date_created, `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.creator,   COALESCE(`bart1_intermediate_bare_bones`.`visit_encounters`.visit_date, `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.date_created) FROM 
`bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters` 
        LEFT OUTER JOIN bart1_intermediate_bare_bones.visit_encounters ON 
        visit_encounter_id = bart1_intermediate_bare_bones.visit_encounters.id
        WHERE `bart1_intermediate_bare_bones`.`outpatient_diagnosis_encounters`.`patient_id` = in_patient_id;
   

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
            visit_encounter_id ,
            patient_id,
            refer_to_anotha_hosp,
            pri_diagnosis,
            sec_diagnosis,
            treatment,
            location,
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
        
        IF NOT ISNULL(refer_to_anotha_hosp) THEN
          
          # Get id of outpatient_reception encounter type
          SET @outpatient_diagnosis_encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = "OUTPATIENT RECEPTION");

          # Create outpatient_reception encounter
          SET @outpatient_reception_encounter_uuid = (SELECT UUID());
          
          INSERT INTO encounter ( encounter_type, patient_id, provider_id, encounter_datetime, creator, date_created, uuid)
          VALUES ( @outpatient_diagnosis_encounter_type, patient_id, @creator, visit_date, @creator, date_created, @outpatient_reception_encounter_uuid);
         
         # get the created outpatient_reception encounter_id
          SET @outpatient_reception_encounter_id = (SELECT encounter_id FROM encounter WHERE uuid = @outpatient_reception_encounter_uuid);
          
          # Get the is_patient_referred_concept_id
          SET @is_patient_referred_concept_id = (SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Is patient referred?" AND voided = 0 AND retired = 0 LIMIT 1);
          
          # Get referred_from_concept_id
          SET @referred_from_concept_id = (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = "Referred from" AND voided = 0 AND retired = 0 LIMIT 1);
          
          # Get yes_concept_name_id
          SET @yes_concept_id = (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Yes" AND voided = 0 AND retired = 0 LIMIT 1);
          
          # Get yes_concept_name_id
           SET @yes_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = "Yes" AND voided = 0 AND retired = 0 LIMIT 1);
          
           # Create is_patient_referred_observation
             INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
             VALUES (patient_id, @is_patient_referred_concept_id, visit_date,@outpatient_reception_encounter_id, visit_date, @yes_concept_name_id, @yes_concept_name_id, @creator, date_created, (SELECT UUID()));

          # Create referred_from_observation
           INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
           VALUES (patient_id, @referred_from_concept_id, @outpatient_reception_encounter_id, visit_date, refer_to_anotha_hosp,@creator, date_created, (SELECT UUID()));
        END IF;
        
        IF NOT ISNULL(pri_diagnosis) THEN
          IF (sec_diagnosis <> "Not applicable") THEN
            # Get id of outpatient_diagnosis encounter type
            SET @outpatient_diagnosis_encounter_type = (SELECT encounter_type_id FROM encounter_type 
                                                        WHERE name = "OUTPATIENT DIAGNOSIS");

            # Create outpatient_diagnosis encounter
            SET @outpatient_diagnosis_encounter_uuid = (SELECT UUID());
            
            INSERT INTO encounter (encounter_type, patient_id, provider_id, encounter_datetime, creator, date_created, uuid)
            VALUES (@outpatient_diagnosis_encounter_type, patient_id, @creator, visit_date, @creator, date_created, @outpatient_diagnosis_encounter_uuid);
           
           # get the created outpatient_diagnosis encounter_id
            SET @outpatient_diagnosis_encounter_id = (SELECT encounter_id FROM encounter WHERE uuid = @outpatient_diagnosis_encounter_uuid);
            
           # get the primary_diagnosis_concept_id
            SET @primary_diagnosis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = "Primary diagnosis" AND voided = 0 AND retired = 0 LIMIT 1);
            
            SET @pri_diagnosis_name = (SELECT bart_two_diagnosis_name FROM diagnosis_name_map WHERE bart_one_diagnosis_name = pri_diagnosis);

            IF ISNULL(@pri_diagnosis_name) THEN
              SET @bart2_primary_diagnosis_name = (pri_diagnosis);
            ELSE
              SET @bart2_primary_diagnosis_name = (@pri_diagnosis_name);
            END IF;
            
            SET @diagnosis_concept_id =  (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = @bart2_primary_diagnosis_name  AND voided = 0 AND retired = 0 LIMIT 1);
            
            SET @diagnosis_concept_name_id =  (SELECT concept_name.concept_name_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = @bart2_primary_diagnosis_name  AND voided = 0 AND retired = 0 LIMIT 1);

            IF ISNULL(@diagnosis_concept_id) THEN
              # Create primary_diagnosis_observation
               INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
               VALUES (patient_id, @primary_diagnosis_concept_id, @outpatient_diagnosis_encounter_id,  visit_date,pri_diagnosis, @creator, date_created, (SELECT UUID()));
            ELSE
              # Create primary_diagnosis_observation
               INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
               VALUES (patient_id, @primary_diagnosis_concept_id, @outpatient_diagnosis_encounter_id, visit_date, @diagnosis_concept_id, @diagnosis_concept_name_id, @creator, date_created, (SELECT UUID()));
            END IF;
            
            # creating a detailed primary diagnosis
            SET @detailed_primary_diagnosis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = "Detailed primary diagnosis" AND voided = 0 AND retired = 0 LIMIT 1);
            
            IF (pri_diagnosis = "Diarrhoea disease(non-bloody)") THEN
              # Create detailed_primary_diagnosis_observation
              
              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
              VALUES (patient_id, @detailed_primary_diagnosis_concept_id, @outpatient_diagnosis_encounter_id,  visit_date,'non-bloody', @creator, date_created, (SELECT UUID()));
            
            ELSE
              IF (pri_diagnosis = "Sprains (Joint Soft Tissue Injury)") THEN
                SET @detailed_diagnosis_name_concept_id = (SELECT concept_name.concept_id FROM concept_name
                            LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                            WHERE name = "Sprain"  AND voided = 0 AND retired = 0 LIMIT 1);
                
                SET @detailed_diagnosis_name_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                            LEFT OUTER JOIN concept ON concept.concept_name_id = concept_name.concept_id 
                            WHERE concept_id = "Sprain"   AND voided = 0 AND retired = 0 LIMIT 1);
                
                # Create _detailed_primary_diagnosis_observation
                
                INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
                VALUES (patient_id, @detailed_primary_diagnosis_concept_id, @outpatient_diagnosis_encounter_id,  visit_date,@detailed_diagnosis_name_concept_id, @creator, date_created, (SELECT UUID()));
             END IF;
            END IF;

          END IF;
        END IF;
          
        # checking if the secondary_diagnosis is null=======================================================================
        IF NOT ISNULL(sec_diagnosis) THEN
          IF (sec_diagnosis <> "Not applicable") THEN
            # Get id of outpatient_diagnosis encounter type
            SET @outpatient_diagnosis_encounter_type = (SELECT encounter_type_id FROM encounter_type 
                                                        WHERE name = "OUTPATIENT DIAGNOSIS");

            # Create outpatient_diagnosis encounter
            SET @outpatient_diagnosis_encounter_uuid = (SELECT UUID());
            
            INSERT INTO encounter (encounter_type, patient_id, provider_id, encounter_datetime, creator, date_created, uuid)
            VALUES (@outpatient_diagnosis_encounter_type, patient_id, @creator, visit_date, @creator, date_created, @outpatient_diagnosis_encounter_uuid);
           
           # get the created outpatient_diagnosis encounter_id
            SET @outpatient_diagnosis_encounter_id = (SELECT encounter_id FROM encounter WHERE uuid = @outpatient_diagnosis_encounter_uuid);
            
           # get the primary_diagnosis_concept_id
            SET @secondary_diagnosis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = "secondary diagnosis" AND voided = 0 AND retired = 0 LIMIT 1);
            
            SET @sec_diagnosis_name = (SELECT bart_two_diagnosis_name FROM diagnosis_name_map WHERE bart_one_diagnosis_name = sec_diagnosis);

          IF ISNULL(@sec_diagnosis_name) THEN
            SET @bart2_secondary_diagnosis_name = (sec_diagnosis);
          ELSE
            SET @bart2_secondary_diagnosis_name = (@sec_diagnosis_name);
          END IF;
            
            SET @diagnosis_concept_id =  (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = @bart2_secondary_diagnosis_name  AND voided = 0 AND retired = 0 LIMIT 1);

            SET @diagnosis_concept_name_id =  (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = @bart2_secondary_diagnosis_name  AND voided = 0 AND retired = 0 LIMIT 1);
                          
            IF ISNULL(@diagnosis_concept_id) THEN
              # Create secondary_diagnosis_observation
               INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
               VALUES (patient_id, @secondary_diagnosis_concept_id, @outpatient_diagnosis_encounter_id,  visit_date,sec_diagnosis, @creator, date_created, (SELECT UUID()));
            ELSE
              # Create secondary_diagnosis_observation
               INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
               VALUES (patient_id, @secondary_diagnosis_concept_id, @outpatient_diagnosis_encounter_id, visit_date, @diagnosis_concept_id, @diagnosis_concept_name_id, @creator, date_created, (SELECT UUID()));
            END IF;

          # creating a detailed secondary diagnosis
            SET @detailed_secondary_diagnosis_concept_id = (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = "Detailed secondary diagnosis" AND voided = 0 AND retired = 0 LIMIT 1);
            
            IF (sec_diagnosis = "Diarrhoea disease(non-bloody)") THEN
              # Create detailed_secondary_diagnosis_observation
              
              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
              VALUES (patient_id, @detailed_primary_diagnosis_concept_id, @outpatient_diagnosis_encounter_id,  visit_date,'non-bloody', @creator, date_created, (SELECT UUID()));
            
            ELSEIF (sec_diagnosis = "Sprains (Joint Soft Tissue Injury)") THEN
              SET @bart_two_sprains_name = (SELECT bart_two_diagnosis_name FROM diagnosis_name_map WHERE bart_one_diagnosis_name = "Sprains");
              
              SET @detailed_diagnosis_name_concept_id = (SELECT concept_name.concept_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                          WHERE name = @bart_two_sprains_name  AND voided = 0 AND retired = 0 LIMIT 1);
              
              SET @detailed_diagnosis_name_concept_name_id = (SELECT concept_name.concept_name_id FROM concept_name
                          LEFT OUTER JOIN concept ON concept.concept_name_id = concept_name.concept_id 
                          WHERE concept_id = @bart_two_sprains_name  AND voided = 0 AND retired = 0 LIMIT 1);
              
              # Create detailed_secondary_diagnosis_observation
              
              INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
              VALUES (patient_id, @detailed_secondary_diagnosis_concept_id, @outpatient_diagnosis_encounter_id,  visit_date,@detailed_diagnosis_name_concept_id, @creator, date_created, (SELECT UUID()));
            END IF;
          
          
          END IF;
       END IF;

    END LOOP;

    # SET UNIQUE_CHECKS = 1;
    # SET FOREIGN_KEY_CHECKS = 1;
    # COMMIT;
    # SET AUTOCOMMIT = 1;

END$$

DELIMITER ;
        

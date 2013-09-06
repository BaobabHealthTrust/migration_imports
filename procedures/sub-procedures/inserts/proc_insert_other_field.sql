DELIMITER $$

DROP PROCEDURE IF EXISTS `proc_insert_other_field`$$

CREATE PROCEDURE `proc_insert_other_field`(
    IN in_patient_id INT, 
    IN in_visit_date DATE, 
    IN in_field_concept INT, 
    IN in_field_value_coded INT,
    IN in_field_value_coded_name_id INT,
    IN in_field_value_text VARCHAR(255),
    IN in_field_value_numeric DOUBLE,
    IN in_field_value_datetime DATETIME,
    IN in_visit_id INT,
    IN encounter_id INT
)
BEGIN

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
    

    SET @ever_received_art = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = "ever received art" AND voided = 0 AND retired = 0 LIMIT 1);
                     
    SET @date_last_taken_arv = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Date ART last taken' AND voided = 0 AND retired = 0 LIMIT 1);     
                     
    SET @art_in_2_months = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Has the patient taken ART in the last two months' AND voided = 0 AND retired = 0 LIMIT 1);                         

    SET @art_in_2_weeks = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Has the patient taken ART in the last two weeks' AND voided = 0 AND retired = 0 LIMIT 1); 
                    
    SET @last_arv_reg =  (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Last ART drugs taken' AND voided = 0 AND retired = 0 LIMIT 1);                           

    SET @ever_reg_4_art = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Ever registered at ART clinic' AND voided = 0 AND retired = 0 LIMIT 1);                         

    SET @has_transfer_letter = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Has transfer letter' AND voided = 0 AND retired = 0 LIMIT 1); 
                    
    SET @art_init_loc =  (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Location of ART INITIATION' AND voided = 0 AND retired = 0 LIMIT 1);
                   
    SET @art_start_date_est = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Has transfer letter' AND voided = 0 AND retired = 0 LIMIT 1); 
                 
    SET @date_started_art =  (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'ART start date' AND voided = 0 AND retired = 0 LIMIT 1);

    SET @cd4_count_loc =  (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Cd4 count location' AND voided = 0 AND retired = 0 LIMIT 1);                          
                                        
    SET @cd4_percent_loc =  (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'CD4 percent location' AND voided = 0 AND retired = 0 LIMIT 1);                                          

    SET @cd4_count_date =  (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Cd4 count datetime' AND voided = 0 AND retired = 0 LIMIT 1);                        
                                                                  
    SET @cd4_count =  (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Cd4 count' AND voided = 0 AND retired = 0 LIMIT 1);                                                    

    SET @cd4_count_percent =  (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Cd4 percent' AND voided = 0 AND retired = 0 LIMIT 1);                            

    SET @cd4_count_mod =  (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Cd4 count' AND voided = 0 AND retired = 0 LIMIT 1);                            

    SET @cd4_percent_less_than_25 = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'CD4 percent less than 25' AND voided = 0 AND retired = 0 LIMIT 1);                            
                    
    SET @cd4_count_less_than_250 = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'CD4 count less than 250' AND voided = 0 AND retired = 0 LIMIT 1);
                                                
    SET @cd4_count_less_than_350 = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'CD4 count less than or equal to 350' AND voided = 0 AND retired = 0 LIMIT 1);                            
                    
    SET @pnuemocystis_pnuemonia = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Pneumocystis pneumonia' AND voided = 0 AND retired = 0 LIMIT 1);  


    SET @lymphocyte_count_date = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Lymphocyte count datetime' AND voided = 0 AND retired = 0 LIMIT 1);                            
                    
    SET @lymphocyte_count = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Lymphocyte count' AND voided = 0 AND retired = 0 LIMIT 1);                            

    SET @asymptomatic = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Asymptomatic HIV infection' AND voided = 0 AND retired = 0 LIMIT 1);                            

    SET @pers_gnrl_lymphadenopathy = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Persistent generalized lymphadenopathy' AND voided = 0 AND retired = 0 LIMIT 1);                            

    SET @unspecified_stage_1_cond = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Unspecified stage I condition' AND voided = 0 AND retired = 0 LIMIT 1);  

    SET @molluscumm_contagiosum = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Molluscum contagiosum' AND voided = 0 AND retired = 0 LIMIT 1);  

    SET @wart_virus_infection_extensive = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Wart virus infection, extensive' AND voided = 0 AND retired = 0 LIMIT 1);  

    SET @oral_ulcerations_recurrent = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Oral ulcerations, recurrent' AND voided = 0 AND retired = 0 LIMIT 1);  

    SET @parotid_enlargement_pers_unexp = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Parotid enlargement' AND voided = 0 AND retired = 0 LIMIT 1);  

    SET @lineal_gingival_erythema = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Lineal gingival erythema' AND voided = 0 AND retired = 0 LIMIT 1);  

    SET @herpes_zoster = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Herpes zoster' AND voided = 0 AND retired = 0 LIMIT 1);  

    SET @resp_tract_infections_rec =  (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Respiratory tract infections, recurrent (sinusitis, tonsilitus, otitis media, pharyngitis)' AND voided = 0 AND retired = 0 LIMIT 1);  

    SET @unspecified_stage2_condition = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Unspecified stage II condition' AND voided = 0 AND retired = 0 LIMIT 1);  

    SET @angular_chelitis = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Angular cheilitis' AND voided = 0 AND retired = 0 LIMIT 1);  


		SET @papular_prurtic_eruptions = (SELECT concept_name.concept_id FROM  concept_name
        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
        WHERE name = 'Papular pruritic eruptions / Fungal nail infections' AND voided = 0 AND retired = 0 LIMIT 1);


    SET @hepatosplenomegaly_unexplained = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Hepatosplenomegaly persistent unexplained' AND voided = 0 AND retired = 0 LIMIT 1);

    SET @oral_hairy_leukoplakia = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Oral hairy leukoplakia' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @severe_weight_loss = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Severe weight loss >10% and/or BMI <18.5kg/m^2, unexplained' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @fever_persistent_unexplained = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Fever, persistent unexplained, intermittent or constant, >1 month' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @pulmonary_tuberculosis = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Pulmonary tuberculosis (current)' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @pulmonary_tuberculosis_last_2_years = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Tuberculosis (PTB or EPTB) within the last 2 years' AND voided = 0 AND retired = 0 LIMIT 1);

    SET @severe_bacterial_infection = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Severe bacterial infections (pneumonia, empyema, pyomyositis, bone/joint, meningitis, bacteraemia)' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @bacterial_pnuemonia = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Bacterial pneumonia, severe recurrent' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @symptomatic_lymphoid_interstitial_pnuemonitis = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Symptomatic lymphoid interstitial pneumonia' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @chronic_hiv_assoc_lung_disease = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Chronic HIV lung disease' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @unspecified_stage3_condition = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Unspecified stage III condition' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @aneamia = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Anaemia, unexplained < 8 g/dl' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @neutropaenia = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Neutropaenia, unexplained < 500 /mm(cubed)' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @thrombocytopaenia_chronic = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Thrombocytopaenia, chronic < 50,000 /mm(cubed)' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @diarhoea = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Diarrhoea, chronic (>1 month) unexplained' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @oral_candidiasis = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Oral candidiasis' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @acute_necrotizing_ulcerative_gingivitis = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = ' Acute necrotizing ulcerative stomatitis, gingivitis or periodontitis' AND voided = 0 AND retired = 0 LIMIT 1);

    SET @lymph_node_tuberculosis = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Lymph node tuberculosis' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @toxoplasmosis_of_brain = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Toxoplasmosis of the brain' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @cryptococcal_meningitis = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Cryptococcal meningitis or other extrapulmonary cryptococcosis' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @progressive_multifocal_leukoencephalopathy = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Progressive multifocal leukoencephalopathy' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @disseminated_mycosis = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Disseminated mycosis (coccidiomycosis or histoplasmosis)' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @candidiasis_of_oesophagus = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Candidiasis of oseophagus, trachea and bronchi or lungs' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @extrapulmonary_tuberculosis = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Extrapulmonary tuberculosis (EPTB)' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @cerebral_non_hodgkin_lymphoma = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Cerebral or B-cell non Hodgkin lymphoma' AND voided = 0 AND retired = 0 LIMIT 1);


    SET @hiv_encephalopathy = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'HIV encephalopathy' AND voided = 0 AND retired = 0 LIMIT 1);

    SET @bacterial_infections_severe_recurrent = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Bacterial infections, severe recurrent  (empyema, pyomyositis, meningitis, bone/joint infections but EXCLUDING pneumonia)' AND voided = 0 AND retired = 0 LIMIT 1);

    SET @unspecified_stage_4_condition = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Unspecified stage IV condition' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @disseminated_non_tuberculosis_mycobactierial_infection = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Disseminated non-tuberculosis mycobacterial infection' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @cryptosporidiosis = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Cryptosporidiosis, chronic with diarroea' AND voided = 0 AND retired = 0 LIMIT 1);

    SET @isosporiasis = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Isosporiasis >1 month' AND voided = 0 AND retired = 0 LIMIT 1);
                    
    SET @symptomatic_hiv_asscoiated_nephropathy = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Symptomatic HIV associated nephropathy or cardiomyopathy' AND voided = 0 AND retired = 0 LIMIT 1);

    SET @chronic_herpes_simplex_infection = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Chronic herpes simplex infection (orolabial, gential / anorectal >1 month or visceral at any site)' AND voided = 0 AND retired = 0 LIMIT 1);

    SET @cytomegalovirus_infection = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Cytomegalovirus infection' AND voided = 0 AND retired = 0 LIMIT 1);
		                        
    SET @toxoplasomis_of_the_brain_1month = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Toxoplasmosis, brain > 1 month' AND voided = 0 AND retired = 0 LIMIT 1);

    SET @recto_vaginal_fitsula = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Rectovaginal fistula' AND voided = 0 AND retired = 0 LIMIT 1);

    SET @mod_wght_loss_less_thanequal_to_10_perc = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Moderate weight loss less than or equal to 10 percent, unexplained' AND voided = 0 AND retired = 0 LIMIT 1);

    SET @seborrhoeic_dermatitis = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Seborrhoeic dermatitis' AND voided = 0 AND retired = 0 LIMIT 1);
		                        
    SET @hepatitis_b_or_c_infection = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Hepatitis B or C infection' AND voided = 0 AND retired = 0 LIMIT 1);
		                        
    SET @kaposis_sarcoma = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Kaposis sarcoma' AND voided = 0 AND retired = 0 LIMIT 1);

    SET @non_typhoidal_salmonella_bacteraemia_recurrent = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Non-typhoidal salmonella bacteraemia, recurrent' AND voided = 0 AND retired = 0 LIMIT 1);

    SET @leishmaniasis_atypical_disseminated = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Atypical disseminated leishmaniasis' AND voided = 0 AND retired = 0 LIMIT 1);
		                        
    SET @cerebral_or_b_cell_non_hodgkin_lymphoma = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Cerebral or B-cell non Hodgkin lymphoma' AND voided = 0 AND retired = 0 LIMIT 1);
		                        
    SET @invasive_cancer_of_cervix = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'invasive cancer of cervix' AND voided = 0 AND retired = 0 LIMIT 1);    
    CASE in_field_concept
    
        WHEN @missed_hiv_drug_construct THEN
        
            SET @missed_hiv_drug_construct1 = (SELECT COALESCE(missed_hiv_drug_construct1, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @missed_hiv_drug_construct2 = (SELECT COALESCE(missed_hiv_drug_construct2, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @missed_hiv_drug_construct3 = (SELECT COALESCE(missed_hiv_drug_construct3, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @missed_hiv_drug_construct4 = (SELECT COALESCE(missed_hiv_drug_construct4, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @missed_hiv_drug_construct5 = (SELECT COALESCE(missed_hiv_drug_construct5, '') FROM flat_table2 WHERE ID = in_visit_id);
        
            IF in_visit_id = 0 THEN
            
                CASE 
                
                    WHEN @missed_hiv_drug_construct1 = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, missed_hiv_drug_construct1, missed_hiv_drug_construct1_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_text, encounter_id);
                       
                    WHEN @missed_hiv_drug_construct2 = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, missed_hiv_drug_construct2, missed_hiv_drug_construct2_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_text, encounter_id);
                        
                    WHEN @missed_hiv_drug_construct3 = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, missed_hiv_drug_construct3, missed_hiv_drug_construct3_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_text, encounter_id);
                      
                    WHEN @missed_hiv_drug_construct4 = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, missed_hiv_drug_construct4, missed_hiv_drug_construct4_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_text, encounter_id);
                       
                    WHEN @missed_hiv_drug_construct5 = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, missed_hiv_drug_construct5, missed_hiv_drug_construct5_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_text, encounter_id);
                        
                    ELSE
                    
                        SET @enc_id = encounter_id;                  
                
                END CASE;
            
            ELSE 
            
                CASE 
                
                    WHEN @missed_hiv_drug_construct1 = "" THEN
                    
                        UPDATE flat_table2 SET missed_hiv_drug_construct1 = in_field_value_text, missed_hiv_drug_construct1_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                       
                    WHEN @missed_hiv_drug_construct2 = "" THEN
                    
                        UPDATE flat_table2 SET missed_hiv_drug_construct2 = in_field_value_text, missed_hiv_drug_construct2_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                        
                    WHEN @missed_hiv_drug_construct3 = "" THEN
                    
                        UPDATE flat_table2 SET missed_hiv_drug_construct3 = in_field_value_text, missed_hiv_drug_construct3_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                      
                    WHEN @missed_hiv_drug_construct4 = "" THEN
                    
                        UPDATE flat_table2 SET missed_hiv_drug_construct4 = in_field_value_text, missed_hiv_drug_construct4_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                       
                    WHEN @missed_hiv_drug_construct5 = "" THEN
                    
                        UPDATE flat_table2 SET missed_hiv_drug_construct5 = in_field_value_text, missed_hiv_drug_construct5_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                        
                    ELSE
                    
                        SET @enc_id = encounter_id;                  
    
                END CASE;
                                            
            END IF;       
    
        #######################################################################################################################################
    
        WHEN @what_was_the_patient_adherence_for_this_drug THEN
        
            SET @what_was_the_patient_adherence_for_this_drug1 = (SELECT COALESCE(what_was_the_patient_adherence_for_this_drug1, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @what_was_the_patient_adherence_for_this_drug2 = (SELECT COALESCE(what_was_the_patient_adherence_for_this_drug2, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @what_was_the_patient_adherence_for_this_drug3 = (SELECT COALESCE(what_was_the_patient_adherence_for_this_drug3, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @what_was_the_patient_adherence_for_this_drug4 = (SELECT COALESCE(what_was_the_patient_adherence_for_this_drug4, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @what_was_the_patient_adherence_for_this_drug5 = (SELECT COALESCE(what_was_the_patient_adherence_for_this_drug5, '') FROM flat_table2 WHERE ID = in_visit_id);
        
            IF in_visit_id = 0 THEN
            
                CASE 
                
                    WHEN @what_was_the_patient_adherence_for_this_drug1 = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, what_was_the_patient_adherence_for_this_drug1, what_was_the_patient_adherence_for_this_drug1_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                       
                    WHEN @what_was_the_patient_adherence_for_this_drug2 = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, what_was_the_patient_adherence_for_this_drug2, what_was_the_patient_adherence_for_this_drug2_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                        
                    WHEN @what_was_the_patient_adherence_for_this_drug3 = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, what_was_the_patient_adherence_for_this_drug3, what_was_the_patient_adherence_for_this_drug3_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                      
                    WHEN @what_was_the_patient_adherence_for_this_drug4 = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, what_was_the_patient_adherence_for_this_drug4, what_was_the_patient_adherence_for_this_drug4_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                       
                    WHEN @what_was_the_patient_adherence_for_this_drug5 = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, what_was_the_patient_adherence_for_this_drug5, what_was_the_patient_adherence_for_this_drug5_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                                    
                    ELSE
                    
                        SET @enc_id = encounter_id;                  
                
                END CASE;
            
            ELSE 
            
                CASE 
                
                    WHEN @what_was_the_patient_adherence_for_this_drug1 = "" THEN
                    
                        UPDATE flat_table2 SET what_was_the_patient_adherence_for_this_drug1 = in_field_value_numeric, what_was_the_patient_adherence_for_this_drug1_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                       
                    WHEN @what_was_the_patient_adherence_for_this_drug2 = "" THEN
                    
                        UPDATE flat_table2 SET what_was_the_patient_adherence_for_this_drug2 = in_field_value_numeric, what_was_the_patient_adherence_for_this_drug2_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                        
                    WHEN @what_was_the_patient_adherence_for_this_drug3 = "" THEN
                    
                        UPDATE flat_table2 SET what_was_the_patient_adherence_for_this_drug3 = in_field_value_numeric, what_was_the_patient_adherence_for_this_drug3_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                      
                    WHEN @what_was_the_patient_adherence_for_this_drug4 = "" THEN
                    
                        UPDATE flat_table2 SET what_was_the_patient_adherence_for_this_drug4 = in_field_value_numeric, what_was_the_patient_adherence_for_this_drug4_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                       
                    WHEN @what_was_the_patient_adherence_for_this_drug5 = "" THEN
                    
                        UPDATE flat_table2 SET what_was_the_patient_adherence_for_this_drug5 = in_field_value_numeric, what_was_the_patient_adherence_for_this_drug5_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                                    
                    ELSE
                    
                        SET @enc_id = encounter_id;                  
                
                END CASE;
                                            
            END IF;       
    
        #######################################################################################################################################
    
        WHEN @amount_of_drug_remaining_at_home THEN
        
            SET @amount_of_drug1_remaining_at_home = (SELECT COALESCE(amount_of_drug1_remaining_at_home, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @amount_of_drug2_remaining_at_home = (SELECT COALESCE(amount_of_drug2_remaining_at_home, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @amount_of_drug3_remaining_at_home = (SELECT COALESCE(amount_of_drug3_remaining_at_home, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @amount_of_drug4_remaining_at_home = (SELECT COALESCE(amount_of_drug4_remaining_at_home, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @amount_of_drug5_remaining_at_home = (SELECT COALESCE(amount_of_drug5_remaining_at_home, '') FROM flat_table2 WHERE ID = in_visit_id);
        
            IF in_visit_id = 0 THEN
            
                CASE 
                
                    WHEN @amount_of_drug1_remaining_at_home = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, amount_of_drug1_remaining_at_home, amount_of_drug1_remaining_at_home_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                       
                    WHEN @amount_of_drug2_remaining_at_home = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, amount_of_drug2_remaining_at_home, amount_of_drug2_remaining_at_home_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                        
                    WHEN @amount_of_drug3_remaining_at_home = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, amount_of_drug3_remaining_at_home, amount_of_drug3_remaining_at_home_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                      
                    WHEN @amount_of_drug4_remaining_at_home = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, amount_of_drug4_remaining_at_home, amount_of_drug4_remaining_at_home_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                       
                    WHEN @amount_of_drug5_remaining_at_home = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, amount_of_drug5_remaining_at_home, amount_of_drug5_remaining_at_home_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                                    
                    ELSE
                    
                        SET @enc_id = encounter_id;                  
                
                END CASE;
            
            ELSE 
            
                CASE 
                
                    WHEN @amount_of_drug1_remaining_at_home = "" THEN
                    
                        UPDATE flat_table2 SET amount_of_drug1_remaining_at_home = in_field_value_numeric, amount_of_drug1_remaining_at_home_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                       
                    WHEN @amount_of_drug2_remaining_at_home = "" THEN
                    
                        UPDATE flat_table2 SET amount_of_drug2_remaining_at_home = in_field_value_numeric, amount_of_drug2_remaining_at_home_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                        
                    WHEN @amount_of_drug3_remaining_at_home = "" THEN
                    
                        UPDATE flat_table2 SET amount_of_drug3_remaining_at_home = in_field_value_numeric, amount_of_drug3_remaining_at_home_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                      
                    WHEN @amount_of_drug4_remaining_at_home = "" THEN
                    
                        UPDATE flat_table2 SET amount_of_drug4_remaining_at_home = in_field_value_numeric, amount_of_drug4_remaining_at_home_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                       
                    WHEN @amount_of_drug5_remaining_at_home = "" THEN
                    
                        UPDATE flat_table2 SET amount_of_drug5_remaining_at_home = in_field_value_numeric, amount_of_drug5_remaining_at_home_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                                    
                    ELSE
                    
                        SET @enc_id = encounter_id;                  
                
                END CASE;
                                            
            END IF;       
    
        ###############################################################################################################################################
    
        WHEN @amount_of_drug_brought_to_clinic THEN
        
            SET @amount_of_drug1_brought_to_clinic = (SELECT COALESCE(amount_of_drug1_brought_to_clinic, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @amount_of_drug2_brought_to_clinic = (SELECT COALESCE(amount_of_drug2_brought_to_clinic, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @amount_of_drug3_brought_to_clinic = (SELECT COALESCE(amount_of_drug3_brought_to_clinic, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @amount_of_drug4_brought_to_clinic = (SELECT COALESCE(amount_of_drug4_brought_to_clinic, '') FROM flat_table2 WHERE ID = in_visit_id);
            
            SET @amount_of_drug5_brought_to_clinic = (SELECT COALESCE(amount_of_drug5_brought_to_clinic, '') FROM flat_table2 WHERE ID = in_visit_id);
        
            IF in_visit_id = 0 THEN
            
                CASE 
                
                    WHEN @amount_of_drug1_brought_to_clinic = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, amount_of_drug1_brought_to_clinic, amount_of_drug1_brought_to_clinic_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                       
                    WHEN @amount_of_drug2_brought_to_clinic = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, amount_of_drug2_brought_to_clinic, amount_of_drug2_brought_to_clinic_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                        
                    WHEN @amount_of_drug3_brought_to_clinic = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, amount_of_drug3_brought_to_clinic, amount_of_drug3_brought_to_clinic_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                      
                    WHEN @amount_of_drug4_brought_to_clinic = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, amount_of_drug4_brought_to_clinic, amount_of_drug4_brought_to_clinic_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                       
                    WHEN @amount_of_drug5_brought_to_clinic = "" THEN
                    
                        INSERT INTO flat_table2 (patient_id, visit_date, amount_of_drug5_brought_to_clinic, amount_of_drug5_brought_to_clinic_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
                                   
                    ELSE
                    
                        SET @enc_id = encounter_id;                  
                 
                END CASE;
            
            ELSE 
            
                CASE 
                
                    WHEN @amount_of_drug1_brought_to_clinic = "" THEN
                    
                        UPDATE flat_table2 SET amount_of_drug1_brought_to_clinic = in_field_value_numeric, amount_of_drug1_brought_to_clinic_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                       
                    WHEN @amount_of_drug2_brought_to_clinic = "" THEN
                    
                        UPDATE flat_table2 SET amount_of_drug2_brought_to_clinic = in_field_value_numeric, amount_of_drug2_brought_to_clinic_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                        
                    WHEN @amount_of_drug3_brought_to_clinic = "" THEN
                    
                        UPDATE flat_table2 SET amount_of_drug3_brought_to_clinic = in_field_value_numeric, amount_of_drug3_brought_to_clinic_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                      
                    WHEN @amount_of_drug4_brought_to_clinic = "" THEN
                    
                        UPDATE flat_table2 SET amount_of_drug4_brought_to_clinic = in_field_value_numeric, amount_of_drug4_brought_to_clinic_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                       
                    WHEN @amount_of_drug5_brought_to_clinic = "" THEN
                    
                        UPDATE flat_table2 SET amount_of_drug5_brought_to_clinic = in_field_value_numeric, amount_of_drug5_brought_to_clinic_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                                    
                    ELSE
                    
                        SET @enc_id = encounter_id;                  
                
                END CASE;
                                            
            END IF;       
    
    ##########################################################################################################################################
    
        WHEN @condoms THEN
        
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, condoms, condoms_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_text, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET condoms = in_field_value_numeric, condoms_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF; 
        
        WHEN @appointment_date THEN
        
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, appointment_date, appointment_date_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_datetime, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET appointment_date = in_field_value_datetime, appointment_date_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;       
    
        WHEN @transfer_out_location THEN
        
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, transfer_out_location, transfer_out_location_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_text, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET transfer_out_location = in_field_value_text, transfer_out_location_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;       
    
        WHEN @regimen_category THEN
        
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, regimen_category, regimen_category_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_text, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET regimen_category = in_field_value_text, regimen_category_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;       
    
        WHEN @Weight THEN
        
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, Weight, Weight_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET Weight = in_field_value_numeric, Weight_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;       
    
        WHEN @Height THEN
        
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, Height, Height_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET Height = in_field_value_numeric, Height_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;         
    
        WHEN @Temperature THEN
        
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, Temperature, Temperature_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET Temperature = in_field_value_numeric, Temperature_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;           
    
        WHEN @BMI THEN
        
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, BMI, BMI_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET BMI = in_field_value_numeric, BMI_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;               
    
        WHEN @systolic_blood_pressure THEN
        
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, systolic_blood_pressure, systolic_blood_pressure_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET systolic_blood_pressure = in_field_value_numeric, systolic_blood_pressure_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;                  
    
        WHEN @diastolic_blood_pressure THEN
        
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, diastolic_blood_pressure, diastolic_blood_pressure_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET diastolic_blood_pressure = in_field_value_numeric, diastolic_blood_pressure_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;                    
    
        WHEN @weight_for_height THEN
        
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, weight_for_height, weight_for_height_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET weight_for_height = in_field_value_numeric, weight_for_height_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;                      
    
        WHEN @weight_for_age THEN
        
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, weight_for_age, weight_for_age_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET weight_for_age = in_field_value_numeric, weight_for_age_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;                     
    
        WHEN @height_for_age THEN
        
            IF in_visit_id = 0 THEN
            
                INSERT INTO flat_table2 (patient_id, visit_date, height_for_age, height_for_age_enc_id) VALUES (in_patient_id, in_visit_date, in_field_value_numeric, encounter_id);
            
            ELSE 
            
                UPDATE flat_table2 SET height_for_age = in_field_value_numeric, height_for_age_enc_id = encounter_id WHERE flat_table2.id = in_visit_id;
                
            END IF;              
            
        WHEN @ever_received_art THEN
           
            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET ever_received_art = @answer WHERE flat_table1.patient_id= in_patient_id;
                             
        WHEN @date_last_taken_arv THEN

            UPDATE flat_table1 SET date_art_last_taken = in_field_value_datetime, date_art_last_taken_v_date = in_visit_date WHERE flat_table1.patient_id= in_patient_id;

        WHEN @art_in_2_months THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET taken_art_in_last_two_months = @answer, taken_art_in_last_two_months_v_date = in_visit_date WHERE flat_table1.patient_id= in_patient_id;

        WHEN @art_in_2_weeks THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET taken_art_in_last_two_weeks = @answer WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @last_arv_reg THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET last_art_drugs_taken = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @ever_reg_4_art THEN    

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET ever_registered_at_art_clinic = @answer, ever_registered_at_art_v_date = in_visit_date WHERE flat_table1.patient_id= in_patient_id;
		         
        WHEN @has_transfer_letter THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET has_transfer_letter = @answer WHERE flat_table1.patient_id = patient_id  ;				                    
                            
        WHEN @art_init_loc THEN
				  
				  SET @answer = (SELECT name FROM location WHERE location_id = in_field_value_text);
				 
				 	IF @answer = NULL THEN 
	    			UPDATE flat_table1 SET location_of_art_initialization = "Unknown" WHERE flat_table1.patient_id = patient_id ;
    			ELSE
    					UPDATE flat_table1 SET location_of_art_initialization = @answer WHERE flat_table1.patient_id = patient_id ;

					END IF;
				 
        WHEN @date_started_art THEN

            UPDATE flat_table1 SET date_started_art = in_field_value_datetime WHERE flat_table1.patient_id= in_patient_id;

				WHEN @cd4_count_loc THEN
					
				 SET @answer = (SELECT name FROM location WHERE location_id = in_field_value_text);
				 
				 	IF @answer = NULL THEN 
	    			UPDATE flat_table1 SET cd4_count_location = "Unknown" WHERE flat_table1.patient_id = patient_id ;
    			ELSE
    				UPDATE flat_table1 SET cd4_count_location = @answer WHERE flat_table1.patient_id = patient_id ;

					END IF;
				
				WHEN @cd4_percent_loc THEN
								 
    			UPDATE flat_table1 SET cd4_count_location = in_field_value_text WHERE flat_table1.patient_id = patient_id ;
				
        WHEN @cd4_count_date THEN

            UPDATE flat_table1 SET cd4_count_datetime = in_field_value_datetime WHERE flat_table1.patient_id= in_patient_id;                           				                                              
	         
        WHEN @cd4_count_percent THEN

            UPDATE flat_table1 SET cd4_count_percent = in_field_value_numeric WHERE flat_table1.patient_id= in_patient_id;
         
        WHEN @cd4_percent_less_than_25 THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET cd4_percent_less_than_25 = @answer WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @cd4_count_less_than_250 THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET cd4_count_less_than_250 = @answer WHERE flat_table1.patient_id= in_patient_id;
                                                        
        WHEN @cd4_count_less_than_350 THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET cd4_count_less_than_350 = @answer WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @lymphocyte_count_date THEN

            UPDATE flat_table1 SET lymphocyte_count_date = in_field_value_datetime WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @lymphocyte_count THEN

            UPDATE flat_table1 SET lymphocyte_count = in_field_value_numeric WHERE flat_table1.patient_id= in_patient_id;

        WHEN @asymptomatic THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET asymptomatic = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @pers_gnrl_lymphadenopathy THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET persistent_generalized_lymphadenopathy = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @unspecified_stage_1_cond THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET unspecified_stage_1_cond = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @molluscumm_contagiosum THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET molluscumm_contagiosum = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @wart_virus_infection_extensive THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET wart_virus_infection_extensive = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @oral_ulcerations_recurrent THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET oral_ulcerations_recurrent = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @parotid_enlargement_pers_unexp THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

        UPDATE flat_table1 SET parotid_enlargement_persistent_unexplained = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @lineal_gingival_erythema THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET lineal_gingival_erythema = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @herpes_zoster THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET herpes_zoster = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @resp_tract_infections_rec THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET respiratory_tract_infections_recurrent = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @unspecified_stage2_condition THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET unspecified_stage2_condition = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @angular_chelitis THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET angular_chelitis = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @papular_prurtic_eruptions THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET papular_pruritic_eruptions = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @hepatosplenomegaly_unexplained THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET hepatosplenomegaly_unexplained = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @oral_hairy_leukoplakia THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET oral_hairy_leukoplakia = @answer WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @severe_weight_loss THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET severe_weight_loss = @answer WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @fever_persistent_unexplained THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET fever_persistent_unexplained = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @pulmonary_tuberculosis THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET pulmonary_tuberculosis = @answer, pulmonary_tuberculosis_v_date = in_visit_date WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @pulmonary_tuberculosis_last_2_years THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET pulmonary_tuberculosis_last_2_years = @answer, pulmonary_tuberculosis_last_2_years_v_date = in_visit_date WHERE flat_table1.patient_id= in_patient_id;

        WHEN @severe_bacterial_infection THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET severe_bacterial_infection = @answer WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @bacterial_pnuemonia THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET bacterial_pnuemonia = @answer WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @symptomatic_lymphoid_interstitial_pnuemonitis THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET symptomatic_lymphoid_interstitial_pnuemonitis = @answer WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @chronic_hiv_assoc_lung_disease THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET chronic_hiv_assoc_lung_disease = @answer WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @unspecified_stage3_condition THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET unspecified_stage3_condition = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @aneamia THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET aneamia = @answer WHERE flat_table1.patient_id= in_patient_id;
		
        WHEN @neutropaenia THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET neutropaenia = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @thrombocytopaenia_chronic THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET thrombocytopaenia_chronic = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @diarhoea THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET diarhoea = @answer WHERE flat_table1.patient_id= in_patient_id;
		         
        WHEN @oral_candidiasis THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET oral_candidiasis = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @acute_necrotizing_ulcerative_gingivitis THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET acute_necrotizing_ulcerative_gingivitis = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @lymph_node_tuberculosis THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET lymph_node_tuberculosis = @answer WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @toxoplasmosis_of_brain THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET toxoplasmosis_of_the_brain  = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @cryptococcal_meningitis THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET cryptococcal_meningitis = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @progressive_multifocal_leukoencephalopathy THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET progressive_multifocal_leukoencephalopathy = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @disseminated_mycosis THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET disseminated_mycosis = @answer WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @candidiasis_of_oesophagus THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET candidiasis_of_oesophagus = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @extrapulmonary_tuberculosis THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET extrapulmonary_tuberculosis = @answer, extrapulmonary_tuberculosis_v_date = in_visit_date WHERE flat_table1.patient_id= in_patient_id;

        WHEN @cerebral_non_hodgkin_lymphoma THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET cerebral_non_hodgkin_lymphoma = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @hiv_encephalopathy THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET hiv_encephalopathy = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @bacterial_infections_severe_recurrent  THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET bacterial_infections_severe_recurrent = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @unspecified_stage_4_condition THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET unspecified_stage_4_condition = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @pnuemocystis_pnuemonia THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET pnuemocystis_pnuemonia = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @disseminated_non_tuberculosis_mycobactierial_infection THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET disseminated_non_tuberculosis_mycobacterial_infection = @answer WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @cryptosporidiosis THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET cryptosporidiosis = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @isosporiasis THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET isosporiasis = @answer WHERE flat_table1.patient_id= in_patient_id;
                            
        WHEN @symptomatic_hiv_asscoiated_nephropathy THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET symptomatic_hiv_associated_nephropathy = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @chronic_herpes_simplex_infection THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET chronic_herpes_simplex_infection = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @cytomegalovirus_infection THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET cytomegalovirus_infection = @answer WHERE flat_table1.patient_id= in_patient_id;
				                        
        WHEN @toxoplasomis_of_the_brain_1month THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET toxoplasomis_of_the_brain_1month = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @recto_vaginal_fitsula THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET recto_vaginal_fitsula = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @pnuemocystis_pnuemonia THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET pnuemocystis_pnuemonia = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @mod_wght_loss_less_thanequal_to_10_perc THEN 

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET moderate_weight_loss_less_than_or_equal_to_10_percent_unexpl = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @seborrhoeic_dermatitis THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET seborrhoeic_dermatitis = @answer WHERE flat_table1.patient_id= in_patient_id;
				                        
        WHEN @hepatitis_b_or_c_infection THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET hepatitis_b_or_c_infection = @answer WHERE flat_table1.patient_id= in_patient_id;
				                        
        WHEN @kaposis_sarcoma THEN  

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET kaposis_sarcoma = @answer, kaposis_sarcoma_v_date = in_visit_date WHERE flat_table1.patient_id= in_patient_id;

        WHEN @non_typhoidal_salmonella_bacteraemia_recurrent THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET non_typhoidal_salmonella_bacteraemia_recurrent = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @leishmaniasis_atypical_disseminated  THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET leishmaniasis_atypical_disseminated = @answer WHERE flat_table1.patient_id= in_patient_id;

        WHEN @cerebral_or_b_cell_non_hodgkin_lymphoma  THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET cerebral_or_b_cell_non_hodgkin_lymphoma = @answer WHERE flat_table1.patient_id= in_patient_id;
				                        
        WHEN @invasive_cancer_of_cervix THEN

            SET @answer = (SELECT name from concept_name LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                WHERE  concept.concept_id = in_field_value_coded AND voided = 0 AND retired = 0 LIMIT 1);

            UPDATE flat_table1 SET invasive_cancer_of_cervix = @answer WHERE flat_table1.patient_id= in_patient_id;

        ELSE
        
            SET @enc_id = encounter_id;                  
    
    END CASE;
    
END$$

DELIMITER ;

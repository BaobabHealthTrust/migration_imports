DELIMITER $$

DROP PROCEDURE IF EXISTS `proc_update_other_field`$$

CREATE PROCEDURE `proc_update_other_field`(
    IN in_patient_id INT, 
    IN in_concept_id INT,
    IN in_value_coded INT, 
    IN encounter_id INT
)

BEGIN

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
                    WHERE name = 'CD4 count less than 350' AND voided = 0 AND retired = 0 LIMIT 1);                            
                    
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
                    
    SET @who_crit_stage = (SELECT concept_name.concept_id FROM concept_name concept_name 
                    LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                    WHERE name = 'Who stages criteria present' AND voided = 0 AND retired = 0 LIMIT 1);
                 
    IF (@who_crit_stage = in_concept_id) THEN
      SET @in_concept_id = in_value_coded;
    ELSE
      SET @in_concept_id = in_concept_id;
    END IF;

	CASE @in_concept_id
		
        WHEN @ever_received_art THEN
           
            UPDATE flat_table1 SET ever_received_art = NULL WHERE flat_table1.patient_id = patient_id ;
                             
        WHEN @date_last_taken_arv THEN

            UPDATE flat_table1 SET date_art_last_taken = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @art_in_2_months THEN
            			
            UPDATE flat_table1 SET taken_art_in_last_two_months = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @art_in_2_weeks THEN
	
            UPDATE flat_table1 SET taken_art_in_last_two_weeks = NULL WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @last_arv_reg THEN

            UPDATE flat_table1 SET last_art_drugs_taken = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @ever_reg_4_art THEN    

            UPDATE flat_table1 SET ever_registered_at_art_clinic = NULL WHERE flat_table1.patient_id = patient_id ;
	             
        WHEN @has_transfer_letter THEN

            UPDATE flat_table1 SET has_transfer_letter = NULL WHERE flat_table1.patient_id = patient_id  ;				                    
                            
        WHEN @art_init_loc THEN
              			
            UPDATE flat_table1 SET location_of_art_initialization = NULL WHERE flat_table1.patient_id = patient_id ;
                                               
        WHEN @date_started_art THEN

            UPDATE flat_table1 SET date_started_art = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @cd4_count_loc THEN

            UPDATE flat_table1 SET cd4_count_location = NULL WHERE flat_table1.patient_id = patient_id ;
 				
 				WHEN @cd4_percent_loc THEN               

            UPDATE flat_table1 SET cd4_count_location = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @cd4_count_date THEN

            UPDATE flat_table1 SET cd4_count_datetime = NULL WHERE flat_table1.patient_id = patient_id ;	               			                                              
        WHEN @cd4_count THEN

            UPDATE flat_table1 SET cd4_count = NULL WHERE flat_table1.patient_id = patient_id ;
            UPDATE flat_table1 SET cd4_count_modifier = NULL WHERE flat_table1.patient_id = patient_id ;
             
        WHEN @cd4_count_percent THEN

            UPDATE flat_table1 SET cd4_count_percent = NULL WHERE flat_table1.patient_id = patient_id ;
         
        WHEN @cd4_percent_less_than_25 THEN

            UPDATE flat_table1 SET cd4_percent_less_than_25 = NULL WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @cd4_count_less_than_250 THEN

            UPDATE flat_table1 SET cd4_count_less_than_250 = NULL WHERE flat_table1.patient_id = patient_id ;
                                                        
        WHEN @cd4_count_less_than_350 THEN

            UPDATE flat_table1 SET cd4_count_less_than_250 = NULL WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @lymphocyte_count_date THEN

            UPDATE flat_table1 SET lymphocyte_count_date = in_field_value_datetime WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @lymphocyte_count THEN

            UPDATE flat_table1 SET lymphocyte_count = in_field_value_numeric WHERE flat_table1.patient_id = patient_id ;

        WHEN @asymptomatic THEN

            UPDATE flat_table1 SET asymptomatic = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @pers_gnrl_lymphadenopathy THEN

            UPDATE flat_table1 SET persistent_generalized_lymphadenopathy = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @unspecified_stage_1_cond THEN

            UPDATE flat_table1 SET unspecified_stage_1_cond = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @molluscumm_contagiosum THEN

            UPDATE flat_table1 SET molluscumm_contagiosum = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @wart_virus_infection_extensive THEN
		
            UPDATE flat_table1 SET wart_virus_infection_extensive = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @oral_ulcerations_recurrent THEN

            UPDATE flat_table1 SET oral_ulcerations_recurrent = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @parotid_enlargement_pers_unexp THEN

            UPDATE flat_table1 SET parotid_enlargement_persistent_unexplained = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @lineal_gingival_erythema THEN

            UPDATE flat_table1 SET lineal_gingival_erythema = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @herpes_zoster THEN

            UPDATE flat_table1 SET herpes_zoster = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @resp_tract_infections_rec THEN

            UPDATE flat_table1 SET respiratory_tract_infections_recurrent = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @unspecified_stage2_condition THEN

            UPDATE flat_table1 SET unspecified_stage2_condition = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @angular_chelitis THEN

            UPDATE flat_table1 SET angular_chelitis = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @papular_prurtic_eruptions THEN

            UPDATE flat_table1 SET papular_pruritic_eruptions = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @hepatosplenomegaly_unexplained THEN

            UPDATE flat_table1 SET hepatosplenomegaly_unexplained = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @oral_hairy_leukoplakia THEN

            UPDATE flat_table1 SET oral_hairy_leukoplakia = NULL WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @severe_weight_loss THEN

            UPDATE flat_table1 SET severe_weight_loss = NULL WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @fever_persistent_unexplained THEN

            UPDATE flat_table1 SET fever_persistent_unexplained = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @pulmonary_tuberculosis THEN

            UPDATE flat_table1 SET pulmonary_tuberculosis = NULL WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @pulmonary_tuberculosis_last_2_years THEN

            UPDATE flat_table1 SET pulmonary_tuberculosis_last_2_years = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @severe_bacterial_infection THEN

            UPDATE flat_table1 SET severe_bacterial_infection = NULL WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @bacterial_pnuemonia THEN

            UPDATE flat_table1 SET bacterial_pnuemonia = NULL WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @symptomatic_lymphoid_interstitial_pnuemonitis THEN

            UPDATE flat_table1 SET symptomatic_lymphoid_interstitial_pnuemonitis = NULL WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @chronic_hiv_assoc_lung_disease THEN

            UPDATE flat_table1 SET chronic_hiv_assoc_lung_disease = NULL WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @unspecified_stage3_condition THEN

            UPDATE flat_table1 SET unspecified_stage3_condition = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @aneamia THEN

            UPDATE flat_table1 SET aneamia = NULL WHERE flat_table1.patient_id = patient_id ;
	
        WHEN @neutropaenia THEN

            UPDATE flat_table1 SET neutropaenia = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @thrombocytopaenia_chronic THEN

            UPDATE flat_table1 SET thrombocytopaenia_chronic = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @diarhoea THEN

            UPDATE flat_table1 SET diarhoea = NULL WHERE flat_table1.patient_id = patient_id ;
	             
        WHEN @oral_candidiasis THEN

            UPDATE flat_table1 SET oral_candidiasis = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @acute_necrotizing_ulcerative_gingivitis THEN

            UPDATE flat_table1 SET acute_necrotizing_ulcerative_gingivitis = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @lymph_node_tuberculosis THEN

            UPDATE flat_table1 SET lymph_node_tuberculosis = NULL WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @toxoplasmosis_of_brain THEN

            UPDATE flat_table1 SET toxoplasmosis_of_the_brain  = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @cryptococcal_meningitis THEN

            UPDATE flat_table1 SET cryptococcal_meningitis = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @progressive_multifocal_leukoencephalopathy THEN

            UPDATE flat_table1 SET progressive_multifocal_leukoencephalopathy = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @disseminated_mycosis THEN

            UPDATE flat_table1 SET disseminated_mycosis = NULL WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @candidiasis_of_oesophagus THEN

            UPDATE flat_table1 SET candidiasis_of_oesophagus = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @extrapulmonary_tuberculosis THEN

            UPDATE flat_table1 SET extrapulmonary_tuberculosis = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @cerebral_non_hodgkin_lymphoma THEN

            UPDATE flat_table1 SET cerebral_non_hodgkin_lymphoma = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @hiv_encephalopathy THEN

            UPDATE flat_table1 SET hiv_encephalopathy = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @bacterial_infections_severe_recurrent  THEN

            UPDATE flat_table1 SET bacterial_infections_severe_recurrent = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @unspecified_stage_4_condition THEN

            UPDATE flat_table1 SET unspecified_stage_4_condition = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @pnuemocystis_pnuemonia THEN

            UPDATE flat_table1 SET pnuemocystis_pnuemonia = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @disseminated_non_tuberculosis_mycobactierial_infection THEN

            UPDATE flat_table1 SET disseminated_non_tuberculosis_mycobacterial_infection = NULL WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @cryptosporidiosis THEN

            UPDATE flat_table1 SET cryptosporidiosis = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @isosporiasis THEN

            UPDATE flat_table1 SET isosporiasis = NULL WHERE flat_table1.patient_id = patient_id ;
                            
        WHEN @symptomatic_hiv_asscoiated_nephropathy THEN

            UPDATE flat_table1 SET symptomatic_hiv_associated_nephropathy = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @chronic_herpes_simplex_infection THEN

            UPDATE flat_table1 SET chronic_herpes_simplex_infection = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @cytomegalovirus_infection THEN

            UPDATE flat_table1 SET cytomegalovirus_infection = NULL WHERE flat_table1.patient_id = patient_id ;
			                            
        WHEN @toxoplasomis_of_the_brain_1month THEN

            UPDATE flat_table1 SET toxoplasomis_of_the_brain_1month = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @recto_vaginal_fitsula THEN

            UPDATE flat_table1 SET recto_vaginal_fitsula = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @mod_wght_loss_less_thanequal_to_10_perc THEN 

            UPDATE flat_table1 SET moderate_weight_loss_less_than_or_equal_to_10_percent_unexpl = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @seborrhoeic_dermatitis THEN

            UPDATE flat_table1 SET seborrhoeic_dermatitis = NULL WHERE flat_table1.patient_id = patient_id ;
			                            
        WHEN @hepatitis_b_or_c_infection THEN

            UPDATE flat_table1 SET hepatitis_b_or_c_infection = NULL WHERE flat_table1.patient_id = patient_id ;
			                            
        WHEN @kaposis_sarcoma THEN  

            UPDATE flat_table1 SET kaposis_sarcoma = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @non_typhoidal_salmonella_bacteraemia_recurrent THEN

            UPDATE flat_table1 SET non_typhoidal_salmonella_bacteraemia_recurrent = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @leishmaniasis_atypical_disseminated  THEN

            UPDATE flat_table1 SET leishmaniasis_atypical_disseminated = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @cerebral_or_b_cell_non_hodgkin_lymphoma  THEN

            UPDATE flat_table1 SET cerebral_or_b_cell_non_hodgkin_lymphoma = NULL WHERE flat_table1.patient_id = patient_id ;
			                            
        WHEN @invasive_cancer_of_cervix THEN

            UPDATE flat_table1 SET invasive_cancer_of_cervix = NULL WHERE flat_table1.patient_id = patient_id ;

        WHEN @pnuemocystis_pnuemonia THEN

            UPDATE flat_table1 SET pnuemocystis_pnuemonia = NULL WHERE flat_table1.patient_id = patient_id ;

				ELSE
						SET @new = patient_id;

    END CASE;
    
END$$

DELIMITER ;

# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130512004616) do

  create_table "anc_visit_encounters", :force => true do |t|
    t.integer "visit_encounter_id",                   :null => false
    t.integer "old_enc_id",                           :null => false
    t.integer "patient_id",                           :null => false
    t.string  "antenatal_clinic_patient_appointment"
    t.string  "call_id"
    t.string  "reason_for_not_attending_anc"
    t.date    "last_anc_visit_date"
    t.date    "next_anc_visit_date"
    t.string  "location"
    t.date    "encounter_datetime",                   :null => false
    t.date    "date_created",                         :null => false
    t.string  "creator"
  end

  create_table "art_visit_encounters", :force => true do |t|
    t.integer  "visit_encounter_id",                                                  :null => false
    t.integer  "old_enc_id",                                                          :null => false
    t.integer  "patient_id",                                                          :null => false
    t.string   "patient_pregnant",                   :limit => 25
    t.string   "patient_breast_feeding",             :limit => 25
    t.string   "using_family_planning_method",       :limit => 25
    t.string   "family_planning_method_used",        :limit => 25
    t.string   "abdominal_pains",                    :limit => 25
    t.string   "anorexia",                           :limit => 25
    t.string   "cough",                              :limit => 25
    t.string   "diarrhoea",                          :limit => 25
    t.string   "fever",                              :limit => 25
    t.string   "jaundice",                           :limit => 25
    t.string   "leg_pain_numbness",                  :limit => 25
    t.string   "vomit",                              :limit => 25
    t.string   "weight_loss",                        :limit => 25
    t.string   "peripheral_neuropathy",              :limit => 25
    t.string   "hepatitis",                          :limit => 25
    t.string   "anaemia",                            :limit => 25
    t.string   "lactic_acidosis",                    :limit => 25
    t.string   "lipodystrophy",                      :limit => 25
    t.string   "skin_rash",                          :limit => 25
    t.string   "other_symptoms",                     :limit => 25
    t.string   "drug_induced_Abdominal_pains",       :limit => 25
    t.string   "drug_induced_anorexia",              :limit => 25
    t.string   "drug_induced_diarrhoea",             :limit => 25
    t.string   "drug_induced_jaundice",              :limit => 25
    t.string   "drug_induced_leg_pain_numbness",     :limit => 25
    t.string   "drug_induced_vomit",                 :limit => 25
    t.string   "drug_induced_peripheral_neuropathy", :limit => 25
    t.string   "drug_induced_hepatitis",             :limit => 25
    t.string   "drug_induced_anaemia",               :limit => 25
    t.string   "drug_induced_lactic_acidosis",       :limit => 25
    t.string   "drug_induced_lipodystrophy",         :limit => 25
    t.string   "drug_induced_skin_rash",             :limit => 25
    t.string   "drug_induced_other_symptom",         :limit => 25
    t.string   "tb_status"
    t.string   "refer_to_clinician",                 :limit => 25
    t.string   "prescribe_arv",                      :limit => 25
    t.string   "drug_name_brought_to_clinic1"
    t.string   "drug_quantity_brought_to_clinic1",   :limit => 25
    t.string   "drug_left_at_home1"
    t.string   "drug_name_brought_to_clinic2"
    t.string   "drug_quantity_brought_to_clinic2",   :limit => 25
    t.string   "drug_left_at_home2",                 :limit => 25
    t.string   "drug_name_brought_to_clinic3"
    t.string   "drug_quantity_brought_to_clinic3",   :limit => 25
    t.string   "drug_left_at_home3",                 :limit => 25
    t.string   "drug_name_brought_to_clinic4"
    t.string   "drug_quantity_brought_to_clinic4",   :limit => 25
    t.string   "drug_left_at_home4",                 :limit => 25
    t.string   "arv_regimen"
    t.string   "prescribe_cpt",                      :limit => 25
    t.string   "prescribe_ipt",                      :limit => 25
    t.integer  "number_of_condoms_given"
    t.string   "depo_provera_given",                 :limit => 25
    t.string   "continue_treatment_at_clinic",       :limit => 25
    t.string   "continue_art",                       :limit => 25
    t.string   "location"
    t.boolean  "voided",                                           :default => false, :null => false
    t.string   "void_reason"
    t.datetime "encounter_datetime"
    t.date     "date_voided"
    t.integer  "voided_by"
    t.datetime "date_created"
    t.string   "creator"
  end

  create_table "baby_delivery_encounters", :force => true do |t|
    t.integer "visit_encounter_id",   :null => false
    t.integer "old_enc_id",           :null => false
    t.integer "patient_id",           :null => false
    t.string  "delivered"
    t.string  "call_id"
    t.string  "health_facility_name"
    t.date    "delivery_date"
    t.string  "delivery_location"
    t.string  "location"
    t.date    "encounter_datetime",   :null => false
    t.date    "date_created",         :null => false
    t.string  "creator"
  end

  create_table "birth_plan_encounters", :force => true do |t|
    t.integer "visit_encounter_id",  :null => false
    t.integer "old_enc_id",          :null => false
    t.integer "patient_id",          :null => false
    t.date    "go_to_hospital_date"
    t.string  "call_id"
    t.string  "delivery_location"
    t.string  "birth_plan"
    t.string  "location"
    t.date    "encounter_datetime",  :null => false
    t.date    "date_created",        :null => false
    t.string  "creator"
  end

  create_table "child_health_symptoms_encounters", :force => true do |t|
    t.integer "visit_encounter_id",                              :null => false
    t.integer "old_enc_id",                                      :null => false
    t.integer "patient_id",                                      :null => false
    t.string  "diarrhea"
    t.string  "cough"
    t.string  "fast_breathing"
    t.string  "skin_dryness"
    t.string  "eye_infection"
    t.string  "fever"
    t.string  "vomiting"
    t.string  "other"
    t.string  "crying"
    t.string  "not_eating"
    t.string  "very_sleepy"
    t.string  "unconscious"
    t.string  "sleeping"
    t.string  "feeding_problems"
    t.string  "bowel_movements"
    t.string  "skin_infections"
    t.string  "umbilicus_infection"
    t.string  "growth_milestones"
    t.string  "accessing_healthcare_services"
    t.string  "fever_of_7_days_or_more"
    t.string  "diarrhea_for_14_days_or_more"
    t.string  "blood_in_stool"
    t.string  "cough_for_21_days_or_more"
    t.string  "not_eating_or_drinking_anything"
    t.string  "red_eye_for_4_days_or_more_with_visual_problems"
    t.string  "potential_chest_indrawing"
    t.string  "call_id"
    t.string  "very_sleepy_or_unconscious"
    t.string  "convulsions_sign"
    t.string  "convulsions_symptom"
    t.string  "skin_rashes"
    t.string  "vomiting_everything"
    t.string  "swollen_hands_or_feet_sign"
    t.string  "severity_of_fever"
    t.string  "severity_of_cough"
    t.string  "severity_of_red_eye"
    t.string  "severity_of_diarrhea"
    t.string  "visual_problems"
    t.string  "gained_or_lost_weight"
    t.string  "location"
    t.date    "encounter_datetime",                              :null => false
    t.date    "date_created",                                    :null => false
    t.string  "creator"
  end

  create_table "first_visit_encounters", :force => true do |t|
    t.integer  "visit_encounter_id",                                              :null => false
    t.integer  "old_enc_id",                                                      :null => false
    t.integer  "patient_id",                                                      :null => false
    t.string   "agrees_to_follow_up",            :limit => 40
    t.date     "date_of_hiv_pos_test"
    t.boolean  "date_of_hiv_pos_test_estimated",               :default => false
    t.string   "location_of_hiv_pos_test"
    t.string   "arv_number_at_that_site"
    t.string   "location_of_art_initiation"
    t.string   "taken_arvs_in_last_two_months"
    t.string   "taken_arvs_in_last_two_weeks"
    t.string   "has_transfer_letter"
    t.string   "site_transferred_from"
    t.date     "date_of_art_initiation"
    t.string   "ever_registered_at_art",         :limit => 25
    t.string   "ever_received_arv",              :limit => 25
    t.string   "last_arv_regimen"
    t.date     "date_last_arv_taken"
    t.date     "date_last_arv_taken_estimated"
    t.float    "weight"
    t.float    "height"
    t.float    "bmi"
    t.string   "location"
    t.boolean  "voided",                                       :default => false, :null => false
    t.string   "void_reason"
    t.date     "date_voided"
    t.integer  "voided_by"
    t.datetime "encounter_datetime"
    t.datetime "date_created",                                                    :null => false
    t.string   "creator"
  end

  create_table "general_reception_encounters", :force => true do |t|
    t.integer  "visit_encounter_id",                    :null => false
    t.integer  "old_enc_id",                            :null => false
    t.integer  "patient_id",                            :null => false
    t.string   "patient_present"
    t.string   "location"
    t.boolean  "voided",             :default => false, :null => false
    t.string   "void_reason"
    t.date     "date_voided"
    t.integer  "voided_by"
    t.datetime "encounter_datetime"
    t.datetime "date_created"
    t.string   "creator"
  end

  create_table "give_drugs_encounters", :force => true do |t|
    t.integer  "visit_encounter_id",                       :null => false
    t.integer  "old_enc_id",                               :null => false
    t.integer  "patient_id",                               :null => false
    t.string   "pres_drug_name1"
    t.string   "pres_dosage1"
    t.string   "pres_frequency1"
    t.string   "pres_drug_name2"
    t.string   "pres_dosage2"
    t.string   "pres_frequency2"
    t.string   "pres_drug_name3"
    t.string   "pres_dosage3"
    t.string   "pres_frequency3"
    t.string   "pres_drug_name4"
    t.string   "pres_dosage4"
    t.string   "pres_frequency4"
    t.string   "pres_drug_name5"
    t.string   "pres_dosage5"
    t.string   "pres_frequency5"
    t.string   "prescription_duration"
    t.string   "dispensed_drug_name1"
    t.string   "dispensed_dosage1"
    t.integer  "dispensed_quantity1"
    t.string   "dispensed_drug_name2"
    t.string   "dispensed_dosage2"
    t.integer  "dispensed_quantity2"
    t.string   "dispensed_drug_name3"
    t.string   "dispensed_dosage3"
    t.integer  "dispensed_quantity3"
    t.string   "dispensed_drug_name4"
    t.string   "dispensed_dosage4"
    t.integer  "dispensed_quantity4"
    t.string   "dispensed_drug_name5"
    t.string   "dispensed_dosage5"
    t.integer  "dispensed_quantity5"
    t.datetime "appointment_date"
    t.string   "regimen_category"
    t.string   "location"
    t.boolean  "voided",                :default => false, :null => false
    t.string   "void_reason"
    t.date     "date_voided"
    t.integer  "voided_by"
    t.datetime "encounter_datetime"
    t.datetime "date_created",                             :null => false
    t.string   "creator",                                  :null => false
  end

  create_table "guardians", :force => true do |t|
    t.integer "patient_id",                      :null => false
    t.integer "relative_id",                     :null => false
    t.string  "name"
    t.string  "relationship"
    t.string  "family_name"
    t.string  "gender"
    t.boolean "voided",       :default => false, :null => false
    t.string  "void_reason"
    t.date    "date_voided"
    t.integer "voided_by"
    t.date    "date_created",                    :null => false
    t.string  "creator",                         :null => false
  end

  create_table "hiv_reception_encounters", :force => true do |t|
    t.integer  "visit_encounter_id",                    :null => false
    t.integer  "old_enc_id",                            :null => false
    t.integer  "patient_id",                            :null => false
    t.integer  "guardian"
    t.string   "patient_present"
    t.string   "guardian_present"
    t.string   "location"
    t.boolean  "voided",             :default => false, :null => false
    t.string   "void_reason"
    t.date     "date_voided"
    t.integer  "voided_by"
    t.datetime "encounter_datetime"
    t.datetime "date_created"
    t.string   "creator"
  end

  create_table "hiv_staging_encounters", :force => true do |t|
    t.integer  "visit_encounter_id",                                                                            :null => false
    t.integer  "old_enc_id",                                                                                    :null => false
    t.integer  "patient_id",                                                                                    :null => false
    t.string   "patient_pregnant",                                             :limit => 25
    t.string   "patient_breast_feeding",                                       :limit => 25
    t.string   "cd4_count_available",                                          :limit => 25
    t.integer  "cd4_count"
    t.string   "cd4_count_modifier",                                           :limit => 5
    t.float    "cd4_count_percentage"
    t.date     "date_of_cd4_count"
    t.string   "asymptomatic",                                                 :limit => 25
    t.string   "persistent_generalized_lymphadenopathy",                       :limit => 25
    t.string   "unspecified_stage_1_cond",                                     :limit => 25
    t.string   "molluscumm_contagiosum",                                       :limit => 25
    t.string   "wart_virus_infection_extensive",                               :limit => 25
    t.string   "oral_ulcerations_recurrent",                                   :limit => 25
    t.string   "parotid_enlargement_persistent_unexplained",                   :limit => 25
    t.string   "lineal_gingival_erythema",                                     :limit => 25
    t.string   "herpes_zoster",                                                :limit => 25
    t.string   "respiratory_tract_infections_recurrent",                       :limit => 25
    t.string   "unspecified_stage2_condition",                                 :limit => 25
    t.string   "angular_chelitis",                                             :limit => 25
    t.string   "papular_prurtic_eruptions",                                    :limit => 25
    t.string   "hepatosplenomegaly_unexplained",                               :limit => 25
    t.string   "oral_hairy_leukoplakia",                                       :limit => 25
    t.string   "severe_weight_loss",                                           :limit => 25
    t.string   "fever_persistent_unexplained",                                 :limit => 25
    t.string   "pulmonary_tuberculosis",                                       :limit => 25
    t.string   "pulmonary_tuberculosis_last_2_years",                          :limit => 25
    t.string   "severe_bacterial_infection",                                   :limit => 25
    t.string   "bacterial_pnuemonia",                                          :limit => 25
    t.string   "symptomatic_lymphoid_interstitial_pnuemonitis",                :limit => 25
    t.string   "chronic_hiv_assoc_lung_disease",                               :limit => 25
    t.string   "unspecified_stage3_condition",                                 :limit => 25
    t.string   "aneamia",                                                      :limit => 25
    t.string   "neutropaenia",                                                 :limit => 25
    t.string   "thrombocytopaenia_chronic",                                    :limit => 25
    t.string   "diarhoea",                                                     :limit => 25
    t.string   "oral_candidiasis",                                             :limit => 25
    t.string   "acute_necrotizing_ulcerative_gingivitis",                      :limit => 25
    t.string   "lymph_node_tuberculosis",                                      :limit => 25
    t.string   "toxoplasmosis_of_brain",                                       :limit => 25
    t.string   "cryptococcal_meningitis",                                      :limit => 25
    t.string   "progressive_multifocal_leukoencephalopathy",                   :limit => 25
    t.string   "disseminated_mycosis",                                         :limit => 25
    t.string   "candidiasis_of_oesophagus",                                    :limit => 25
    t.string   "extrapulmonary_tuberculosis",                                  :limit => 25
    t.string   "cerebral_non_hodgkin_lymphoma",                                :limit => 25
    t.string   "kaposis",                                                      :limit => 25
    t.string   "hiv_encephalopathy",                                           :limit => 25
    t.string   "bacterial_infections_severe_recurrent",                        :limit => 25
    t.string   "unspecified_stage_4_condition",                                :limit => 25
    t.string   "pnuemocystis_pnuemonia",                                       :limit => 25
    t.string   "disseminated_non_tuberculosis_mycobactierial_infection",       :limit => 25
    t.string   "cryptosporidiosis",                                            :limit => 25
    t.string   "isosporiasis",                                                 :limit => 25
    t.string   "symptomatic_hiv_asscoiated_nephropathy",                       :limit => 25
    t.string   "chronic_herpes_simplex_infection",                             :limit => 25
    t.string   "cytomegalovirus_infection",                                    :limit => 25
    t.string   "toxoplasomis_of_the_brain_1month",                             :limit => 25
    t.string   "recto_vaginal_fitsula",                                        :limit => 25
    t.string   "hiv_wasting_syndrome",                                         :limit => 25
    t.string   "cryptococcal_meningitis_or_other_eptb_cryptococcosis",         :limit => 25
    t.string   "candidiasis_of_oesophagus_trachea_bronchi_or_lungs",           :limit => 25
    t.string   "severe_unexplained_wasting_malnutrition",                      :limit => 25
    t.string   "diarrhoea_chronic_less_1_month_unexplained",                   :limit => 25
    t.string   "moderate_weight_loss_10_unexplained",                          :limit => 25
    t.string   "cd4_percentage_available",                                     :limit => 25
    t.string   "acute_necrotizing_ulcerative_stomatitis_gingivitis_or_period", :limit => 25
    t.string   "moderate_unexplained_wasting_malnutrition",                    :limit => 25
    t.string   "diarrhoea_persistent_unexplained_14_days_or_more",             :limit => 25
    t.string   "acute_ulcerative_mouth_infections",                            :limit => 25
    t.string   "anaemia_unexplained_8_g_dl",                                   :limit => 25
    t.string   "atypical_mycobacteriosis_disseminated_or_lung",                :limit => 25
    t.string   "bacterial_infections_sev_recurrent_excluding_pneumonia",       :limit => 25
    t.string   "cancer_cervix",                                                :limit => 25
    t.string   "chronic_herpes_simplex_infection_genital",                     :limit => 25
    t.string   "cryptosporidiosis_chronic_with_diarrhoea",                     :limit => 25
    t.string   "cytomegalovirus_infection_retinitis_or_other_organ",           :limit => 25
    t.string   "cytomegalovirus_of_an_organ_other_than_liver",                 :limit => 25
    t.string   "fungal_nail_infections",                                       :limit => 25
    t.string   "herpes_simplex_infection_mucocutaneous_visceral",              :limit => 25
    t.string   "hiv_associated_cardiomyopathy",                                :limit => 25
    t.string   "hiv_associated_nephropathy",                                   :limit => 25
    t.string   "invasive_cancer_cervix",                                       :limit => 25
    t.string   "isosporiasis_1_month",                                         :limit => 25
    t.string   "leishmaniasis_atypical_disseminated",                          :limit => 25
    t.string   "minor_mucocutaneous_manifestations_seborrheic_dermatitis",     :limit => 25
    t.string   "moderate_unexplained_malnutrition",                            :limit => 25
    t.string   "molluscum_contagiosum_extensive",                              :limit => 25
    t.string   "non_typhoidal_salmonella_bacteraemia_recurrent",               :limit => 25
    t.string   "oral_candidiasis_from_age_2_months",                           :limit => 25
    t.string   "oral_thrush",                                                  :limit => 25
    t.string   "perform_extended_staging",                                     :limit => 25
    t.string   "pneumocystis_carinii_pneumonia",                               :limit => 25
    t.string   "pneumonia_severe",                                             :limit => 25
    t.string   "recurrent_bacteraemia_or_sepsis_with_nts",                     :limit => 25
    t.string   "recurrent_severe_presumed_pneumonia",                          :limit => 25
    t.string   "recurrent_upper_respiratory_tract_bac_sinusitis",              :limit => 25
    t.string   "seborrhoeic_dermatitis",                                       :limit => 25
    t.string   "sepsis_severe",                                                :limit => 25
    t.string   "tb_lymphadenopathy",                                           :limit => 25
    t.string   "unexplained_anaemia_neutropenia_or_thrombocytopenia",          :limit => 25
    t.string   "visceral_leishmaniasis",                                       :limit => 25
    t.string   "reason_for_starting_art",                                      :limit => 25
    t.string   "who_stage"
    t.string   "location"
    t.boolean  "voided",                                                                     :default => false, :null => false
    t.string   "void_reason"
    t.date     "date_voided"
    t.integer  "voided_by"
    t.datetime "encounter_datetime"
    t.datetime "date_created"
    t.string   "creator"
  end

  create_table "maternal_health_symptoms_encounters", :force => true do |t|
    t.integer "visit_encounter_id",                         :null => false
    t.integer "old_enc_id",                                 :null => false
    t.integer "patient_id",                                 :null => false
    t.string  "abdominal_pain"
    t.string  "method_of_family_planning"
    t.string  "patient_using_family_planning"
    t.string  "current_complaints_or_symptoms"
    t.string  "family_planning"
    t.string  "other"
    t.string  "infertility"
    t.string  "acute_abdominal_pain"
    t.string  "vaginal_bleeding_during_pregnancy"
    t.string  "postnatal_bleeding"
    t.string  "healthcare_visits"
    t.string  "nutrition"
    t.string  "body_changes"
    t.string  "discomfort"
    t.string  "concerns"
    t.string  "emotions"
    t.string  "warning_signs"
    t.string  "routines"
    t.string  "beliefs"
    t.string  "babys_growth"
    t.string  "milestones"
    t.string  "prevention"
    t.string  "heavy_vaginal_bleeding_during_pregnancy"
    t.string  "excessive_postnatal_bleeding"
    t.string  "severe_headache"
    t.string  "call_id"
    t.string  "fever_during_pregnancy_sign"
    t.string  "fever_during_pregnancy_symptom"
    t.string  "postnatal_fever_sign"
    t.string  "postnatal_fever_symptom"
    t.string  "headaches"
    t.string  "fits_or_convulsions_sign"
    t.string  "fits_or_convulsions_symptom"
    t.string  "swollen_hands_or_feet_sign"
    t.string  "swollen_hands_or_feet_symptom"
    t.string  "paleness_of_the_skin_and_tiredness_sign"
    t.string  "paleness_of_the_skin_and_tiredness_symptom"
    t.string  "no_fetal_movements_sign"
    t.string  "no_fetal_movements_symptom"
    t.string  "water_breaks_sign"
    t.string  "water_breaks_symptom"
    t.string  "postnatal_discharge_bad_smell"
    t.string  "problems_with_monthly_periods"
    t.string  "frequent_miscarriages"
    t.string  "vaginal_bleeding_not_during_pregnancy"
    t.string  "vaginal_itching"
    t.string  "birth_planning_male"
    t.string  "birth_planning_female"
    t.string  "satisfied_with_family_planning_method"
    t.string  "require_information_on_family_planning"
    t.string  "problems_with_family_planning_method"
    t.string  "location"
    t.date    "encounter_datetime",                         :null => false
    t.date    "date_created",                               :null => false
    t.string  "creator"
  end

  create_table "outcome_encounters", :force => true do |t|
    t.integer  "visit_encounter_id",                      :null => false
    t.integer  "old_enc_id",                              :null => false
    t.integer  "patient_id",                              :null => false
    t.string   "state"
    t.date     "outcome_date"
    t.string   "transferred_out_location"
    t.string   "location"
    t.integer  "voided",                   :default => 0, :null => false
    t.string   "void_reason"
    t.date     "date_voided"
    t.integer  "voided_by"
    t.datetime "encounter_datetime"
    t.datetime "date_created",                            :null => false
    t.string   "creator",                                 :null => false
  end

  create_table "outpatient_diagnosis_encounters", :force => true do |t|
    t.integer  "visit_encounter_id",                      :null => false
    t.integer  "old_enc_id",                              :null => false
    t.integer  "patient_id",                              :null => false
    t.string   "refer_to_anotha_hosp"
    t.string   "pri_diagnosis"
    t.string   "sec_diagnosis"
    t.string   "treatment1"
    t.string   "treatment2"
    t.string   "treatment3"
    t.string   "treatment4"
    t.string   "treatment5"
    t.string   "location"
    t.boolean  "voided",               :default => false, :null => false
    t.string   "void_reason"
    t.date     "date_voided"
    t.integer  "voided_by"
    t.datetime "encounter_datetime"
    t.datetime "date_created"
    t.string   "creator"
  end

  create_table "patient_outcomes", :force => true do |t|
    t.integer "visit_encounter_id"
    t.integer "outcome_id",         :null => false
    t.integer "patient_id",         :null => false
    t.string  "outcome_state"
    t.date    "outcome_date"
  end

  create_table "patient_records", :primary_key => "patient_id", :force => true do |t|
    t.string  "given_name",                                              :null => false
    t.string  "middle_name"
    t.string  "family_name"
    t.string  "gender",                 :limit => 25,                    :null => false
    t.date    "dob"
    t.text    "dob_estimated"
    t.integer "dead"
    t.string  "traditional_authority"
    t.string  "current_address"
    t.string  "landmark"
    t.string  "cellphone_number"
    t.string  "home_phone_number"
    t.string  "office_phone_number"
    t.string  "occupation"
    t.string  "nat_id"
    t.string  "art_number"
    t.string  "pre_art_number"
    t.string  "tb_number"
    t.string  "legacy_id"
    t.string  "legacy_id2"
    t.string  "legacy_id3"
    t.string  "new_nat_id"
    t.string  "prev_art_number"
    t.string  "filing_number"
    t.string  "archived_filing_number"
    t.boolean "voided",                               :default => false, :null => false
    t.string  "void_reason"
    t.date    "date_voided"
    t.integer "voided_by"
    t.date    "date_created",                                            :null => false
    t.string  "creator",                                                 :null => false
  end

  create_table "patients", :primary_key => "patient_id", :force => true do |t|
    t.string  "given_name"
    t.string  "middle_name"
    t.string  "family_name"
    t.string  "gender",                  :limit => 25
    t.date    "dob"
    t.text    "dob_estimated"
    t.integer "dead"
    t.string  "traditional_authority"
    t.string  "current_address"
    t.string  "home_village"
    t.string  "current_ta"
    t.string  "group_ta"
    t.string  "landmark"
    t.string  "cellphone_number"
    t.string  "home_phone_number"
    t.string  "office_phone_number"
    t.string  "occupation"
    t.integer "guardian_id"
    t.string  "nat_id"
    t.string  "art_number"
    t.string  "pre_art_number"
    t.string  "tb_number"
    t.string  "legacy_id"
    t.string  "legacy_id2"
    t.string  "legacy_id3"
    t.string  "new_nat_id"
    t.string  "prev_art_number"
    t.string  "filing_number"
    t.string  "archived_filing_number"
    t.string  "anc_connect_id"
    t.string  "ivr_code_id"
    t.string  "nearest_health_facility"
    t.boolean "voided",                                :default => false, :null => false
    t.string  "void_reason"
    t.date    "date_voided"
    t.integer "voided_by"
    t.date    "date_created",                                             :null => false
    t.string  "creator",                                                  :null => false
  end

  create_table "pre_art_visit_encounters", :force => true do |t|
    t.integer  "visit_encounter_id",                               :null => false
    t.integer  "old_enc_id",                                       :null => false
    t.integer  "patient_id",                                       :null => false
    t.string   "patient_pregnant",                   :limit => 25
    t.string   "patient_breast_feeding",             :limit => 25
    t.string   "abdominal_pains",                    :limit => 25
    t.string   "using_family_planning_method",       :limit => 25
    t.string   "family_planning_method_in_use"
    t.string   "anorexia",                           :limit => 25
    t.string   "cough",                              :limit => 25
    t.string   "diarrhoea",                          :limit => 25
    t.string   "fever",                              :limit => 25
    t.string   "jaundice",                           :limit => 25
    t.string   "leg_pain_numbness",                  :limit => 25
    t.string   "vomit",                              :limit => 25
    t.string   "weight_loss",                        :limit => 25
    t.string   "peripheral_neuropathy",              :limit => 25
    t.string   "hepatitis",                          :limit => 25
    t.string   "anaemia",                            :limit => 25
    t.string   "lactic_acidosis",                    :limit => 25
    t.string   "lipodystrophy",                      :limit => 25
    t.string   "skin_rash",                          :limit => 25
    t.string   "drug_induced_abdominal_pains",       :limit => 25
    t.string   "drug_induced_anorexia",              :limit => 25
    t.string   "drug_induced_diarrhoea",             :limit => 25
    t.string   "drug_induced_jaundice",              :limit => 25
    t.string   "drug_induced_leg_pain_numbness",     :limit => 25
    t.string   "drug_induced_vomit",                 :limit => 25
    t.string   "drug_induced_peripheral_neuropathy", :limit => 25
    t.string   "drug_induced_hepatitis",             :limit => 25
    t.string   "drug_induced_anaemia",               :limit => 25
    t.string   "drug_induced_lactic_acidosis",       :limit => 25
    t.string   "drug_induced_lipodystrophy",         :limit => 25
    t.string   "drug_induced_skin_rash",             :limit => 25
    t.string   "drug_induced_other_symptom",         :limit => 25
    t.string   "tb_status"
    t.string   "refer_to_clinician",                 :limit => 25
    t.string   "prescribe_cpt",                      :limit => 25
    t.string   "prescription_duration",              :limit => 25
    t.integer  "number_of_condoms_given"
    t.string   "prescribe_ipt",                      :limit => 25
    t.datetime "encounter_datetime"
    t.datetime "date_created"
    t.string   "location"
    t.string   "creator"
  end

  create_table "pregnancy_status_encounters", :force => true do |t|
    t.integer "visit_encounter_id", :null => false
    t.integer "old_enc_id",         :null => false
    t.integer "patient_id",         :null => false
    t.string  "pregnancy_status"
    t.string  "call_id"
    t.date    "pregnancy_due_date"
    t.date    "delivery_date"
    t.string  "location"
    t.date    "encounter_datetime", :null => false
    t.date    "date_created",       :null => false
    t.string  "creator"
  end

  create_table "registration_encounters", :force => true do |t|
    t.integer "visit_encounter_id", :null => false
    t.integer "old_enc_id",         :null => false
    t.integer "patient_id",         :null => false
    t.string  "call_id"
    t.string  "location"
    t.date    "encounter_datetime", :null => false
    t.date    "date_created",       :null => false
    t.string  "creator"
  end

  create_table "tips_and_reminders_encounters", :force => true do |t|
    t.integer "visit_encounter_id",         :null => false
    t.integer "old_enc_id",                 :null => false
    t.integer "patient_id",                 :null => false
    t.string  "telephone_number"
    t.string  "telephone_number_type"
    t.string  "who_is_present_as_quardian"
    t.string  "call_id"
    t.string  "on_tips_and_reminders"
    t.string  "type_of_message"
    t.string  "language_preference"
    t.string  "type_of_message_content"
    t.string  "location"
    t.date    "encounter_datetime",         :null => false
    t.date    "date_created",               :null => false
    t.string  "creator"
  end

  create_table "update_outcomes_encounters", :force => true do |t|
    t.integer "visit_encounter_id",   :null => false
    t.integer "old_enc_id",           :null => false
    t.integer "patient_id",           :null => false
    t.string  "outcome"
    t.string  "call_id"
    t.string  "health_facility_name"
    t.string  "reason_for_referral"
    t.string  "secondary_outcome"
    t.string  "location"
    t.date    "encounter_datetime",   :null => false
    t.date    "date_created",         :null => false
    t.string  "creator"
  end

  create_table "users", :force => true do |t|
    t.integer "person_id"
    t.integer "user_id"
    t.string  "username"
    t.string  "first_name"
    t.string  "middle_name"
    t.string  "last_name"
    t.string  "password"
    t.string  "salt"
    t.string  "user_role1"
    t.string  "user_role2"
    t.string  "user_role3"
    t.string  "user_role4"
    t.string  "user_role5"
    t.string  "user_role6"
    t.string  "user_role7"
    t.string  "user_role8"
    t.string  "user_role9"
    t.string  "user_role10"
    t.date    "date_created",                    :null => false
    t.boolean "voided",       :default => false, :null => false
    t.string  "void_reason"
    t.date    "date_voided"
    t.integer "voided_by"
    t.string  "creator",                         :null => false
  end

  create_table "visit_encounters", :force => true do |t|
    t.datetime "visit_date", :null => false
    t.integer  "patient_id", :null => false
  end

  create_table "vitals_encounters", :force => true do |t|
    t.integer  "visit_encounter_id",                    :null => false
    t.integer  "old_enc_id",                            :null => false
    t.integer  "patient_id",                            :null => false
    t.float    "weight"
    t.float    "height"
    t.float    "bmi"
    t.float    "weight_for_age"
    t.float    "height_for_age"
    t.float    "weight_for_height"
    t.string   "location"
    t.boolean  "voided",             :default => false, :null => false
    t.string   "void_reason"
    t.date     "date_voided"
    t.integer  "voided_by"
    t.datetime "encounter_datetime"
    t.datetime "date_created"
    t.string   "creator"
  end

end

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

ActiveRecord::Schema.define(:version => 20130130144218) do

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
    t.string  "gender",                 :limit => 25
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
    t.boolean "voided",                               :default => false, :null => false
    t.string  "void_reason"
    t.date    "date_voided"
    t.integer "voided_by"
    t.date    "date_created",                                            :null => false
    t.string  "creator",                                                 :null => false
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

end

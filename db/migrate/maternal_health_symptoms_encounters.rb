class CreateMaternalHealthSymptomsEncounters < ActiveRecord::Migration
  def self.up
ActiveRecord::Base.connection.execute <<EOF
drop table if exists `maternal_health_symptoms_encounters`
EOF

ActiveRecord::Base.connection.execute <<EOF
create table `maternal_health_symptoms_encounters`(
`id` int not null auto_increment primary key,
`visit_encounter_id` int not null,
`old_enc_id` int not null,
`patient_id` int not null,
`abdominal_pain` varchar(255), 
`method_of_family_planning` varchar(255), 
`patient_using_family_planning` varchar(255), 
`current_complaints_or_symptoms` varchar(255), 
`family_planning` varchar(255), 
`other` varchar(255), 
`infertility` varchar(255), 
`acute_abdominal_pain` varchar(255), 
`vaginal_bleeding_during_pregnancy` varchar(255), 
`postnatal_bleeding` varchar(255), 
`healthcare_visits` varchar(255), 
`nutrition` varchar(255), 
`body_changes` varchar(255), 
`discomfort` varchar(255), 
`concerns` varchar(255), 
`emotions` varchar(255), 
`warning_signs` varchar(255), 
`routines` varchar(255), 
`beliefs` varchar(255), 
`babys_growth` varchar(255), 
`milestones` varchar(255), 
`prevention` varchar(255), 
`heavy_vaginal_bleeding_during_pregnancy` varchar(255), 
`excessive_postnatal_bleeding` varchar(255), 
`severe_headache` varchar(255), 
`call_id` varchar(255), 
`fever_during_pregnancy_sign` varchar(255), 
`fever_during_pregnancy_symptom` varchar(255), 
`postnatal_fever_sign` varchar(255), 
`postnatal_fever_symptom` varchar(255), 
`headaches` varchar(255), 
`fits_or_convulsions_sign` varchar(255), 
`fits_or_convulsions_symptom` varchar(255), 
`swollen_hands_or_feet_sign` varchar(255), 
`swollen_hands_or_feet_symptom` varchar(255), 
`paleness_of_the_skin_and_tiredness_sign` varchar(255), 
`paleness_of_the_skin_and_tiredness_symptom` varchar(255), 
`no_fetal_movements_sign` varchar(255), 
`no_fetal_movements_symptom` varchar(255), 
`water_breaks_sign` varchar(255), 
`water_breaks_symptom` varchar(255), 
`postnatal_discharge_bad_smell` varchar(255), 
`problems_with_monthly_periods` varchar(255), 
`frequent_miscarriages` varchar(255), 
`vaginal_bleeding_not_during_pregnancy` varchar(255), 
`vaginal_itching` varchar(255), 
`birth_planning_male` varchar(255), 
`birth_planning_female` varchar(255), 
`satisfied_with_family_planning_method` varchar(255), 
`require_information_on_family_planning` varchar(255), 
`problems_with_family_planning_method` varchar(255), 
`location` varchar(255), 
`encounter_datetime` date not null, 
`date_created` date not null, 
`creator` varchar(255)

);

EOF

  end

  def self.down
    drop_table :maternal_health_symptoms_encounters
  end
end

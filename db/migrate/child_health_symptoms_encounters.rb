class CreateChildHealthSymptomsEncounters < ActiveRecord::Migration
  def self.up
ActiveRecord::Base.connection.execute <<EOF
drop table if exists `child_health_symptoms_encounters`
EOF

ActiveRecord::Base.connection.execute <<EOF
create table `child_health_symptoms_encounters`(
`id` int not null auto_increment primary key,
`visit_encounter_id` int not null,
`old_enc_id` int not null,
`patient_id` int not null,
`diarrhea` varchar(255),
`cough` varchar(255),
`fast_breathing` varchar(255),
`skin_dryness` varchar(255),
`eye_infection` varchar(255),
`fever` varchar(255),
`vomiting` varchar(255),
`other` varchar(255),
`crying` varchar(255),
`not_eating` varchar(255),
`very_sleepy` varchar(255),
`unconscious` varchar(255),
`sleeping` varchar(255),
`feeding_problems` varchar(255),
`bowel_movements` varchar(255),
`skin_infections` varchar(255),
`umbilicus_infection` varchar(255),
`growth_milestones` varchar(255),
`accessing_healthcare_services` varchar(255),
`fever_of_7_days_or_more` varchar(255),
`diarrhea_for_14_days_or_more` varchar(255),
`blood_in_stool` varchar(255),
`cough_for_21_days_or_more` varchar(255),
`not_eating_or_drinking_anything` varchar(255),
`red_eye_for_4_days_or_more_with_visual_problems` varchar(255),
`potential_chest_indrawing` varchar(255),
`call_id` varchar(255),
`very_sleepy_or_unconscious` varchar(255),
`convulsions_sign` varchar(255),
`convulsions_symptom` varchar(255),
`skin_rashes` varchar(255),
`vomiting_everything` varchar(255),
`swollen_hands_or_feet_sign` varchar(255),
`severity_of_fever` varchar(255),
`severity_of_cough` varchar(255),
`severity_of_red_eye` varchar(255),
`severity_of_diarrhea` varchar(255),
`visual_problems` varchar(255),
`gained_or_lost_weight` varchar(255),
`location` varchar(255),
`encounter_datetime` date not null,
`date_created` date not null,
`creator` varchar(255)

);

EOF

  end

  def self.down
    drop_table :child_health_symptoms_encounters
  end
end

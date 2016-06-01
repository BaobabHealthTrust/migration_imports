class CreateANCVisitEncounters < ActiveRecord::Migration
  def self.up
ActiveRecord::Base.connection.execute <<EOF
drop table if exists `anc_visit_encounters`
EOF

ActiveRecord::Base.connection.execute <<EOF
create table `anc_visit_encounters`(
`id` int not null auto_increment primary key,
`visit_encounter_id` int not null,
`old_enc_id` int not null,
`patient_id` int not null,
`antenatal_clinic_patient_appointment` varchar(255),
`call_id` varchar(255),
`reason_for_not_attending_anc` varchar(255),
`last_anc_visit_date` date not null,
`next_anc_visit_date` date not null,
`location` varchar(255),
`encounter_datetime` date not null,
`date_created` date not null,
`creator` varchar(255)

);

EOF

  end

  def self.down
    drop_table :anc_visit_encounters
  end
end

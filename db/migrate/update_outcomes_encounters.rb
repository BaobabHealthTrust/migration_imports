class CreateUpdateOutcomesEncounters < ActiveRecord::Migration
  def self.up
ActiveRecord::Base.connection.execute <<EOF
drop table if exists `update_ouctomes_encounters`
EOF

ActiveRecord::Base.connection.execute <<EOF
create table `update_outcomes_encounters`(
`id` int not null auto_increment primary key,
`visit_encounter_id`  int not null,
`old_enc_id` int not null,
`patient_id` int not null,
`outcome` varchar(255),
`call_id` varchar(255),
`health_facility_name` varchar(255),
`reason_for_referral` varchar(255),
`secondary_outcome` varchar(255),
`location` varchar(255),
`encounter_datetime` date not null,
`date_created` date not null,
`creator`  varchar(255)

);

EOF

  end

  def self.down
    drop_table :update_outcomes_encounters
  end
end

class CreateBirthPlanEncounters < ActiveRecord::Migration
  def self.up
ActiveRecord::Base.connection.execute <<EOF
drop table if exists `birth_plan_encounters`
EOF

ActiveRecord::Base.connection.execute <<EOF
create table `birth_plan_encounters`(
`id` int not null auto_increment primary key,
`visit_encounter_id` int not null,
`old_enc_id` int not null,
`patient_id` int not null,
`go_to_hospital_date` date,
`call_id`  varchar(255),
`delivery_location` varchar(255),
`birth_plan` varchar(255),
`location` varchar(255),
`encounter_datetime` date not null,
`date_created` date not null,
`creator` varchar(255)

);

EOF

  end

  def self.down
    drop_table :birth_plan_encounters
  end
end

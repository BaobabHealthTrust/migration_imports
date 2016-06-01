class CreateRegistrationEncounters < ActiveRecord::Migration
  def self.up
ActiveRecord::Base.connection.execute <<EOF
drop table if exists `registration_encounters`
EOF

ActiveRecord::Base.connection.execute <<EOF
create table `registration_encounters`(
`id` int not null auto_increment primary key,
`visit_encounter_id` int not null,
`old_enc_id` int not null,
`patient_id` int not null,
`call_id` varchar(255),
`location` varchar(255),
`encounter_datetime` date not null,
`date_created` date not null,
`creator` varchar(255) 

);

EOF

  end

  def self.down
    drop_table :registration_encounters
  end
end

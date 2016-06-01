class CreateTipsAndRemindersEncounters < ActiveRecord::Migration
  def self.up
ActiveRecord::Base.connection.execute <<EOF
drop table if exists `tips_and_reminders_encounters`
EOF

ActiveRecord::Base.connection.execute <<EOF
create table `tips_and_reminders_encounters`(
`id` int not null auto_increment primary key,
`visit_encounter_id` int not null,
`old_enc_id` int not null,
`patient_id` int not null,
`telephone_number` varchar(255),
`telephone_number_type` varchar(255),
`who_is_present_as_quardian` varchar(255),
`call_id` varchar(255),
`on_tips_and_reminders` varchar(255),
`type_of_message` varchar(255),
`language_preference` varchar(255),
`type_of_message_content` varchar(255),
`location` varchar(255),
`encounter_datetime` date not null,
`date_created` date not null,
`creator` varchar(255)

);

EOF

  end

  def self.down
    drop_table :tips_and_reminders_encounters
  end
end

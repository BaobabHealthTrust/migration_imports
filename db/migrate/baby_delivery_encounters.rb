class CreateBabyDeliveryEncounters < ActiveRecord::Migration
  def self.up
ActiveRecord::Base.connection.execute <<EOF
drop table if exists `baby_delivery_encounters`
EOF

ActiveRecord::Base.connection.execute <<EOF
create table `baby_delivery_encounters`(
`id` int not null auto_increment primary key,
`visit_encounter_id` int not null,
`old_enc_id` int not null,
`patient_id` int not null,
`delivered` varchar(255),
`call_id` varchar(255),
`health_facility_name` varchar(255),
`delivery_date`date not null),
`delivery_location` varchar(255),
`location` varchar(255),
`encounter_datetime` date not null,
`date_created` date not null),
`creator` varchar(255)

);

EOF

  end

  def self.down
    drop_table :baby_delivery_encounters
  end
end

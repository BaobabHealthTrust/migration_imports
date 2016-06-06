Source_db = YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart2']["database"]
CONN = ActiveRecord::Base.connection

def start
  #get all patients with ART startdate linked to HIV reception encounter
   call_log_details = Encounter.find_by_sql("SELECT
                                                  o.person_id,
                                                  o.encounter_id,
                                                  cl.call_log_id,
                                                  o.value_text,
                                                  cl.start_time,
                                                  cl.end_time,
                                                  cl.call_type,
                                                  cl.creator,
                                                  DATE(o.obs_datetime)
                                              FROM
                                                  openmrs_mnch_latest.call_log cl
                                                      left JOIN
                                                  openmrs_mnch_latest.obs o ON cl.call_log_id = o.value_text
                                              WHERE
                                                  o.concept_id = 8304
                                              group by call_log_id , o.creator , Date(o.obs_datetime)")

  #loop through each patient
  ( call_log_details || []).each do |patient|
    #insert the call_log details
     puts "............................working on #{patient.person_id}"
    ActiveRecord::Base.connection.execute <<EOF
INSERT INTO #{Source_db}.call_log (call_log_id, start_time, end_time, call_type, person_id, creator)
VALUES (#{patient.call_log_id}, '#{patient.start_time}', '#{patient.end_time}', #{patient.call_type}, #{patient.person_id}, #{patient.creator})
EOF

  end
end
start

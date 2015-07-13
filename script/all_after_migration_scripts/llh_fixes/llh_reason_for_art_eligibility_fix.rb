Source_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart2']["database"]

CONN = ActiveRecord::Base.connection

def start
  time_started = Time.now
  started_at =  Time.now.strftime("%Y-%m-%d-%H%M%S")

  puts "Starting the process at : #{time_started}"
  $failed_orders = File.open("./migration_output/#{started_at}-Failed_hiv_staging_fix.txt", "w")
  
  #get all patients in earliest_start_date
   eligible_patients = Patient.find_by_sql("SELECT * FROM #{Source_db}.earliest_start_date").map(&:patient_id)
  #raise eligible_patients.count.to_yaml
  #get all patients with reason for eligibility observation
  patients_with_reason_for_eligibility = Observation.find_by_sql("SELECT person_id FROM #{Source_db}.obs
                                                                  WHERE person_id IN (#{eligible_patients.join(',')})
                                                                  AND concept_id IN (7562, 7563)
                                                                  AND voided = 0
                                                                  GROUP BY person_id").map(&:person_id)

  #get all patients without reason for eligilibility obs
  patients_without_reason_for_eligibility = []
  patients_without_reason_for_eligibility = (eligible_patients - patients_with_reason_for_eligibility)
  
  #get all eligible patients with hiv_staging_encounter
  $eligible_patients_with_hiv_staging_encounter = Encounter.find_by_sql("SELECT patient_id, encounter_id, encounter_datetime, date_created, location_id, creator
                                                                          FROM #{Source_db}.encounter
                                                                          WHERE encounter_type = 52
                                                                          AND patient_id IN (#{patients_without_reason_for_eligibility.join(',')})
                                                                          AND voided = 0")
  
  #getting all reason_for_starting_art and who_Stage details from bart1_intermediate_bare_bones
  reason_for_starting_details = Encounter.find_by_sql("SELECT 
                                                            patient_id,
                                                            old_enc_id,
	                                                        CASE reason_for_starting_art
                                                              WHEN 'WHO stage 1 adult' THEN '9786'
                                                              WHEN  'WHO stage 2 adult' THEN '9788'
                                                              WHEN 'WHO stage 3 adult' THEN '9789'
                                                              WHEN 'WHO stage 4 adult' THEN '9792'
                                                              WHEN 'WHO stage 1 peds' THEN '9793'
                                                              WHEN 'WHO stage 2 peds' THEN '9796'
                                                              WHEN 'WHO stage 3 peds' THEN '9798'
                                                              WHEN 'WHO stage 4 peds' THEN '9800'
                                                              WHEN 'CD4 Count < 250' THEN '11336'
                                                              WHEN 'CD4 Count < 350' THEN '11264'
                                                              WHEN 'CD4 Count < 500' THEN '12589'
                                                              WHEN 'CD4 Count < 750' THEN '11266'
                                                              WHEN 'Presumed HIV Disease' THEN '10403'
                                                              WHEN 'Child HIV positive' THEN '1207'
                                                              WHEN 'PCR Test' THEN '863'
                                                              WHEN 'Pregnant' THEN '1915'
                                                              WHEN 'Breastfeeding' THEN '4002'
                                                            ELSE
                                                              reason_for_starting_art
                                                            END AS reason_for_eligibility_concept_name_id,
                                                            reason_for_starting_art,
                                                            CASE who_stage
                                                              WHEN 'WHO stage 1' THEN 3152
                                                              WHEN 'WHO stage 2' THEN 3153
                                                              WHEN 'WHO stage 3' THEN 12323
                                                              WHEN 'WHO stage 4' THEN 12324
	                                                        ELSE
	                                                          who_stage
                                                            END AS who_stage_concept_name_id,
                                                            who_stage,
                                                            encounter_datetime,
                                                            date_created
                                                        FROM
                                                            bart1_intermediate_bare_bones.hiv_staging_encounters
                                                        WHERE patient_id IN (#{patients_without_reason_for_eligibility.join(',')})")

  count = 0
  total_obs = reason_for_starting_details.length
  #loop through reason_for_starting_details
  (reason_for_starting_details || []).each do |patient|
   #check if patient exist in $eligible_patients_with_hiv_staging_encounter
   
   this_patient = $eligible_patients_with_hiv_staging_encounter.select{|pat| pat.patient_id == patient.patient_id}
   if !this_patient.blank?
     if this_patient.first.encounter_datetime == patient.encounter_datetime
      count += 1
      if !patient.reason_for_eligibility_concept_name_id.blank?
      #insert reason_for_eligibility_obs
      puts "working on patient_id: #{patient.patient_id}"
      @reason_for_elibility_concept_id = Encounter.find_by_sql("SELECT * FROM #{Source_db}.concept_name
                                                                WHERE concept_name_id = #{patient.reason_for_eligibility_concept_name_id}
                                                                AND voided = 0").map(&:concept_id)
      #insert who_stage
      @who_stage_concept_id = Encounter.find_by_sql("SELECT * FROM #{Source_db}.concept_name
                                                     WHERE concept_name_id = #{patient.who_stage_concept_name_id}
                                                     AND voided = 0").map(&:concept_id)
                                                                
	ActiveRecord::Base.connection.insert "           
INSERT INTO #{Source_db}.obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
VALUES (#{this_patient.first.patient_id}, 7563, #{this_patient.first.encounter_id}, '#{this_patient.first.encounter_datetime.to_date.strftime('%Y-%m-%d 00:00:02')}', #{this_patient.first.location_id}, #{@reason_for_elibility_concept_id}, #{patient.reason_for_eligibility_concept_name_id}, #{this_patient.first.creator}, (NOW()), (SELECT UUID()))"
    
   ActiveRecord::Base.connection.execute <<EOF
INSERT INTO #{Source_db}.obs (person_id, concept_id, encounter_id, obs_datetime, location_id , value_coded, value_coded_name_id, creator, date_created, uuid)
VALUES (#{this_patient.first.patient_id}, 7562, #{this_patient.first.encounter_id}, '#{this_patient.first.encounter_datetime.to_date.strftime('%Y-%m-%d 00:00:02')}', #{this_patient.first.location_id}, #{@who_stage_concept_id}, #{patient.who_stage_concept_name_id}, #{this_patient.first.creator}, (NOW()), (SELECT UUID()))
EOF
    end
      puts "Finished working on patient_id: #{patient.patient_id}"
   else
     puts  "Patient>>>>#{patient.patient_id} failed"
		 $failed_orders << "#{patient.patient_id} \n"
   end
  end
 end
end                                                                                                                            
start

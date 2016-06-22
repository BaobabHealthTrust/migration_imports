Source_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart']["database"]

CONN = ActiveRecord::Base.connection

def start
  #get all the patients with non-zch ARV_IDs
  non_zch_arv_ids_patients = Encounter.find_by_sql("SELECT * FROM #{Source_db}.patient_identifier
                                                    WHERE identifier_type = 18
                                                    AND identifier  LIKE '%MAT%'
                                                    AND voided = 0
                                                    GROUP BY patient_id")

  $flagged_pats = []
  #loop through to get the encounter_ids as they are in BART1
  (non_zch_arv_ids_patients || []).each do |patient|
    puts "working on patient #{patient.patient_id}........."

    #get all patient_encs as in bart1
    pat_encs = []
    pat_encs = Encounter.find_by_sql("select e.* from #{Source_db}.encounter e
                                      	inner join #{Source_db}.obs o on o.encounter_id = e.encounter_id and o.voided = 0
                                      where o.patient_id = #{patient.patient_id} GROUP BY e.encounter_id").map(&:encounter_id)
    if !pat_encs.blank?
      #check if the encs are all voided in bart2_dataset
      pat_bart2_migrated_encs  = Encounter.find_by_sql("SELECT * FROM openmrs_zomba_latest.encounter
                                                WHERE patient_id = #{patient.patient_id}
                                                AND encounter_id IN (#{pat_encs.join(', ')})
                                                AND voided = 0 GROUP BY encounter_type").map(&:encounter_type)
      #get encs after migration for the patient
      pat_bart2_after_migration_encs  = Encounter.find_by_sql("SELECT * FROM openmrs_zomba_latest.encounter
                                                WHERE patient_id = #{patient.patient_id}
                                                AND encounter_id NOT IN (#{pat_encs.join(', ')})
                                                AND voided = 0 GROUP BY encounter_type").map(&:encounter_type)

      #bart2_art_enc_types
      bart2_art_enc_types = [6, 7, 9, 25, 51, 52, 53, 54, 68, 119]

      if pat_bart2_migrated_encs.blank?
        #check if the patient does not have encs in bart2
        if !pat_bart2_after_migration_encs.blank?
           #check if encs include art enc_types
           art_encs = pat_bart2_after_migration_encs.select{|enc| bart2_art_enc_types.include?(enc)}
           if !art_encs.blank?
             #flag the patient
             #raise $failed_encs.write.to_yaml
             #self.flag_patient(patient.patient_id)
             $flagged_pats << patient.patient_id
             puts "#{patient.patient_id} : With ART encs"
           else
             #void ARV number
             self.void_arv_number(patient.patient_id)
           end
        else
          #void patient with associated things
          self.void_complete_patient(patient.patient_id)
        end
      else
        #check if the enc_types are ART encs
        pat_art_encs = pat_bart2_migrated_encs.select{|enc| bart2_art_enc_types.include?(enc)}
        if !pat_art_encs.blank?
          #flag the patient
          #raise patient.patient_id.to_yaml
          $flagged_pats << patient.patient_id
          #self.flag_patient(patient.patient_id)
          puts "#{patient.patient_id} : With ART encs"
        else
          #check if the patient does not have encs in bart2
          if !pat_bart2_after_migration_encs.blank?
             #check if encs include art enc_types
             art_encs = pat_bart2_after_migration_encs.select{|enc| bart2_art_enc_types.include?(enc)}
             if !art_encs.blank?
               #flag the patient
               #raise patient.patient_id.to_yaml
               $flagged_pats << patient.patient_id
               #self.flag_patient(patient.patient_id)
               puts "#{patient.patient_id} : With ART encs"
             else
               #void ARV number
               self.void_arv_number(patient.patient_id)
             end
          else
            #void patient with associated things
            self.void_complete_patient(patient.patient_id)
          end
        end
      end
    end
  end
  self.flag_patient($flagged_pats)

end

def self.void_arv_number(patient_id)
  #update patient_identifier table and void ARV_number
ActiveRecord::Base.connection.execute <<EOF
UPDATE openmrs_zomba_latest.patient_identifier
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE patient_id = patient_id
AND identifier_type = 4
EOF
end

def self.void_complete_patient(patient)
ActiveRecord::Base.connection.execute <<EOF
UPDATE openmrs_zomba_latest.patient
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE patient_id = #{patient}
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE openmrs_zomba_latest.person
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE person_id = #{patient}
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE openmrs_zomba_latest.person_address
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE person_id = #{patient}
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE openmrs_zomba_latest.patient_identifier
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE patient_id = #{patient}
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE openmrs_zomba_latest.person_attribute
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE person_id = #{patient}
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE openmrs_zomba_latest.obs
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE person_id = #{patient}
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE openmrs_zomba_latest.orders
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE patient_id = #{patient}
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE openmrs_zomba_latest.patient_program
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE patient_id = #{patient}
EOF
end

def self.flag_patient(patients)
  started_at = Time.now.strftime("%Y-%m-%d-%H%M%S")
  File.open("./migration_output/#{started_at}-non_zch_patients.txt", "w") do |pat|
    (patients || []).each do |p|
      pat.puts(p)
    end
  end
end
start

Source_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart2']["database"]

Source_dba= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart']["database"]


CONN = ActiveRecord::Base.connection

def start
  #get all the patients with non-zch ARV_IDs
  non_zch_arv_ids_patients = Encounter.find_by_sql("SELECT * FROM #{Source_dba}.patient_identifier
                                                    WHERE identifier_type = 18
                                                    AND identifier NOT LIKE '%ZCH%'
                                                    AND voided = 0
                                                    GROUP BY patient_id ")

  count = patients.length

  $flagged_pats = []
  #loop through to get the encounter_ids as they are in BART1
  (non_zch_arv_ids_patients || []).each do |patient|

    puts "working on patient #{patient.patient_id}........."

    #get all patient_encs as in bart1
    pat_encs = []
    pat_encs = Encounter.find_by_sql("select e.* from #{Source_dba}.encounter e
                                        inner join #{Source_dba}.obs o on o.encounter_id = e.encounter_id and o.voided = 0
                                      where o.patient_id = #{patient.patient_id} GROUP BY e.encounter_id
                                      union all
                                      select e.* from #{Source_dba}.encounter e
                                        inner join #{Source_dba}.orders o on o.encounter_id = e.encounter_id and o.voided = 0
                                      where e.patient_id = #{patient.patient_id} GROUP BY e.encounter_id").map(&:encounter_id)

    if !pat_encs.blank?
      #check if the encs are all voided in bart2_dataset
      pat_bart2_migrated_encs  = Encounter.find_by_sql("SELECT e.* FROM #{Source_db}.encounter e
                                                         INNER JOIN #{Source_db}.obs o ON o.encounter_id = e.encounter_id AND o.voided = 0
                                                         INNER JOIN #{Source_db}.orders ords ON ords.encounter_id = e.encounter_id and ords.voided = 0
                                                        WHERE e.patient_id = #{patient.patient_id}
                                                        AND e.encounter_id IN (#{pat_encs.join(', ')})
                                                        AND e.voided = 0
                                                        GROUP BY encounter_type").map(&:encounter_type)

      #get encs after migration for the patient
      pat_bart2_after_migration_encs  = Encounter.find_by_sql("SELECT * FROM #{Source_db}.encounter
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
             $flagged_pats << patient.patient_id
             puts "#{patient.patient_id} : With ART encs"
           else
             #void ARV number
             self.void_arv_number(patient)
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
          $flagged_pats << patient.patient_id
          puts "#{patient.patient_id} : With ART encs"
        else
          #check if the patient does not have encs in bart2
          if !pat_bart2_after_migration_encs.blank?
             #check if encs include art enc_types
             art_encs = pat_bart2_after_migration_encs.select{|enc| bart2_art_enc_types.include?(enc)}
             if !art_encs.blank?
               #flag the patient
               $flagged_pats << patient.patient_id
               puts "#{patient.patient_id} : With ART encs"
             else
               #void ARV number
               self.void_arv_number(patient)
             end
          else
            #void patient with associated things
            self.void_complete_patient(patient.patient_id)
          end
        end
      end
    end
    puts "#{count-=1}................ patient(s) to go"
  end
  self.flag_patient($flagged_pats)
  unvoid_all_opd_patient
end

#Connecting to bart2 dataset on the server
ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :host     => "192.168.0.15",
  :username => "root",
  :password => "only4u",
  :database => "openmrs_zch"
)

def self.void_arv_number(patient)
  ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0")
  #update patient_identifier table and void ARV_number
ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.patient_identifier
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE patient_id = #{patient.patient_id}
AND identifier_type = 4
AND identifier LIKE '%#{patient.identifier}%'
EOF
end

def self.void_complete_patient(patient)
ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.patient
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE patient_id = #{patient}
AND voided = 0
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.person
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE person_id = #{patient}
AND voided = 0
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.person_address
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE person_id = #{patient}
AND voided = 0
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.patient_identifier
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE patient_id = #{patient}
AND voided = 0
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.person_attribute
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE person_id = #{patient}
AND voided = 0
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.obs
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE person_id = #{patient}
AND voided = 0
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.orders
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE patient_id = #{patient}
AND voided = 0
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.patient_program
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE patient_id = #{patient}
AND voided = 0
EOF

ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.patient_state
SET voided = 1, voided_by = 1, void_reason = 'Not ZCH data', date_voided = NOW()
WHERE patient_program_id IN (SELECT patient_program_id FROM #{Source_db}.patient_program WHERE  patient_id = #{patient})
AND voided = 0
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

def unvoid_all_opd_patient
  #check if patient have OPD encs
  patient_opd_encs = Encounter.find_by_sql("SELECT * FROM  #{Source_db}.encounter
                                            WHERE encounter_type NOT IN (6, 7, 9, 25, 51, 52, 53, 54, 68, 119)
                                            AND void_reason = 'Not ZCH data' GROUP BY patient_id")

  (patient_opd_encs || []).each do |patient|
    #unvoid everything
     self.completely_unvoid_opd_patient(patient.patient_id)
  end
end

def self.completely_unvoid_opd_patient(patient_id)
  #update patient_identifier table and void ARV_number
  opd_encs = Encounter.find_by_sql("SELECT * FROM #{Source_db}.encounter WHERE  encounter_type NOT IN (6, 7, 9, 25, 51, 52, 53, 54, 68, 119)
                                    AND patient_id = #{patient_id}
                                    AND void_reason = 'Not ZCH data'
                                    AND voided = 1").map(&:encounter_id)

  puts "working on OPD patient #{patient_id}........."

  if !opd_encs.blank?
    ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0")
ActiveRecord::Base.connection.execute <<EOF
  UPDATE #{Source_db}.patient_identifier
  SET voided = 0, voided_by = NULL, void_reason = NULL, date_voided = NULL
  WHERE identifier_type IN (2, 3)
  AND void_reason = 'Not ZCH data'
  AND patient_id  = #{patient_id}
EOF

ActiveRecord::Base.connection.execute <<EOF
  UPDATE #{Source_db}.patient
  SET voided = 0, voided_by = NULL, void_reason = NULL, date_voided = NULL, date_changed = NOW(), changed_by = 1
  WHERE patient_id = patient_id
  AND void_reason = 'Not ZCH data'
  AND patient_id  = #{patient_id}
EOF

ActiveRecord::Base.connection.execute <<EOF
  UPDATE #{Source_db}.person
  SET voided = 0, voided_by = NULL, void_reason = NULL, date_voided = NULL, date_changed = NOW(), changed_by = 1
  WHERE void_reason = 'Not ZCH data'
  AND person_id  = #{patient_id}
EOF

ActiveRecord::Base.connection.execute <<EOF
  UPDATE #{Source_db}.person_address
  SET voided = 0, voided_by = NULL, void_reason = NULL, date_voided = NULL
  WHERE void_reason = 'Not ZCH data'
  AND person_id  = #{patient_id}
EOF

ActiveRecord::Base.connection.execute <<EOF
  UPDATE #{Source_db}.person_attribute
  SET voided = 0, voided_by = NULL, void_reason = NULL, date_voided = NULL, date_changed = NOW(), changed_by = 1
  WHERE void_reason = 'Not ZCH data'
  AND person_id  = #{patient_id}
EOF

ActiveRecord::Base.connection.execute <<EOF
  UPDATE #{Source_db}.obs
  SET voided = 0, voided_by = NULL, void_reason = NULL, date_voided = NULL
  WHERE void_reason = 'Not ZCH data'
  AND person_id  = #{patient_id}
  AND encounter_id IN (#{opd_encs.join(',')})
EOF

ActiveRecord::Base.connection.execute <<EOF
  UPDATE #{Source_db}.orders
  SET voided = 0, voided_by = NULL, void_reason = NULL, date_voided = NULL
  WHERE void_reason = 'Not ZCH data'
  AND patient_id  = #{patient_id}
  AND encounter_id IN (#{opd_encs.join(',')})
EOF

ActiveRecord::Base.connection.execute <<EOF
  UPDATE #{Source_db}.encounter
  SET voided = 0, voided_by = NULL, void_reason = NULL, date_voided = NULL, date_changed = NOW(), changed_by = 1
  WHERE void_reason = 'Not ZCH data'
  AND patient_id  = #{patient_id}
  AND encounter_id IN (#{opd_encs.join(',')})
EOF

ActiveRecord::Base.connection.execute <<EOF
  UPDATE #{Source_db}.patient_program
  SET voided = 0, voided_by = NULL, void_reason = NULL, date_voided = NULL, date_changed = NOW(), changed_by = 1
  WHERE void_reason = 'Not ZCH data'
  AND patient_id  = #{patient_id}
  AND patient_program_id = 14
EOF

ActiveRecord::Base.connection.execute <<EOF
  UPDATE #{Source_db}.patient_state
  SET voided = 0, voided_by = NULL, void_reason = NULL, date_voided = NULL, date_changed = NOW(), changed_by = 1
  WHERE void_reason = 'Not ZCH data'
  AND patient_program_id IN (SELECT patient_program_id FROM #{Source_db}.patient_program WHERE  patient_program_id = 14 AND patient_id = #{patient_id})
EOF
  end
end

start

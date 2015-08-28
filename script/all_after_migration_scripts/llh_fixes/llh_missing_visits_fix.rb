Source_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart2']["database"]

CONN = ActiveRecord::Base.connection

def start
  time_started = Time.now
  started_at =  Time.now.strftime("%Y-%m-%d-%H%M%S")

  ##get all patients that where migrated outside the normal migration
  patients = [17697]

  ##loop through each patient and get the visits per encounter_type
  (patients || []).each do |patient|
    puts "<<< working on patient: #{patient}>>>>"
    ##get hiv_reception encounters
    hiv_reception_encs_missed = Encounter.find_by_sql("SELECT 
                                                                encounter_datetime
                                                           FROM
                                                               bart1_intermediate_bare_bones.hiv_reception_encounters
                                                            WHERE
                                                                patient_id = #{patient}
                                                                    AND encounter_datetime NOT IN (SELECT 
                                                                        encounter_datetime
                                                                    FROM
                                                                        #{Source_db}.encounter
                                                                    WHERE
                                                                        patient_id = #{patient} AND voided = 0
                                                                            AND encounter_type = 51)").map(&:encounter_datetime)


    if !hiv_reception_encs_missed.blank?
      (hiv_reception_encs_missed || []).each do |enc_datetime|
         hiv_enc_datetime = enc_datetime.strftime("%Y-%m-%d %H:%M:%S")

     ActiveRecord::Base.connection.execute <<EOF
     CALL #{Source_db}.proc_import_hiv_reception_encounters_llh_missing_visit(#{patient}, '#{hiv_enc_datetime}')
EOF
      end
    end                                                                                                   
 
  ##get vitals_encounters
    hiv_vitals_encs_missed = Encounter.find_by_sql("SELECT 
                                                         encounter_datetime
                                                        FROM
                                                          bart1_intermediate_bare_bones.vitals_encounters
                                                        WHERE
                                                          patient_id = #{patient}
                                                        AND encounter_datetime NOT IN (SELECT encounter_datetime
                                                                                       FROM #{Source_db}.encounter
                                                                                       WHERE patient_id = #{patient} AND voided = 0
                                                                                       AND encounter_type = 6)").map(&:encounter_datetime)


    if !hiv_vitals_encs_missed.blank?
      (hiv_vitals_encs_missed || []).each do |enc_datetime|
         vit_enc_datetime = enc_datetime.strftime("%Y-%m-%d %H:%M:%S")

         ActiveRecord::Base.connection.execute <<EOF
         CALL #{Source_db}.proc_import_vitals_encounters_llh_missing_visit(#{patient}, '#{vit_enc_datetime}')
EOF
      end
    end

    ##get hiv_clinic_registration_encounters
    hiv_clinic_reg_encs_missed = Encounter.find_by_sql("SELECT 
                                                         encounter_datetime
                                                        FROM
                                                          bart1_intermediate_bare_bones.first_visit_encounters
                                                        WHERE
                                                          patient_id = #{patient}
                                                        AND encounter_datetime NOT IN (SELECT encounter_datetime
                                                                                       FROM #{Source_db}.encounter
                                                                                       WHERE patient_id = #{patient} AND voided = 0
                                                                                       AND encounter_type = 9)").map(&:encounter_datetime)


    if !hiv_clinic_reg_encs_missed.blank?
      (hiv_clinic_reg_encs_missed || []).each do |enc_datetime|
         reg_enc_datetime = enc_datetime.strftime("%Y-%m-%d %H:%M:%S")

         ActiveRecord::Base.connection.execute <<EOF
         CALL #{Source_db}.proc_import_first_visit_encounters_llh_missing_visit(#{patient}, '#{reg_enc_datetime}')
EOF
      end
    end

    ##get hiv_staging_encounters
    hiv_staging_encs_missed = Encounter.find_by_sql("SELECT 
                                                         encounter_datetime
                                                        FROM
                                                          bart1_intermediate_bare_bones.hiv_staging_encounters
                                                        WHERE
                                                          patient_id = #{patient}
                                                        AND encounter_datetime NOT IN (SELECT encounter_datetime
                                                                                       FROM #{Source_db}.encounter
                                                                                       WHERE patient_id = #{patient} AND voided = 0
                                                                                       AND encounter_type = 52)").map(&:encounter_datetime)


    if !hiv_staging_encs_missed.blank?
      (hiv_staging_encs_missed || []).each do |enc_datetime|
         staging_enc_datetime = enc_datetime.strftime("%Y-%m-%d %H:%M:%S")

         ActiveRecord::Base.connection.execute <<EOF
         CALL #{Source_db}.proc_import_hiv_staging_encounters_llh_missing_visit(#{patient}, '#{staging_enc_datetime}')
EOF
      end
    end

    ##get pre_art_visit encounters
    pre_art_visit_encs_missed = Encounter.find_by_sql("SELECT 
                                                         encounter_datetime
                                                        FROM
                                                          bart1_intermediate_bare_bones.pre_art_visit_encounters
                                                        WHERE
                                                          patient_id = #{patient}
                                                        AND encounter_datetime NOT IN (SELECT encounter_datetime
                                                                                       FROM #{Source_db}.encounter
                                                                                       WHERE patient_id = #{patient} AND voided = 0
                                                                                       AND encounter_type = 53)").map(&:encounter_datetime)


    if !pre_art_visit_encs_missed.blank?
      (pre_art_visit_encs_missed || []).each do |enc_datetime|
         pre_art_enc_datetime = enc_datetime.strftime("%Y-%m-%d %H:%M:%S")

         ActiveRecord::Base.connection.execute <<EOF
         CALL #{Source_db}.proc_import_pre_art_visit_encounters_llh_missing_visit(#{patient}, '#{pre_art_enc_datetime}')
EOF
      end
    end

    ##get hiv_clinic_consultation_encounters
    hiv_clinic_cons_encs_missed = Encounter.find_by_sql("SELECT 
                                                         encounter_datetime
                                                        FROM
                                                          bart1_intermediate_bare_bones.art_visit_encounters
                                                        WHERE
                                                          patient_id = #{patient}
                                                        AND encounter_datetime NOT IN (SELECT encounter_datetime
                                                                                       FROM #{Source_db}.encounter
                                                                                       WHERE patient_id = #{patient} AND voided = 0
                                                                                       AND encounter_type = 53)").map(&:encounter_datetime)


    if !hiv_clinic_cons_encs_missed.blank?
      (hiv_clinic_cons_encs_missed || []).each do |enc_datetime|
         cons_enc_datetime = enc_datetime.strftime("%Y-%m-%d %H:%M:%S")

         ActiveRecord::Base.connection.execute <<EOF
         CALL #{Source_db}.proc_import_art_visit_encounters_llh_missing_visit(#{patient}, '#{cons_enc_datetime}')
EOF
      end
    end

    ##get give_drugs_encounters
    give_drugs_encs_missed = Encounter.find_by_sql("SELECT 
                                                         encounter_datetime
                                                        FROM
                                                          bart1_intermediate_bare_bones.give_drugs_encounters
                                                        WHERE
                                                          patient_id = #{patient}
                                                        AND encounter_datetime NOT IN (SELECT encounter_datetime
                                                                                       FROM #{Source_db}.encounter
                                                                                       WHERE patient_id = #{patient} AND voided = 0
                                                                                       AND encounter_type IN (25, 54))").map(&:encounter_datetime)


    if !give_drugs_encs_missed.blank?
      (give_drugs_encs_missed || []).each do |enc_datetime|
         give_drugs_enc_datetime = enc_datetime.strftime("%Y-%m-%d %H:%M:%S")

         ActiveRecord::Base.connection.execute <<EOF
         CALL #{Source_db}.proc_import_give_drugs_llh_missing_visit(#{patient}, '#{give_drugs_enc_datetime}')
EOF
      end
    end
    puts "<<< Finished working on patient: #{patient}>>>>"
end
  
  time_ended = Time.now
  ended_at =  Time.now.strftime("%Y-%m-%d-%H%M%S")

  puts "Started at: #{time_started}"
  puts "Ended at: #{ended_at}"
end
start

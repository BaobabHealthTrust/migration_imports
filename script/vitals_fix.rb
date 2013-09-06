Source_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart2']["database"]

CONN = ActiveRecord::Base.connection

def start
	
  started_at = Time.now.strftime("%Y-%m-%d-%H%M%S")
    
  @weight_concept_id = Encounter.find_by_sql("SELECT concept_id FROM #{Source_db}.concept_name
                                              WHERE name = 'Weight (Kg)'").map(&:concept_id).first

  @height_concept_id = Encounter.find_by_sql("SELECT concept_id FROM #{Source_db}.concept_name
                                              WHERE name = 'Height (cm)'").map(&:concept_id).first

  @bmi_concept_id    = Encounter.find_by_sql("SELECT concept_id FROM #{Source_db}.concept_name
                                              WHERE name = 'BMI'").map(&:concept_id).first
  
  puts "Started at : #{Time.now}"

  puts "formatting weight, height and bmi values"
  
  vitals_obs = Observation.find_by_sql("SELECT * FROM #{Source_db}.obs
                                        WHERE concept_id IN (#{@weight_concept_id},#{@height_concept_id},#{@bmi_concept_id})")
  count = vitals_obs.length

  puts "Records found: #{vitals_obs.length}"
  
  (vitals_obs || []).each  do |obs|
    
    update_obs = "UPDATE #{Source_db}.obs
                  SET value_numeric = ROUND(value_numeric, 1)
                  WHERE person_id = obs.person_id
                  AND concept_id IN (#{@weight_concept_id},#{@height_concept_id},#{@bmi_concept_id})"
                  
    CONN.execute update_obs

    puts "#{count -= 1} records to go..............."
  end

  puts "creating OPD program and corresponding following encounter......"

  @outpatient_reception_enc_type_id = Encounter.find_by_sql(" SELECT encounter_type_id
                                                              FROM #{Source_db}.encounter_type
                                                              WHERE name = 'OUTPATIENT RECEPTION'").map(&:encounter_type_id).first

  outpatient_reception_encs = Encounter.find_by_sql(" SELECT DISTINCT t1.patient_id, t1.encounter_datetime, t1.location_id
                                                      FROM #{Source_db}.encounter t1
                                                      WHERE encounter_type = #{@outpatient_reception_enc_type_id}
                                                      AND t1.encounter_datetime = (  SELECT MIN(t2.encounter_datetime)
                                                                  FROM #{Source_db}.encounter t2
                                                                  WHERE t2.patient_id = t1.patient_id
                                                                  AND t2.encounter_type = #{@outpatient_reception_enc_type_id})
                                                      GROUP BY t1.patient_id")

  @opd_program_id = Encounter.find_by_sql(" SELECT program_id
                                            FROM #{Source_db}.program
                                            WHERE name = 'OPD Program'").map(&:program_id).first

  @opd_program_state = Encounter.find_by_sql("SELECT pws.program_workflow_state_id
                        FROM #{Source_db}.program_workflow pw
	                       INNER JOIN #{Source_db}.program_workflow_state pws on pws.program_workflow_id = pw.program_workflow_id
                         INNER JOIN #{Source_db}.concept_name c ON c.concept_id = pws.concept_id
                        WHERE pw.program_id  = #{@opd_program_id}
                        AND c.name = 'Following'").map(&:program_workflow_state_id).first

   count_opd_obs = outpatient_reception_encs.length

  (outpatient_reception_encs || []).each  do |patient|
    @date_enrolled = patient.encounter_datetime.strftime("%Y-%m-%d %H:%M")
    @date_created  = Date.today.strftime("%Y-%m-%d %H:%M")
    
    puts "creating opd_program for #{patient.patient_id}..........#{count_opd_obs -= 1} patients to go"
    
    create_opd_program = "INSERT INTO #{Source_db}.patient_program (patient_id, program_id, date_enrolled, creator, date_created, location_id,uuid)
VALUES(#{patient.patient_id}, #{@opd_program_id}, '#{@date_enrolled}', 1, '#{@date_created}' ,#{patient.location_id},(SELECT UUID()))"

    CONN.execute create_opd_program
    
    @opd_patient_program_id = Encounter.find_by_sql("SELECT patient_program_id FROM #{Source_db}.patient_program
                                                    WHERE patient_id = #{patient.patient_id}
                                                    AND program_id = #{@opd_program_id}").map(&:patient_program_id).first
                     
    opd_program_patient_state = "INSERT INTO #{Source_db}.patient_state(patient_program_id, state, start_date, creator, date_created, uuid)
                                 VALUES(#{@opd_patient_program_id}, #{@opd_program_state}, '#{@date_created}', 1, '#{@date_created}', (SELECT UUID()))"                     

    CONN.execute opd_program_patient_state
  end    
  
  puts "Started at : #{Time.now}"

end 

start

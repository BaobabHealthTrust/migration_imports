Source_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart2']["database"]

CONN = ActiveRecord::Base.connection

def start
	#antiretroviral_drugs_concept = 1085
  arv_drug_concepts =   Encounter.find_by_sql("SELECT * FROM #{Source_db}.concept_set
                                                WHERE concept_set = 1085").collect{|x| x.concept_id.to_i}

  $arv_drugs =   Encounter.find_by_sql("SELECT * FROM #{Source_db}.drug
                                        WHERE concept_id IN (#{arv_drug_concepts.join(',')})").collect{|x| x.drug_id}
                                        
  #hiv_program_id =  1
  $art_patients = Encounter.find_by_sql("SELECT 
                                          p.patient_id, p.patient_program_id, esd.earliest_start_date
                                        FROM
                                          #{Source_db}.patient_program p
                                         INNER JOIN
                                           #{Source_db}.earliest_start_date esd ON esd.patient_id = p.patient_id
                                        WHERE
                                          p.program_id = 1 AND p.voided = 0
                                        GROUP BY p.patient_id")

  ($art_patients || []).each do |patient|
    
    enrolled_date = date_antiretrovirals_started(patient) 

    first_dispense = get_first_dispensation(patient.patient_id)

    if !first_dispense.blank?
      if first_dispense.to_date == enrolled_date
        puts"<<<<<<<<<<The earliest_start_date and first dispensed date are the same"
      else
        puts "change dates"
        first_dispense = first_dispense.to_date if !first_dispense.blank?
        
        correct_start_date = first_dispense.to_date.strftime('%Y-%m-%d 00:00:00')

				latest_program = Encounter.find_by_sql("SELECT patient_program_id
				                                        FROM #{Source_db}.patient_program
				                                        WHERE program_id = 1
				                                        AND patient_id = #{patient.patient_id}
				                                        AND voided = 0").map(&:patient_program_id).first
				                                        	
				last_state = Encounter.find_by_sql("SELECT patient_state_id 
				                                    FROM #{Source_db}.patient_state
				                                    WHERE patient_program_id = #{latest_program}
				                                    AND state = 7").map(&:patient_state_id).first


        ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.patient_program
SET date_enrolled = '#{correct_start_date}'
WHERE patient_program_id = #{latest_program}
EOF

        ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.patient_state
SET start_date = '#{first_dispense.to_date.strftime('%Y-%m-%d 00:00:00')}',
date_created = '#{first_dispense.to_date.strftime('%Y-%m-%d 00:00:00')}'
WHERE patient_state_id = #{last_state}
EOF
#        enrolled_date = enrolled_date.to_date if !enrolled_date.blank?
#				correct_start_date = correct_start_date.to_date if !correct_start_date.blank?
        puts">>>>>>>#{patient.patient_id}....From: #{enrolled_date}......To: #{correct_start_date.to_date}........."
      end
    end
  end
end

def get_first_dispensation(patient_id)
  #amount_dispense_concept_id = 2834
  dispense_obs = Encounter.find_by_sql("SELECT min(obs_datetime) as obs_datetime
                                        FROM #{Source_db}.obs 
                                        WHERE person_id = #{patient_id}
                                        AND concept_id = 2834 and value_drug in (#{$arv_drugs.join(',')})")
  return dispense_obs.first.obs_datetime rescue nil
end

def date_antiretrovirals_started(patient)
  #art_start_date_concept_id =  2516
  start_date = Encounter.find_by_sql("SELECT value_datetime FROM obs
                                      WHERE concept_id = 2516
                                      AND person_id = #{patient.patient_id} ").map(&:value_datetime).first rescue ""

  if start_date.blank? || start_date == ""      
    start_date = Encounter.find_by_sql("SELECT value_text FROM #{Source_db}.obs
                                        WHERE concept_id = 2516
                                        AND person_id = #{patient.patient_id}").map(&:value_text).first  rescue ""    

    art_start_date = start_date
    if art_start_date.blank? || art_start_date == ""
    
    this_patient = $art_patients.select{|pat| pat.patient_id == patient.patient_id}
    start_date = this_patient.first.earliest_start_date
=begin      
      start_date = ActiveRecord::Base.connection.select_value "
        SELECT earliest_start_date FROM #{Source_db}.earliest_start_date
        WHERE patient_id = #{patient.patient_id} LIMIT 1"
=end
          
    end
  end

  start_date.to_date rescue nil
end

start

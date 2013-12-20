Source_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart2']["database"]

CONN = ActiveRecord::Base.connection

def start
	
  started_at = Time.now.strftime("%Y-%m-%d-%H%M%S")

  puts "updating diagnosis observations that were saved as value_text instead of value_coded..."

  diagnosis_with_value_text_obs = Encounter.find_by_sql(" SELECT * FROM #{Source_db}.obs
                                                          WHERE voided = 0 
                                                          AND concept_id IN (6542,6543,8345,8346,8347,8348) 
                                                          AND value_coded IS NULL
                                                          AND value_text IS NOT NULL
                                                          GROUP BY value_text
                                                          ORDER BY value_text")

   count_opd_obs = diagnosis_with_value_text_obs.length

  (diagnosis_with_value_text_obs || []).each  do |patient|

    @date_enrolled = patient.obs_datetime#.strftime("%Y-%m-%d %H:%M")
    @date_created  = Date.today.strftime("%Y-%m-%d %H:%M")
    @bart2_diagnosis = Encounter.find_by_sql("SELECT bart_two_concept_name 
                                              FROM #{Source_db}.concept_name_map
                                              WHERE bart_one_concept_name = '#{patient.value_text}'
                                              ").map(&:bart_two_concept_name).first
 
    @bart2_diagnosis_concept_id = Encounter.find_by_sql("SELECT concept_id 
                                              FROM #{Source_db}.concept_name
                                              WHERE name = '#{@bart2_diagnosis}'").map(&:concept_id).first
#raise @bart2_diagnosis.to_yaml
		ActiveRecord::Base.connection.execute <<EOF
		  UPDATE #{Source_db}.obs
			SET value_coded = #{@bart2_diagnosis_concept_id}, value_text = NULL
			WHERE value_text = '#{patient.value_text}'
EOF

  end    
  
  puts "Started at : #{Time.now}"

end 

start

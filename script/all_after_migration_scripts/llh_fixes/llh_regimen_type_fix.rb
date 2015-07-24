Source_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart2']["database"]

CONN = ActiveRecord::Base.connection

def start
  time_started = Time.now
  started_at =  Time.now.strftime("%Y-%m-%d-%H%M%S")

  puts "Starting the process at : #{time_started}"

  #get all patients with regimen_type saved as value_text
  regimen_type_with_value_text = Encounter.find_by_sql("
                                      SELECT obs_id, person_id, encounter_id,
                                        CASE value_text
                                          WHEN 'Abacavir Sulfate and Lamivudine 600/300mg tablet' THEN '7927'
                                          WHEN 'Didanosine Abacavir Lopinavir/Ritonavir' THEN '2988'
                                          WHEN 'ARV Non standard regimen' THEN  '5811'
                                          WHEN 'Stavudine Lamivudine + Efavirenz' THEN '1759'
                                          WHEN 'Stavudine Lamivudine + Stavudine Lamivudine Nevirapine' THEN '792'
                                          WHEN 'Stavudine Lamivudine + Stavudine Lamivudine Nevirapine (Triomune Baby)' THEN '792'
                                          WHEN 'Stavudine Lamivudine Nevirapine' THEN '792'
                                          WHEN 'Stavudine Lamivudine Nevirapine (Triomune Baby)' THEN '792'
                                          WHEN 'Stavudine Lamivudine Nevirapine Regimen' THEN '792'
                                          WHEN 'Tenofovir Lamivudine + Atazanavir and Ritonavir (ATV/r)' THEN '9177'
                                          WHEN 'Tenofovir Lamivudine and Nevirapine' THEN'2984'
                                          WHEN 'Tenofovir Lamivudine Lopinavir and Ritonavir' THEN'9177'
                                          WHEN 'Zidovudine Lamivudine + Atazanavir and Ritonavir (ATV/r)' THEN '9178'
                                          WHEN 'Zidovudine Lamivudine + Efavirenz' THEN '1613'
                                          WHEN 'Zidovudine Lamivudine + Nevirapine' THEN '1610'
                                          WHEN 'Zidovudine Lamivudine + Zidovudine Lamivudine Nevirapine' THEN '792'
                                          WHEN 'Zidovudine Lamivudine Lopinavir and Ritonavir' THEN '9178'
                                          WHEN 'Zidovudine Lamivudine Nevirapine (fixed)' THEN '1610'
                                          WHEN 'Zidovudine Lamivudine Tenofovir Lopinavir/ Ritonavir' THEN '6880'
                                          WHEN 'Lopinavir Ritonavir (Aluvia)' THEN '794'
	                                      ELSE 
                                            value_text
                                          END AS regimen_type,
                                          value_text
                                      FROM #{Source_db}.obs
                                      WHERE concept_id = 6882
                                      AND value_text IS NOT NULL")

  #update the value_coded
  (regimen_type_with_value_text).each do |reg_type|
    puts"<<<<<<<Working on obs_id #{reg_type.obs_id}"
    if reg_type.regimen_type != 'Cured'	
        ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.obs
SET value_coded = #{reg_type.regimen_type}, value_text = NULL
WHERE obs_id = #{reg_type.obs_id}
EOF
    end
    puts"<<<<<<<finished working on obs_id #{reg_type.obs_id}"
  end
  time_ended = Time.now
  ended_at =  Time.now.strftime("%Y-%m-%d-%H%M%S")

  puts "Started at: #{time_started}"
  puts "Ended at: #{ended_at}"

end                                                                                                                            
start

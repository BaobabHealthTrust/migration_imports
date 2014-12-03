MY_ENV = YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart']["database"]
CONN = ActiveRecord::Base.connection

def start
  #get all patients with ART startdate linked to HIV reception encounter
  art_start_date_obs = Encounter.find_by_sql("SELECT 
                                                    e.patient_id, e.encounter_id,
                                                    e.encounter_datetime, e.date_created,
                                                    o.obs_id, o.concept_id,
                                                    o.value_datetime, o.value_text,
                                                    e.provider_id, e.creator, e.location_id
                                              FROM
                                                    #{MY_ENV}.encounter e
                                                        INNER JOIN
                                                    #{MY_ENV}.obs o ON o.encounter_id = e.encounter_id
                                              WHERE o.concept_id = 143
                                              AND e.encounter_type IN (6, 2)
                                              AND o.voided = 0 ")

  #loop through each patient
  (art_start_date_obs || []).each do |patient|
    puts "............................working on #{patient.patient_id}"
    #check if patient has first visit encounter during that visit
    existing_first_vis_enc = Encounter.find_by_sql("SELECT encounter_id, encounter_datetime, date_created
                                          FROM #{MY_ENV}.encounter
                                          WHERE DATE(encounter_datetime) = '#{patient.encounter_datetime.strftime('%Y-%m-%d')}'
                                          AND patient_id = #{patient.patient_id}
                                          AND encounter_type = 1
                                          ORDER BY DATE(encounter_datetime) DESC
                                          LIMIT 1").map(&:encounter_id)

     #if--yes--check if patient has art startdate obs
     if !existing_first_vis_enc.blank?
       first_vis_enc_ART_startdate = Observation.find_by_sql("SELECT value_datetime
                                                              FROM #{MY_ENV}.obs
                                                              WHERE encounter_id = #{existing_first_vis_enc}
                                                              AND patient_id = #{patient.patient_id}
                                                              AND concept_id = 143 ").map(&:value_datetime)
       if !first_vis_enc_ART_startdate.blank?
         #void hiv_reception ART startdate observations
         update_art_start_date_obs = "UPDATE #{MY_ENV}.obs
                                     SET voided = 1,
                                         voided_by = 1, 
                                         void_reason = 'created a HIV first visit encounter and linked this obs to it', 
                                         date_voided = #{Date.today}
                                     WHERE obs_id = #{patient.obs_id}"
        CONN.execute update_art_start_date_obs

       else
        #create observation and void the reception ART startdate obs
        obs = Observation.new()
        obs.patient_id = patient.patient_id
        obs.encounter_id = first_vis_enc_ART_startdate
        obs.obs_datetime = patient.encounter_datetime
        obs.date_created = Date.today
        obs.concept_id =  patient.concept_id
        obs.value_datetime = patient.value_datetime
        obs.creator = patient.creator
        obs.location_id = patient.location_id
        obs.save
      
        #void hiv_reception ART startdate observations
        update_art_start_date_obs = "UPDATE #{MY_ENV}.obs
                                     SET voided = 1,
                                         voided_by = 1, 
                                         void_reason = 'created a HIV first visit encounter and linked this obs to it', 
                                         date_voided = #{Date.today}
                                     WHERE obs_id = #{patient.obs_id}"
        CONN.execute update_art_start_date_obs
      
       end                                                             
     else
       #if--not--create an art startdate obs linked to first visit with reception
       #details and update the reception obs

       #create a new first visit_encounter       
       enc = Encounter.new()
       enc.patient_id = patient.patient_id
       enc.encounter_type = 1
       enc.encounter_datetime = patient.encounter_datetime
       enc.date_created = Date.today
       enc.provider_id = patient.provider_id
       enc.location_id = patient.location_id
       enc.save
       
       #get the last ID insert encounter id
       new_enc_id =  Encounter.find(:last).id

       #create observation and void the reception ART startdate obs
       obs = Observation.new()
       obs.patient_id = patient.patient_id
       obs.encounter_id = new_enc_id
       obs.obs_datetime = patient.encounter_datetime
       obs.date_created = Date.today
       obs.concept_id =  patient.concept_id
       obs.value_datetime = patient.value_datetime
       obs.creator = patient.creator
       obs.location_id = patient.location_id
       obs.save       
       
       #void hiv_reception ART startdate observations
      update_art_start_date_obs = "UPDATE #{MY_ENV}.obs
                                     SET voided = 1,
                                         voided_by = 1, 
                                         void_reason = 'created a HIV first visit encounter and linked this obs to it', 
                                         date_voided = #{Date.today}
                                     WHERE obs_id = #{patient.obs_id}"
        CONN.execute update_art_start_date_obs
             
     end

  end

end
start

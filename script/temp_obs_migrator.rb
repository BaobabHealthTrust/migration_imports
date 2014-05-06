NULL = nil

def start

  source_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart2']["database"]

  started_at = Time.now.strftime("%Y-%m-%d-%H%M%S")

  $temporary_outfile = File.open("./migration_output/temporary_observations-" + started_at + ".sql", "w")

  temps_obs = Observation.find_by_sql("SELECT * FROM #{source_db}.temp_obs")

  obs_id = temps_obs.collect{|x| x.encounter_id}.uniq

  temp_enc = Encounter.find_by_sql("SELECT * FROM #{source_db}.encounter where void_reason in (#{obs_id.join(',')}) ")

  temp_keys = {}

  (temp_enc || []).each do |enc|
      temp_keys[enc.void_reason.to_i] = enc.encounter_id
  end

  max = temps_obs.length
  count = 1
  (temps_obs || []).each do |obs|

    encounter_value_datetime = obs.value_datetime.blank? ? 'NULL' : "'#{obs.value_datetime.to_s}'"
    
    $temporary_outfile << "INSERT INTO obs (`person_id`,`concept_id`,`encounter_id`,`order_id`,`obs_datetime`,
                          `value_coded`,`value_drug`,`value_datetime`,`value_numeric`,
                          `value_text`, `creator`,`date_created`,`uuid`) VALUES (#{obs.person_id},#{obs.concept_id},
                          #{temp_keys[obs.encounter_id]},#{obs.order_id.blank? ? 'NULL' : obs.order_id      },'#{obs.obs_datetime}',
                          #{obs.value_coded.blank? ? 'NULL' : obs.value_coded },#{obs.value_drug.blank? ? 'NULL' : obs.value_drug},
                          #{encounter_value_datetime},
                          #{obs.value_numeric.blank? ? 'NULL' : obs.value_numeric},#{obs.value_text.blank? ? 'NULL' : obs.value_text},
                          #{obs.creator},'#{obs.date_created}','#{obs.uuid}');"

    puts ".......................#{count} of #{max}"
    count += 1
  end

  $temporary_outfile.close

end

start

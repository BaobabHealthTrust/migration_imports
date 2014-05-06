

def start

  source_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart2']["database"]

  started_at = Time.now.strftime("%Y-%m-%d-%H%M%S")

  $encounters_outfile = File.open("./migration_output/temporary_encounters-" + started_at + ".sql", "w")

  temp_encounters = Encounter.find_by_sql(" SELECT * FROM #{source_db}.temp_encounter")

  count = temp_encounters.length
  max = temp_encounters.length
  (temp_encounters || []).each do |encounter|

    $encounters_outfile << "INSERT INTO encounter (`encounter_type`,`patient_id`,`provider_id`,
                            `encounter_datetime`,`creator`,`date_created`,`voided`,`void_reason`,
                            `uuid`) VALUES (#{encounter.encounter_type},#{encounter.patient_id},
                            #{encounter.provider_id}, '#{encounter.encounter_datetime}',
                            #{encounter.creator},'#{encounter.date_created}',#{encounter.voided},
                            #{encounter.encounter_id},'#{encounter.uuid}');"

    puts ".......................#{count} of #{max}"
    count -= 1
  end

  $encounters_outfile.close

end

start
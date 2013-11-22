Source_db = YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart']["database"]

def start

  encounters_without_creator = Encounter.find_by_sql("select * from #{Source_db}.encounter where creator = 0").length
	minimum_patient_id = Patient.find_by_sql("Select MIN(patient_id) as patient_id from #{Source_db}.patient where voided = 0").patient_id
	
	puts ""
  print "Encounters without creators".ljust(30)
  puts encounters_without_creator
  


end


start

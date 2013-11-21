Source_db = YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart']["database"]

def start

  encounters_without_creator = Encounter.find_by_sql("select * from #{Source_db}.encounter where creator = 0").length
	
	puts ""
  print "Encounters without creators".lju


end


start

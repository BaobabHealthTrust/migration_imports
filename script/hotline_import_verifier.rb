Source_db = YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart2']["database"]


def start

  puts "Comparison of numerical records between intermediate and destination (OpenMRS 1.7/bart2)"

	patient_destination = Patient.find_by_sql("Select * from #{Source_db}.patient").length
	patient_intermed = PatientRecord.all.length
	males_destination = Patient.find_by_sql("Select * from #{Source_db}.person where voided = 0 and gender = 'M'").length
	females_destination = Patient.find_by_sql("Select * from #{Source_db}.person where voided = 0 and gender = 'F'").length
	males_intermed = PatientRecord.find_all_by_gender('M').length
	females_intermed = PatientRecord.find_all_by_gender('F').length


  registration_enc_destination = Encounter.find_by_sql("select * from #{Source_db}.encounter where encounter_type = 2 and voided = 0").length
  registration_enc_intermed = RegistrationEncounter.all.length
  baby_delivery_enc_destination = Encounter.find_by_sql("select * from #{Source_db}.encounter where encounter_type = 8 and voided = 0").length
  baby_delivery_enc_intermed = BabyDeliveryEncounter.all.length
  birth_plan_enc_destination = Encounter.find_by_sql("select * from #{Source_db}.encounter where encounter_type = 10 and voided = 0").length
  birth_plan_enc_intermed = BirthPlanEncounter.all.length
  anc_visit_enc_destination = Encounter.find_by_sql("select * from #{Source_db}.encounter where encounter_type = 14 and voided = 0").length
  anc_visit_enc_intermed = AncVisitEncounter.all.length
  tips_and_reminders_enc_destination = Encounter.find_by_sql("select * from #{Source_db}.encounter where encounter_type = 4 and voided = 0").length
  tips_and_reminders_enc_intermed = TipsAndRemindersEncounter.all.length
  update_outcome_enc_destination = Encounter.find_by_sql("select * from #{Source_db}.encounter where encounter_type = 3 and voided = 0").length
  update_outcome_enc_intermed = UpdateOutcomesEncounter.all.length
  child_health_symptoms_enc_destination = Encounter.find_by_sql("select * from #{Source_db}.encounter where encounter_type = 6 and voided = 0").length
  child_health_symptoms_enc_intermed = ChildHealthSymptomsEncounter.all.length
  maternal_health_symptoms_enc_destination = Encounter.find_by_sql("select * from #{Source_db}.encounter where encounter_type = 5 and voided = 0").length
  maternal_health_symptoms_enc_intermed = MaternalHealthSymptomsEncounter.all.length
  pregnancy_status_enc_destination = Encounter.find_by_sql("select * from #{Source_db}.encounter where encounter_type = 9 and voided = 0").length
  pregnancy_status_enc_intermed = PregnancyStatusEncounter.all.length


  users_destination = User.find_by_sql("select * from #{Source_db}.users").length
  user_intermed = User.all.length
  guardian_destination = Relationship.find_by_sql("select * from #{Source_db}.relationship").length
  guardian_intermed = Relationship.all.length


  print "Category".ljust(30)
  print "Source DB".ljust(20)
  print "Intermediate DB".ljust(20)
  print "Differences"
  puts ""
  print "Total Patients".ljust(30)
  print patient_destination.to_s.ljust(20)
  print patient_intermed.to_s.ljust(20)
  print (patient_intermed.to_i  - patient_destination.to_i ).to_s
  puts ""
  print "Total Males".ljust(30)
  print males_destination.to_s.ljust(20)
  print males_intermed.to_s.ljust(20)
  print ( males_intermed.to_i  - males_destination.to_i ).to_s
  puts ""
  print "Total Females".ljust(30)
  print females_destination.to_s.ljust(20)
  print females_intermed.to_s.ljust(20)
  print (females_intermed.to_i - females_destination.to_i ).to_s
  puts ""
  puts ""
  print "Registration".ljust(30)
  print registration_enc_destination.to_s.ljust(20)
  print registration_enc_intermed.to_s.ljust(20)
  print (registration_enc_destination.to_i - registration_enc_intermed.to_i ).to_s
  puts ""
  print "Baby Delivery ".ljust(30)
  print baby_delivery_enc_destination.to_s.ljust(20)
  print baby_delivery_enc_intermed.to_s.ljust(20)
  print (baby_delivery_enc_destination.to_i - baby_delivery_enc_intermed.to_i ).to_s
  puts ""
  print "Birth Plan".ljust(30)
  print birth_plan_enc_destination.to_s.ljust(20)
  print birth_plan_enc_intermed.to_s.ljust(20)
  print (birth_plan_enc_destination.to_i - birth_plan_enc_intermed.to_i ).to_s
  puts ""
  print "ANC Visit".ljust(30)
  print anc_visit_enc_destination.to_s.ljust(20)
  print anc_visit_enc_intermed.to_s.ljust(20)
  print (anc_visit_enc_destination.to_i - anc_visit_enc_intermed.to_i ).to_s
  puts ""
  print "Tips and Reminders".ljust(30)
  print tips_and_reminders_enc_destination.to_s.ljust(20)
  print tips_and_reminders_enc_intermed.to_s.ljust(20)
  print (tips_and_reminders_enc_destination.to_i - tips_and_reminders_enc_intermed.to_i ).to_s
  puts ""
  print "Child Health Symptoms".ljust(30)
  print child_health_symptoms_enc_destination.to_s.ljust(20)
  print child_health_symptoms_enc_intermed.to_s.ljust(20)
  print (child_health_symptoms_enc_destination.to_i - child_health_symptoms_enc_intermed.to_i ).to_s
  puts ""
  print "Maternal Health Symptoms".ljust(30)
  print maternal_health_symptoms_enc_destination.to_s.ljust(20)
  print maternal_health_symptoms_enc_intermed.to_s.ljust(20)
  print (maternal_health_symptoms_enc_destination.to_i - maternal_health_symptoms_enc_intermed.to_i ).to_s
  puts ""
  print "Pregnancy Status".ljust(30)
  print pregnancy_status_enc_destination.to_s.ljust(20)
  print pregnancy_status_enc_intermed.to_s.ljust(20)
  print (pregnancy_status_enc_destination.to_i - pregnancy_status_enc_intermed.to_i ).to_s
  puts ""
  print "Update Ouctome".ljust(30)
  print update_outcome_enc_destination.to_s.ljust(20)
  print update_outcome_enc_intermed.to_s.ljust(20)
  print (update_outcome_enc_destination.to_i - update_outcome_enc_intermed.to_i ).to_s
  puts ""
  print "Users".ljust(30)
  print users_destination.to_s.ljust(20)
  print user_intermed.to_s.ljust(20)
  print (users_destination.to_i - user_intermed.to_i ).to_s
  puts ""
  print "Guardians".ljust(30)
  print guardian_destination.to_s.ljust(20)
  print guardian_intermed.to_s.ljust(20)
  print (guardian_destination.to_i - guardian_intermed.to_i ).to_s
  puts ""
end

start

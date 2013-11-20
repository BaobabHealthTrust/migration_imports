Source_db = YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart']["database"]


def start

  puts "Comparison of numerical records between source and intermediate tables"

	patient_original = Patient.find_by_sql("Select * from #{Source_db}.patient").length
	patient_intermed = PatientRecord.all.length
	males_original = Patient.find_by_sql("Select * from #{Source_db}.patient where voided = 0 and gender = 'Male'").length
	females_original = Patient.find_by_sql("Select * from #{Source_db}.patient where voided = 0 and gender = 'Female'").length
	males_intermed = PatientRecord.find_all_by_gender('Male').length
	females_intermed = Patient.find_all_by_gender('Female').length
  hiv_clinic_enc_original = Encounter.find_by_sql("select count(*) from #{Source_db}.encounter where encounter_type = 1").length
  hiv_clinic_enc_intermed = FirstVisitEncounter.all.length
  hiv_recp_enc_original = Encounter.find_by_sql("select count(*) from #{Source_db}.encounter where encounter_type = 5").length
  hiv_recp_enc_intermed = HivReceptionEncounter.all.length
  hiv_stage_enc_original = Encounter.find_by_sql("select count(*) from #{Source_db}.encounter where encounter_type = 1").length
  hiv_stage_enc_intermed = HivStagingEncounter.all.length
  treatment_enc_original = Encounter.find_by_sql("select count(*) from #{Source_db}.encounter where encounter_type = 3").length
  treatment_enc_intermed = GiveDrugsEncounter.all.length
  hiv_consult_enc_original = Encounter.find_by_sql("select count(*) from #{Source_db}.encounter where encounter_type = 2").length
  hiv_consult_enc_intermed = ArtVisitEncounter.all.length
  opd_diag_enc_original = Encounter.find_by_sql("select count(*) from #{Source_db}.encounter where encounter_type = 18").length
  opd_diag_enc_intermed = OutpatientDiagnosisEncounter.all.length
  opd_recp_enc_original = Encounter.find_by_sql("select count(*) from #{Source_db}.encounter where encounter_type = 17").length
  opd_recp_enc_intermed = GeneralReceptionEncounter.all.length
  vitals_enc_original = Encounter.find_by_sql("select count(*) from #{Source_db}.encounter where encounter_type = 7").length
  vitals_enc_intermed = VitalsEncounter.all.length

  print "Category".ljust(30)
  print "Source Database".ljust(20)
  print "Intermediate Database"
  puts ""
  print "Number of Patients".ljust(30)
  print patient_original.to_s.ljust(20)
  print patient_intermed.to_s
  puts ""
  print "Number of Males".ljust(30)
  print males_original.to_s.ljust(20)
  print males_intermed.to_s
  puts ""
  print "Number of Females".ljust(30)
  print females_original.to_s.ljust(20)
  print females_intermed.to_s
  puts ""
  print "HIV Clinic Registration".ljust(30)
  print hiv_clinic_enc_original.to_s.ljust(20)
  print hiv_clinic_enc_intermed.to_s
  puts ""
  print "HIV Clinic Reception".ljust(30)
  print hiv_recp_enc_original.to_s.ljust(20)
  print hiv_recp_enc_intermed.to_s
  puts ""
  print "HIV Clinic Consultation".ljust(30)
  print hiv_consult_enc_original.to_s.ljust(20)
  print hiv_consult_enc_intermed.to_s
  puts ""
  print "HIV Clinic Staging".ljust(30)
  print hiv_stage_enc_original.to_s.ljust(20)
  print hiv_stage_enc_intermed.to_s
  puts ""
  print "Treatment Encounters".ljust(30)
  print treatment_enc_original.to_s.ljust(20)
  print treatment_enc_intermed.to_s
  puts ""
  print "General Reception".ljust(30)
  print opd_recp_enc_original.to_s.ljust(20)
  print opd_recp_enc_intermed.to_s
  puts ""
  print "OPD Diagnosis".ljust(30)
  print opd_diag_enc_original.to_s.ljust(20)
  print opd_diag_enc_intermed.to_s
  puts ""
  print "Vitals".ljust(30)
  print vitals_enc_original.to_s.ljust(20)
  print vitals_enc_intermed.to_s
  puts ""



end

start

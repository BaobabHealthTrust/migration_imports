Source_db = YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart']["database"]
require "csv"

def start
  puts "Getting Pre-Migration Statistics \n\n"

  started_at = Time.now.strftime("%Y-%m-%d-%H%M%S")
  $pre_migration = File.open("./migration_output/#{started_at}-Pre_migration_report.txt", "w")
  concept_ids = Concept.find(:all, :conditions =>["retired = ?", 0]).collect{|x| x.concept_id}.uniq
  retired_concepts = Concept.find(:all, :conditions =>["retired = ?", 1]).collect{|x| x.concept_id}.uniq
  obs_with_voided_concepts = Observation.find_by_sql("SELECT * FROM obs WHERE value_coded IN (#{retired_concepts.join(',')})").length
  obs_with_missing_concepts = Observation.find_by_sql("SELECT value_coded as concept_id FROM obs WHERE value_coded NOT IN (#{concept_ids.join(',')})").length
  encounters_without_obs = Encounter.find_by_sql("select count(*) as enc_count from #{Source_db}.encounter where encounter_id not in (select distinct encounter_id from #{Source_db}.obs where voided = 0)").first.enc_count
  encounters_without_creator = Encounter.find_by_sql("select * from #{Source_db}.encounter where creator = 0").length
  encounters = Encounter.find_by_sql("Select count(*) as enc_count from #{Source_db}.encounter").first.enc_count
	minimum_patient_id = Patient.find_by_sql("Select MIN(patient_id) as patient_id from #{Source_db}.patient where voided = 0").first.patient_id
  maximum_patient_id = Patient.find_by_sql("Select MAX(patient_id) as patient_id from #{Source_db}.patient where voided = 0").first.patient_id
  patient_count = Patient.find_by_sql("Select count(*) as patient_count from #{Source_db}.patient").first.patient_count
  patients_unvoided = Patient.find_by_sql("Select count(*) as patient_count from #{Source_db}.patient where voided = 0").first.patient_count
  patients_voided = Patient.find_by_sql("Select count(*) as patient_count from #{Source_db}.patient where voided = 1").first.patient_count
  dead_patients = Patient.find_by_sql("Select count(*) as patient_count from #{Source_db}.patient where voided = 0 AND dead IS NOT NULL").first.patient_count
  art_patients = Patient.find_by_sql("select count(patient_id) as pat_count from #{Source_db}.patient where voided = 0 and patient_id in (SELECT distinct patient_id FROM #{Source_db}.patient_program where program_id = 1 and voided = 0)").first.pat_count
  opd_patients = Patient.find_by_sql("select count(patient_id) as pat_count from #{Source_db}.patient where voided = 0 and patient_id not in (SELECT distinct patient_id FROM #{Source_db}.patient_program where program_id = 1 and voided = 0)").first.pat_count
  observations = Observation.find_by_sql("SELECT count(*) as obs_count from #{Source_db}.obs").first.obs_count
  unvoided_obs = Observation.find_by_sql("SELECT count(*) as obs_count from #{Source_db}.obs where COALESCE(voided,0) = 0").first.obs_count
  voided_obs = Observation.find_by_sql("SELECT count(*) as obs_count from #{Source_db}.obs where COALESCE(voided,0) != 0").first.obs_count
  orders = Order.find_by_sql("SELECT count(*) as order_count from #{Source_db}.orders").first.order_count
  unvoided_orders = Order.find_by_sql("SELECT count(*) as order_count from #{Source_db}.orders where COALESCE(voided,0) = 0").first.order_count
  voided_orders = Order.find_by_sql("SELECT count(*) as order_count from #{Source_db}.orders where COALESCE(voided,0) != 0").first.order_count
  encounters_by_type = Encounter.find_by_sql("select t.name as enc_name,count(e.encounter_id) as enc_type_count from #{Source_db}.encounter as e inner join #{Source_db}.encounter_type as t on e.encounter_type = t.encounter_type_id group by t.name")
  drugs_ever_dispensed = Drug.find_by_sql("SELECT (SELECT name from #{Source_db}.drug where drug_id = value_drug) as drug_type, value_drug as drug_identifier ,count(*) as counts from #{Source_db}.obs where voided = 0 AND value_drug IS NOT NULL group by value_drug order by drug_type ASC")
  observation_without_enc_types = Observation.find_by_sql("select count(*) as obs_count from #{Source_db}.obs where encounter_id in (select encounter_id from #{Source_db}.encounter where encounter_type is null)").first.obs_count
  concepts_used = Concept.find_by_sql("SELECT distinct value_coded as concept_id, (select name from concept where concept_id = value_coded limit 1) as name from obs where voided = 0 UNION SELECT distinct concept_id as v_concept_id , (select name from concept where concept_id = v_concept_id limit 1) as name from obs where voided = 0 order by name")

  $pre_migration << "Minimum patient ID: #{minimum_patient_id} \n"
  $pre_migration << "Maximum patient ID: #{maximum_patient_id} \n"
  $pre_migration << "Total patients : #{patient_count} \n"
  $pre_migration << "Total unvoided patients : #{patients_unvoided} \n"
  $pre_migration << "Total voided patients : #{patients_voided} \n"
  $pre_migration << "Dead unvoided patients : #{dead_patients} \n"
	$pre_migration << "ART patients : #{art_patients}\n"
  $pre_migration << "OPD patients : #{opd_patients}\n"
  $pre_migration << "Encounters Count : #{encounters} \n"
  $pre_migration << "Encounters  Without Observations : #{encounters_without_obs} \n"
  $pre_migration << "Encounters without creators : #{encounters_without_creator} \n"
  $pre_migration << "Total Observations : #{observations} \n"
  $pre_migration << "Unvoided Observations : #{unvoided_obs}\n"
  $pre_migration << "Voided Observations : #{voided_obs}\n"
  $pre_migration << "Observations With voided concepts: #{obs_with_voided_concepts}\n"
  $pre_migration << "Observations With missing concepts: #{obs_with_missing_concepts}\n"
  $pre_migration << "Observations With without encounter types: #{observation_without_enc_types}\n"
  $pre_migration << "Total Orders : #{orders}\n"
  $pre_migration << "Unvoided Orders : #{unvoided_orders}\n"
  $pre_migration << "Voided Orders : #{voided_orders}\n"
  $pre_migration << "\nEncounter Count Per Type \n\n"

  puts"Minimum patient ID: #{minimum_patient_id} \n"
  puts"Maximum patient ID: #{maximum_patient_id} \n"
  puts"Total patients : #{patient_count} \n"
  puts"Total unvoided patients : #{patients_unvoided} \n"
  puts"Total voided patients : #{patients_voided} \n"
  puts"Dead unvoided patients : #{dead_patients} \n"
  puts"ART patients : #{art_patients}\n"
  puts"OPD patients : #{opd_patients}\n"
  puts"Encounters Count : #{encounters} \n"
  puts"Encounters  Without Observations : #{encounters_without_obs} \n"
  puts"Encounters without creators : #{encounters_without_creator}\n"
  puts"Total Observations : #{observations} \n"
  puts"Unvoided Observations : #{unvoided_obs}\n"
  puts"Voided Observations : #{voided_obs}\n"
  puts"Observations With voided concepts: #{obs_with_voided_concepts}\n"
  puts"Observations With missing concepts: #{obs_with_missing_concepts}\n"
  puts"Observations With Encounters without encounter types: #{observation_without_enc_types}\n"
  puts"Total Orders : #{orders}\n"
  puts"Unvoided Orders : #{unvoided_orders}\n"
  puts"Voided Orders : #{voided_orders}\n"
  puts"\nEncounter Count Per Type \n\n"

  (encounters_by_type || []).each do |enc_type|
    puts "Number Of #{enc_type.enc_name rescue "Unknown"} encounters : #{enc_type.enc_type_count}"
    $pre_migration << "Number Of #{enc_type.enc_name rescue "Unknown"} encounters : #{enc_type.enc_type_count} \n"
  end

  CSV.open("./migration_output/#{started_at}-pre_migration_drugs_used.csv", "wb") do |csv|

    csv << ["Drug Name","Drug ID","Number of Times Used"]

    (drugs_ever_dispensed || []).each do |drug|

      csv <<  [drug.drug_type,drug.drug_identifier ,drug.counts]

    end

  end

  CSV.open("./migration_output/#{started_at}-pre_migration_concepts_used.csv", "wb") do |csv|

    csv << ["Concept Name","Concept ID"]

    (concepts_used || []).each do |concept|

      csv <<  [concept.name, concept.concept_id]

    end

  end


  puts "\n\nList of all drugs ever used was created. Check in the migration_output folder\n\n"

end


start

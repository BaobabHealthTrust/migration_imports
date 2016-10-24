Reg = EncounterType.find_by_name("REGISTRATION")
UpdOutcome = EncounterType.find_by_name("UPDATE OUTCOME")
TipsNRem = EncounterType.find_by_name("TIPS AND REMINDERS")
MatHeltSymps = EncounterType.find_by_name("MATERNAL HEALTH SYMPTOMS")
ChildHeltSym = EncounterType.find_by_name("CHILD HEALTH SYMPTOMS")
BabyDel = EncounterType.find_by_name("BABY DELIVERY")
PregStat = EncounterType.find_by_name("PREGNANCY STATUS")
BirthPl = EncounterType.find_by_name("BIRTH PLAN")
AncVis = EncounterType.find_by_name("ANC VISIT")

Concepts = Hash.new()
Visit_encounter_hash = Hash.new()

Use_queue = 1
Output_sql = 1
Execute_sql = 1

Patient_queue = Array.new
Patient_queue_size = 1000
Registration_queue = Array.new
Registration_size = 1000
Update_outcome_queue = Array.new
Update_outcome_size = 1000
Tips_and_reminders_queue = Array.new
Tips_and_reminders_size = 1000
Maternal_health_symptoms_queue = Array.new
Maternal_health_symptoms_size = 1000
Child_health_symptoms_queue = Array.new
Child_health_symptoms_size = 1000
Baby_delivery_queue = Array.new
Baby_delivery_size = 1000
Pregnancy_status_queue = Array.new
Pregnancy_status_size = 1000
Birth_plan_queue = Array.new
Birth_plan_size = 1000
Patient_outcome_queue = Array.new
Patient_outcome_size = 1000
ANC_visit_queue = Array.new
ANC_visit_size = 1000
Guardian_queue = Array.new
Guardian_queue_size = 1000

Users_queue = Array.new

Source_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart']["database"]

CONN = ActiveRecord::Base.connection

$missing_concept_errors=0

def start

  $visit_encounter_id = 1

  started_at = Time.now.strftime("%Y-%m-%d-%H%M%S")

	$duplicates_outfile = File.open("./migration_output/#{started_at}-duplicates.txt", "w")
	$failed_encs = File.open("./migration_output/#{started_at}-Failed_encounters.txt", "w")


  if Output_sql == 1
    $visits_outfile = File.open("./migration_output/migration_export_visits-" + started_at + ".sql", "w")
    $pat_encounters_outfile = File.open("./migration_output/migration_export_pat_encounters-" + started_at + ".sql", "w")

  end

  puts "Started at : #{Time.now}"
  t1 = Time.now
  Concept.find(:all).map do |con|
    Concepts[con.id] = con
  end
  t2 = Time.now
  elapsed = time_diff_milli t1, t2
  puts "Loaded concepts in #{elapsed}"

  #you can specify the number of patients to export by adding limit then number of patiets e.g limit 100 to the query below
  patients = Patient.find_by_sql("Select * from #{Source_db}.patient where voided = 0 ORDER BY patient_id desc")
  patient_ids = patients.map{|p| p.patient_id}
  pat_ids =  [0] if patient_ids.blank?

  count = patients.length
  puts "Number of patients to be exported to intermediary storage #{count}"

  total_enc = 0
  pat_enc = 0
  pat_outs = 0
  pat_outcomes = 0

  t1 = Time.now

  started_at = Time.now.strftime("%Y-%m-%d-%H%M%S")

  if Output_sql == 1
    $visits_outfile = File.open("./migration_output/migration_export_visits-" + started_at + ".sql", "w")
    $pat_encounters_outfile = File.open("./migration_output/migration_export_pat_encounters-" + started_at + ".sql", "w")
  end

  patients.each do |patient|

  	$migratedencs = Hash.new(false)
    puts "Working on patient with ID: #{patient.id}"
    pt1 = Time.now

    encounters = Encounter.find_by_sql("
                              	SELECT
                									e . *
                								FROM encounter e
                									INNER JOIN
                									  obs o ON e.encounter_id = o.encounter_id
                									 and o.voided = 0
                								WHERE
                									e.patient_id = #{patient.id} AND o.voided = 0
                									AND o.concept_id != 0
                									AND e.date_created = (SELECT
                										MAX(enc.date_created)
                									FROM
                										encounter enc
                										INNER JOIN
                										obs ob ON ob.encounter_id = enc.encounter_id
                										AND ob.voided = 0
                									WHERE
                										enc.patient_id = e.patient_id
                										AND enc.encounter_type = e.encounter_type
                										AND DATE(enc.encounter_datetime) = DATE(e.encounter_datetime))
                								GROUP BY e.encounter_id")
		ordered_encs = {}

		encounters.each do |enc|
		  if !enc.encounter_datetime.nil?
		      if ordered_encs[enc.encounter_datetime.to_date].blank?
		         ordered_encs[enc.encounter_datetime.to_date] = []
		end
			   if enc.encounter_type.blank?
           $failed_encs << "#{enc.encounter_id} : Missing encounter  type"
			   else
			     if enc.encounter_type == 57
			      $failed_encs << "#{enc.encounter_id} : Missing encounter  type"
			     else
            ordered_encs[enc.encounter_datetime.to_date] << enc
			     end
			   end
		  end
    end
    #check if patient does not have update outcome encounter
    patient_encounter_types = encounters.map{|enc| enc.encounter_type}

    (ordered_encs.sort_by{|x,y| x} || {}).each do |visit_date, values|

 			values.sort_by{|x| x.name }.each do |enc|
		    total_enc +=1
		    pat_enc +=1

		    visit_encounter_id = self.check_for_visitdate("#{patient.id}", enc.encounter_datetime.to_date)
		    if !enc.encounter_type.blank?
		    	self.create_record(visit_encounter_id, enc)
		    else
		    	$failed_encs << "#{enc.encounter_id} : Missing encounter  type"
		    end
     	end
    end

    self.create_patient(patient)
    self.create_guardian(patient)

    pt2 = Time.now
    elapsed = time_diff_milli pt1, pt2
    eps = total_enc / elapsed
    puts "#{pat_enc} Encounters were processed in #{elapsed} for #{eps} eps"
    puts "#{count-=1}................ patient(s) to go"
    pat_enc = 0

  end

  #Create system users
  self.create_users()
  # flush the queues
  flush_patient()
  flush_registration()
  flush_update_outcome()
  flush_tips_and_reminders()
  flush_maternal_health_symptoms()
  flush_child_health_symptoms()
  flush_baby_delivery()
  flush_pregnancy_status()
  flush_birth_plan()
  flush_anc_visit()
  flush_users()
  #flush_patient_outcome()
  flush_guardians()

  if Output_sql == 1
    $visits_outfile.close()
    $pat_encounters_outfile.close()
  end

  $duplicates_outfile.close()
  puts "Finished at : #{Time.now}"
  t2 = Time.now
  elapsed = time_diff_milli t1, t2
  eps = total_enc / elapsed
  puts "#{total_enc} Encounters were processed in #{elapsed} seconds for #{eps} eps"
  puts "Encounters with missing concepts: " + $missing_concept_errors.to_s

	puts "Verifying patients"

	encounter_tables = ["registration_encounters","update_outcomes_encounters", "tips_and_reminders_encounters", "maternal_health_symptoms_encounters", "child_health_symptoms_encounters", "baby_delivery_encounters", "pregnancy_status_encounters", "birth_plan_encounters", "anc_visit_encounters"]

	encounter_tables.each do |enc_type|
		puts "Encounter type : #{enc_type}"
		patients = PatientRecord.find_by_sql("select patient_id from #{enc_type} where patient_id not in (select patient_id from patients)")
		puts "#{patients.length} will be created"
		patients.each do |patient|
			self.create_patient(Patient.find(patient.patient_id))
		end
	end
  flush_patient()
end

def time_diff_milli(start, finish)
  (finish - start)
end

def self.get_encounter(type)
  case type
    when 'REGISTRATION'
      return Reg.id
    when 'UPDATE OUTCOME'
      return UpdOutcome.id
    when 'TIPS AND REMINDERS'
      return TipsNRem.id
    when 'MATERNAL HEALTH SYMPTOMS'
      return MatHeltSymps.id
    when 'CHILD HEALTH SYMPTOMS'
      return ChildHeltSym.id
    when 'BABY DELIVERY'
      return BabyDel.id
    when 'PREGNANCY STATUS'
      return PregStat.id
    when 'BIRTH PLAN'
      return BirthPl.id
    when 'ANC VISIT'
      return AncVis.id
  end
end

def self.check_for_visitdate(patient_id, encounter_date)
  # check if we have seen this patient visit and return the visit encounter id if we have
  if Visit_encounter_hash["#{patient_id}#{encounter_date}"] != nil
    return Visit_encounter_hash["#{patient_id}#{encounter_date}"]
  end

  # make a new visit encounter
  vdate = VisitEncounter.new()
  vdate.visit_date = encounter_date
  vdate.patient_id = patient_id

  # if executing sql utilize db to generate ids
  if Execute_sql == 1
    vdate.save
    Visit_encounter_hash["#{patient_id}#{encounter_date}"] = vdate.id
  else
    # generate an id internally
    Visit_encounter_hash["#{patient_id}#{encounter_date}"] = $visit_encounter_id
    # increment the counter
    $visit_encounter_id += 1
    # assign the id to the vdate object
    vdate.id = Visit_encounter_hash["#{patient_id}#{encounter_date}"]
  end

  if Output_sql == 1
    $visits_outfile << "INSERT INTO visit_encounters (id, patient_id, visit_date) VALUES (#{vdate.id}, #{patient_id}, '#{encounter_date}');\n"
  end

  return vdate.id
end

def preprocess_insert_val(val)
  # numbers returned as strings with no quotes
  if val.kind_of? Integer
    return val.to_s
  end

  # null values returned
  if val == nil || val == ""
    return "NULL"
  end

  # escape characters and return with quotes
  val = val.to_s.gsub("'", "''")
  return "'" + val + "'"
end


def self.create_patient(pat)
  #temp = PersonName.find(:last, :conditions => ["person_id = ? and voided = 0", pat.id])
  temp = []
  Patient.find_by_sql("select pn.person_id, pn.given_name, pn.family_name, pn.family_name2,pn.middle_name,
                             pn.middle_name, p.gender, p.birthdate, p.birthdate_estimated,
                             pa.address2, pa.city_village, pa.county_district, pa.subregion,
                             p.dead
                      from #{Source_db}.person_name pn
                        left join #{Source_db}.person p on p.person_id = pn.person_id
                        left join #{Source_db}.person_address pa on pa.person_id = pn.person_id
                      where pn.voided = 0
                      and p.person_id = #{pat.id}
                      order by p.date_created DESC
                      limit 1").collect{|d| temp << d}

  identifiers = self.get_patient_identifiers(pat.id)

  attributes = self.get_patient_attribute(pat.id)

  guardian = Relationship.find(:all, :conditions => ["person_a = ?", pat.id]).last
  patient = PatientRecord.new()
  patient.patient_id = pat.id
  temp.each do |p|
	  patient.given_name = p.given_name rescue nil
	  patient.middle_name = p.middle_name rescue nil
	  patient.family_name = p.family_name rescue nil
    patient.mothers_surname = p.family_name2 rescue nil
	  patient.gender = p.gender
	  patient.dob = p.birthdate
	  patient.dob_estimated = p.birthdate_estimated
    patient.dead = p.dead
    patient.current_address = p.city_village
    patient.home_village = p.address2
    patient.current_ta = p.county_district
    patient.group_ta = p.subregion
  end

  patient.nat_id = identifiers["nat_id"]
  patient.ivr_code_id = identifiers["ivr_code"]
  patient.anc_connect_id = identifiers["anc_conn"]
  patient.cellphone_number = attributes["cell_phone"]
  patient.office_phone_number = attributes["office_phone"]
  patient.occupation = attributes["occ"]
  patient.nearest_health_facility = attributes["nearest_fac"]

  patient.void_reason = pat.void_reason
  patient.date_voided = pat.date_voided
  patient.voided_by = pat.voided_by
  patient.date_created = pat.date_created.to_date
  patient.creator = User.find_by_user_id(pat.creator).username rescue User.first.username

	if pat.voided
	  patient.voided = 1
  end

  if !guardian.nil?
    patient.guardian_id = guardian.person_b
  end

  if Use_queue > 0
    if Patient_queue[Patient_queue_size-1] == nil
      Patient_queue << patient
    else
      flush_patient()
      Patient_queue << patient
    end
  else
    patient.save()
  end

end

def self.create_guardian(pat)
  person_id = Person.find(:last, :conditions => ["person_id = ? ", pat.id]).person_id rescue nil
  relatives = Relationship.find(:all, :conditions => ["person_a = ?", person_id])
  (relatives || []).each do |relative|
    guardian = Guardian.new()
    guardian_patient_id = Person.find(:last, :conditions => ["person_id = ? ", relative.person_b]).person_id rescue nil
    temp_relative = Patient.find(:last, :conditions => ["patient_id = ? ", guardian_patient_id]) rescue nil
    guardian.patient_id = pat.id
    guardian.relative_id = guardian_patient_id

    temp = []
    Patient.find_by_sql("select pn.person_id, pn.given_name, pn.family_name, pn.middle_name,
                               pn.middle_name, p.birthdate, p.birthdate_estimated,
                               pa.address2, pa.city_village, pa.county_district, pa.subregion,
                               p.dead, p.gender
                        from #{Source_db}.person_name pn
                          left join #{Source_db}.person p on p.person_id = pn.person_id
                          left join #{Source_db}.person_address pa on pa.person_id = pn.person_id
                        where pn.voided = 0
                        and p.person_id = #{pat.id}
                        order by p.date_created DESC
                        limit 1").collect{|d| temp << d}

    temp.each do |gurd|
      guardian.family_name = gurd.family_name #rescue nil
      guardian.name = gurd.given_name #rescue nil
      guardian.gender = gurd.gender #rescue nil
    end
    #raise relative.relationship.to_yaml
    guardian.relationship = RelationshipType.find(relative.relationship).b_is_to_a

    guardian.creator = User.find_by_user_id(temp_relative.creator).username rescue User.first.username
    guardian.date_created = relative.date_created
    Guardian_queue << guardian
  end
end

def self.get_patient_identifiers(pat_id)
	pat_identifiers = Hash.new()
	identifiers = PatientIdentifier.find_by_sql("select pi.* from #{Source_db}.patient_identifier pi
                                            where pi.date_created = (select max(pid.date_created)
                                                                     from #{Source_db}.patient_identifier pid
                                                                     where pid.patient_id = pi.patient_id
                                                                     and pid.voided = 0
                                                                     and pid.identifier_type = pi.identifier_type)
                                            and pi.patient_id = #{pat_id}
                                            and pi.voided = 0")

	identifiers.each do |id|
		#id_type=PatientIdentifierType.find(id.identifier_type).name
		#case id_type.upcase
    if id.identifier_type ==  3 #'National id'
				pat_identifiers["nat_id"] = id.identifier
		elsif id.identifier_type ==  21 #'IVR Access Code'
				pat_identifiers["ivr_code"] = id.identifier
		elsif id.identifier_type ==  25 #''ANC Connect ID'
				pat_identifiers["anc_conn"] = id.identifier
    else
		end
	end
	return pat_identifiers
end

def self.get_patient_attribute(pat_id)

	pat_attributes = PatientIdentifier.find_by_sql("select pa.* from #{Source_db}.person_attribute pa
                                            where pa.date_created = (select max(pad.date_created)
                                                                     from #{Source_db}.person_attribute pad
                                                                     where pad.person_id = pa.person_id
                                                                     and pad.voided = 0)
                                            and pa.person_id = #{pat_id}
                                            and pa.voided = 0")
  attributes = Hash.new()

	pat_attributes.each do |id|
      if id.person_attribute_type_id == "12" #'Cell Phone Number'
				attributes["cell_phone"] = id.value
		  elsif id.person_attribute_type_id == '13' #'Occupation'
				attributes["occ"] = id.value
	    elsif id.person_attribute_type_id == "15" #'Office Phone Number'
				attributes["office_phone"] = id.value
      elsif id.person_attribute_type_id == "30" #'Nearest health facilityr'
        attributes["nearest_fac"] = id.value
      else
      end
	end
	return attributes
end

def self.create_record(visit_encounter_id, encounter)
  case encounter.name.upcase
    when 'REGISTRATION'
      self.create_registration_encounter(visit_encounter_id, encounter)
    when 'UPDATE OUTCOME'
      self.create_update_outcome_encounter(visit_encounter_id, encounter)
    when 'TIPS AND REMINDERS'
      self.create_tips_and_reminders_encounter(visit_encounter_id, encounter)
    when 'MATERNAL HEALTH SYMPTOMS'
      self.create_maternal_health_symptoms_encounter(visit_encounter_id, encounter)
    when 'CHILD HEALTH SYMPTOMS'
      self.create_child_health_symptoms_encounter(visit_encounter_id, encounter)
    when 'BABY DELIVERY'
      self.create_baby_delivery_encounter(visit_encounter_id, encounter)
    when 'PREGNANCY STATUS'
      self.create_pregnancy_status_encounter(visit_encounter_id, encounter)
    when 'BIRTH PLAN'
      self.create_birth_plan_encounter(visit_encounter_id, encounter)
    when 'ANC VISIT'
      self.create_anc_visit_encounter(visit_encounter_id, encounter)
    else
      $failed_encs << "#{encounter.encounter_id} : Invalid encounter type "
  end

end

def self.create_registration_encounter(visit_encounter_id, encounter)
  enc = RegistrationEncounter.new()
  enc.patient_id = encounter.patient_id
  enc.location = Location.find(encounter.location_id).name
  enc.visit_encounter_id = visit_encounter_id
  enc.date_created = encounter.date_created
  enc.encounter_datetime = encounter.encounter_datetime
  enc.old_enc_id = encounter.encounter_id
  enc.creator = User.find_by_user_id(encounter.creator).username rescue User.first.username

  (encounter.observations || []).each do |ob|
     if ob.concept_id == 8304 #call_id
     	enc.call_id = ob.value_text
     end
  end

  # check if we are to utilize the queue
	if $migratedencs[visit_encounter_id.to_s+"registration"] == false
		if Use_queue > 0
		  if Registration_queue[Registration_size-1] == nil
		    Registration_queue << enc
		  else
		    flush_registration()
		    Registration_queue << enc
		  end
		else
		  enc.save
		end
		$migratedencs[visit_encounter_id.to_s+"registration"] = true
	else
    $duplicates_outfile << "Enc_id: #{encounter.id}, Pat_id: #{encounter.patient_id}, Enc_type: Registration \n"
	end
end

def self.create_tips_and_reminders_encounter(visit_encounter_id, encounter)
  enc = TipsAndRemindersEncounter.new()
  enc.patient_id = encounter.patient_id
  enc.visit_encounter_id = visit_encounter_id
  enc.old_enc_id = encounter.encounter_id
  enc.location = Location.find(encounter.location_id).name
  enc.date_created = encounter.date_created
  enc.encounter_datetime = encounter.encounter_datetime
  enc.creator = User.find_by_user_id(encounter.creator).username rescue User.first.username

  #get the appointment_date value
  (encounter.observations || []).each do |ob|
    if ob.value_text
      value = ob.value_text
    else
      value = self.get_concept(ob.value_coded)
    end

    if ob.concept_id == 1426 #'TELEPHONE NUMBER'
      enc.telephone_number = value
	  elsif ob.concept_id == 2613 #'TELEPHONE NUMBER TYPE'
		  enc.telephone_number_type = value
	  elsif ob.concept_id == 6794 #'WHO IS PRESENT AS GUARDIAN'
		  enc.who_is_present_as_quardian = value
   	elsif ob.concept_id ==  8304 #'CALL ID'
		  enc.call_id = value
	  elsif ob.concept_id == 8315 #'ON TIPS AND REMINDERS PROGRAM'
		  enc.on_tips_and_reminders = value
	  elsif ob.concept_id ==  8317 #'TYPE OF MESSAGE'
		  enc.type_of_message = value
	  elsif ob.concept_id ==  8316 #'LANGUAGE PREFERENCE'
		  enc.language_preference = value
	  elsif ob.concept_id ==  8318 #'TYPE OF MESSAGE CONTENT'
      enc.type_of_message_content = value
    else
    end
  end

  # check if we are to utilize the queue
  if $migratedencs[visit_encounter_id.to_s+"tips_and_reminders"] == false
		if Use_queue > 0
		  if Tips_and_reminders_queue[Tips_and_reminders_size-1] == nil
		    Tips_and_reminders_queue << enc
		  else
		    flush_tips_and_reminders()
		    Tips_and_reminders_queue << enc
		  end
		else
		  enc.save
    end
		$migratedencs[visit_encounter_id.to_s+"tips_and_reminders"] = true
	else
	    $duplicates_outfile << "Enc_id: #{encounter.id}, Pat_id: #{encounter.patient_id}, Enc_type: Tips and reiminders \n"
	end
end

def self.create_update_outcome_encounter(visit_encounter_id, encounter)
  enc = UpdateOutcomesEncounter.new()
  enc.patient_id = encounter.patient_id
  enc.location = Location.find(encounter.location_id).name
  enc.visit_encounter_id = visit_encounter_id
  enc.old_enc_id = encounter.encounter_id
  enc.date_created = encounter.date_created
  enc.encounter_datetime = encounter.encounter_datetime
  enc.creator = User.find_by_user_id(encounter.creator).username rescue User.first.username

 (encounter.observations || []).each do |ob|
   if ob.value_text
     value = ob.value_text
   else
     value = self.get_concept(ob.value_coded)
   end
      if ob.concept_id == 6538 #'OUTCOME'
        enc.outcome = value
      elsif ob.concept_id == 8304 #'CALL ID'
        enc.call_id = value
      elsif ob.concept_id ==  8341 #'HEALTH FACILITY NAME'
        enc.health_facility_name = value
      elsif ob.concept_id ==  8343 #'REASON FOR REFERRAL'
        enc.reason_for_referral = value
      elsif ob.concept_id ==  9149 #'SECONDARY OUTCOME'
        enc.secondary_outcome = value
      end
  end

	if $migratedencs[visit_encounter_id.to_s+"update_outcome"] == false
		if Use_queue > 0
		  if Update_outcome_queue[Update_outcome_size-1] == nil
		    Update_outcome_queue << enc
		  else
		    flush_update_outcome()
		    Update_outcome_queue << enc
		  end
		else
		  enc.save()
		end
		$migratedencs[visit_encounter_id.to_s+"update_outcome"] = true
	else
	    $duplicates_outfile << "Enc_id: #{encounter.id}, Pat_id: #{encounter.patient_id}, Enc_type: Update Outcome \n"
	end
end

def self.create_maternal_health_symptoms_encounter(visit_encounter_id, encounter)
  enc = MaternalHealthSymptomsEncounter.new()
  enc.patient_id = encounter.patient_id
  enc.location = Location.find(encounter.location_id).name
  enc.visit_encounter_id = visit_encounter_id
  enc.old_enc_id = encounter.encounter_id
  enc.date_created = encounter.date_created
  enc.encounter_datetime = encounter.encounter_datetime
  enc.creator = User.find_by_user_id(encounter.creator).username rescue User.first.username

  (encounter.observations || []).each do |ob|
		if ob.concept_id == 151 #'Abdominal pain'
		  enc.abdominal_pain = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 374 #'Method of family planning'
		  enc.method_of_family_planning = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 1717 #'Patient using family planning'
		  enc.patient_using_family_planning = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id ==   2310#'Current complaints or symptoms'
		  enc.current_complaints_or_symptoms = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id ==  5271 #'Family planning'
		  enc.family_planning = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 6408 #'Other'
		  enc.family_planning = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 7180 #'Infertility'
		  enc.infertility = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 7757 #'Acute abdominal pain'
		  enc.acute_abdominal_pain = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 7778 #'Vaginal bleeding during pregnancy'
		  enc.vaginal_bleeding_during_pregnancy = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 7779 #'Postnatal bleeding'
		  enc.postnatal_bleeding = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8289 #'Healthcare visits'
		  enc.healthcare_visits = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8290 #'Nutrition'
		  enc.nutrition = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8291 #'Body changes'
		  enc.body_changes = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8292 #'Discomfort'
		  enc.discomfort = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8293 #'Concerns'
		  enc.concerns = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8294 #'Emotions'
		  enc.emotions = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8295 #'Warning signs'
		  enc.warning_signs = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8296 #'Routines'
		  enc.routines = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8297 #'Beliefs'
		  enc.beliefs = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8298 #'Baby\'s growth'
		  enc.babys_growth = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8299 #'Milestones'
		  enc.milestones = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8300 #'Prevention'
		  enc.prevention = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8301 #'Heavy vaginal bleeding during pregnancy'
		  enc.heavy_vaginal_bleeding_during_pregnancy = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8302 #'Excessive postnatal bleeding'
		  enc.excessive_postnatal_bleeding = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8303 #'Severe headache'
		  enc.severe_headache = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8304 #'Call ID'
		  enc.call_id = ob.value_text if self.get_concept(ob.value_coded).blank?
		elsif ob.concept_id == 8326 #'Fever during pregnancy sign'
		  enc.fever_during_pregnancy_sign = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8327 #'Fever during pregnancy symptom'
		  enc.fever_during_pregnancy_symptom = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8328 #'Postnatal fever sign'
		  enc.postnatal_fever_sign = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8329 #'Postnatal fever symptom'
		  enc.postnatal_fever_symptom = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8330 #'Headaches'
		  enc.headaches = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8331 #'Fits or convulsions sign'
		  enc.fits_or_convulsions_sign = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8332 #'Fits or convulsions symptom'
		  enc.fits_or_convulsions_symptom = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8333 #'Swollen hands or feet sign'
		  enc.swollen_hands_or_feet_sign = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8334 #'Swollen hands or feet symptom'
		  enc.swollen_hands_or_feet_symptom = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8335 #'Paleness of the skin and tiredness sign'
		  enc.paleness_of_the_skin_and_tiredness_sign = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8336 #'Paleness of the skin and tiredness symptom'
		  enc.paleness_of_the_skin_and_tiredness_symptom = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8337 #'No fetal movements sign'
		  enc.no_fetal_movements_sign = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8338 #'No fetal movements symptom'
		  enc.no_fetal_movements_symptom = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8339 #'Water breaks sign'
		  enc.water_breaks_sign = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 8340 #'Water breaks symptom'
		  enc.water_breaks_symptom = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 9150 #'Postnatal discharge bad smell'
		  enc.postnatal_discharge_bad_smell = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 9151 #'Problems with monthly periods'
		  enc.problems_with_monthly_periods = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 9152 #'Frequent miscarriages'
		  enc.frequent_miscarriages = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 9153 #'Vaginal bleeding not during pregnancy'
		  enc.vaginal_bleeding_not_during_pregnancy = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 9154 #'Vaginal itching'
		  enc.vaginal_itching = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 9155 #'0Birth planning male'
		  enc.birth_planning_male = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 9156 #'Birth planning female'
		  enc.birth_planning_female = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 9159 #'Satisfied with family planning method'
		  enc.satisfied_with_family_planning_method = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 9160 #'Require information on family planning'
		  enc.require_information_on_family_planning = self.get_concept(ob.value_coded) if ob.value_text.blank?
		elsif ob.concept_id == 9163 #'Problems with family planning method'
		  enc.problems_with_family_planning_method = self.get_concept(ob.value_coded) if ob.value_text.blank?
    else
    end
  end

  if $migratedencs[visit_encounter_id.to_s+"maternal_health_symptoms"] == false
    if  Use_queue > 0
	  if Maternal_health_symptoms_queue[Maternal_health_symptoms_size-1] == nil
		 Maternal_health_symptoms_queue << enc
	  else
		 flush_maternal_health_symptoms()
		 Maternal_health_symptoms_queue << enc
	  end
    else
	  enc.save()
	end
    $migratedencs[visit_encounter_id.to_s+"maternal_health_symptoms"] = true
  else
	$duplicates_outfile << "Enc_id: #{encounter.id}, Pat_id: #{encounter.patient_id}, Enc_type: Maternal Health Symptoms \n"
  end
end

def self.create_child_health_symptoms_encounter(visit_encounter_id, encounter)
  enc = ChildHealthSymptomsEncounter.new()
  enc.patient_id = encounter.patient_id
  enc.visit_encounter_id = visit_encounter_id
  enc.old_enc_id = encounter.encounter_id
  enc.location = Location.find(encounter.location_id).name
  enc.date_created = encounter.date_created
  enc.encounter_datetime = encounter.encounter_datetime
  enc.creator = User.find_by_user_id(encounter.creator).username rescue User.first.username

 (encounter.observations || []).each do |ob|

   if ob.concept_id == 16 #'Diarrhea'
     enc.diarrhea = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 107  #'Cough'
     enc.cough = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 876 #'Fast breathing'
     enc.fast_breathing = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 3647 #'Skin dryness'
    enc.skin_dryness = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 3692 #'Eye infection'
    enc.eye_infection = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 5945 #'Fever'
    enc.fever = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 5980 #'Vomiting'
    enc.vomiting = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 6408 #'Other'
    enc.other = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8267 #'Crying'
    enc.crying = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8269 #'Not eating'
    enc.not_eating = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8270 #'Very sleepy'
    enc.very_sleepy = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8271 #'Unconscious'
    enc.unconscious = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8272 #'Sleeping'
    enc.sleeping = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8273 #'Feeding problems'
    enc.feeding_problems = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8274 #'Bowel movements'
    enc.bowel_movements = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8275 #'Skin infections'
    enc.skin_infections = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8276 #'Umbilicus infection'
    enc.umbilicus_infection = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8277 #'Growth milestones'
    enc.growth_milestones = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8278 #'Accessing healthcare services'
    enc.accessing_healthcare_services = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8279 #'Fever of 7 days or more'
    enc.fever_of_7_days_or_more = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8280 #'Diarrhea for 14 days or more'
    enc.diarrhea_for_14_days_or_more = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8281 #'Blood in stool'
    enc.blood_in_stool = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8282 #'Cough for 21 days or more'
    enc.cough_for_21_days_or_more or more = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8283 #'Not eating or drinking anything'
    enc.not_eating_or_drinking_anything = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8284 #'Red eye for 4 days or more with visual problems'
      enc.red_eye_for_4_days_or_more_with_visual_problems = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8285 #'Potential chest indrawing'
    enc.potential_chest_indrawing = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8304 #'Call ID'
     enc.call_id = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8319 #'Very sleepy or unconscious'
     enc.very_sleepy_or_unconscious = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8322 #'Convulsions sign'
     enc.convulsions_sign = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8323 #'Convulsions symptom'
     enc.convulsions_symptom = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8324 #'Skin rashes'
     enc.skin_rashes = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8325 #'Vomiting everything'
     enc.vomiting_everything = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8333 #'Swollen hands or feet sign'
     enc.swollen_hands_or_feet_sign = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8368 #'Severity of fever'
     enc.severity_of_fever = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8369 #'Severity of cough'
     enc.severity_of_cough = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8370 #'Severity of red eye'
     enc.severity_of_red_eye = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id ==  8371 #'Severity of diarrhea'
     enc.severity_of_diarrhea = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8409 #'Visual problems'
       enc.visual_problems = self.get_concept(ob.value_coded) if ob.value_text.blank?
   elsif ob.concept_id == 8412 #'Gained or lost weight'
     enc.gained_or_lost_weight = self.get_concept(ob.value_coded) if ob.value_text.blank?
   else
   end
   end

	if $migratedencs[visit_encounter_id.to_s+"child_health_symptoms"] == false
		if Use_queue > 0
		  if Child_health_symptoms_queue[Child_health_symptoms_size-1] == nil
		    Child_health_symptoms_queue << enc
		  else
		    flush_child_health_symptoms()
		    Child_health_symptoms_queue << enc
		  end
		else
		  enc.save()
		end
		$migratedencs[visit_encounter_id.to_s+"child_health_symptoms"] = true
	else
	    $duplicates_outfile << "Enc_id: #{encounter.id}, Pat_id: #{encounter.patient_id}, Enc_type: Child Health Symptoms \n"
	end
end

def self.create_baby_delivery_encounter(visit_encounter_id, encounter)
  enc = BabyDeliveryEncounter.new()
  enc.patient_id = encounter.patient_id
  enc.location = Location.find(encounter.location_id).name
  enc.visit_encounter_id = visit_encounter_id
  enc.old_enc_id = encounter.encounter_id
  enc.date_created = encounter.date_created
  enc.encounter_datetime = encounter.encounter_datetime
  enc.creator = User.find_by_user_id(encounter.creator).username rescue User.first.username

  (encounter.observations || []).each do |ob|
    if ob.value_text
      value = ob.value_text
    else
      value = self.get_concept(ob.value_coded)
    end

	  if ob.concept_id ==  7377 #'Delivered'
	    enc.delivered = value
	  elsif ob.concept_id ==  8304 #'Call ID'
	    enc.call_id = value
	  elsif ob.concept_id ==  8341 #'Health facility name'
	    enc.health_facility_name = value
	  elsif ob.concept_id ==  8342 #'Delivery date'
	    enc.delivery_date = ob.value_text
	  elsif ob.concept_id ==  9455 #'Delivery location'
	    enc.delivery_location = value
    else
    end
  end

	if $migratedencs[visit_encounter_id.to_s+"baby_delivery"] == false
		if Use_queue > 0
		  if Baby_delivery_queue[Baby_delivery_size-1] == nil
		    Baby_delivery_queue << enc
		  else
		    flush_baby_delivery()
		    Baby_delivery_queue << enc
		  end
		else
		  enc.save()
		end
		$migratedencs[visit_encounter_id.to_s+"baby_delivery"] = true
	else
    $duplicates_outfile << "Enc_id: #{encounter.id}, Pat_id: #{encounter.patient_id}, Enc_type: Baby Delivery \n"
	end
end

def self.create_pregnancy_status_encounter(visit_encounter_id, encounter)
  enc = PregnancyStatusEncounter.new()
  enc.patient_id = encounter.patient_id
  enc.location = Location.find(encounter.location_id).name
  enc.visit_encounter_id = visit_encounter_id
  enc.old_enc_id = encounter.encounter_id
  enc.date_created = encounter.date_created
  enc.encounter_datetime = encounter.encounter_datetime
  enc.creator = User.find_by_user_id(encounter.creator).username rescue User.first.username

  (encounter.observations || []).each do |ob|
    if ob.value_text
      value = ob.value_text
    else
      value = self.get_concept(ob.value_coded)
    end

	  if ob.concept_id == 5272 #'Pregnancy status'
	    enc.pregnancy_status = value
	  elsif ob.concept_id == 8304 #'Call ID'
	    enc.call_id = ob.value_text
	  elsif ob.concept_id == 6188 #'Pregnancy due date'
	    enc.pregnancy_due_date = ob.value_text
	  elsif ob.concept_id == 8342 #'Delivery date'
	    enc.delivery_date = ob.value_text
    else
    end
  end

	if $migratedencs[visit_encounter_id.to_s+"pregnancy_status"] == false
		if Use_queue > 0
		  if Pregnancy_status_queue[Pregnancy_status_size-1] == nil
		    Pregnancy_status_queue << enc
		  else
		    flush_pregnancy_status()
		    Pregnancy_status_queue << enc
		  end
		else
		  enc.save()
		end
		$migratedencs[visit_encounter_id.to_s+"pregnancy_status"] = true
	else
    $duplicates_outfile << "Enc_id: #{encounter.id}, Pat_id: #{encounter.patient_id}, Enc_type: Pregnancy Status \n"
	end
end

def self.create_anc_visit_encounter(visit_encounter_id, encounter)
  enc = AncVisitEncounter.new()
  enc.patient_id = encounter.patient_id
  enc.location = Location.find(encounter.location_id).name
  enc.visit_encounter_id = visit_encounter_id
  enc.old_enc_id = encounter.encounter_id
  enc.date_created = encounter.date_created
  enc.encounter_datetime = encounter.encounter_datetime
  enc.creator = User.find_by_user_id(encounter.creator).username rescue User.first.username

  (encounter.observations || []).each do |ob|
    if ob.value_text
      value = ob.value_text
    else
      value = self.get_concept(ob.value_coded)
    end

	  if ob.concept_id == 6259 #'Antenatal clinic patient appointment'
	    enc.antenatal_clinic_patient_appointment = value
	  elsif ob.concept_id ==  8304 #'Call ID'
	    enc.call_id =  ob.value_text
	  elsif ob.concept_id ==  9443 #'Reason for not attending ANC'
	    enc.reason_for_not_attending_anc = value
	  elsif ob.concept_id ==  9457 #'Last ANC Visit Date'
	    enc.last_anc_visit_date = value
	  elsif ob.concept_id ==  9459 #'Next ANC Visit Date'
	    enc.next_anc_visit_date = value
	  else
      end
  end

	if $migratedencs[visit_encounter_id.to_s+"anc_visit"] == false
		if Use_queue > 0
		  if ANC_visit_queue[ANC_visit_size-1] == nil
		    ANC_visit_queue << enc
		  else
		    flush_anc_visit()
		    ANC_visit_queue << enc
		  end
		else
		  enc.save()
		end
		$migratedencs[visit_encounter_id.to_s+"anc_visit"] = true
	else
	    $duplicates_outfile << "Enc_id: #{encounter.id}, Pat_id: #{encounter.patient_id}, Enc_type: ANC Visit \n"
	end
end

def self.create_birth_plan_encounter(visit_encounter_id, encounter)
  enc = BirthPlanEncounter.new()
  enc.patient_id = encounter.patient_id
  enc.location = Location.find(encounter.location_id).name
  enc.visit_encounter_id = visit_encounter_id
  enc.old_enc_id = encounter.encounter_id
  enc.date_created = encounter.date_created
  enc.encounter_datetime = encounter.encounter_datetime
  enc.creator = User.find_by_user_id(encounter.creator).username rescue User.first.username

  (encounter.observations || []).each do |ob|
    if ob.value_text
      value = ob.value_text
    else
      value = self.get_concept(ob.value_coded)
    end
	if ob.concept_id == 9456 #'Go to hospital date'
	  enc.go_to_hospital_date = value
	elsif ob.concept_id == 8304 #'Call ID'
	  enc.call_id = value
	elsif ob.concept_id == 9455 #'Delivery location'
	  enc.delivery_location = value
	elsif ob.concept_id == 9460 #'Birth plan'
	  enc.birth_plan = value
    else
    end
  end

	if $migratedencs[visit_encounter_id.to_s+"birth_plan"] == false
		if Use_queue > 0
		  if Birth_plan_queue[Birth_plan_size-1] == nil
		    Birth_plan_queue << enc
		  else
		    flush_birth_plan()
		    Birth_plan_queue << enc
		  end
		else
		  enc.save()
		end
		$migratedencs[visit_encounter_id.to_s+"birth_plan"] = true
	else
	    $duplicates_outfile << "Enc_id: #{encounter.id}, Pat_id: #{encounter.patient_id}, Enc_type: Birth Plan \n"
	end
end

def self.get_concept(id)
  begin
    if Concepts[id] == nil
      con_name = Concept.find_by_sql("SELECT name FROM #{Source_db}.concept_name
                                      WHERE concept_id = #{id}
                                      GROUP BY concept_id").map(&:name)
      return con_name
    else
	  con_name = Concept.find_by_sql("SELECT name FROM #{Source_db}.concept_name
                                      WHERE concept_id = #{id}
                                      GROUP BY concept_id").map(&:name)
      return con_name
    end
  rescue
    $missing_concept_errors += 1
    #Concept.find_by_name('Missing').name
  end

end

def preprocess_insert_val(val)

  # numbers returned as strings with no quotes
  if val.kind_of? Integer
    return val.to_s
  end

  # null values returned
  if val == nil || val == ""
    return "NULL"
  end

  # escape characters and return with quotes
  val = val.to_s.gsub("'", "''")
  return "'" + val + "'"
end

def flush_patient()
  flush_queue(Patient_queue, "patients", ['patient_id','given_name', 'middle_name', 'family_name', 'mothers_surname', 'gender', 'dob', 'dob_estimated', 'dead', 'traditional_authority','guardian_id', 'current_address', 'landmark', 'cellphone_number', 'home_phone_number', 'office_phone_number', 'occupation', 'nat_id', 'art_number', 'pre_art_number', 'tb_number', 'legacy_id', 'legacy_id2', 'legacy_id3', 'new_nat_id', 'prev_art_number', 'filing_number', 'archived_filing_number', 'ivr_code_id', 'anc_connect_id', 'nearest_health_facility', 'home_village', 'current_ta', 'group_ta', 'voided', 'void_reason', 'date_voided', 'voided_by', 'date_created', 'creator'])
end

def flush_registration()
  flush_queue(Registration_queue, "registration_encounters", ['visit_encounter_id','old_enc_id', 'patient_id', 'call_id', 'location', 'encounter_datetime', 'date_created', 'creator'])
end

def flush_update_outcome()
  flush_queue(Update_outcome_queue, "update_outcomes_encounters", ['visit_encounter_id','old_enc_id', 'patient_id', 'outcome', 'call_id', 'health_facility_name', 'reason_for_referral', 'secondary_outcome', 'location', 'encounter_datetime', 'date_created', 'creator'])
end

def flush_tips_and_reminders()
  flush_queue(Tips_and_reminders_queue, "tips_and_reminders_encounters", ['visit_encounter_id','old_enc_id', 'patient_id', 'telephone_number', 'telephone_number_type', 'who_is_present_as_quardian', 'call_id', 'on_tips_and_reminders', 'type_of_message', 'language_preference', 'type_of_message_content', 'location', 'encounter_datetime', 'date_created', 'creator'])
end

def flush_maternal_health_symptoms()
  flush_queue(Maternal_health_symptoms_queue, "maternal_health_symptoms_encounters", ['visit_encounter_id','old_enc_id', 'patient_id', 'abdominal_pain', 'method_of_family_planning', 'patient_using_family_planning', 'current_complaints_or_symptoms', 'family_planning', 'other', 'infertility', 'acute_abdominal_pain', 'vaginal_bleeding_during_pregnancy', 'postnatal_bleeding', 'healthcare_visits', 'nutrition', 'body_changes', 'discomfort', 'concerns', 'emotions', 'warning_signs', 'routines', 'beliefs', 'babys_growth', 'milestones', 'prevention', 'heavy_vaginal_bleeding_during_pregnancy', 'excessive_postnatal_bleeding', 'severe_headache', 'call_id', 'fever_during_pregnancy_sign', 'fever_during_pregnancy_symptom', 'postnatal_fever_sign', 'postnatal_fever_symptom', 'headaches', 'fits_or_convulsions_sign', 'fits_or_convulsions_symptom', 'swollen_hands_or_feet_sign', 'swollen_hands_or_feet_symptom', 'paleness_of_the_skin_and_tiredness_sign', 'paleness_of_the_skin_and_tiredness_symptom', 'no_fetal_movements_sign', 'no_fetal_movements_symptom', 'water_breaks_sign', 'water_breaks_symptom', 'postnatal_discharge_bad_smell', 'problems_with_monthly_periods', 'frequent_miscarriages', 'vaginal_bleeding_not_during_pregnancy', 'vaginal_itching', 'birth_planning_male', 'birth_planning_female', 'satisfied_with_family_planning_method', 'require_information_on_family_planning', 'problems_with_family_planning_method', 'location', 'encounter_datetime', 'date_created', 'creator'])
end

def flush_child_health_symptoms()
  flush_queue(Child_health_symptoms_queue, "child_health_symptoms_encounters", ['visit_encounter_id','old_enc_id', 'patient_id','diarrhea', 'cough', 'fast_breathing', 'skin_dryness', 'eye_infection', 'fever', 'vomiting', 'other', 'crying', 'not_eating', 'very_sleepy', 'unconscious', 'sleeping', 'feeding_problems', 'bowel_movements', 'skin_infections', 'umbilicus_infection', 'growth_milestones', 'accessing_healthcare_services', 'fever_of_7_days_or_more', 'diarrhea_for_14_days_or_more', 'blood_in_stool', 'cough_for_21_days_or_more', 'not_eating_or_drinking_anything', 'red_eye_for_4_days_or_more_with_visual_problems', 'potential_chest_indrawing', 'call_id', 'very_sleepy_or_unconscious', 'convulsions_sign', 'convulsions_symptom', 'skin_rashes', 'vomiting_everything', 'swollen_hands_or_feet_sign', 'severity_of_fever', 'severity_of_cough', 'severity_of_red_eye', 'severity_of_diarrhea', 'visual_problems', 'gained_or_lost_weight', 'location', 'encounter_datetime', 'date_created', 'creator'])
end

def flush_baby_delivery()
  flush_queue(Baby_delivery_queue, "baby_delivery_encounters", ['visit_encounter_id','old_enc_id', 'patient_id', 'delivered', 'call_id', 'health_facility_name', 'delivery_date', 'delivery_location', 'location', 'encounter_datetime', 'date_created', 'creator'])
end

def flush_pregnancy_status()
  flush_queue(Pregnancy_status_queue, "pregnancy_status_encounters", ['visit_encounter_id','old_enc_id', 'patient_id', 'pregnancy_status', 'call_id', 'pregnancy_due_date', 'delivery_date', 'location', 'encounter_datetime', 'date_created', 'creator'])
end

def flush_birth_plan()
  flush_queue(Birth_plan_queue, "birth_plan_encounters", ['visit_encounter_id','old_enc_id', 'patient_id', 'go_to_hospital_date' ,'call_id' ,'delivery_location', 'birth_plan', 'location', 'encounter_datetime', 'date_created', 'creator'])
end

def flush_anc_visit()
  flush_queue(ANC_visit_queue, "anc_visit_encounters", ['visit_encounter_id','old_enc_id', 'patient_id', 'antenatal_clinic_patient_appointment', 'call_id', 'reason_for_not_attending_anc', 'last_anc_visit_date', 'next_anc_visit_date', 'location', 'encounter_datetime', 'date_created', 'creator'])
end

#def flush_patient_outcome()
#  flush_queue(Patient_outcome_queue, "patient_outcomes", ['visit_encounter_id', 'patient_id', 'outcome_state', 'outcome_date'])
#end

def flush_users()
  flush_queue(Users_queue, 'users', ['username', 'first_name', 'middle_name', 'last_name', 'person_id', 'user_id', 'password', 'salt', 'user_role1', 'user_role2', 'user_role3', 'user_role4', 'user_role5', 'user_role6', 'user_role7', 'user_role8', 'user_role9', 'user_role10', 'date_created', 'voided', 'void_reason', 'date_voided', 'voided_by', 'creator'])
end

def flush_guardians()
  flush_queue(Guardian_queue, "guardians", ['patient_id', 'relative_id', 'family_name', 'name', 'gender', 'relationship', 'creator', 'date_created'])
end

def flush_queue(queue, table, columns)
  if queue.length == 0
    return
  end

  insert_vals = columns

  inserts = []

  queue.each { |e|
    i = ("(")
    insert_vals.each { |insert_val|
      i += preprocess_insert_val(eval("e.#{insert_val}"))
      i += ", "
    }
    # remove last comma space before appending the end parenthesis
    i = i.chop.chop
    i += ")"
    inserts << i
  }

  sql = "INSERT INTO #{table} (#{insert_vals.join(", ")}) VALUES #{inserts.join(", ")}"

  if Output_sql == 1
    $pat_encounters_outfile << sql + ";\n"
  end

  if Execute_sql == 1
    CONN.execute sql
  end

  queue.clear()
end


def self.create_users()
  users = User.find_by_sql("select u.*, pn.person_id, pn.given_name, pn.family_name, pn.middle_name
                            from #{Source_db}.users u
                              left join #{Source_db}.person_name pn on pn.person_id = u.user_id")
#raise users.to_yaml
  users.each do |user|
    new_user = MigratedUsers.new()
    user_roles = User.find_by_sql("SELECT r.role FROM #{Source_db}.user_role ur
                                       INNER JOIN #{Source_db}.role r ON r.role = ur.role
                                       WHERE user_id = #{user.user_id}").map{|role| role.role}
    #puts "#{user.person_id}......#{user.user_id}.....#{user.username}"
    new_user.username = user.username
    new_user.first_name = user.given_name #rescue nil
    new_user.middle_name = user.middle_name #rescue nil
    new_user.last_name = user.family_name #rescue nil
    new_user.person_id = user.person_id,
    new_user.user_id = user.user_id,
    new_user.password = user.password
    new_user.salt = user.salt
    new_user.user_role1 = user_roles[0]
    new_user.user_role2 = user_roles[1]
    new_user.user_role3 = user_roles[2]
    new_user.user_role4 = user_roles[3]
    new_user.user_role5 = user_roles[4]
    new_user.user_role6 = user_roles[5]
    new_user.user_role7 = user_roles[6]
    new_user.user_role8 = user_roles[7]
    new_user.user_role9 = user_roles[8]
    new_user.user_role10 = user_roles[9]
    new_user.date_created = user.date_created
    new_user.voided = user.voided
    new_user.void_reason = user.void_reason
    new_user.date_voided = user.date_voided
    new_user.voided_by = user.voided_by
    new_user.creator = User.find_by_user_id(user.creator).username if !user.creator.blank?
    Users_queue << new_user
  end
end

start

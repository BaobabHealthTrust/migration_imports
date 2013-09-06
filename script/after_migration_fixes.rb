
def start
=begin
 vitals_concept_ids =  [ConceptName.find_by_name('Weight (Kg)').concept_id,
                        ConceptName.find_by_name('Height (cm)').concept_id,
                        ConceptName.find_by_name('BMI').concept_id]
 
 vitals_patients = Observation.find(:all,
			:conditions => ["concept_id IN (?)", vitals_concept_ids])
  
 ActiveRecord::Base.connection.execute <<EOF                              
      UPDATE obs SET value_numeric = ROUND(value_numeric, 1)                                        
      WHERE concept_id IN ("#{vitals_concept_ids}");        
EOF
=end
  opd_program_id = Program.find_by_name('OPD Program').program_id
  outpatient_reception_enc_type_id = EncounterType.find_by_name('OUTPATIENT RECEPTION').encounter_type_id
  opd_program_patients = Encounter.find_by_sql("SELECT DISTINCT patient_id, encounter_datetime FROM encounter WHERE encounter_type = #{outpatient_reception_enc_type_id}")
  
  opd_program_patients.each do |patient| 
    opd_program_id = PatientProgram.find(:all, :conditions => ['patient_id = ? and program_id = ?', patient.patient_id, opd_program_id ])
    
    if opd_pragram_id.blank?
      PatientProgram.transaction do
        patient_opd_program = PatientProgram.new
        patient_opd_program.patient_id = patient.patient_id
        patient_opd_program.program_id = opd_program_id
        patient_opd_program.date_enrolled = patient.encounter_datetime
        patient_opd_program.creator = 1
        patient_opd_program.date_created = Date.today
        if patient_opd_program.save
          patient_program_id = PatientProgram.find(:last, 
                                    :conditions => ['patient_id = ? and program_id = ?', patient.patient_id, opd_program_id ]).patient_program_id
          pat_state = PatientState.new()
          pat_state.patient_program_id = patient_program_id
          pat_state.state = 126
          pat_state.start_date = patient.encounter_datetime
          pat_state.creator = 1
          pat_state.date_created = Date.today 
          pat_state.save
        end
      end
    end
  end
  
end

start

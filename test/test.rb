#!/usr/bin/ruby

require 'test/unit'
require 'mysql'

class Con < Test::Unit::TestCase

  def colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end

  def red(text); colorize(text, 31); end
  def green(text); colorize(text, 32); end
  def yellow(text); colorize(text, 33); end
  def blue(text); colorize(text, 34); end
  def magenta(text); colorize(text, 35); end
  def cyan(text); colorize(text, 36); end

  def test
    begin

      print green("\tEnter MySQL username: ")

      $username = gets.chomp
      
      puts ""
      print green("\tEnter MySQL password: ")

      `stty -echo`
      $password = gets.chomp
      `stty echo`

      puts ""
      puts ""
      print green("\tEnter Target Database Name: ")

      $database = gets.chomp

      puts ""
      
      con = Mysql.new 'localhost', "#{$username}", "#{$password}", "#{$database}"
      
      date = Time.now.strftime("%Y-%m-%d %H:%M:%S")

      us = con.query "SELECT user_id FROM users LIMIT 1"

      assert us.num_rows > 0, "Line 14: No users found!"

      user_id = us.fetch_row[0] rescue nil

      is = con.query "INSERT INTO person (gender, creator, date_created, uuid) " +
        "VALUES ('F', #{user_id}, '#{date}', (SELECT UUID()))"

      is = con.query "SELECT LAST_INSERT_ID()"
      
      assert is.num_rows > 0, "Line 20: Create person failed!"

      person_id = is.fetch_row[0].to_i

      ps = con.query "INSERT INTO patient (patient_id, creator, date_created, voided) " +
        "VALUES (#{person_id}, #{user_id}, '#{date}', 0)"

      ps = con.query "SELECT LAST_INSERT_ID()"

      assert ps.num_rows > 0, "Line 29: Patient create failed!"
            
      patient_id = ps.fetch_row[0]

      ps = con.query "INSERT INTO patient_program (patient_id, program_id, date_enrolled, " +
        "creator, date_created, voided, uuid) VALUES (#{patient_id}, 1, '#{date}', #{user_id}, " +
        "'#{date}', 0, (SELECT UUID()))"

      ps = con.query "SELECT LAST_INSERT_ID()"

      assert ps.num_rows > 0, "Line 425: patient_program creation failed!"

      patient_program_id = ps.fetch_row[0].to_i

      state = "On antiretrovirals"

      cs = con.query "SELECT concept_name.concept_id FROM concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = 'On ARVs' AND voided = 0 AND retired = 0 LIMIT 1"

      assert cs.num_rows > 0, "Line 435: Failed to pull concept"

      concept_id = cs.fetch_row[0].to_i

      ws = con.query "SELECT program_workflow_state_id FROM program_workflow_state " +
        "WHERE concept_id = #{concept_id} AND program_workflow_id = 1"

      assert ws.num_rows > 0, "Line 441: Failed to pull program_workflow_state_id"

      program_workflow_state_id = ws.fetch_row[0].to_i

      ps = con.query "INSERT INTO patient_state (patient_program_id, state, start_date, " +
        "creator, date_created, voided, uuid) VALUES (#{patient_program_id}, #{program_workflow_state_id}, '#{date}', " +
        " #{user_id} , '#{date}', 0, (SELECT UUID()))";

      fs = con.query "SELECT current_hiv_program_state, current_hiv_program_start_date " +
        " FROM flat_table2 WHERE patient_id = #{person_id} AND visit_date = DATE('#{date}')"

      assert fs.num_rows > 0, "Line 454: Failed to update flat-table with current_hiv_program_state = '#{state}'!"

      row = fs.fetch_row

      assert row[0] == state, "Line 454: Failed to update flat-table with current_hiv_program_state '#{state}'"

      assert row[1] == Time.now.strftime("%Y-%m-%d"), "Line 454: Failed to update flat-table with " +
        "current_hiv_program_start_date '#{Time.now.strftime("%Y-%m-%d")}'"
        
      es = con.query "SELECT encounter_type_id FROM encounter_type WHERE name = 'HIV CLINIC CONSULTATION'"

      assert es.num_rows > 0, "Line 38: Encounter type not found!"

      encounter_type_id = es.fetch_row[0].to_i

      rs = con.query "INSERT INTO encounter (encounter_type, patient_id, " +
        "provider_id, encounter_datetime, creator, date_created, uuid) " +
        "VALUES (#{encounter_type_id}, #{patient_id}, #{user_id}, '#{date}', " +
        "#{user_id}, '#{date}', (SELECT UUID()))"
            
      rs = con.query "SELECT LAST_INSERT_ID()"
            
      encounter_id = rs.fetch_row[0].to_i
            
      assert encounter_id.to_i > 0, "Line 44: Encounter creation failed!"
            
      fields_set1 = [
        ["breastfeeding_yes", "No", "Text", "Breastfeeding", "Yes", "Yes"],
        ["breastfeeding_no", "No", "Text", "Breastfeeding", "No", "No"],
        ["symptom_present_cough", "No", "Text", "Symptom present", "Cough", "Cough"],
        ["transfer_within_responsibility_no", "No", "Text", "Transfer within responsibility", "No", "No"],
        ["transfer_within_responsibility_yes", "No", "Text", "Transfer within responsibility", "Yes", "Yes"],
        ["guardian_present_yes", "No", "Text", "Guardian Present", "Yes", "Yes"],
        ["guardian_present_no", "No", "Text", "Guardian Present", "No", "No"],
        ["patient_present_yes", "No", "Text", "Patient present", "Yes", "Yes"],
        ["patient_present_no", "No", "Text", "Patient present", "No", "No"],
        ["pregnant_yes", "No", "Text", "Is patient pregnant?", "Yes", "Yes"],
        ["pregnant_no", "No", "Text", "Is patient pregnant?", "No", "No"],
        ["currently_using_family_planning_method_yes", "No", "Text", "Currently using family planning method", "Yes", "Yes"],
        ["currently_using_family_planning_method_no", "No", "Text", "Currently using family planning method", "No", "No"],
        ["family_planning_method_oral_contraceptive_pills", "No", "Text", "Method of family planning", "oral contraceptive pills", "Oral contraceptive pills"],
        ["family_planning_method_depo_provera", "No", "Text", "Method of family planning", "depo-provera", "depo-provera"],
        ["family_planning_method_intrauterine_contraception", "No", "Text", "Method of family planning", "intrauterine contraception", "intrauterine contraception"],
        ["family_planning_method_contraceptive_implant", "No", "Text", "Method of family planning", "contraceptive implant", "contraceptive implant"],
        ["family_planning_method_male_condoms", "No", "Text", "Method of family planning", "male condoms", "male condoms"],
        ["family_planning_method_female_condoms", "No", "Text", "Method of family planning", "female condoms", "female condoms"],
        ["family_planning_method__rythm_method", "No", "Text", "Method of family planning", "Rhythm method", "Rhythm method"],
        ["family_planning_method_withdrawal ", "No", "Text", "Method of family planning", "Withdrawal Method", "Withdrawal Method"],
        ["family_planning_method_abstinence", "No", "Text", "Method of family planning", "abstinence", "abstinence"],
        ["family_planning_method_tubal_ligation", "No", "Text", "Method of family planning", "tubal ligation", "tubal ligation"],
        ["family_planning_method_vasectomy", "No", "Text", "Method of family planning", "vasectomy", "vasectomy"],
        ["family_planning_method_emergency__contraception", "No", "Text", "Method of family planning", "emergency contraception", "emergency contraception"],
        ["symptom_present_lipodystrophy", "No", "Text", "Symptom present", "Lipodystrophy", "Lipodystrophy"],
        ["symptom_present_anemia", "No", "Text", "Symptom present", "Anemia", "Anemia"],
        ["symptom_present_jaundice", "No", "Text", "Symptom present", "Jaundice", "Jaundice"],
        ["symptom_present_lactic_acidosis", "No", "Text", "Symptom present", "Lactic acidosis", "Lactic acidosis"],
        ["symptom_present_fever", "No", "Text", "Symptom present", "Fever", "Fever"],
        ["symptom_present_skin_rash", "No", "Text", "Symptom present", "Skin rash", "Skin rash"],
        ["symptom_present_abdominal_pain", "No", "Text", "Symptom present", "Abdominal pain", "Abdominal pain"],
        ["symptom_present_anorexia", "No", "Text", "Symptom present", "Anorexia", "Anorexia"],
        ["symptom_present_diarrhea", "No", "Text", "Symptom present", "Diarrhea", "Diarrhea"],
        ["symptom_present_hepatitis", "No", "Text", "Symptom present", "Hepatitis", "Hepatitis"],
        ["symptom_present_leg_pain_numbness", "No", "Text", "Symptom present", "Leg pain / numbness", "Leg pain / numbness"],
        ["symptom_present_peripheral_neuropathy", "No", "Text", "Symptom present", "Peripheral neuropathy", "Peripheral neuropathy"],
        ["symptom_present_vomiting", "No", "Text", "Symptom present", "Vomiting", "Vomiting"],
        ["symptom_present_other_symptom", "No", "Text", "Symptom present", "Other symptom", "Other symptom"],
        ["drug_induced_abdominal_pain", "No", "text", "Drug induced", "Abdominal pain", "Abdominal pain"],
        ["drug_induced_anorexia", "No", "text", "Drug induced", "Anorexia", "Anorexia"],
        ["drug_induced_diarrhea", "No", "text", "Drug induced", "Diarrhea", "Diarrhea"],
        ["drug_induced_jaundice", "No", "text", "Drug induced", "Jaundice", "Jaundice"],
        ["drug_induced_leg_pain_numbness", "No", "text", "Drug induced", "Leg pain / numbness", "Leg pain / numbness"],
        ["drug_induced_vomiting", "No", "text", "Drug induced", "Vomiting", "Vomiting"],
        ["drug_induced_peripheral_neuropathy", "No", "text", "Drug induced", "Peripheral neuropathy", "Peripheral neuropathy"],
        ["drug_induced_hepatitis", "No", "text", "Drug induced", "Hepatitis", "Hepatitis"],
        ["drug_induced_anemia", "No", "text", "Drug induced", "Anemia", "Anemia"],
        ["drug_induced_lactic_acidosis", "No", "text", "Drug induced", "Lactic acidosis", "Lactic acidosis"],
        ["drug_induced_lipodystrophy", "No", "text", "Drug induced", "Lipodystrophy", "Lipodystrophy"],
        ["drug_induced_skin_rash", "No", "text", "Drug induced", "Skin rash", "Skin rash"],
        ["drug_induced_fever", "No", "text", "Drug induced", "Fever", "Fever"],
        # ["drug_induced_cough", "No", "text", "Drug induced", "Cough", "Cough"],
        ["drug_induced_other_symptom", "No", "text", "Drug induced", "Other symptom", "Other symptom"],
        ["routine_tb_screening_fever", "NO", "Text", "Routine TB Screening", "Fever", "Fever"],
        ["routine_tb_screening_night_sweats", "NO", "Text", "Routine TB Screening", "Night sweats", "Night sweats"],
        ["routine_tb_screening_cough_of_any_duration", "NO", "Text", "Routine TB Screening", "Cough of any duration", "Cough of any duration"],
        ["routine_tb_screening_weight_loss_failure", "NO", "Text", "Routine TB Screening", "Weight loss / Failure to thrive / malnutrition", "Weight loss / Failure to thrive / malnutrition"],
        ["tb_status_tb_not_suspected", "No", "Text", "TB status", "TB NOT suspected", "TB NOT suspected"],
        ["tb_status_tb_suspected", "No", "Text", "TB status", "TB suspected", "TB suspected"],
        ["tb_status_confirmed_tb_not_on_treatment", "No", "Text", "TB status", "Confirmed TB NOT on treatment", "Confirmed TB NOT on treatment"],
        ["tb_status_confirmed_tb_on_treatment", "No", "Text", "TB status", "Confirmed TB on treatment", "Confirmed TB on treatment"],
        ["tb_status_unknown", "No", "Text", "TB status", "Unknown", "Unknown"],
        ["allergic_to_sulphur_no", "No", "Text", "Allergic to sulphur", "No", "No"],
        ["allergic_to_sulphur_yes", "No", "Text", "Allergic to sulphur", "Yes ", "Yes"],
        ["arv_regimen_type_unknown", "No", "Text", "What type of antiretroviral regimen", "UNKNOWN ANTIRETROVIRAL DRUG", "UNKNOWN ANTIRETROVIRAL DRUG"],
        ["arv_regimen_type_d4T_3TC_NVP", "No", "Text", "What type of antiretroviral regimen", "d4T/3TC/NVP", "d4T/3TC/NVP"],
        ["arv_regimen_type_triomune", "No", "Text", "What type of antiretroviral regimen", "Triomune", "Triomune"],
        ["arv_regimen_type_triomune_30", "No", "Text", "What type of antiretroviral regimen", "Triomune-30", "Triomune-30"],
        ["arv_regimen_type_triomune_40", "No", "Text", "What type of antiretroviral regimen", "Triomune-40", "Triomune-40"],
        ["arv_regimen_type_AZT_3TC_NVP", "No", "Text", "What type of antiretroviral regimen", "AZT/3TC/NVP", "AZT/3TC/NVP"],
        ["arv_regimen_type_AZT_3TC_LPV_r", "No", "Text", "What type of antiretroviral regimen", "AZT/3TC+LPV/r", "AZT/3TC+LPV/r"],
        ["arv_regimen_type_AZT_3TC_EFV", "No", "Text", "What type of antiretroviral regimen", "AZT/3TC+EFV", "AZT/3TC+EFV"],
        ["arv_regimen_type_d4T_3TC_EFV", "No", "Text", "What type of antiretroviral regimen", "d4T/3TC/EFV", "d4T/3TC/EFV"],
        ["arv_regimen_type_TDF_3TC_NVP", "No", "Text", "What type of antiretroviral regimen", "TDF/3TC+NVP", "TDF/3TC+NVP"],
        ["arv_regimen_type_TDF_3TC_EFV", "No", "Text", "What type of antiretroviral regimen", "TDF/3TC/EFV", "TDF/3TC/EFV"],
        ["arv_regimen_type_ABC_3TC_LPV_r", "No", "Text", "What type of antiretroviral regimen", "ABC/3TC+LPV/r", "ABC/3TC+LPV/r"],
        ["arv_regimen_type_TDF_3TC_LPV_r", "No", "Text", "What type of antiretroviral regimen", "TDF/3TC+LPV/r", "TDF/3TC+LPV/r"],
        ["arv_regimen_type_d4T_3TC_d4T_3TC_NVP", "No", "Text", "What type of antiretroviral regimen", "d4T/3TC + d4T/3TC/NVP (Starter pack)", "d4T/3TC + d4T/3TC/NVP (Starter pack)"],
        ["arv_regimen_type_AZT_3TC_AZT_3TC_NVP", "No", "Text", "What type of antiretroviral regimen", "AZT/3TC + AZT/3TC/NVP (Starter pack)", "AZT/3TC + AZT/3TC/NVP (Starter pack)"],
        ["cpt_given_yes", "No", "Text", "CPT given", "Yes", "Yes"],
        ["cpt_given_no", "No", "Text", "CPT given", "No", "No"],
        ["ipt_given_yes", "No", "Text", "Isoniazid", "Yes", "Yes"],
        ["ipt_given_no", "No", "Text", "Isoniazid", "No", "No"],
        ["prescribe_arvs_yes", "No", "Text", "Prescribe ARVs this visit", "Yes", "Yes"],
        ["prescribe_arvs_no", "No", "Text", "Prescribe ARVs this visit", "No", "No"],
        ["continue_existing_regimen_yes", "No", "Text", "Continue existing regimen", "Yes", "Yes"],
        ["continue_existing_regimen_no", "No", "Text", "Continue existing regimen", "No", "No"]
      ];


      fields_set1.each do |field|

        puts "Testing: #{field.inspect}"
        
        assert field.length == 6, "Line 115: Field '#{field.inspect}' does not have enough content!"
        
        concept = field[3] # "Patient Pregnant"
        value_coded = field[4] # "Yes"
        flat_name = field[0] # "pregnant_yes"

        cs = con.query "SELECT concept.concept_id FROM concept_name " +
          " LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id " +
          " WHERE name = '#{concept}' AND voided = 0 AND retired = 0 LIMIT 1"

        assert cs.num_rows > 0, "Line 113: Concept #{concept} not found!"

        concept_id = cs.fetch_row[0].to_i

        vs = con.query "SELECT concept_name_id, concept.concept_id FROM concept_name " +
          " LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id " +
          " WHERE name = '#{value_coded}' AND voided = 0 AND retired = 0 LIMIT 1"

        assert vs.num_rows > 0, "Line 122: Concept for value_coded #{value_coded} not found!"

        result = vs.fetch_row
        
        value_coded_name_id = result[0].to_i

        value_coded_id = result[1].to_i

        os = con.query "INSERT INTO obs (person_id, concept_id, encounter_id, " +
          "obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid) " +
          "VALUES (#{person_id}, #{concept_id}, #{encounter_id}, '#{date}', #{value_coded_id}, " +
          "#{value_coded_name_id}, #{user_id}, '#{date}', (SELECT UUID()))"

        os = con.query "SELECT LAST_INSERT_ID()"

        assert os.num_rows > 0, "Line 131: Obs creation failed!"

        fs = con.query "SELECT #{flat_name} FROM flat_table2 WHERE patient_id = " +
          "#{person_id} AND visit_date = DATE('#{date}') AND #{flat_name} = '#{value_coded}'"

        assert fs.num_rows > 0, "Line 142: Failed to update flat-table with '#{value_coded}'!"

      end
      
      fields_set2 = [
        ["regimen_category", "Regimen Category", "value_text", "5A"],
        ["transfer_out_location", "Transfer out to", "value_text", "Test Site"],
        ["appointment_date", "Appointment date", "value_datetime", "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"],
        ["Weight", "Weight", "value_numeric", "10.4"],
        ["Height", "Height (cm)", "value_numeric", "50.2"],
        ["Temperature", "Temperature", "value_numeric", "37.5"],
        ["BMI", "BMI", "value_numeric", "25"],
        ["systolic_blood_pressure", "Systolic blood pressure", "value_numeric", "120"],
        ["diastolic_blood_pressure", "Diastolic blood pressure", "value_numeric", "80"],
        ["weight_for_height", "Weight for height percent of median", "value_numeric", "10"],
        ["weight_for_age", "Weight for age percent of median", "value_numeric", "12"],
        ["height_for_age", "Height for age percent of median", "value_numeric", "89"],
        ["condoms", "Condoms", "value_text", "Unknown"],
        ["amount_of_drug1_brought_to_clinic", "Amount of drug brought to clinic", "value_text", "Unknown1"],
        ["amount_of_drug1_remaining_at_home", "Amount of drug remaining at home", "value_text", "Unknown1"],
        ["what_was_the_patient_adherence_for_this_drug1", "What was the patients adherence for this drug order",
          "value_text", "Unknown1"],
        ["missed_hiv_drug_construct1", "Missed HIV drug construct ", "value_text", "Unknown1"],
        ["amount_of_drug2_brought_to_clinic", "Amount of drug brought to clinic", "value_text", "Unknown2"],
        ["amount_of_drug2_remaining_at_home", "Amount of drug remaining at home", "value_text", "Unknown2"],
        ["what_was_the_patient_adherence_for_this_drug2", "What was the patients adherence for this drug order",
          "value_text", "Unknown2"],
        ["missed_hiv_drug_construct2", "Missed HIV drug construct ", "value_text", "Unknown2"],
        ["amount_of_drug3_brought_to_clinic", "Amount of drug brought to clinic", "value_text", "Unknown3"],
        ["amount_of_drug3_remaining_at_home", "Amount of drug remaining at home", "value_text", "Unknown3"],
        ["what_was_the_patient_adherence_for_this_drug3", "What was the patients adherence for this drug order",
          "value_text", "Unknown3"],
        ["missed_hiv_drug_construct3", "Missed HIV drug construct ", "value_text", "Unknown3"],
        ["amount_of_drug4_brought_to_clinic", "Amount of drug brought to clinic", "value_text", "Unknown4"],
        ["amount_of_drug4_remaining_at_home", "Amount of drug remaining at home", "value_text", "Unknown4"],
        ["what_was_the_patient_adherence_for_this_drug4", "What was the patients adherence for this drug order",
          "value_text", "Unknown4"],
        ["missed_hiv_drug_construct4", "Missed HIV drug construct ", "value_text", "Unknown4"],
        ["amount_of_drug5_brought_to_clinic", "Amount of drug brought to clinic", "value_text", "Unknown5"],
        ["amount_of_drug5_remaining_at_home", "Amount of drug remaining at home", "value_text", "Unknown5"],
        ["what_was_the_patient_adherence_for_this_drug5", "What was the patients adherence for this drug order",
          "value_text", "Unknown5"],
        ["missed_hiv_drug_construct5", "Missed HIV drug construct", "value_text", "Unknown5"]
      ]

      fields_set2.each do |field|

        puts "Testing: #{field.inspect}"

        assert field.length == 4, "Line 219: Field '#{field.inspect}' does not have enough content!"

        flat_name = field[0]
        concept = field[1] 
        field_type = field[2]
        test_data = field[3]

        cs = con.query "SELECT concept.concept_id FROM concept_name " +
          " LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id " +
          " WHERE name = '#{concept}' AND voided = 0 AND retired = 0 LIMIT 1"

        assert cs.num_rows > 0, "Line 113: Concept #{concept} not found!"

        concept_id = cs.fetch_row[0].to_i

        os = con.query "INSERT INTO obs (person_id, concept_id, encounter_id, " +
          "obs_datetime, #{field_type}, creator, date_created, uuid) " +
          "VALUES (#{person_id}, #{concept_id}, #{encounter_id}, '#{date}', '#{test_data}', " +
          " #{user_id}, '#{date}', (SELECT UUID()))"

        os = con.query "SELECT LAST_INSERT_ID()"

        assert os.num_rows > 0, "Line 131: Obs creation failed!"

        fs = con.query "SELECT #{flat_name} FROM flat_table2 WHERE patient_id = " +
          "#{person_id} AND visit_date = DATE('#{date}') AND #{flat_name} = '#{test_data}'"

        assert fs.num_rows > 0, "Line 142: Failed to update flat-table with '#{test_data}'!"

      end
      
      drugs = [
        {
          "drug_name" => "Triomune-40",
          "start_date" => "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}",
          "auto_expire_date" => "#{(Time.now + (60 * 86400)).strftime("%Y-%m-%d %H:%M:%S")}",
          "dose" => "3",
          "equivalent_daily_dose" => "9",
          "frequency" => "TDS",
          "quantity" => "540"
        },
        {
          "drug_name" => "TDF (Tenofavir 300 mg tablet)",
          "start_date" => "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}",
          "auto_expire_date" => "#{(Time.now + (30 * 86400)).strftime("%Y-%m-%d %H:%M:%S")}",
          "dose" => "1",
          "equivalent_daily_dose" => "2",
          "frequency" => "BD",
          "quantity" => "60"
        },
        {
          "drug_name" => "INH or H (Isoniazid 100mg tablet)",
          "start_date" => "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}",
          "auto_expire_date" => "#{(Time.now + (60 * 86400)).strftime("%Y-%m-%d %H:%M:%S")}",
          "dose" => "3",
          "equivalent_daily_dose" => "9",
          "frequency" => "TDS",
          "quantity" => "540"
        },
        {
          "drug_name" => "d4T (Stavudine 15mg tablet)",
          "start_date" => "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}",
          "auto_expire_date" => "#{(Time.now + (60 * 86400)).strftime("%Y-%m-%d %H:%M:%S")}",
          "dose" => "3",
          "equivalent_daily_dose" => "9",
          "frequency" => "TDS",
          "quantity" => "540"
        },
        {
          "drug_name" => "3TC (Lamivudine syrup 10mg/mL from 100mL bottle)",
          "start_date" => "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}",
          "auto_expire_date" => "#{(Time.now + (60 * 86400)).strftime("%Y-%m-%d %H:%M:%S")}",
          "dose" => "2",
          "equivalent_daily_dose" => "6",
          "frequency" => "TDS",
          "quantity" => "360"
        },
        {
          "drug_name" => "Moxi (Moxifloxacin 400mg tablet)",
          "start_date" => "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}",
          "auto_expire_date" => "#{(Time.now + (60 * 86400)).strftime("%Y-%m-%d %H:%M:%S")}",
          "dose" => "3",
          "equivalent_daily_dose" => "9",
          "frequency" => "TDS",
          "quantity" => "540"
        }
      ]

      es = con.query "SELECT encounter_type_id FROM encounter_type WHERE name = 'TREATMENT'"

      assert es.num_rows > 0, "Line 309: Encounter type not found!"

      encounter_type_id = es.fetch_row[0].to_i

      rs = con.query "INSERT INTO encounter (encounter_type, patient_id, " +
        "provider_id, encounter_datetime, creator, date_created, uuid) " +
        "VALUES (#{encounter_type_id}, #{patient_id}, #{user_id}, '#{date}', " +
        "#{user_id}, '#{date}', (SELECT UUID()))"

      rs = con.query "SELECT LAST_INSERT_ID()"

      encounter_id = rs.fetch_row[0].to_i

      assert encounter_id.to_i > 0, "Line 313: Encounter creation failed!"

      ot = con.query "SELECT order_type_id FROM order_type WHERE name = 'Drug Order'"

      assert ot.num_rows > 0, "Line 324: Drug Order type not found!"

      order_type_id = ot.fetch_row[0].to_i

      pos = 0
      
      drugs.each do |drug|

        pos = pos + 1
        
        next if pos > 5

        puts "Testing: #{drug.inspect}"

        ds = con.query "SELECT * FROM drug WHERE name = '#{drug["drug_name"]}' LIMIT 1"

        assert ds.num_rows > 0, "Line 335: Drug not found!"

        thedrug = ds.fetch_row

        os = con.query "INSERT INTO orders (order_type_id, concept_id, orderer, encounter_id, " +
          "start_date, auto_expire_date, creator, date_created, patient_id, uuid) " +
          "VALUES (#{order_type_id}, #{thedrug[1]}, #{user_id}, #{encounter_id}, '#{drug["start_date"]}', " +
          "'#{drug["auto_expire_date"]}', #{user_id}, '#{date}', #{patient_id}, (SELECT UUID()))"

        is = con.query "SELECT LAST_INSERT_ID()"

        assert is.num_rows > 0, "Line 341: orders creation failed!"

        order_id = is.fetch_row[0].to_i

        fs = con.query "SELECT drug_order_id#{pos}, drug_encounter_id#{pos}, drug_start_date#{pos}, " +
          "drug_auto_expire_date#{pos} FROM flat_table2 WHERE patient_id = " +
          "#{person_id} AND visit_date = DATE('#{date}') AND drug_order_id#{pos} = #{order_id}"

        assert fs.num_rows > 0, "Line 352: Failed to update flat-table with drug_order_id#{pos} '#{order_id}'!"

        row = fs.fetch_row
        
        assert row[0].to_i == order_id, "Line 355: Failed to add order_id"

        assert row[1].to_i == encounter_id, "Line 355: Failed to add encounter_id"

        assert row[2] == drug["start_date"], "Line 355: Failed to add start_date: #{drug["start_date"]}"

        assert row[3] == drug["auto_expire_date"], "Line 355: Failed to add auto_expire_date #{drug["start_date"]}"

        ds = con.query "INSERT INTO drug_order (order_id, drug_inventory_id, dose, " +
          "equivalent_daily_dose, frequency, quantity) VALUES (#{order_id}, #{thedrug[0]}, " +
          "#{drug["dose"]}, #{drug["equivalent_daily_dose"]}, '#{drug["frequency"]}', #{drug["quantity"]})"

        fs = con.query "SELECT drug_inventory_id#{pos}, drug_name#{pos}, drug_equivalent_daily_dose#{pos}, " +
          "drug_dose#{pos}, drug_frequency#{pos}, drug_quantity#{pos} FROM flat_table2 WHERE patient_id = " +
          "#{person_id} AND visit_date = DATE('#{date}') AND drug_order_id#{pos} = #{order_id}"

        assert fs.num_rows > 0, "Line 377: Failed to update flat-table with drug_order_id#{pos} '#{order_id}'!"

        row = fs.fetch_row

        assert row[0].to_i == thedrug[0].to_i, "Line 377: Failed to add drug_inventory_id#{pos} #{thedrug[0].to_i}"

        assert row[1] == thedrug[2], "Line 377: Failed to add drug_name #{thedrug[2]}"

        assert row[2] == drug["equivalent_daily_dose"], "Line 377: Failed to add equivalent_daily_dose #{drug["equivalent_daily_dose"]}"

        assert row[3] == drug["dose"], "Line 377: Failed to add dose #{drug["dose"]}"

        assert row[4] == drug["frequency"], "Line 377: Failed to add frequency #{drug["frequency"]}"

        assert row[5] == drug["quantity"], "Line 377: Failed to add quantity #{drug["quantity"]}"
        
      end

    rescue Mysql::Error => e
      puts e.errno
      puts e.error
            
    ensure
      con.close if con
    end
  end
end

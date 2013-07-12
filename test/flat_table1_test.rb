#!/usr/bin/ruby

require 'test/unit'
require 'mysql'

class Con < Test::Unit::TestCase

	$con = Mysql.new 'localhost', 'root', 't1m0', 'bart2_db'

	def test_connection
	
		us = $con.query "SELECT * FROM flat_table1 LIMIT 1"

	    assert us.num_rows == 0, "Line 12: No records"
	
	end
	
	def test_complete_test
	
		user_id = 1
		
		date = Time.now.strftime("%Y-%m-%d")
		
		person = $con.query "INSERT INTO person (gender,birthdate,creator, uuid) VALUES ('M', #{date},1, (SELECT UUID()))" ;
	
		is = $con.query "SELECT LAST_INSERT_ID()"
		  
		assert is.num_rows > 0, "Line 20: Create person failed!"

		person_id = is.fetch_row[0].to_i
	
		name = $con.query "INSERT INTO person_name ( person_id, given_name, family_name, uuid, creator) VALUES ( #{person_id},'Test','Case', (SELECT UUID()), #{user_id})";
		
		names = $con.query "Select * from flat_table1 where given_name = 'test' and patient_id = #{person_id}"
		
		assert names.num_rows > 0 , "Failed to write person name"
		
		patient = $con.query "INSERT INTO patient (patient_id, creator, date_created, voided) VALUES (#{person_id}, #{user_id}, '#{date}', 0)"

		check_patient = $con.query "Select * from patient where patient_id = #{person_id}"
		
		assert check_patient.num_rows > 0, "Failed to create patient"
	
		#address = $con.query "INSERT INTO person_address (person_id, address2,county_district,city_village,creator) VALUES (#{person_id},'Mzimba','Mbonekera','Lilongwe' ,#{user_id})"
		
		# checkers = $con.query "Select * from flat_table1 where home_district = 'Mzimba' and patient_id = #{person_id}"
		
		# assert checkers.num_rows() > 0, "failed to write addresses"
	
		rs = $con.query "INSERT INTO encounter (encounter_type, patient_id,provider_id, encounter_datetime, creator, date_created, uuid) VALUES ( 52, #{person_id}, #{user_id}, '#{date}', #{user_id}, '#{date}', (SELECT UUID()))"

		encounter = $con.query "SELECT LAST_INSERT_ID()"
		
		encounter_id = encounter.fetch_row[0].to_i

		yes = ($con.query "Select concept_id from concept_name where name = 'yes' limit 1").fetch_row[0].to_i
		
		no = ($con.query "Select concept_id from concept_name where name = 'no' limit 1").fetch_row[0].to_i
	 
	 	values = [yes,no]
	 	
		fields =  [5006,  9099, 2543, 7031, 6830, 9098, 7032, 7881, 1359, 6625, 5034, 7551, 3461, 1499, 7937, 6393, 8205, 836, 1362, 2588, 2858, 507, 7753, 2891, 8344, 7547, 7557, 5334, 5337, 5328, 5046, 42, 1549, 2578, 8011, 7040, 7562]

		fields.each do |field|
	
			os = $con.query "INSERT INTO obs (person_id, concept_id, encounter_id,obs_datetime, value_coded,value_numeric, creator, date_created, uuid) VALUES (#{person_id}, #{field}, #{encounter_id}, '#{date}','#{yes}', 410 ,#{user_id}, '#{date}', (SELECT UUID()))"

		end

		puts "obs created"
		
		#void = $con.query "UPDATE patient set voided = 1 where patient_id = #{person_id}"
		
		#check_void = $con.query "Select * from flat_table1 where patient_id = #{person_id} limit 1"
		
		#assert check_void.num_rows < 1, "Failed to remove patient after voiding"	
		

	end
	
	
	def test_state_test 
	
		user_id = 1
		
		date = Time.now.strftime("%Y-%m-%d") 
		
		person = $con.query "INSERT INTO person (gender,birthdate,creator, uuid) VALUES ('M', #{date},1, (SELECT UUID()))" ;
	
		is = $con.query "SELECT LAST_INSERT_ID()"
		  
		assert is.num_rows > 0, "Line 20: Create person failed!"

		person_id = is.fetch_row[0].to_i
	
		name = $con.query "INSERT INTO person_name ( person_id, given_name, family_name, uuid, creator) VALUES ( #{person_id},'Test','Case', (SELECT UUID()), #{user_id})";
				
		patient = $con.query "INSERT INTO patient (patient_id, creator, date_created, voided) VALUES (#{person_id}, #{user_id}, '#{date}', 0)"

		check_patient = $con.query "Select patient_id from patient where patient_id = #{person_id}"
		
		program = 1
		
		assert check_patient.num_rows > 0, "Failed to create patient"

			insert = $con.query "INSERT INTO patient_program (patient_id,program_id,date_enrolled,creator) VALUES (2,1,#{date},1)"
      
      ps = $con.query "SELECT LAST_INSERT_ID()"

      assert ps.num_rows > 0, "Line 425: patient_program creation failed!"

      patient_program_id = ps.fetch_row[0].to_i


      ws = $con.query "SELECT program_workflow_state_id FROM program_workflow_state " + 
        "WHERE concept_id = 1577 AND program_workflow_id = 1"

      assert ws.num_rows > 0, "Line 441: Failed to pull program_workflow_state_id"

      program_workflow_state_id = ws.fetch_row[0].to_i


      ws = $con.query "SELECT program_workflow_state_id FROM program_workflow_state " + 
        "WHERE concept_id = 1742 AND program_workflow_id = 1"

      program_workflow_state_id2 = ws.fetch_row[0].to_i


      ps = $con.query "INSERT INTO patient_state (patient_program_id, state, start_date, " +
        "creator, date_created, voided, uuid) VALUES (#{patient_program_id}, #{program_workflow_state_id}, '#{date}', " +
        " #{user_id} , '#{date}', 0, (SELECT UUID()))";

      
      ps1 = $con.query "INSERT INTO patient_state (patient_program_id, state, start_date, " +
        "creator, date_created, voided, uuid) VALUES (#{patient_program_id}, #{program_workflow_state_id}, '#{date}', " +
        " #{user_id} , '#{date}', 0, (SELECT UUID()))";


   ps1 = $con.query "INSERT INTO patient_state (patient_program_id, state, start_date, " +
        "creator, date_created, voided, uuid) VALUES (#{patient_program_id}, #{program_workflow_state_id2}, '2014-04-01', " +
        " #{user_id} , '#{date}', 0, (SELECT UUID()))";

      
      fs = $con.query "SELECT current_hiv_program_state, current_hiv_program_start_date " +
        " FROM flat_table2 WHERE patient_id = #{person_id} AND visit_date = DATE('#{date}')"

      assert fs.num_rows > 0, "Line 454: Failed to update flat-table with current_hiv_program_state !"

      row = fs.fetch_row



      assert row[1] == Time.now.strftime("%Y-%m-%d"), "Line 454: Failed to update flat-table with " +
        "current_hiv_program_start_date '#{Time.now.strftime("%Y-%m-%d")}'"
     
	
	end
	
	def test_patient_insert
	
		user_id = 1
		
		date = Time.now.strftime("%Y-%m-%d") 
		
		person = $con.query "INSERT INTO person (gender,birthdate,creator, uuid) VALUES ('M', #{date},1, (SELECT UUID()))" ;
	
		is = $con.query "SELECT LAST_INSERT_ID()"
		  
		assert is.num_rows > 0, "Line 20: Create person failed!"

		person_id = is.fetch_row[0].to_i
		
		name = $con.query "INSERT INTO person_name ( person_id, given_name, family_name, uuid, creator) VALUES ( #{person_id},'Test','Case', (SELECT UUID()), #{user_id})";
		
		patient = $con.query "INSERT INTO patient (patient_id, creator, date_created, voided) VALUES (#{person_id}, #{user_id}, '#{date}', 0)"

		check_patient = $con.query "SELECT * from flat_table1 where patient_id = #{person_id}"

		assert check_patient.num_rows > 0, "Failed to create patient"
		
	end
	
end

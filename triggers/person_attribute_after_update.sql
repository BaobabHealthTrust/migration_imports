DELIMITER $$

	DROP TRIGGER IF EXISTS `person_attribute_update`$$
	
	CREATE TRIGGER `person_attribute_update` AFTER UPDATE ON person_attribute
	
	FOR EACH ROW BEGIN
		
		SET @cellphone = (SELECT person_attribute_type_id FROM person_attribute_type where name = 'Cell phone number');

		SET @home_number = (SELECT person_attribute_type_id FROM person_attribute_type where name = 'Home phone number');
	
		SET @office_number = (SELECT person_attribute_type_id FROM person_attribute_type where name = 'Office phone number');

		SET @occupation = (SELECT person_attribute_type_id FROM person_attribute_type where name = 'Occupation');		
		
		IF new.voided = 1 THEN

			CASE new.person_attribute_type_id
					
					WHEN @occupation THEN
			
						UPDATE flat_table1 SET occupation = NULL WHERE patient_id = new.person_id;
			
					WHEN @cellphone THEN
			
						UPDATE flat_table1 SET cellphone_number = NULL WHERE patient_id = new.person_id;
			
					WHEN @home_number THEN
			
						UPDATE flat_table1 SET home_phone_number = NULL WHERE patient_id = new.person_id;
			
					WHEN @office_number THEN
			 		
			 			UPDATE flat_table1 SET office_phone_number = NULL WHERE patient_id = new.person_id;
	
					ELSE
						SET @null = new.creator;
		

			
			END CASE;

		END IF;
		
	END$$
	
DELIMITER ;

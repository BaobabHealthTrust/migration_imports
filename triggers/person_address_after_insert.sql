DELIMITER $$

	DROP TRIGGER IF EXISTS `person_address_after_insert` $$

	CREATE TRIGGER 	`person_address_after_insert` AFTER INSERT ON person_address 
	
	FOR EACH ROW	
	BEGIN
		UPDATE flat_table1 SET landmark = new.address1, ta = new.county_district, current_address = new.city_village, home_district = new.address2 WHERE patient_id = new.person_id;
	END$$

DELIMITER ;

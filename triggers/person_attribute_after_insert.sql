DELIMITER $$

	DROP TRIGGER IF EXISTS `person_attribute_insert`$$
	
	CREATE TRIGGER `person_attribute_insert` AFTER INSERT ON person_attribute
	
	FOR EACH ROW BEGIN
		
		CALL proc_person_attribute_after_insert(new.person_id, new.value,new.person_attribute_type_id);
		
	END$$
	
DELIMITER ;

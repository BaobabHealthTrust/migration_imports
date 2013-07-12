DELIMITER $$

	DROP TRIGGER IF EXISTS `pat_identifier_after_save`$$
	
	CREATE TRIGGER `pat_identifier_after_save` AFTER INSERT ON patient_identifier
	
	FOR EACH ROW
	
		BEGIN
		
			CALL proc_insert_patient_identifier(
				new.patient_id,
				new.identifier,
				new.identifier_type
			);
	
		END$$

DELIMITER ;

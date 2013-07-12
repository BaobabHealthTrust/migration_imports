DELIMITER $$

	DROP TRIGGER IF EXISTS `patient_identifier_after_update`$$

	CREATE TRIGGER `patient_identifier_after_update` AFTER UPDATE ON patient_identifier

		FOR EACH ROW BEGIN
			
			IF new.voided = 1 THEN
			
				CALL `proc_update_patient_identifier`(new.patient_id, new.identifier_type);
		 	
		 	ELSE 
		 
	 			CALL proc_insert_patient_identifier(
					new.patient_id,
					new.identifier,
					new.identifier_type
				);
		 
		 	END IF;
		 
		END$$
		
DELIMITER ;

DELIMITER $$
	
	DROP TRIGGER IF EXISTS `patient_after_void`$$
	
	CREATE TRIGGER `patient_after_void` AFTER UPDATE ON patient

		FOR EACH ROW BEGIN
		
			IF new.voided = 1 THEN
			
				DELETE FROM flat_table1 where patient_id = new.patient_id;
				DELETE FROM flat_table2 where patient_id = new.patient_id;
				DELETE FROM flat_cohort_table where patient_id = new.patient_id;

			ELSE
				
					SET @check_existence = (SELECT patient_id FROM flat_table1 WHERE patient_id = new.patient_id);
					
					if @check_existence IS NULL THEN
					
							CALL `proc_insert_basics`(
								new.patient_id,
								new.date_created,
								new.creator
							); 					
					
					END IF;
				
			END IF;	
				
		END$$
	
DELIMITER ;

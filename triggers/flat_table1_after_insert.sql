DELIMITER $$

	DROP TRIGGER IF EXISTS `cohort_for_table1`$$
	
	CREATE TRIGGER `cohort_for_table1` AFTER INSERT ON flat_table1
	
	FOR EACH ROW BEGIN
	
		INSERT INTO flat_cohort_table (patient_id,gender) VALUES (new.patient_id, new.gender);
	
	END$$

DELIMITER ;

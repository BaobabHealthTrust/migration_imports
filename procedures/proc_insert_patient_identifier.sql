DELIMITER $$

DROP PROCEDURE IF EXISTS `proc_insert_patient_identifier`$$
	
CREATE PROCEDURE`proc_insert_patient_identifier`(
		IN pat_id INT,
		IN identifier VARCHAR(255),
		IN identifier_type INT
	)
	
	BEGIN
		
		SET @tb_number = (SELECT patient_identifier_type_id FROM patient_identifier_type where name = 'District TB Number');
		
		SET @arv_number = (SELECT patient_identifier_type_id FROM patient_identifier_type where name = 'ARV Number');
						
		SET @arv_nat_number = (SELECT patient_identifier_type_id FROM patient_identifier_type where name = 'Arv national id');
		
		SET @new_nat_id = (SELECT patient_identifier_type_id FROM patient_identifier_type where name = 'New national id');
		
		SET @nat_id = (SELECT patient_identifier_type_id FROM patient_identifier_type where name = 'National id');
				
		SET @prev_art_number = (SELECT patient_identifier_type_id FROM patient_identifier_type where name = 'Previous ARV number');
		
		SET @pre_art_number = (SELECT patient_identifier_type_id FROM patient_identifier_type where name = 'Pre ARV number ID');
				
		SET @arch_filing_number = (SELECT patient_identifier_type_id FROM patient_identifier_type where name = 'Archived filing number');
		
		SET @filing_number = (SELECT patient_identifier_type_id FROM patient_identifier_type where name = 'Filing number');
				
		CASE identifier_type

			WHEN @tb_number THEN
				UPDATE flat_table1 SET tb_number = identifier WHERE patient_id = pat_id;
			WHEN @arv_number THEN
				UPDATE flat_table1 SET arv_number = identifier WHERE patient_id = pat_id;
			WHEN @arv_nat_number THEN
				UPDATE flat_table1 SET arv_number = identifier WHERE patient_id = pat_id;
			WHEN @new_nat_id THEN
				UPDATE flat_table1 SET new_nat_id = identifier WHERE patient_id = pat_id;
			WHEN @nat_id THEN
				UPDATE flat_table1 SET nat_id = identifier WHERE patient_id = pat_id;	
			WHEN @prev_art_number THEN
				UPDATE flat_table1 SET prev_art = identifier WHERE patient_id = pat_id;	
			WHEN @pre_art_number THEN
				UPDATE flat_table1 SET pre_art_number = identifier WHERE patient_id = pat_id;
			WHEN @arch_filing_number THEN
				UPDATE flat_table1 SET archived_filing_number = identifier WHERE patient_id = pat_id;
			WHEN @filing_number THEN
				UPDATE flat_table1 SET filing_number = identifier WHERE patient_id = pat_id;

			ELSE
				SET @encounter = pat_id;
		END CASE;
	
	END$$


DELIMITER ;

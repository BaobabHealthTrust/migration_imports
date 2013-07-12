DELIMITER $$
DROP TRIGGER IF EXISTS `states_after_insert`$$
CREATE TRIGGER `states_after_insert` AFTER INSERT 
ON `patient_state`
FOR EACH ROW
BEGIN

    SET @patient_id = (SELECT patient_id FROM patient_program 
        LEFT OUTER JOIN patient_state ON patient_program.patient_program_id = patient_state.patient_program_id WHERE patient_program.patient_program_id = new.patient_program_id LIMIT 1);

    SET @state = (SELECT name FROM concept_name 
        LEFT OUTER JOIN program_workflow_state ON program_workflow_state.concept_id = concept_name.concept_id
        LEFT OUTER JOIN program_workflow ON program_workflow.program_workflow_id = program_workflow_state.program_workflow_id
        LEFT OUTER JOIN patient_program ON patient_program.program_id = program_workflow.program_id
        WHERE program_workflow_state.program_workflow_state_id = new.state AND patient_program.patient_program_id = new.patient_program_id
        LIMIT 1);
        
    SET @on_arv = (SELECT concept_name.concept_id FROM concept_name 
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id 
                        WHERE name = 'On ARVs' AND voided = 0 AND retired = 0 LIMIT 1);

    
    SET @state_concept = (SELECT concept_id from program_workflow_state where program_workflow_state_id = new.state AND retired = 0 LIMIT 1);
    
    SET @visit = (SELECT COALESCE((SELECT id FROM flat_table2 WHERE patient_id = @patient_id AND DATE(visit_date) = DATE(new.start_date)), 0));
    
    IF @visit = 0 THEN
            
        INSERT INTO flat_table2 (patient_id, visit_date, current_hiv_program_state, 
            current_hiv_program_start_date, current_hiv_program_end_date) 
        VALUES (@patient_id, new.start_date, @state, new.start_date, new.end_date);
    
    ELSE 
    
        UPDATE flat_table2 SET current_hiv_program_state = @state, current_hiv_program_start_date = new.start_date,
            current_hiv_program_end_date = new.end_date
        WHERE flat_table2.id = @visit;
        
    END IF;   

		IF @state_concept = @on_arv THEN
		
			SET @start_date = (SELECT earliest_start_date from flat_table1 where patient_id = @patient_id);
						
			IF @start_date IS NULL THEN

				UPDATE flat_table1 SET earliest_start_date = new.start_date WHERE patient_id = @patient_id;
			
			ELSEIF DATE(@start_date) > DATE(new.start_date) THEN
			
				UPDATE flat_table1 SET earliest_start_date = new.start_date WHERE patient_id = @patient_id;			

			END IF;
		
		END IF;

END$$

DELIMITER ;

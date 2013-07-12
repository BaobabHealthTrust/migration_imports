DELIMITER $$
DROP TRIGGER IF EXISTS `observation_after_insert`$$
CREATE TRIGGER `observation_after_insert` AFTER INSERT 
ON `obs`
FOR EACH ROW
BEGIN

    SET @visit = (SELECT COALESCE((SELECT id FROM flat_table2 WHERE patient_id = new.person_id AND DATE(visit_date) = DATE(new.obs_datetime)), 0));

    CALL proc_insert_observations(
        new.person_id, 
        DATE(new.obs_datetime), 
        new.concept_id, 
        new.value_coded,
        new.value_coded_name_id,
        new.value_text,
        new.value_numeric,
        new.value_datetime,
        new.value_modifier,
        @visit,
        new.encounter_id
    );

END$$

DELIMITER ;

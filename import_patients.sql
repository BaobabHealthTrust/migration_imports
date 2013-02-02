# This procedure imports patients from intermediate tables to ART2 OpenMRS database

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_patients`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_patients`()
BEGIN
    
    # Declare condition for exiting loop
    DECLARE done INT DEFAULT FALSE;
    
    # Declare fields to hold our values for our patients
    DECLARE patient_id INT(11);
    DECLARE given_name VARCHAR(255);
    DECLARE middle_name VARCHAR(255);
    DECLARE family_name VARCHAR(255);
    DECLARE gender VARCHAR(25);
    DECLARE dob DATE;
    DECLARE dob_estimated BIT(1);
    DECLARE dead BIT(1);
    DECLARE traditional_authority VARCHAR(255);
    DECLARE current_address VARCHAR(255);
    DECLARE landmark VARCHAR(255);
    DECLARE cellphone_number VARCHAR(255);
    DECLARE home_phone_number VARCHAR(255);
    DECLARE office_phone_number VARCHAR(255);
    DECLARE occupation VARCHAR(255);
    DECLARE nat_id VARCHAR(255);
    DECLARE art_number VARCHAR(255);
    DECLARE pre_art_number VARCHAR(255);
    DECLARE tb_number VARCHAR(255);
    DECLARE legacy_id VARCHAR(255);
    DECLARE legacy_id2 VARCHAR(255);
    DECLARE legacy_id3 VARCHAR(255);
    DECLARE new_nat_id VARCHAR(255);
    DECLARE prev_art_number VARCHAR(255);
    DECLARE filing_number VARCHAR(255);
    DECLARE archived_filing_number VARCHAR(255);
    DECLARE voided TINYINT(1);
    DECLARE void_reason VARCHAR(255);
    DECLARE date_voided DATE;
    DECLARE voided_by INT(11);
    DECLARE date_created DATE;
    DECLARE creator INT(11);
    
    # Declare and initialise cursor for looping through the table
    DECLARE cur CURSOR FOR SELECT * FROM `bart1_intermediate_bare_bones`.`patients`;

    # Declare loop position check
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    # Open cursor
    OPEN cur;
    
    # Declare loop for traversing through the records
    read_loop: LOOP
    
        # Get the fields into the variables declared earlier
        FETCH cur INTO patient_id, given_name, middle_name, family_name, gender, dob, dob_estimated, dead, traditional_authority, current_address, landmark, cellphone_number, home_phone_number, office_phone_number, occupation, nat_id, art_number, pre_art_number, tb_number, legacy_id, legacy_id2, legacy_id3, new_nat_id, prev_art_number, filing_number, archived_filing_number, voided, void_reason, date_voided, voided_by, date_created, creator;
    
        # Check if we are done and exit loop if done
        IF done THEN
        
            LEAVE read_loop;
        
        END IF;
    
        # Not done, process the parameters
        
        # Map destination user to source user
        SET @creator = COALESCE((SELECT user_id FROM users WHERE user_id = creator), 1);
    
        # Create person object in destination
        INSERT INTO person (gender, birthdate, birthdate_estimated, dead, creator, date_created, uuid)
        VALUES (SUBSTRING(gender, 1, 1), dob, dob_estimated, dead, @creator, date_created, (SELECT UUID()));
    
        # Get last person id for association later to other records
        SET @person_id = (SELECT LAST_INSERT_ID());
    
        # Create person name details
        INSERT INTO person_name (person_id, given_name, middle_name, family_name, creator, date_created, uuid)
        VALUES (@person_id, given_name, middle_name, family_name, @creator, date_created, (SELECT UUID()));
    
        # Check variables for several person attribute type ids
        SET @cellphone_number_type_id = (SELECT person_attribute_type_id FROM person_attribute_type WHERE name = "Cell Phone Number");
        SET @home_phone_number_type_id = (SELECT person_attribute_type_id FROM person_attribute_type WHERE name = "Home Phone Number");
        SET @office_phone_number_type_id = (SELECT person_attribute_type_id FROM person_attribute_type WHERE name = "Office Phone Number");
        SET @occupation_type_id = (SELECT person_attribute_type_id FROM person_attribute_type WHERE name = "Occupation");
        SET @traditional_authority_type_id = (SELECT person_attribute_type_id FROM person_attribute_type WHERE name = "Ancestral Traditional Authority");
        SET @current_address_type_id = (SELECT person_attribute_type_id FROM person_attribute_type WHERE name = "Current Place Of Residence");
        SET @landmark_type_id = (SELECT person_attribute_type_id FROM person_attribute_type WHERE name = "Landmark Or Plot Number");
    
        # Create associated person attributes
        IF COALESCE(traditional_authority, "") != "" THEN
        
            INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, uuid)
            VALUES (@person_id, traditional_authority, @traditional_authority_type_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF COALESCE(current_address, "") != "" THEN
        
            INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, uuid)
            VALUES (@person_id, current_address, @current_address_type_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF COALESCE(landmark, "") != "" THEN
        
            INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, uuid)
            VALUES (@person_id, landmark, @landmark_type_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF COALESCE(occupation, "") != "" THEN
        
            INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, uuid)
            VALUES (@person_id, occupation, @occupation_type_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF COALESCE(office_phone_number, "") != "" THEN
        
            INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, uuid)
            VALUES (@person_id, office_phone_number, @office_phone_number_type_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF COALESCE(cellphone_number, "") != "" THEN
        
            INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, uuid)
            VALUES (@person_id, cellphone_number, @cellphone_number_type_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF COALESCE(home_phone_number, "") != "" THEN
        
            INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, uuid)
            VALUES (@person_id, home_phone_number, @home_phone_number_type_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        # Create a patient
        INSERT INTO patient (patient_id, creator, date_created)
        VALUES (@person_id, @creator, date_created);
    
        # Set patient identifier types
        SET @art_number = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "ARV Number");
        SET @tb_number = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "District TB Number");
        SET @legacy_id = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "Old Identification Number");
        SET @new_nat_id = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "National id");
        SET @nat_id = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "National id");
        SET @archived_filing_number_id = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "Archived filing number");
    
    END LOOP;

END$$

DELIMITER ;

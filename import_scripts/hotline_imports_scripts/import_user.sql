# This procedure imports patients hiv_staging encounters from intermediate tables to ART2 OpenMRS database
# ASSUMPTION
# ==========
# The assumption here is your source database name is `hotline_intermediate_bare_bones`
# and the destination any name you prefer.
# This has been necessary because there seems to be no way to use dynamic database
# names in procedures yet

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_users`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_users`(

)


BEGIN

    # Declare condition for exiting loop
    DECLARE done INT DEFAULT FALSE;

    DECLARE id int(11);
    DECLARE person_id int(11);
    DECLARE user_id INT(11);
    DECLARE username varchar(255);
    DECLARE first_name varchar(255);
    DECLARE middle_name varchar(255);
    DECLARE last_name varchar(255);
    DECLARE password varchar(255);
    DECLARE salt varchar(255);
    DECLARE user_role1 varchar(255);
    DECLARE user_role2 varchar(255);
    DECLARE user_role3 varchar(255);
    DECLARE user_role4 varchar(255);
    DECLARE user_role5 varchar(255);
    DECLARE user_role6 varchar(255);
    DECLARE user_role7 varchar(255);
    DECLARE user_role8 varchar(255);
    DECLARE user_role9 varchar(255);
    DECLARE user_role10 varchar(255);
    DECLARE date_created date;
    DECLARE voided tinyint(1);
    DECLARE void_reason varchar(255);
    DECLARE date_voided date;
    DECLARE voided_by int(11);
    DECLARE creator varchar(255);


    # Declare and initialise cursor for looping through the table
    DECLARE cur CURSOR FOR SELECT DISTINCT `hotline_intermediate_bare_bones`.`users`.id,
`hotline_intermediate_bare_bones`.`users`.person_id,
`hotline_intermediate_bare_bones`.`users`.user_id,
`hotline_intermediate_bare_bones`.`users`.username,
`hotline_intermediate_bare_bones`.`users`.first_name,
`hotline_intermediate_bare_bones`.`users`.middle_name,
`hotline_intermediate_bare_bones`.`users`.last_name,
`hotline_intermediate_bare_bones`.`users`.password,
`hotline_intermediate_bare_bones`.`users`.salt,
`hotline_intermediate_bare_bones`.`users`.user_role1,
`hotline_intermediate_bare_bones`.`users`.user_role2,
`hotline_intermediate_bare_bones`.`users`.user_role3,
`hotline_intermediate_bare_bones`.`users`.user_role4,
`hotline_intermediate_bare_bones`.`users`.user_role5,
`hotline_intermediate_bare_bones`.`users`.user_role6,
`hotline_intermediate_bare_bones`.`users`.user_role7,
`hotline_intermediate_bare_bones`.`users`.user_role8,
`hotline_intermediate_bare_bones`.`users`.user_role9,
`hotline_intermediate_bare_bones`.`users`.user_role10,
`hotline_intermediate_bare_bones`.`users`.date_created,
`hotline_intermediate_bare_bones`.`users`.voided,
`hotline_intermediate_bare_bones`.`users`.void_reason,
`hotline_intermediate_bare_bones`.`users`.date_voided,
`hotline_intermediate_bare_bones`.`users`.creator FROM
`hotline_intermediate_bare_bones`.`users`
WHERE `hotline_intermediate_bare_bones`.`users`.id > 2
GROUP BY `hotline_intermediate_bare_bones`.`users`.user_id;

    # Declare loop position check
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    # Disable system checks and indexing to speed up processing
    # SET FOREIGN_KEY_CHECKS = 0;
    # SET UNIQUE_CHECKS = 0;
    # SET AUTOCOMMIT = 0;
    # Open cursor
    OPEN cur;

    # Declare loop for traversing through the records
    read_loop: LOOP

        # Get the fields into the variables declared earlier
        FETCH cur INTO
          id,
          person_id,
          user_id,
          username,
          first_name,
          middle_name,
          last_name,
          password,
          salt,
          user_role1,
          user_role2,
          user_role3,
          user_role4,
          user_role5,
          user_role6,
          user_role7,
          user_role8,
          user_role9,
          user_role10,
          date_created,
          voided,
          void_reason,
          date_voided,
          creator;

        # Check if we are done and exit loop if done
        IF done THEN

            LEAVE read_loop;

        END IF;

        #SET @max_patient_id = (SELECT MAX(patient_id) + 1 FROM `hotline_intermediate_bare_bones`.`patients`);

	      # Map destination user to source user
	      SET @creator = COALESCE((SELECT user_id FROM users WHERE username = creator limit 1), 1);

        IF NOT ISNULL(user_id) THEN

        #create person
        SET @person_uuid = (SELECT UUID());
        INSERT INTO person (person_id,date_created, date_changed, creator, uuid)
        VALUES (user_id,date_created, date_created, @creator, @person_uuid) ON DUPLICATE KEY UPDATE person_id = user_id;

        INSERT INTO person_name(person_id, given_name, middle_name, family_name, date_created, creator, uuid)
        VALUES (user_id, last_name, middle_name, first_name, date_created, @creator, (SELECT UUID())) ON DUPLICATE KEY UPDATE person_id = user_id;

        #create user
        INSERT INTO users(user_id, username, password, salt, person_id, date_created, creator, uuid)
        VALUES (user_id, username, password, salt, @person_id, date_created, @creator, (SELECT UUID())) ON DUPLICATE KEY UPDATE user_id = user_id;

        #create user_roles
        IF NOT ISNULL(user_role1) THEN
          IF (user_role1 = 'Data Entry Clerk') THEN
           SET @user_role1 = 'Data Assistant';
          ELSEIF (user_role1 = 'provider') THEN
           SET @user_role1 = 'Provider';
          ELSEIF (user_role1 = 'superuser') THEN
           SET @user_role1 = 'Superuser';
          ELSE
           SET @user_role1 = user_role1;
          END IF;

          INSERT INTO user_role(user_id, role)
          VALUES(user_id, @user_role1);
        END IF;

        IF NOT ISNULL(user_role2) THEN
          IF (user_role2 = 'Data Entry Clerk') THEN
           SET @user_role2 = 'Data Assistant';
          ELSEIF (user_role2 = 'provider') THEN
           SET @user_role2 = 'Provider';
          ELSEIF (user_role2 = 'superuser') THEN
           SET @user_role2 = 'Superuser';
          ELSE
           SET @user_role2 = user_role2;
          END IF;

          INSERT INTO user_role(user_id, role)
          VALUES(user_id, @user_role2);
        END IF;

        IF NOT ISNULL(user_role3) THEN
          IF (user_role3 = 'Data Entry Clerk') THEN
           SET @user_role3 = 'Data Assistant';
          ELSEIF (user_role3 = 'provider') THEN
           SET @user_role3 = 'Provider';
          ELSEIF (user_role3 = 'superuser') THEN
           SET @user_role3 = 'Superuser';
          ELSE
           SET @user_role3 = user_role3;
          END IF;

          INSERT INTO user_role(user_id, role)
          VALUES(user_id, @user_role3);
        END IF;

        IF NOT ISNULL(user_role4) THEN
          IF (user_role4 = 'Data Entry Clerk') THEN
           SET @user_role4 = 'Data Assistant';
          ELSEIF (user_role4 = 'provider') THEN
           SET @user_role4 = 'Provider';
          ELSEIF (user_role4 = 'superuser') THEN
           SET @user_role4 = 'Superuser';
          ELSE
           SET @user_role4 = user_role4;
          END IF;

          INSERT INTO user_role(user_id, role)
          VALUES(user_id, @user_role4);
        END IF;

        IF NOT ISNULL(user_role5) THEN
          IF (user_role5 = 'Data Entry Clerk') THEN
           SET @user_role5 = 'Data Assistant';
          ELSEIF (user_role5 = 'provider') THEN
           SET @user_role5 = 'Provider';
          ELSEIF (user_role5 = 'superuser') THEN
           SET @user_role5 = 'Superuser';
          ELSE
           SET @user_role5 = user_role5;
          END IF;

          INSERT INTO user_role(user_id, role)
          VALUES(user_id, @user_role5);
        END IF;

        IF NOT ISNULL(user_role6) THEN
          IF (user_role6 = 'Data Entry Clerk') THEN
           SET @user_role6 = 'Data Assistant';
          ELSEIF (user_role6 = 'provider') THEN
           SET @user_role6 = 'Provider';
          ELSEIF (user_role6 = 'superuser') THEN
           SET @user_role6 = 'Superuser';
          ELSE
           SET @user_role6 = user_role6;
          END IF;

          INSERT INTO user_role(user_id, role)
          VALUES(user_id, @user_role6);
        END IF;

        IF NOT ISNULL(user_role7) THEN
          IF (user_role7 = 'Data Entry Clerk') THEN
           SET @user_role7 = 'Data Assistant';
          ELSEIF (user_role7 = 'provider') THEN
           SET @user_role7 = 'Provider';
          ELSEIF (user_role7 = 'superuser') THEN
           SET @user_role7 = 'Superuser';
          ELSE
           SET @user_role7 = user_role7;
          END IF;

          INSERT INTO user_role(user_id, role)
          VALUES(user_id, @user_role7);
        END IF;

        IF NOT ISNULL(user_role8) THEN
          IF (user_role8 = 'Data Entry Clerk') THEN
           SET @user_role8 = 'Data Assistant';
          ELSEIF (user_role8 = 'provider') THEN
           SET @user_role8 = 'Provider';
          ELSEIF (user_role8 = 'superuser') THEN
           SET @user_role8 = 'Superuser';
          ELSE
           SET @user_role8 = user_role8;
          END IF;

          INSERT INTO user_role(user_id, role)
          VALUES(user_id, @user_role8);
        END IF;

        IF NOT ISNULL(user_role9) THEN
          IF (user_role9 = 'Data Entry Clerk') THEN
           SET @user_role9 = 'Data Assistant';
          ELSEIF (user_role9 = 'provider') THEN
           SET @user_role9 = 'Provider';
          ELSEIF (user_role9 = 'superuser') THEN
           SET @user_role9 = 'Superuser';
          ELSE
           SET @user_role9 = user_role9;
          END IF;

          INSERT INTO user_role(user_id, role)
          VALUES(user_id, @user_role9);
        END IF;

        IF NOT ISNULL(user_role10) THEN
          IF (user_role10 = 'Data Entry Clerk') THEN
           SET @user_role10 = 'Data Assistant';
          ELSEIF (user_role10 = 'provider') THEN
           SET @user_role10 = 'Provider';
          ELSEIF (user_role10 = 'superuser') THEN
           SET @user_role10 = 'Superuser';
          ELSE
           SET @user_role10 = user_role10;
          END IF;

          INSERT INTO user_role(user_id, role)
          VALUES(user_id, @user_role10);
        END IF;

      #--END IF;
    END IF;
   END LOOP;

    # SET UNIQUE_CHECKS = 1;
    # SET FOREIGN_KEY_CHECKS = 1;
    # COMMIT;
    # SET AUTOCOMMIT = 1;

END$$

DELIMITER ;

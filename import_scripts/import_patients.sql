# This procedure imports patients from intermediate tables to ART2 OpenMRS database
# ASSUMPTION
# ==========
# The assumption here is your source database name is `bart1_intermediate_bare_bones`
# and the destination any name you prefer.
# This has been necessary because there seems to be no way to use dynamic database 
# names in procedures yet

# The default DELIMITER is disabled to avoid conflicting with our scripts
DELIMITER $$

# Check if a similar procedure exists and drop it so we can start from a clean slate
DROP PROCEDURE IF EXISTS `proc_import_patients`$$

# Procedure does not take any parameters. It assumes fixed table names and database
# names as working with flexible names is not supported as of writing in MySQL.
CREATE PROCEDURE `proc_import_patients`(
  #--IN start_pos INT(11),
  #--IN end_pos INT(11)
  #--IN in_patient_id INT(11)
	)
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
    DECLARE guardian_id INT(11);
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
    DECLARE creator varchar(255);

    # Declare and initialise cursor for looping through the table
    DECLARE cur CURSOR FOR SELECT * FROM `bart1_intermediate_bare_bones`.`patients`;
           #--WHERE `bart1_intermediate_bare_bones`.`patients`.`patient_id` IN (2,4,10,14,18,20,22,28,34,38,46,50,52,56,62,66,70,74,78,80,86,88,90,98,100,104,110,112,118,120,122,126,134,136,142,144,150,152,156,156,160,162,170,172,178,180,182,190,192,194,196,204,210,214,220,224,226,230,232,238,240,244,246,250,254,258,260,262,270,272,278,280,286,288,294,298,302,304,306,308,310,316,318,326,330,336,342,346,350,354,360,362,364,370,370,376,380,384,388,394,400,404,408,412,414,418,422,424,432,440,444,446,452,454,460,464,468,470,474,478,482,484,492,496,498,504,506,512,516,518,520,522,524,528,532,536,538,546,550,554,556,562,566,568,570,578,582,586,590,592,594,596,602,606,610,614,616,622,626,630,632,636,638,646,648,654,656,662,664,666,674,678,680,682,684,686,690,702,706,710,712,718,720,722,724,728,734,736,742,748,754,758,760,762,770,774,778,780,786,792,796,802,804,808,810,812,814,818,822,826,830,832,834,842,846,850,854,856,858,866,870,872,876,880,882,886,894,900,904,906,912,914,918,918,918,920,928,930,940,944,946,952,954,960,962,968,970,974,978,982,988,990,998,1000,1002,1010,1012,1018,1020,1028,1030,1032,1038,1046,1048,1054,1056,1062,1064,1068,1074,1078,1082,1084,1090,1092,1098,1100,1106,1108,1112,1122,1124,1130,1132,1138,1142,1146,1150,1154,1158,1160,1162,1170,1172,1174,1182,1184,1190,1194,1196,1202,1204,1208,1210,1222,1224,1230,1234,1236,1240,1244,1246,1250,1258,1260,1266,1270,1280,1284,1288,1292,1296,1300,1308,1312,1320,1324,1328,1330,1336,1338,1342,1346,1352,1354,1358,1368,1370,1376,1378,1384,1386,1392,1400,1402,1408,1410,1412,1422,1430,1434,1438,1438,1442,1444,1450,1454,1458,1460,1466,1470,1474,1478,1480,1484,1490,1492,1494,1498,1506,1508,1512,1514,1524,1528,1530,1532,1536,1540,1542,1544,1546,1546,1556,1560,1564,1566,1568,1576,1578,1584,1588,1590,1596,1600,1604,1608,1610,1616,1620,1626,1628,1630,1642,1644,1650,1654,1656,1658,1660,1666,1668,1678,1680,1684,1690,1692,1694,1702,1706,1708,1716,1718,1726,1728,1734,1738,1742,1744,1748,1750,1754,1756,1758,1766,1770,1774,1778,1780,1784,1790,1792,1798,1800,1802,1806,1814,1816,1820,1824,1826,1834,1838,1840,1842,1850,1852,1858,1860,1866,1868,1872,1876,1878,1884,1890,1894,1898,1900,1906,1908,1912,1914,1918,1920,1926,1928,1930,1934,1942,1946,1950,1954,1956,1962,1964,1970,1972,1978,1982,1986,1990,1992,1998,2002,2006,2008,2014,2018,2022,2026,2028,2034,2038,2042,2046,2048,2050,2058,2060,2068,2072,2074,2080,2082,2088,2092,2096,2098,2100,2108,2112,2116,2118,2124,2128,2130,2132,2138,2146,2148,2154,2154,2154,2158,2160,2166,2174,2178,2180,2186,2188,2194,2198,2200,2206,2210,2214,2218,2222,2226,2230,2232,2238,2242,2246,2248,2250,2252,2266,2268,2274,2278,2282,2284,2286,2292,2298,2302,2304,2306,2308,2310,2326,2330,2334,2338,2342,2346,2350,2354,2358,2362,2366,2372,2376,2382,2386,2390,2392,2394,2398,2406,2410,2412,2418,2420,2422,2430,2432,2434,2438,2448,2454,2456,2462,2470,2472,2474,2476,2480,2490,2494,2498,2504,2508,2512,2516,2520,2522,2526,2530,2534,2538,2542,2546,2552,2556,2560,2564,2566,2570,2578,2582,2586,2594,2598,2600,2606,2608,2610,2612,2616,2618,2626,2628,2630,2636,2640,2644,2650,2652,2654,2658,2662,2664,2670,2672,2678,2680,2684,2690,2694,2698,2702,2704,2708,2710,2714,2728,2732,2734,2736,2742,2744,2752,2756,2758,2760,2768,2770,2772,2780,2782,2784,2786,2796,2800,2800,2800,2804,2804,2806,2808,2816,2818,2826,2830,2834,2836,2842,2846,2848,2854,2858,2860,2866,2870,2878,2880,2882,2890,2892,2898,2900,2904,2910,2912,2918,2922,2924,2930,2934,2936,2938,2944,2948,2950,2958,2960,2962,2968,2970,2978,2982,2986,2992,2992,2994,2996,2998,3010,3014,3016,3022,3026,3028,3032,3034,3036,3038,3052,3054,3056,3060,3064,3066,3070,3074,3080,3082,3086,3090,3092,3096,3104,3106,3110,3112,3120,3122,3128,3132,3136,3140,3142,3144,3152,3154,3160,3164,3172,3174,3176,3178,3188,3190,3196,3198,3204,3206,3208,3210,3220,3222,3228,3230,3236,3238,3248,3252,3256,3260,3262,3264,3272,3274,3280,3282,3284,3292,3294,3298,3300,3306,3310,3312,3318,3320,3326,3330,3334,3336,3338,3340,3344,3354,3358,3360,3366,3368,3374,3378,3380,3386,3388,3394,3398,3402,3404,3406,3414,3416,3424,3428,3430,3436,3438,3444,3448,3450,3456,3458,3462,3468,3470,3476,3480,3482,3486,3490,3492,3500,3502,3508,3512,3516,3518,3524,3526,3532,3536,3536,3540,3542,3544,3550,3554,3560,3564,3568,3572,3574,3580,3584,3586,3592,3594,3600,3604,3608,3608,3610,3612,3620,3622,3630,3632,3638,3640,3644,3648,3650,3652,3654,3662,3666,3668,3670,3678,3682,3684,3686,3694,3696,3702,3706,3710,3714,3718,3726,3730,3734,3740,3744,3746,3748,3754,3758,3764,3768,3770,3772,3780,3782,3788,3792,3798,3802,3804,3808,3814,3818,3820,3826,3830,3832,3836,3842,3844,3846,3854,3858,3862,3864,3870,3876,3880,3882,3884,3886,3896,3898,3900,3906,3910,3912,3920,3924,3926,3928,3932,3940,3944,3946,3950,3952,3954,3964,3966,3970,3976,3980,3984,3986,3992,3994,3996,4004,4008,4012,4014,4024,4026,4030,4034,4036,4038,4044);
           #--LIMIT 1000;#--start_pos, end_pos;

    # Declare loop position check
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    # Disable system checks and indexing to speed up processing
    SET FOREIGN_KEY_CHECKS = 0;
    SET UNIQUE_CHECKS = 0;
    SET AUTOCOMMIT = 0;

    # Open cursor
    OPEN cur;
    
    # Declare loop for traversing through the records
    read_loop: LOOP
    
        # Get the fields into the variables declared earlier
        FETCH cur INTO patient_id, given_name, middle_name, family_name, gender, dob, dob_estimated, dead, traditional_authority, current_address, landmark, cellphone_number, home_phone_number, office_phone_number, occupation, guardian_id, nat_id, art_number, pre_art_number, tb_number, legacy_id, legacy_id2, legacy_id3, new_nat_id, prev_art_number, filing_number, archived_filing_number, voided, void_reason, date_voided, voided_by, date_created, creator;
    
        # Check if we are done and exit loop if done
        IF done THEN
        
            LEAVE read_loop;
        
        END IF;
    
        # Not done, process the parameters
        
        # Map destination user to source user
        SET @creator = COALESCE((SELECT user_id FROM users WHERE username = creator), 1);
        IF ISNULL(dob_estimated) THEN
          SET @date_of_birth_estimated = (false);
        ELSE
          SET @date_of_birth_estimated = (dob_estimated);
        END IF;

        IF ISNULL(dead) THEN
          SET @patient_dead = (0);
        ELSE
          SET @patient_dead = (dead);
        END IF;

        # Create person object in destination
        INSERT INTO person (person_id, gender, birthdate, birthdate_estimated, dead, creator, date_created, uuid)
        VALUES (patient_id,SUBSTRING(gender, 1, 1), dob, @date_of_birth_estimated, @patient_dead, @creator, date_created, (SELECT UUID()))  ON DUPLICATE KEY UPDATE person_id = patient_id;
    
        # Get last person id for association later to other records
        SET @person_id = (patient_id);
    
        # Create person name details
        INSERT INTO person_name (person_id, given_name, middle_name, family_name, creator, date_created, uuid)
        VALUES (patient_id, given_name, middle_name, family_name, @creator, date_created, (SELECT UUID()));
        
        SET @person_name_id = (SELECT LAST_INSERT_ID());
        
        #create person_name_coded
        INSERT INTO person_name_code (person_name_id, given_name_code, middle_name_code, family_name_code)
        VALUES (@person_name_id, soundex(given_name), soundex(middle_name), soundex(family_name));

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
            VALUES (patient_id, traditional_authority, @traditional_authority_type_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF COALESCE(current_address, "") != "" THEN
            SET @person_address_uuid = (SELECT UUID());

            INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, uuid)
            VALUES (patient_id, current_address, @current_address_type_id, @creator, date_created, (SELECT UUID()));
            
            INSERT INTO person_address (person_id, city_village, creator, date_created, uuid)
            VALUES (patient_id, current_address, @creator, date_created, @person_address_uuid);

            SET @person_address_id = (SELECT person_address_id FROM person_address WHERE uuid = @person_address_uuid);

          IF COALESCE(landmark, "") != "" THEN

            INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, uuid)
            VALUES (patient_id, landmark, @landmark_type_id, @creator, date_created, @person_address_uuid);

            UPDATE person_address SET address1 = landmark
            WHERE uuid = @person_address_uuid;

          END IF;

        END IF;
    
        IF COALESCE(occupation, "") != "" THEN
        
            INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, uuid)
            VALUES (patient_id, occupation, @occupation_type_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF COALESCE(office_phone_number, "") != "" THEN
        
            INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, uuid)
            VALUES (patient_id, office_phone_number, @office_phone_number_type_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF COALESCE(cellphone_number, "") != "" THEN
        
            INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, uuid)
            VALUES (patient_id, cellphone_number, @cellphone_number_type_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF COALESCE(home_phone_number, "") != "" THEN
        
            INSERT INTO person_attribute (person_id, value, person_attribute_type_id, creator, date_created, uuid)
            VALUES (patient_id, home_phone_number, @home_phone_number_type_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
  #--  
        # Create a patient
        INSERT INTO patient (patient_id, creator, date_created)
        VALUES (patient_id, @creator, date_created)  ON DUPLICATE KEY UPDATE patient_id = patient_id;
    
        # Set patient identifier types
        SET @art_number = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "ARV Number");
        SET @tb_number = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "District TB Number");
        SET @legacy_id = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "Old Identification Number");
        SET @new_nat_id = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "National id");
        SET @nat_id = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "National id");
        SET @archived_filing_number_id = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "Archived filing number");
        SET @filing_number_id = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "Filing number");
        SET @pre_art_number_id = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "Pre-ART number");
        SET @prev_art_number_id = (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "z_deprecated Pre ART Number (Old format)");
    
        # Location id defaulted to "Unknown" since the source database version 
        # did not capture this field
        SET @location_id = (SELECT location_id FROM location WHERE name = "Unknown");
    
        # Create patient identifiers            
        IF NOT ISNULL(prev_art_number) AND NOT ISNULL(@pre_art_number_id) THEN
        
            INSERT INTO patient_identifier (patient_id, identifier, identifier_type, location_id, creator, date_created, uuid)
            VALUES (patient_id, prev_art_number, @prev_art_number_id, @location_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
                                         
        IF NOT ISNULL(pre_art_number) AND NOT ISNULL(@pre_art_number_id) THEN
        
            INSERT INTO patient_identifier (patient_id, identifier, identifier_type, location_id, creator, date_created, uuid)
            VALUES (patient_id, pre_art_number, @pre_art_number_id, @location_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
                                  
        IF NOT ISNULL(filing_number) AND NOT ISNULL(@filing_number_id) THEN
        
            INSERT INTO patient_identifier (patient_id, identifier, identifier_type, location_id, creator, date_created, uuid)
            VALUES (patient_id, filing_number, @filing_number_id, @location_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
                          
        IF NOT ISNULL(archived_filing_number) AND NOT ISNULL(@archived_filing_number_id) THEN
        
            INSERT INTO patient_identifier (patient_id, identifier, identifier_type, location_id, creator, date_created, uuid)
            VALUES (patient_id, archived_filing_number, @archived_filing_number_id, @location_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
                  
        IF NOT ISNULL(nat_id) AND NOT ISNULL(@nat_id) THEN
        
            INSERT INTO patient_identifier (patient_id, identifier, identifier_type, location_id, creator, date_created, uuid)
            VALUES (patient_id, nat_id, (CASE WHEN ISNULL(new_nat_id) THEN @nat_id ELSE @legacy_id END), @location_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
          
        IF NOT ISNULL(new_nat_id) AND NOT ISNULL(@new_nat_id) THEN
        
            INSERT INTO patient_identifier (patient_id, identifier, identifier_type, location_id, creator, date_created, uuid)
            VALUES (patient_id, new_nat_id, @new_nat_id, @location_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF NOT ISNULL(art_number) AND NOT ISNULL(@art_number) THEN
        
            INSERT INTO patient_identifier (patient_id, identifier, identifier_type, location_id, creator, date_created, uuid)
            VALUES (patient_id, art_number, @art_number, @location_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF NOT ISNULL(tb_number) AND NOT ISNULL(@tb_number) THEN
        
            INSERT INTO patient_identifier (patient_id, identifier, identifier_type, location_id, creator, date_created, uuid)
            VALUES (patient_id, tb_number, @tb_number, @location_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF NOT ISNULL(legacy_id) AND NOT ISNULL(@legacy_id) THEN
        
            INSERT INTO patient_identifier (patient_id, identifier, identifier_type, location_id, creator, date_created, uuid)
            VALUES (patient_id, legacy_id, @legacy_id, @location_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF NOT ISNULL(legacy_id2) AND NOT ISNULL(@legacy_id) THEN

            INSERT INTO patient_identifier (patient_id, identifier, identifier_type, location_id, creator, date_created, uuid)
            VALUES (patient_id, legacy_id2, @legacy_id, @location_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
    
        IF NOT ISNULL(legacy_id3) AND NOT ISNULL(@legacy_id) THEN
        
            INSERT INTO patient_identifier (patient_id, identifier, identifier_type, location_id, creator, date_created, uuid)
            VALUES (patient_id, legacy_id3, @legacy_id, @location_id, @creator, date_created, (SELECT UUID()));
        
        END IF;
        select patient_id;
        select "first_visit_encounter";
        CALL proc_import_first_visit_encounters(@person_id);          # good
        
        select "hiv_reception_encounter";
        CALL proc_import_hiv_reception_encounters(@person_id);        # good
        
        select "vitals_encounter";
        CALL proc_import_vitals_encounters(@person_id);               # good
        
        select "first_visit_encounter";
        CALL proc_import_art_visit_encounters(@person_id);            # good
        
        select "pre_art_visit_encounter";
        CALL proc_import_pre_art_visit_encounters(@person_id);        # good
        
        select "hiv_staging_encounter";        
        CALL proc_import_hiv_staging_encounters(@person_id);          # good

        select "give_drugs_encounter";        
        CALL proc_import_give_drugs(@person_id);                      # good
        
        select "patient_outcome_encounter";        
        CALL proc_import_patient_outcome(@person_id);                 # good
        
        select "guardians_encounter";        
        CALL proc_import_guardians(@person_id);                       # good
        
        select "general_reception_encounter";        
        CALL proc_import_general_reception_encounters(@person_id);    # good
        
        select "outpatient_diagnosis_encounter";        
        CALL proc_import_outpatient_diagnosis_encounters(@person_id); # good

        select patient_id;

    END LOOP;

    SET UNIQUE_CHECKS = 1;
    SET FOREIGN_KEY_CHECKS = 1;
    COMMIT;
    SET AUTOCOMMIT = 1;

END$$

DELIMITER ;


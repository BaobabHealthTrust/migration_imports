#!/usr/bin/env ruby

require "rubygems"
require "json"

def expand_obs(field, category, concept=nil, type=nil)
  
  result = ""

  unless category.upcase != "OBSERVATION"

    unless type.nil? or concept.nil?

      case type.upcase
      when "VALUE_CODED"
        result = "
        # Check if the field is not empty
        IF NOT ISNULL(#{field}) THEN

            # Get concept_id
            SET @#{field}_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = '#{concept}' AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded id
            SET @#{field}_value_coded = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = #{field} AND voided = 0 AND retired = 0 LIMIT 1);

            # Get value_coded_name_id
            SET @#{field}_value_coded_name_id = (SELECT concept_name.concept_name_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = #{field} AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @#{field}_concept_id, visit_encounter_id, visit_date, @#{field}_value_coded, @#{field}_value_coded_name_id, @creator, date_created, (SELECT UUID()));

        END IF;
    "
      when "VALUE_DATETIME"
        result = "
        # Check if the field is not empty
        IF NOT ISNULL(#{field}) THEN

            # Get concept_id
            SET @#{field}_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = '#{field}' AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_datetime, creator, date_created, uuid)
            VALUES (patient_id, @#{field}_concept_id, visit_encounter_id, visit_date, #{field}, @creator, date_created, (SELECT UUID()));

        END IF;
    "
      when "VALUE_NUMERIC"
        result = ""
      else
        result = "
        # Check if the field is not empty
        IF NOT ISNULL(#{field}) THEN

            # Get concept_id
            SET @#{field}_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = '#{field}' AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, value_text, creator, date_created, uuid)
            VALUES (patient_id, @#{field}_concept_id, visit_encounter_id, visit_date, #{field}, @creator, date_created, (SELECT UUID()));

        END IF;
    "
      end

    end
    
  end

  return result
  
end

unless ARGV.length < 5

  src_table = ARGV[1]
  dst_filename = "output/import_#{src_table}.sql"
  src_db = ARGV[2]
  dst_db = ARGV[3]
  encounter = ARGV[4]

  commands = [
    "DELIMITER $$",
    "DROP PROCEDURE IF EXISTS `proc_import_#{src_table}`$$",
    "CREATE PROCEDURE `proc_import_#{src_table}`(\n\tIN in_patient_id INT(11)\n)",
    "BEGIN",
    "DECLARE done INT DEFAULT FALSE;",
    "DECLARE cur CURSOR FOR SELECT DISTINCT ",
    "DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;",
    "OPEN cur;",
    "read_loop: LOOP",
    "FETCH cur INTO",
    "IF done THEN",
    "LEAVE read_loop;",
    "END IF;",
    "SET @creator = COALESCE((SELECT user_id FROM users WHERE user_id = creator), 1);",
    "SET @encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = '#{encounter}');",
    "INSERT INTO encounter (encounter_id, encounter_type, patient_id, provider_id, " + 
      "encounter_datetime, creator, date_created, uuid) VALUES (visit_encounter_id, " +
      "@encounter_type, patient_id, @creator, visit_date, @creator, date_created, (SELECT UUID()));",
    "END LOOP;",
    "END$$",
    "DELIMITER ;"
  ]

  script = "# This procedure imports data from `#{src_db}` to `#{dst_db}`\n\n# " +
    "The default DELIMITER is disabled to avoid conflicting with our scripts\n" +
    "#{commands[0]}\n\n# Check if a similar procedure exists and drop it so we can " +
    "start from a clean slate\n#{commands[1]}\n\n# Procedure does not take any " +
    "parameters. It assumes fixed table names and database\n# names as working " +
    "with flexible names is not supported as of writing in MySQL.\n#{commands[2]}\n" +
    "#{commands[3]}\n\n\n\t# Declare condition for exiting loop\n\t#{commands[4]}\n\n\t"
  
  declarations = []

  selects = []

  fields = []

  obs = ""

  cursor = "# Declare and initialise cursor for looping through the table\n#{commands[5]}"

  File.open(ARGV[0], "r").each{|line|
    row = JSON.parse(line.strip.gsub(/,$/,""))

    fields << row[0]

    declarations << "DECLARE #{row[0]} #{row[1]};"

    selects << "`#{src_db}`.`#{src_table}`.`#{row[0]}`"

    obs = obs + expand_obs(row[0], row[2], row[3], row[4]) if row[2].upcase == "OBSERVATION"
  }

  script = script + declarations.join("\n\t") + "\n\tDECLARE visit_date DATE;\n\n\t"

  cursor = cursor + "#{selects.join(", ")}, COALESCE(`#{src_db}`.`visit_encounters`.visit_date, " +
    "`#{src_db}`.`first_visit_encounters`.date_created) FROM `#{src_db}`.`#{src_table}` " +
    "LEFT OUTER JOIN `#{src_db}`.`visit_encounters` ON
        visit_encounter_id = `#{src_db}`.`visit_encounters`.`id`
        WHERE `#{src_db}`.`#{src_table}`.`patient_id` = in_patient_id;\n\n\t# " +
    "Declare loop position check\n#{commands[6]}\n\n\t# Open cursor\n\t#{commands[7]}" +
    "\n\n\t# Declare loop for traversing through the records\n\t#{commands[8]}\n\n\t\t" +
    "# Get the fields into the variables declared earlier\n\t\t#{commands[9]}\n\t\t\t" +
    "#{fields.join(",\n\t\t\t")},\n\t\t\tvisit_date;\n\n\t\t# Check if we are done and exit loop if done\n\t\t#{commands[10]}\n" +
    "\n\t\t\t#{commands[11]}\n\n\t\t#{commands[12]}\n\n\t# Not done, process " +
    "the parameters\n\n\t# Map destination user to source user\n\t#{commands[13]}\n\n\t" +
    "# Get id of encounter type\n\t#{commands[14]}\n\n\t# Create encounter\n\t" +
    "#{commands[15]}\n\n\t"

  script = script + cursor
  
  script = script + obs

  script = script + "\n\t#{commands[16]}\n\n#{commands[17]}\n\n#{commands[18]}"

  file = File.open(dst_filename, "w")
  
  file.write(script)
  
  file.close

else

  puts "\nUsage:\n\t./generate.rb [target definition filename] " + 
    "[table name] [source database] [target database] [encounter type]\n\n"

end
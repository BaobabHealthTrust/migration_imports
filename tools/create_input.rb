#!/usr/bin/env ruby

require "rubygems"
require "json"
require "mysql"

$username = nil
$password = nil
$databases = []
$database = nil
$tables = []
$table = nil
$description = []
$row = nil
$filename = nil

$src_db = nil
$dst_db = nil
$folder = "output/"
$encounter_type = nil

def login
  
  if $username.nil?
    puts ""
    print green("\tEnter MySQL username: ")

    $username = gets.chomp
  end

  system("clear")

  if $password.nil?
    `stty -echo`
    puts ""
    print green("\tEnter MySQL password: ")

    $password = gets.chomp
    `stty echo`
  end

  system("clear")
end

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text); colorize(text, 31); end
def green(text); colorize(text, 32); end
def yellow(text); colorize(text, 33); end
def blue(text); colorize(text, 34); end
def magenta(text); colorize(text, 35); end
def cyan(text); colorize(text, 36); end

def list_databases(called=nil, destination=nil)
  system("clear")   # Clear screen
  
  if $username.nil? || $password.nil?
    login
  end

  puts ""
  puts blue("\tLISTING DATABASES")
  puts "\t================="
  puts ""

  print "\t"
  
  query = `mysql -u #{$username} -p#{$password} -e 'SHOW DATABASES'`

  puts ""
  
  $databases = query.split("\n") rescue []

  (1..($databases.length - 1)).each{|d|
    print "\t#{d}."
    puts green("\t#{$databases[d]}")
  }

  puts ""

  if destination.nil?
    $tables = []
    $table = nil
    $description = []
  end

  unless called.nil?

    print "\tSelect database number:"

    p = gets.chomp

    if p.to_i > 0 and p.to_i < $databases.length
      $database = p.to_i
      if !destination.nil?
        $dst_db = $databases[p.to_i]
      else
        $src_db = $databases[p.to_i]
      end

      system("clear")
      
      puts "\n\n\t\tDATABASE '#{green($databases[$database])}' SELECTED!"

      print cyan("\n\n\t\tPress ENTER to continue ")

      p = gets.chomp

      system("clear")

      return
    else

      system("clear")

      puts red("\n\n\t\tNO DATABASE SELECTED!")

      print cyan("\n\n\t\tPress ENTER to continue ")

      p = gets.chomp

      system("clear")

      return
    end
    
  end

  print "\tContinue? [y/n]: "

  p = gets.chomp

  if p[0,1].downcase == "y"
    select_task
  else
    system("clear")

    print red("\n\n\tCan't understand your choice! Quit? [y/n | n]: ")

    s = gets.chomp

    if s.to_s == "y"
      system("clear")

      exit(0)
    else
      select_task
    end
  end

  system("clear")
end

def list_tables(called=nil)
  system("clear")
  
  if $database.nil?
    list_databases(true)
  end

  puts ""
  puts blue("\tLISTING TABLES")
  puts "\t================="
  puts ""

  query = `mysql -u #{$username} -p#{$password} -e 'USE #{$databases[$database]}; SHOW TABLES'`

  $tables = query.split("\n") rescue []

  (1..($tables.length - 1)).each{|d|
    print "\t#{d}."
    puts green("\t#{$tables[d]}")
  }

  puts ""
  
  unless called.nil?

    $description = []

    print "\tSelect table number:"

    p = gets.chomp

    if p.to_i > 0 and p.to_i < $tables.length
      $table = p.to_i

      $filename = "data/#{$databases[$database]}_#{$tables[$table]}"

      system("clear")

      puts "\n\n\t\tTABLE '#{green($tables[$table])}' SELECTED!"

      print cyan("\n\n\t\tPress ENTER to continue ")

      p = gets.chomp

      system("clear")

      return
    else

      system("clear")

      puts red("\n\n\t\tNO TABLE SELECTED!")

      print cyan("\n\n\t\tPress ENTER to continue ")

      p = gets.chomp

      system("clear")
      
      list_tables

    end

  end

  print "\tContinue? [y/n | n]: "

  p = gets.chomp

  if p[0,1].downcase == "y"
    select_task
  else
    system("clear")

    print red("\n\n\tCan't understand your choice! Quit? [y/n | n]: ")

    s = gets.chomp

    if s.to_s == "y"
      system("clear")

      exit(0)
    else
      select_task
    end
  end
  
  system("clear")
end

def describe_table
  system("clear")

  if $table.nil?
    list_tables(true)
  end

  unless $table.nil?
    puts ""
    puts blue("\tDESCIBING TABLE '#{$tables[$table]}'")
    puts "\t======================================================================"
    puts ""
  end

  $description = []
  
  puts "\t#{("").ljust(5)}#{"FIELD".ljust(35)}#{"FIELD TYPE".ljust(15)}" +
    "#{"FIELD CATEGORY".ljust(16)}#{"CONCEPT".ljust(40)}#{"RECORD TYPE".ljust(15)}" +
    "#{"GROUP FIELD".ljust(35)}"

  if !$filename.nil? and File.exists?($filename)

    file = File.open($filename, "r")

    $description = JSON.parse(file.read)

    file.close

  else

    query = `mysql -u #{$username} -p#{$password} -e 'USE #{$databases[$database]}; DESCRIBE #{$tables[$table]};'`

    rows = query.split("\n") rescue []

    (0..(rows.length - 1)).each{|d|
      cells = rows[d].split("\t")

      category = nil
      concept = nil
      type = nil

      case cells[0].to_s.downcase
      when "visit_encounter_id"
        category = "ENCOUNTER"
      when "old_enc_id"
        category = "ENCOUNTER"
      when "patient_id"
        category = "PATIENT_ID"
      when "id"
        category = "POSITION"
      when "voided"
      when "void_reason"
      when "date_voided"
      when "voided_by"
      when "date_created"
      when "creator"
      when "location"
      else
        category = "OBSERVATION"
        concept = cells[0].to_s.gsub(/\_/, " ") rescue nil
        type = "VALUE_CODED"
      end

      $description << [cells[0], cells[1], category, concept, type, nil]

    }

  end

  display_rows

  puts ""

  print "\tSelect record to edit or [s] to save or [g] to generate script: "
  
  p = gets.chomp

  prefix = ""

  if p.to_s.downcase == "s"

    # Save updates
    file = File.open($filename, "w")

    file.write($description.to_json)

    file.close

    prefix = "Data Saved. "

  elsif p.to_s.downcase == "g"

    generate

    system("clear")

    puts "\n\n\t\tDone! File saved as '#{"#{$folder}import_#{$tables[$table]}.sql"}'"

    print cyan("\n\n\t\tPress ENTER to continue ")

    p = gets.chomp

    system("clear")

    select_task

  elsif p.to_i > 0 and p.to_i < ($description.length - 1)
    $row = p.to_i
    
    edit_row
  end

  system("clear")
  
  unless $table.nil?
    puts ""
    puts blue("\tDESCIBING TABLE '#{$tables[$table]}'")
    puts "\t======================================================================"
    puts ""
  end
    
  print "\n\n\n\t#{prefix}Continue? [y/n/f/b | f]: "

  p = gets.chomp

  if p[0,1].downcase == "y"
    describe_table
  elsif p[0,1].downcase == "n"
    select_task
  elsif p[0,1].downcase == "b"    
    edit_row
  else p[0,1].downcase == "f"
    $row = $row.to_i + 1 if ($row.to_i + 1) < $description.length

    edit_row
  end
  
  system("clear")
end

def display_rows

  (1..($description.length - 1)).each{|d|
    cells = $description[d]

    puts "\t#{(d.to_s + ".").ljust(5)}#{green(cells[0].ljust(35))}#{cyan(cells[1].ljust(15))}" +
      "#{cells[2].to_s.ljust(16)}#{cells[3].to_s.ljust(40)}#{cells[4].to_s.ljust(15)}#{cells[5].to_s.ljust(35)}"
  }

end

def edit_row

  if $row.nil?
    describe_table
  end

  show_edit_row

  puts "\tField Category: [ POSITION | ENCOUNTER | PATIENT_ID | OBSERVATION ]"
  puts""
  if $description[$row][2].nil?
    print "\tAdd field category: "
  else
    print "\tAdd field category[#{yellow($description[$row][2])}]: "
  end
  
  p = gets.chomp

  if p.to_s.strip.length == 0 and $description[$row][2].to_s.length > 0
    print red("\tDelete current entry? [y/n | n]: ")

    s = gets.chomp

    if s.to_s.strip[0,1].downcase == "y"
      $description[$row][2] = nil
    end
    
  else
    $description[$row][2] = p.to_s.strip
  end

  show_edit_row

  if $description[$row][3].nil?
    print "\tAdd concept: "
  else
    print "\tAdd concept[#{yellow($description[$row][3])}]: "
  end

  p = gets.chomp

  if p.to_s.strip.length == 0 and $description[$row][3].to_s.length > 0
    print red("\tDelete current entry? [y/n | n]: ")

    s = gets.chomp

    if s.to_s.strip[0,1].downcase == "y"
      $description[$row][3] = nil
    end

  else
    $description[$row][3] = p.to_s.strip
  end

  show_edit_row

  puts "\tRecord Types: [ VALUE_CODED | VALUE_TEXT | VALUE_NUMERIC | VALUE_DATETIME | VALUE_MODIFIER ]"
  if $description[$row][4].nil?
    print "\tAdd record type: "
  else
    print "\tAdd record type[#{yellow($description[$row][4])}]: "
  end

  p = gets.chomp

  if p.to_s.strip.length == 0 and $description[$row][4].to_s.length > 0
    print red("\tDelete current entry? [y/n | n]: ")

    s = gets.chomp

    if s.to_s.strip[0,1].downcase == "y"
      $description[$row][4] = nil
    end

  else
    $description[$row][4] = p.to_s.strip
  end

  show_edit_row

  if $description[$row][5].nil?
    print "\tAdd group field: "
  else
    print "\tAdd  group field[#{yellow($description[$row][5])}]: "
  end

  p = gets.chomp

  if p.to_s.strip.length == 0 and $description[$row][5].to_s.length > 0
    print red("\tDelete current entry? [y/n | n]: ")

    s = gets.chomp

    if s.to_s.strip[0,1].downcase == "y"
      $description[$row][5] = nil
    end

  else
    $description[$row][5] = p.to_s.strip
  end

  # Save updates
  file = File.open($filename, "w")

  file.write($description.to_json)

  file.close

  print "\n\n\n\tContinue? [y/n/f/b | f]: "

  p = gets.chomp

  if p[0,1].downcase == "y"
    describe_table
  elsif p[0,1].downcase == "n"
    select_task
  elsif p[0,1].downcase == "b"
    $row = $row.to_i - 1 if ($row.to_i - 1) > 0
    
    edit_row
  else p[0,1].downcase == "f"
    $row = $row.to_i + 1 if ($row.to_i + 1) < $description.length

    edit_row
  end

end

def show_edit_row
  system("clear")
  
  unless $table.nil?
    puts ""
    puts blue("\tEDITING '#{$tables[$table]}'")
    puts "\t======================================================================"
    puts ""
  end

  puts "\t#{("").ljust(5)}#{"FIELD".ljust(35)}#{"FIELD TYPE".ljust(15)}" +
    "#{"FIELD CATEGORY".ljust(16)}#{"CONCEPT".ljust(40)}#{"RECORD TYPE".ljust(15)}" +
    "#{"GROUP FIELD".ljust(35)}"

  cells = $description[$row]

  puts "\t#{($row.to_s + ".").ljust(5)}#{green(cells[0].ljust(35))}#{cyan(cells[1].ljust(15))}" +
    "#{cells[2].to_s.ljust(16)}#{cells[3].to_s.ljust(40)}#{cells[4].to_s.ljust(15)}#{cells[5].to_s.ljust(35)}"

  puts ""
end

def set_folder
  system("clear")
  
  print "\n\n\tChange folder name [#{yellow($folder)}]: "

  p = gets.chomp

  if p.to_s.strip.length == 0 and $folder.to_s.length > 0
    print red("\tDelete current entry? [y/n | n]: ")

    s = gets.chomp

    if s.to_s.strip[0,1].downcase == "y"
      $folder = nil
    end

  else
    $folder = p.to_s.strip
  end

end

def expand_obs(field, category, concept=nil, type=nil, group=nil)

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
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id #{(!group.nil? ? ", obs_group_id" : "")}, value_coded, value_coded_name_id, creator, date_created, uuid)
            VALUES (patient_id, @#{field}_concept_id, old_enc_id, visit_date, @location_id #{(!group.nil? ? ", @" + group + "_id" : "")}, @#{field}_value_coded, @#{field}_value_coded_name_id, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @#{field}_id = (SELECT LAST_INSERT_ID());

        END IF;
        "
      when "VALUE_DATETIME"
        result = "
        # Check if the field is not empty
        IF NOT ISNULL(#{field}) THEN

            # Get concept_id
            SET @#{field}_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = '#{concept}' AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id #{(!group.nil? ? ", obs_group_id" : "")}, value_datetime, creator, date_created, uuid)
            VALUES (patient_id, @#{field}_concept_id, old_enc_id, visit_date, @location_id #{(!group.nil? ? ", @" + group + "_id" : "")}, #{field}, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @#{field}_id = (SELECT LAST_INSERT_ID());

        END IF;
        "
      when "VALUE_NUMERIC"
        result = "
        # Check if the field is not empty
        IF NOT ISNULL(#{field}) THEN

            # Get concept_id
            SET @#{field}_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = '#{concept}' AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id #{(!group.nil? ? ", obs_group_id" : "")}, value_numeric, creator, date_created, uuid)
            VALUES (patient_id, @#{field}_concept_id, old_enc_id, visit_date, @location_id #{(!group.nil? ? ", @" + group + "_id" : "")}, #{field}, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @#{field}_id = (SELECT LAST_INSERT_ID());

        END IF;
        "
      when "VALUE_MODIFIER"
        result = "
        # Check if the field is not empty
        IF NOT ISNULL(#{field}) THEN

            # Update parent observation
            UPDATE obs SET value_modifier = '#{field}' WHERE obs_id = @#{group}_id;

        END IF;
        "
      else
        result = "
        # Check if the field is not empty
        IF NOT ISNULL(#{field}) THEN

            # Get concept_id
            SET @#{field}_concept_id = (SELECT concept_name.concept_id FROM concept_name concept_name
                        LEFT OUTER JOIN concept ON concept.concept_id = concept_name.concept_id
                        WHERE name = '#{concept}' AND voided = 0 AND retired = 0 LIMIT 1);

            # Create observation
            INSERT INTO obs (person_id, concept_id, encounter_id, obs_datetime, location_id #{(!group.nil? ? ", obs_group_id" : "")}, value_text, creator, date_created, uuid)
            VALUES (patient_id, @#{field}_concept_id, old_enc_id, visit_date, @location_id #{(!group.nil? ? ", @" + group + "_id" : "")}, #{field}, @creator, date_created, (SELECT UUID()));

            # Get last obs id for association later to other records
            SET @#{field}_id = (SELECT LAST_INSERT_ID());

        END IF;
        "
      end

    end

  end

  return result

end

def generate
  
  set_encounter_type

  if $dst_db.nil?
    list_databases(true, true)
  end

  src_table = $tables[$table]
  dst_filename = "#{$folder}import_#{src_table}.sql"
  src_db = $src_db
  dst_db = $dst_db
  encounter = $encounter_type

  commands = [
    "DELIMITER $$",   # 0
    "DROP PROCEDURE IF EXISTS `proc_import_#{src_table}`$$",    # 1
    "CREATE PROCEDURE `proc_import_#{src_table}`(\n\tIN in_patient_id INT(11)\n)",    # 2
    "BEGIN",    # 3
    "DECLARE done INT DEFAULT FALSE;",    # 4
    "DECLARE cur CURSOR FOR SELECT DISTINCT ",    # 5
    "DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;",    # 6
    "OPEN cur;",    # 7
    "read_loop: LOOP",    # 8
    "FETCH cur INTO",   # 9
    "IF done THEN",   # 10
    "LEAVE read_loop;",   # 11
    "END IF;",    # 12
    "SET @creator = COALESCE((SELECT user_id FROM users WHERE user_id = creator), 1);",   # 13
    "SET @encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = '#{encounter}');",    # 14
    "INSERT INTO encounter (encounter_id, encounter_type, patient_id, provider_id, location_id, " +
      "encounter_datetime, creator, date_created, uuid) VALUES (old_enc_id, " +
      "@encounter_type, patient_id, @creator, @location_id, visit_date, @creator, date_created, (SELECT UUID())) " +
      "ON DUPLICATE KEY UPDATE encounter_id = old_enc_id;",   # 15
    "END LOOP;",    # 16
    "END$$",    # 17
    "DELIMITER ;",   # 18
    "SET @location_id = (SELECT location_id FROM location WHERE name = location);"
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

  $description.each{|line|
    row = line

    if row[0].downcase.strip == "field"
      next
    end

    fields << row[0]

    declarations << "DECLARE #{row[0]} #{row[1]};"

    selects << "`#{src_db}`.`#{src_table}`.`#{row[0]}`"

    obs = obs + expand_obs(row[0], row[2], row[3], row[4], ((row[5].strip.length rescue 0) > 0 ? row[5] : nil)) if (row[2].upcase rescue "") == "OBSERVATION"
  }

  script = script + declarations.join("\n\t") + "\n\tDECLARE visit_date DATE;\n\n\t"

  cursor = cursor + "#{selects.join(", ")}, COALESCE(`#{src_db}`.`visit_encounters`.visit_date, " +
    "`#{src_db}`.`#{src_table}`.date_created) FROM `#{src_db}`.`#{src_table}` " +
    "LEFT OUTER JOIN `#{src_db}`.`visit_encounters` ON
        visit_encounter_id = `#{src_db}`.`visit_encounters`.`id`
        WHERE `#{src_db}`.`#{src_table}`.`patient_id` = in_patient_id;\n\n\t# " +
    "Declare loop position check\n#{commands[6]}\n\n\t# Open cursor\n\t#{commands[7]}" +
    "\n\n\t# Declare loop for traversing through the records\n\t#{commands[8]}\n\n\t\t" +
    "# Get the fields into the variables declared earlier\n\t\t#{commands[9]}\n\t\t\t" +
    "#{fields.join(",\n\t\t\t")},\n\t\t\tvisit_date;\n\n\t\t# Check if we are done and exit loop if done\n\t\t#{commands[10]}\n" +
    "\n\t\t\t#{commands[11]}\n\n\t\t#{commands[12]}\n\n\t# Not done, process " +
    "the parameters\n\n\t# Map destination user to source user\n\t#{commands[13]}\n\n\t" +
    "# Get location id\n\t#{commands[19]}\n\n\t" +
    "# Get id of encounter type\n\t#{commands[14]}\n\n\t# Create encounter\n\t" +
    "#{commands[15]}\n\n\t"

  script = script + cursor
  
  script = script + obs

  script = script + "\n\t#{commands[16]}\n\n#{commands[17]}\n\n#{commands[18]}"

  file = File.open(dst_filename, "w")
  
  file.write(script)
  
  file.close

end

def set_encounter_type
  system("clear")

  print "\n\n\tSet encounter type [#{yellow($encounter_type)}]: "

  p = gets.chomp

  if p.to_s.strip.length == 0 and $encounter_type.to_s.length > 0
    print red("\tDelete current entry? [y/n | n]: ")

    s = gets.chomp

    if s.to_s.strip[0,1].downcase == "y"
      $encounter_type = nil
    end

  else
    $encounter_type = p.to_s.strip
  end

end

def select_task
  system("clear")

  puts ""
  puts cyan("\tSelect task number")
  puts blue("\t==================")
  puts ""
  print yellow("\t\t1.")
  puts green(" List databases")
  print yellow("\t\t2.")
  puts green(" Select database")
  print yellow("\t\t3.")
  puts green(" List tables")
  print yellow("\t\t4.")
  puts green(" Select table")
  print yellow("\t\t5.")
  puts green(" Describe table")
  print yellow("\t\t6.")
  puts green(" Set source database")
  print yellow("\t\t7.")
  puts green(" Set destination database")
  print yellow("\t\t8.")
  puts green(" Set destination folder")
  print yellow("\t\t9.")
  puts green(" Quit")

  print "\n\n\t\tTask number: "

  p = gets.chomp

  case p[0,1].to_i
  when 1
    list_databases
  when 2
    list_databases(true)
    
    select_task
  when 3
    list_tables
  when 4
    list_tables(true)

    select_task
  when 5
    describe_table
    
    select_task
  when 6
    list_databases(true)

    select_task
  when 7
    list_databases(true, true)

    select_task
  when 8
    set_folder

    select_task
  when 9
    system("clear")
    
    exit(0)
  else
    system("clear")
      
    print red("\n\n\tCan't understand your choice! Quit? [y/n | n]: ")

    s = gets.chomp

    if s.to_s == "y"
      system("clear")

      exit(0)
    else
      select_task
    end
  end

  system("clear")
end

def main
  if !File.exists?("data")
    Dir.mkdir("data")
  end

  if !File.exists?("output")
    Dir.mkdir("output")
  end
  
  select_task
end

main
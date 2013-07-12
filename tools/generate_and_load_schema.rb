#!/usr/bin/ruby

require 'rubygems'
require 'mysql'
require "yaml"

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text); colorize(text, 31); end
def green(text); colorize(text, 32); end
def yellow(text); colorize(text, 33); end
def blue(text); colorize(text, 34); end
def magenta(text); colorize(text, 35); end
def cyan(text); colorize(text, 36); end

puts ""

host = "localhost" 

print green("\tEnter Host MySQL username: ")

user = gets.chomp

puts ""
print green("\tEnter Host MySQL password: ")

`stty -echo`
pass = gets.chomp
`stty echo`

puts ""
puts ""
print green("\tEnter Source Database Name: ")

db = gets.chomp

dest_host = "localhost"

puts ""
print green("\tEnter Destination Database Name: ")

dest_db = gets.chomp

puts ""

print green("\tEnter Start Position: ")

start_pos = gets.chomp

puts ""

print green("\tEnter End Position: ")

end_pos = gets.chomp

puts ""
con = Mysql.connect(host, user, pass, db)

rs = con.query("show tables") 
tables = [] 

rs.each_hash{|h| tables << h["Tables_in_" + db]}

exception_tables = ["person", "person_address", "person_attribute", "person_name", 
  "person_name_code", "patient", "patient_identifier", "patient_program", "patient_state",
  "patient_state_on_arvs", "encounter", "obs", "orders", "drug_order", 
  "regimen_observation, relationship"]

tables = tables - exception_tables

if(start_pos.to_i <= 1)

  system("mysql -u #{user} -p#{pass} -e 'DROP DATABASE IF EXISTS #{dest_db};'")
  system("mysql -u #{user} -p#{pass} -e 'CREATE DATABASE #{dest_db};'")

  command = "mysqldump --user=#{user} --password=#{pass} #{db} "

  tables.each{|table|
    command += " " + table
  }

  command += " > tools/schema/defaults.sql\n"

  print "# dumping tools/schema/defaults.sql file\n"
  `#{command}`

  print "# dumping tools/schema/schema.sql file\n"
  `mysqldump --user=#{user} --password=#{pass} #{db} --no-data > tools/schema/schema.sql`

  print "# loading tools/schema/schema.sql file\n"
  `mysql --host=#{dest_host} --user=#{user} --password=#{pass} #{dest_db} < tools/schema/schema.sql`

  print "# loading tools/schema/defaults.sql file\n"
  `mysql --host=#{dest_host} --user=#{user} --password=#{pass} #{dest_db} < tools/schema/defaults.sql`

  `./setup.sh #{dest_db} #{user} #{pass}`

end

start_time = Time.now

dest_con = Mysql.connect(dest_host, user, pass, dest_db)

people = con.query("SELECT person_id FROM person LIMIT #{start_pos}, #{end_pos}")

p = dest_con.query("SET UNIQUE_CHECKS = 0")
p = dest_con.query("SET AUTOCOMMIT = 0")
p = dest_con.query("SET FOREIGN_KEY_CHECKS = 0")

pos = 0

people.each_hash do |person|

  pos = pos.to_i + 1

  t = Thread.new {
    # Person table and associated fields
    print "# importing person with id #{person["person_id"]}\n"
      
    begin
      p = dest_con.query("INSERT INTO person SELECT * FROM `#{db}`.`person` " + 
          "WHERE `#{db}`.`person`.`person_id` = #{person["person_id"]}")   
    rescue Mysql::Error => e
      puts "?? Error importing person #{e.errno}: #{e.error}"
    end
    
    print "# importing person_address with id #{person["person_id"]}\n"
      
    begin
      p = dest_con.query("INSERT INTO person_address SELECT * FROM `#{db}`.`person_address` " + 
          "WHERE `#{db}`.`person_address`.`person_id` = #{person["person_id"]}")    
    rescue Mysql::Error => e
      puts "?? Error importing person_address #{e.errno}: #{e.error}"
    end
    
    print "# importing person_attribute with id #{person["person_id"]}\n"
      
    begin
      p = dest_con.query("INSERT INTO person_attribute SELECT * FROM `#{db}`.`person_attribute` " + 
          "WHERE `#{db}`.`person_attribute`.`person_id` = #{person["person_id"]}")   
    rescue Mysql::Error => e
      puts "?? Error importing person_attribute #{e.errno}: #{e.error}"
    end
    
    print "# importing person_name with id #{person["person_id"]}\n"
      
    begin
      p = dest_con.query("INSERT INTO person_name SELECT * FROM `#{db}`.`person_name` " + 
          "WHERE `#{db}`.`person_name`.`person_id` = #{person["person_id"]}")    
    rescue Mysql::Error => e
      puts "?? Error importing person_name #{e.errno}: #{e.error}"
    end
    
    print "# importing person_name_code with id #{person["person_id"]}\n"
    
    begin
      p = dest_con.query("INSERT INTO person_name_code SELECT * FROM `#{db}`.`person_name_code` " + 
          "WHERE `#{db}`.`person_name_code`.`person_name_id` IN (SELECT person_name_id FROM " + 
          "`#{db}`.`person_name` WHERE `#{db}`.`person_name`.`person_id` = #{person["person_id"]})")    
    rescue Mysql::Error => e
      puts "?? Error importing person_name_code #{e.errno}: #{e.error}"
    end
    
    # Patient and associated fields
    print "# importing patient with id #{person["person_id"]}\n"
      
    begin
      p = dest_con.query("INSERT INTO patient SELECT * FROM `#{db}`.`patient` " + 
          "WHERE `#{db}`.`patient`.`patient_id` = #{person["person_id"]}")   
    rescue Mysql::Error => e
      puts "?? Error importing patient #{e.errno}: #{e.error}"
    end
    
    print "# importing patient_identifier with id #{person["person_id"]}\n"
      
    begin
      p = dest_con.query("INSERT INTO patient_identifier SELECT * FROM `#{db}`.`patient_identifier` " + 
          "WHERE `#{db}`.`patient_identifier`.`patient_id` = #{person["person_id"]}")    
    rescue Mysql::Error => e
      puts "?? Error importing patient_identifier #{e.errno}: #{e.error}"
    end
    
    print "# importing patient_program with id #{person["person_id"]}\n"
      
    begin
      p = dest_con.query("INSERT INTO patient_program SELECT * FROM `#{db}`.`patient_program` " + 
          "WHERE `#{db}`.`patient_program`.`patient_id` = #{person["person_id"]}")    
    rescue Mysql::Error => e
      puts "?? Error importing patient_program #{e.errno}: #{e.error}"
    end
    
    print "# importing patient_state with id #{person["person_id"]}\n"
      
    begin
      p = dest_con.query("INSERT INTO patient_state SELECT * FROM `#{db}`.`patient_state` " + 
          "WHERE `#{db}`.`patient_state`.`patient_program_id` IN (SELECT patient_program_id " + 
          "FROM `#{db}`.`patient_program` WHERE `#{db}`.`patient_program`.`patient_id` = #{person["person_id"]})")    
    rescue Mysql::Error => e
      puts "?? Error importing patient_state #{e.errno}: #{e.error}"
    end
    
    # Encounter table     
    print "# importing encounter with patient id #{person["person_id"]}\n"
      
    begin
      p = dest_con.query("INSERT INTO encounter SELECT * FROM `#{db}`.`encounter` " + 
          "WHERE `#{db}`.`encounter`.`patient_id` = #{person["person_id"]}")     
    rescue Mysql::Error => e
      puts "?? Error importing encounter #{e.errno}: #{e.error}"
    end
    
    # Observations - simple mapping assumed at this stage
    print "# importing observations with patient id #{person["person_id"]}\n"
      
    begin
      # p = dest_con.query("SET @@FOREIGN_KEY_CHECKS=0")
      p = dest_con.query("INSERT INTO obs SELECT * FROM `#{db}`.`obs` " + 
          "WHERE `#{db}`.`obs`.`person_id` = #{person["person_id"]}")    
    rescue Mysql::Error => e
      puts "?? Error importing observations #{e.errno}: #{e.error}"
    end
    
    # Orders - simple mapping assumed at this stage
    print "# importing orders with patient id #{person["person_id"]}\n"
      
    begin
      p = dest_con.query("INSERT INTO orders SELECT * FROM `#{db}`.`orders` " + 
          "WHERE `#{db}`.`orders`.`encounter_id` IN (SELECT encounter_id FROM " + 
          "`#{db}`.`encounter` WHERE `#{db}`.`encounter`.`patient_id` = #{person["person_id"]})")    
    rescue Mysql::Error => e
      puts "?? Error importing orders #{e.errno}: #{e.error}"
    end
     
    print "# importing drug_orders with patient id #{person["person_id"]}\n"
      
    begin
      p = dest_con.query("INSERT INTO drug_order SELECT * FROM `#{db}`.`drug_order` " + 
          "WHERE `#{db}`.`drug_order`.`order_id` IN (SELECT order_id FROM `#{db}`.`orders` " + 
          "WHERE encounter_id IN (SELECT encounter_id FROM " + 
          "`#{db}`.`encounter` WHERE `#{db}`.`encounter`.`patient_id` = #{person["person_id"]}))")    
    rescue Mysql::Error => e
      puts "?? Error importing drug_orders #{e.errno}: #{e.error}"
    end

    puts "Patient #{pos} of #{end_pos} imported. Started: #{((Time.now - start_time) / (60))} minutes ago"
    
  }
  t.join
end

puts "Total time taken: #{(Time.now - start_time) / 3600} hours"

p = dest_con.query("SET FOREIGN_KEY_CHECKS = 1")
p = dest_con.query("SET UNIQUE_CHECKS = 1")
p = dest_con.query("SET AUTOCOMMIT = 1")

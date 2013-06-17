migration_imports

This application is used to import data from the intermediate tables into OpenMRS 1.7 database.

Getting started 

1. Make sure you have an up-to-date migration_imports application

2. In migration_imports terminal create database e.g mysqladmin -u username -p password create database_name; 

3. Run the procedure_setup.sh to initialize the database you have created above and load all the procedures then import data.
   type: ruby procedure_setup.sh database_name username password site_code
   for example ruby procedure_setup.sh test_database test testing mpc
   
4. After successfully importing switch to bart2 application and make sure it is up-to-date. Change the bart2 config/database.yaml
   update the database_name to the migrated OpenMRS 1.7 under production or development. 

5. Under bart2 terminal load the following into OpenMRS 1.7 dataset (the one which will has the imported data)
   a. mysql -u username -p password openmrs_1.7_database_name < db/adherence_calculation.sql
   b. mysql -u username -p password openmrs_1.7_database_name < db/recalculate_adherence.sql

6. On the same bart2 terminal run the following scripts
   a. script/runner script/recalculate_adherence.rb
   b. script/runner script/fix_program_locations.rb
   



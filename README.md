migration_imports

This application is used to migrated data from OpenMRS 1.1 to OpenMRS 1.7. The process of migrating data is categorized into two:
  1. Export data from OpenMRS 1.1 to the intermediary storage (flat tables).
  2. Import from the flat tables into OpenMRS 1.7

Getting started 

1. Make sure you have an up-to-date migration_imports application.
    a. If you don't have the application type the command below in your terminal
        https://github.com/BaobabHealthTrust/migration_imports.git
    
    b. If you have the application, type the comman below to update the application.
       git pull orgin (run this command in the terminal which you have opened the application)
       
2. Edit the config/database.yml file
   a. under bart2: enter details of your Source database. (This is the database you want to export from. OpenMRS 1.1 dataset).
   b. under development/production: enter details of your intermediary database. (The database which will hold the flat tables) For the sake of constistency the database name should be bart1_intermediate_bare_bones.

3. Run the procedure_setup.sh to migrate data.
   type: ruby procedure_setup.sh database_name username password site_code
   for example ruby procedure_setup.sh test_database test testing mpc
   
4. After successfully migrating data switch to bart2 application and make sure it is up-to-date. Change the bart2 config/database.yaml
   update the database_name to the migrated OpenMRS 1.7 under production or development. 

5. Under bart2 terminal load the following into OpenMRS 1.7 dataset (the one which will has the imported data)
   a. mysql -u username -p password openmrs_1.7_database_name < db/adherence_calculation.sql
   b. mysql -u username -p password openmrs_1.7_database_name < db/recalculate_adherence.sql

6. On the same bart2 terminal run the following scripts
   a. script/runner script/recalculate_adherence.rb
   b. script/runner script/fix_program_locations.rb

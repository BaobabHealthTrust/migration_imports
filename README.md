git migration_imports

This application is used to migrated data from OpenMRS 1.1 to OpenMRS 1.7. The process of migrating data is categorized into two:
  1. Export data from OpenMRS 1.1 to the intermediary storage (flat tables).
  2. Import from the flat tables into OpenMRS 1.7

Getting started 

Steps on migrating data from OpenMRS 1.1 to OpenMRS 1.7
1. Make sure you have the OpenMRS 1.1 dataset.

2. Make sure you have an up-to-date bart1 application and edit the config/database.yml to point to OpenMRS 1.1 dataset you want to migrate.

3. Under bart1 terminal, type script/console then press enter and run the following:
  a) PersonAttribute.reset
     This is done inorder to get the updated reason for starting ART and  WHO stage for patients.

  b) PatientHistoricalOutcome.reset
    This is done inorder to get the updated patients' outcomes.

  c) PatientHistoricalRegimen.reset
  This is done inorder to get the updated regimen categories for patients.

4. Make sure that you have migration_imports application on your machine

5. Change database settings in config/database.yml of migration_imports application to your specifications as below:

    Under bart1: enter the details of your Source database (the dataset you want to export from. This is the OpenMRS 1.1 dataset.)

    Under development or production: enter the details of the intermediary database (the database that will hold the intermediary tables.
    For the sake of consistency the database name should be bart1_intermediate_bare_bones.
    
    Under bart2: enter the details of your destination database. (This is the OpenMRS 1.7)

6. Enter the command below to export data from OpenMRS1.1 into the intermediary storage
   ruby export_setup.sh development|production
   
   for example: assuming on step 5 above you have specified intermediary database under production:
   ruby export_setup.sh production 

7. There are two methods to import data. These methods are dependent on the size of the dataset and also the available resources (in terms of number of servers).
  a) Full procedure setup: with this method all patients are imported at once. This method is adpoted when the size of the dataset is small and also if there are limited resources.
    
    On migration_imports terminal type: ruby full_procedure_setup.sh site_code
    For example: ruby full_procedure_setup.sh mpc
    
  b) Partital procedure setup: with this method patients are imported in batches. One can specify the range which you want to import. This method should be used if and only if the dataset is huge and if there are several servers reserved for migration. 
     I. Enter the command below to setup the database and all the procedures:
       ruby partial_procedure_setup.sh site_code
       
       For example: ruby partial_procedure.sh mpc
       
     II. After setting up the database and the procedures enter the command below:
       ruby import_patients_in_batches lower_limit upper_limit
       
       Note: On lower_limit and upper_limit you have to specify the patient range. For example lower limit can be patient_id 1 and upper limit patient_id 20.
       
       For example: ruby import_patients_in_batched 1 10
    
    III. After importing all the data then run the following: 
       ruby migration_fixes_scripts/migration_fixes.sh
    
8. After successfully importing all the data, then switch to bart2 application and make sure it is up-to-date. 

9. Change the bart2 config/database.yaml to point to the OpenMRS 1.7 you specified on step 7 above. 

9. Under bart2 terminal load the following into OpenMRS 1.7 dataset (the one which will has the imported data). Remember to replace the username with the actual username of your MySQL, the password with also the actual password of your MySQL and finally openmrs_1.7_database_name with the actual database name you specified on step 7 above.

  a) mysql -uusername -ppassword openmrs_1.7_database_name < db/adherence_calculation.sql

  b) mysql -u username -p password openmrs_1.7_database_name < db/recalculate_adherence.sql

10. On the same bart2 terminal run the following scripts
  a) script/runner script/recalculate_adherence.rb
     This script recalculates the patients' adherence.
  b) script/runner script/fix_program_locations.rb
     This script fix patients' program locations.

10. Test the database by running bart2 application. Make sure your bart2 application is pointing to the migrated database.  Edit config/database.yml file.

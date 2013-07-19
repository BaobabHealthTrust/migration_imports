git migration_imports

This application is used to migrated data from OpenMRS 1.1 to OpenMRS 1.7. The process of migrating data is categorized into two:
  1. Export data from OpenMRS 1.1 to the intermediary storage (flat tables).
  2. Import from the flat tables into OpenMRS 1.7

Getting started 

Steps on migrating data from OpenMRS 1.1 to OpenMRS 1.7
1. Make sure you have the OpenMRS 1.1 dataset on your machine. 

2. Make sure you have an up-to-date bart1 application and edit the config/database.yml to point to OpenMRS 1.1 dataset you want to migrate.

3. Under bart1 script/console run the following:
  a) PersonAttribute.reset
     This is done inorder to get the updated reason for starting ART and  WHO stage for patients.

  b) PatientHistoricalOutcome.reset
    This is done inorder to get the updated patients' outcomes.

  c) PatientHistoricalRegimen.reset
  This is done inorder to get the updated regimen categories for patients.

4. Make sure that you have migration_imports application on your machine

5. Change database settings in config/database.yml of migration_imports application to your specifications as below:

    Under bart2: enter the details of your Source database (the dataset you want to export from. This is the OpenMRS 1.1 dataset.)

    Under development or production: enter the details of the intermediary database (the database that will hold the intermediary tables.
    For the sake of consistency the database name should be bart1_intermediate_bare_bones.

6. Enter the command below to export data from OpenMRS1.1 into the intermediary storage
   ruby export_setup.sh development|production
   
   for example: assuming on step 5 above you have specified intermediary database under production:
   ruby export_setup.sh production 

7. Enter the the command below to import data from intermediary storage into OpenMRS1.7
  b) ruby procedure_setup.rb openmrs1.7_database username password  site_code
  For example: ruby procedure_setup.rb bart2_database root admin mpc

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

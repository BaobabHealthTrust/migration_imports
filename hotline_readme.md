Hotline Migration

This application is used to migrate data from OpenMRS 1.4 database to OpenMRS 1.7 database.
The process of migratng this data is divided into three main phases.

These are:
1. Export data from OpenMRS1.4 database into the intermediary storage
2. Verify if the data is complete from the source database to the intermediary tables
3. Map and imporrt data from the intermediary tables into OpenMRS 1.9

***Please note that the migration process requires enough hard disk space,
   depending on how large the dataset one is migrating. For example, 2.3 GB dataset (dump)
   may require approximately 15 GB of free Hard Disk Space. This is vital when importing
   data from intermediate tables into OpenMRS version 1.9.
   Refer to Phase two of the migration process.***

***The Intermediary storage in this case will have several tables but the ones that are
   vital to Hotline are listed below***
   1. anc_visit_encounters
   2. baby_delivery_encounters
   3. birth_plan_encounters
   4. child_health_symptoms_encounters
   5. maternal_health_symptoms_encounters
   6. pregnancy_status_encounters
   7. registration_encounters
   8. tips_and_reminders_encounters
   9. update_outcomes_encounters
   10. users
   11. patients

   Getting started

   Phase One : Export to Intermediate Tables

   1. Make sure you have OpenMRS version 1.4 dataset.

   2. Clone migration_imports application if you don't have it.
      (Refer to How to clone migration_imports application section)

   3. If you already have migration_imports, then make sure it is up-to-date.

   4. Change database settings in config/database.yml of migration_imports application to your specifications as below.

   	- Under bart1: enter the details of your Source database (the dataset you want to export. This is the OpenMRS version 1.4 dataset)

   	- Under development or production: Use hotline_intermediate_bare_bones as the database name for this for consistency.

   	- Under bart2: enter the details of your destination database. (This is the OpenMRS version 1.9)

   5. Open the Console from migration_imports and enter the command below:
      (to create intermediary storage and export data from OpenMRS version 1.4 into the intermediary storage)

   		ruby hotline_export_setup.sh development|production

   	Note: development/production in the above command depends on the type of environment in which you are running the Migration_imports.
    For example: assuming in step 4 above, you specified intermediary database 	under production, the command will be as below;

   		ruby export_setup.sh production

   6. After successfully exporting all data from OpenMRS version 1.4 into the intermediary storage.
      Verify data completeness by running some queries on both OpenMRS version 1.4 dataset and intermediary storage tables.
      OpenMRS version 1.4 is the gold standard in this case.
      Run the following command;

       script/runner script/hotline_export_verifier.rb

   7. After running the queries and you are sure that the data is as expected,
      you are now ready to map and import data from the intermediary tables into OpenMRS version 1.9.

Phase Two: Import data From Intermediate Tables to Destination Database

  8. On migration_imports terminal, type the following command to map and import data:
       ruby full_hotline_procedure_setup.sh site_code

          Note: Site code in this case is the code for a particular site.
               Example is given below, and if not sure ask the helpdesk where to get the site code.

      		ruby full_procedure_setup.sh blk

Phase Three: Testing Migrated Data
  9. After successfully mapping and importing all data. Verify data completeness
     by running some queries on both OpenMRS version 1.9 dataset and intermediary storage tables.
     Run the following script to run the queries.

      script/runner script/import_verifier.rb

  10. Switch to Hotline application and make sure it is up-to-date.

  11. Change the Hotline config/database.yml to point to the OpenMRS version 1.9. This is the database which has the migrated data.

  12. Test the data by sampling some patients and comparing their records with old Hotline application. You could also run queries on
      these databases to verify the data

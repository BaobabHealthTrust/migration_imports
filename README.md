migration_imports application

Migration imports application is used to migrate data from OpenMRS version 1.1 database platform to OpenMRS 1.7. database platform. The process of migrating data is divided into three main categories.

These are:
1. Export data from OpenMRS version 1.1 into the intermediary storage (14 flat tables)
2. Map and import data from the intermediary tables into OpenMRS version 1.7
3. Run the after migration scripts.

Getting started 

Steps on migrating data from OpenMRS 1.1 to OpenMRS 1.7

Phase One : Export to Intermediate Tables

Bart 1 Data Preparation

1. Make sure you have OpenMRS version 1.1 dataset.

2. Make sure you have an up-to-date BART 1 application and edit the config/database.yml to point to OpenMRS version 1.1 dataset you want to migrate.

3. Open the Console from Bart 1, and run the following command;
	
	script/runner script/reset_views.rb
	
	The command above allows you  to reset the following; patient start dates,  	patient registration dates, patient adherence dates, patient adherence 	rates, patient prescription totals, patient whole tablets remaining and 	brought, patient historical outcomes, patient historical regimens, and person 	attribute. 


Setup of Intermediate Tables


1. Make sure that you have an up-to-date migration_imports application on your machine.

2. Change database settings in config/database.yml of migration_imports application to your specifications as below.

	Under bart1: enter the details of your Source database (the dataset you want to export. This is the OpenMRS version 1.1 dataset)

	Under development or production: Use bart1_intermediate_bare_bones as the database name for this for consistency.

	Under bart2: enter the details of your destination database. (This is the OpenMRS version 1.7)

3. Open the Console from migration_imports and enter the command below to create intermediary storage and export data from OpenMRS version 1.1 into the intermediary storage

		ruby export_setup.sh development|production

	Note: development/production in the above command depends on the type 	of environment in which you are running the Migration_imports. For 	example: assuming in step 5 above, you specified intermediary database 	under production, the command will be as below;

		ruby export_setup.sh production 

4. After successfully exporting all data from OpenMRS version 1.1 into the intermediary storage. Verify data completeness by running some queries on both OpenMRS version 1.1 dataset and intermediary storage tables. OpenMRS version 1.1 is the gold standard in this case. Run the following script to run the queries.
    
    script/runner script/export_verifier.rb

5. After running the queries and you are sure that the data is as you expected, you are now ready to map and import data from the intermediary tables into OpenMRS version 1.7.


Phase Two: Import of From Intermediate Tables to Destination Database

Importing of records can be done in two ways. The first is a complete importation of all patient records while the second is a partial importation of records. The partial importation transfers patients in a given range to the source database. The two approaches have different steps that are followed to accomplish them.

1. Complete Import
This method is also called the Full procedure setup. With this method, all patients with their associated encounters and observations are mapped and imported from the first patient to the last patients. This method is adopted when the size of the dataset is small and also if there are limited resources.

    On migration_imports terminal, type the following command to map and import data:

		ruby full_procedure_setup.sh site_code

    Note: Site code in this case is the code for a particular site. Example is given below;

		ruby full_procedure_setup.sh mpc

2. Partial Import
With this method  patients are mapped and  imported in batches. This method should be used if and only if the dataset is huge and if there are several servers reserved for the data migration process.

    2.1 On migration_imports terminal, type the following command to create the destination database and setup migration procedures:

 		ruby partial_procedure_setup.sh site_code

    	Please note that the site code in the above command, is as explained for complete import

    2.2 Enter the following command to import a batch of patients:

	    ruby import_patients_in_batches lower_limit upper_limit

        Note: On lower_limit and upper_limit you have to specify the patient range.For example lower limit can
              be patient_id 1   and upper limit patient_id 20. This will import all patients with id's between 1 and 20
              inclusive of the limits.


    2.3 When the above process is complete, and all the data has been migrated, please run the following command;

       		ruby migration_fixes_scripts/migration_fixes.sh


Phase Three: Testing Migrated Data

1. After successfully mapping and importing all data. Verify data completeness by running some queries on both OpenMRS version 1.7 dataset and intermediary storage tables. Run the following script to run the queries.
    
     script/runner script/import_verifier.rb

2. Switch to BART 2 application and make sure it is up-to-date. 

3. Change the BART 2 config/database.yml to point to the OpenMRS version 1.7. This is the database which has the migrated data.

4. Test the data by running sampling some patients and comparing their records with BART 1. You could also run queries on
   the 3 databases to verify the data

5. Can also test data by running cohort in both BART 1 and BART 2 and BART 1 cohort should be a gold standard in this case.


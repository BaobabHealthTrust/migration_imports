migration_imports application

Migration imports application is used to migrate data from OpenMRS version 1.1 database platform to OpenMRS 1.7. database platform. The process of migrating data is divided into three main categories.

These are:
1. Export data from OpenMRS version 1.1 into the intermediary storage (14 flat tables)
2. Map and import data from the intermediary tables into OpenMRS version 1.7
3. Run the after migration scripts.

Getting started 

Steps on migrating data from OpenMRS 1.1 to OpenMRS 1.7

1. Make sure you have OpenMRS version 1.1 dataset.

2. Make sure you have an up-to-date BART 1 application and edit the config/database.yml to point to OpenMRS version 1.1 dataset you want to migrate.

3. Open the Console from Bart 1, and run the following command;
	
	script/runner script/reset_views.rb
	
	The command above allows you  to reset the following; patient start dates,  	patient registration dates, patient adherence dates, patient adherence 	rates, patient prescription totals, patient whole tablets remaining and 	brought, patient historical outcomes, patient historical regimens, and person 	attribute. 

4. Make sure that you have an up-to-date migration_imports application on your machine.

5. Change database settings in config/database.yml of migration_imports application to your specifications as below.

	Under bart1: enter the details of your Source database (the dataset 	you want to export from. This is the OpenMRS version 1.1 dataset)

	Under development or production: enter the details of the 	intermediary database (the database that will hold the 	intermediary tables). For consistence sake use 	bart1_intermediate_bare_bones

	Under bart2: enter the details of your destination database. (This is 	the OpenMRS version 1.7)

6. Open the Console from migration_imports and enter the command below to export data from OpenMRS version 1.1 into the intermediary storage

		ruby export_setup.sh development|production

	Note: development/production in the above command depends on the type 	of environment in which you are running the Migration_imports. For 	example: assuming in step 5 above, you specified intermediary database 	under production, the command will be as below;

		ruby export_setup.sh production 

7. After successfully importing all data from OpenMRS version 1.1 into the intermediary storage. Verify data completeness by running some queries on both OpenMRS version 1.1 dataset and intermediary storage tables. OpenMRS version 1.1 is the gold standard in this case.

8. After running the queries and you are sure that the data is as you expected, you are now ready to map and import data from the intermediary tables into OpenMRS version 1.7.  There are two methods on how to map and import data. These are dependent on the size of the dataset and also the available resources (for example the number of servers set aside for migration). Below are the methods in detail.

8.1	First Method
This method is also called the Full procedure setup. With this method, all patients with their associated encounters and observations are mapped and imported from the first patient to the last patients. This method is adopted when the size of the dataset is small and also if there are limited resources.

    On migration_imports terminal, type the following command to map and import data:

		ruby full_procedure_setup.sh site_code

    Note: Site code in this case is the code for a particular site. Example is given below;

			ruby full_procedure_setup.sh mpc

8.1	Second Method
This method is also called the Partial procedure setup. With this method  patients are mapped and  imported 	in batches.  This method should be used if and only if the dataset is huge 	and if there are several servers reserved for the data migration process. 

On migration_imports terminal, type the following command to map and import data in batches. Please note that firstly, we have to create the destination database.  Enter the command below to setup the database and all the procedures:

 		ruby partial_procedure_setup.sh site_code

    for example: ruby partial_procedure.sh mpc
		Please note that the site code in the above command, is as in 8.1 			above

    After setting up the database and the procedures use the following command to start the process.

	  ruby import_patients_in_batches lower_limit upper_limit

Note: On lower_limit and upper_limit you have to specify the patient range. For example lower limit can be patient_id 1   and upper limit patient_id 20.

For example if you want to map and import the first 20 patients then enter the command below:
       
	ruby import_patients_in_batched 1 20

When the above process is complete, and all the data has been migrated, please run the following command; 

       		ruby migration_fixes_scripts/migration_fixes.sh

9. After successfully mapping and importing all data, then switch to BART 2 application and make sure it is up-to-date. 

10. Change the BART 2 config/database.yml to point to the OpenMRS version 1.7 you specified on step 5 above under bart2 section. This is the database which has the migrated data. 


11. Under BART 2 terminal type the following command to run all after 	migration scripts:
	
	script/runner script/run_all_after_migration_scripts.sh

12. Test the data by running some queries in both intermediary storage tables and also OpenMRS version 1.7. In this case the gold standard is the intermediary storage tables. 

13. Can also test data by running cohort in both BART 1 and BART 2 and BART 1 cohort should be a gold standard in this case. You can also choose at random some patients in both BART version 1 and 2 and compare their master-cards.

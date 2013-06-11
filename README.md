migration_imports

This application is used to import data from the intermediate tables into OpenMRS 1.7 database.

Getting started 

1. Make sure you have an up-to-date migration_imports application
2. In migration_imports terminal create database e.g mysqladmin -u username -p password create database_name; 
3. Run the procedure_setup.sh to initialize the database you have created above and load all the procedures then import data.
   type: ruby procedure_setup.sh database_name username password site_code
   for example ruby procedure_setup.sh test_database test testing mpc


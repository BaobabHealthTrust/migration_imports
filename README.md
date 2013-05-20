migration_imports

This application is used to import data from the intermediate tables into OpenMRS 1.7 database.

Getting started 

1. Create a database, initialize it using bart2 application.
2. Load into the database you have just created above the following
   - latest concepts
   - concept_name_map and drug_map
    
   - under bart2: enter the details of your Source database. (This is the database you want to export from. The OpenMRS 1.1 dataset).

2. Run rake db:create RAILS_ENV=['environment for execution'] eg  rake db:create RAILS_ENV='development' to create database to keep the exported data. This is the database which will hold 12/14 flat tables.

3. If database has been succesfully created, run rake db:migrate to create the tables and relations.

4. You can now run the migrator script in the script folder with script runner. ie script/runner script/migrator.rb

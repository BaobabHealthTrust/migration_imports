In migration_imports application do the following to migrate all give_drugs encounters that were missed during the initial migration.

Note: Make sure that bart1 database is the dump which was used during migration on 22/01/2014.
      Also make sure bart2 database is the migrated database.

1. git pull

2. Update config/database.yml under
      a.under production
         i. Enter bart1_intermediate_bare_bones as the database name
      
      b. under bart
         i. Enter the database name of bart1
  
      c. under bart2
         ii. Enter the database name of bart2

3. On the terminal type:
      a. ruby give_drugs_export_setup.sh production

4. On the terminal type:
      b. ruby importing_give_drugs_encounters_linked_to_orders_only.sh mpc

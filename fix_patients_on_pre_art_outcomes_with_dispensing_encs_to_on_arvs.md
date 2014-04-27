In migration_imports application do the following to revert the outcomes of those patients on 'Pre-ART' with dispensing encounters to 'On ARVs'.

Note: 1. Make sure that bart1_intermediate_bare_bones is the one which was used 
         during migration of give_drugs_encounters that were linked to orders.
         
      2. Also make sure bart2 database is the migrated database.
      3. Backup the bart2 database before this process.

1. git pull

2. Update config/database.yml under

      a. under bart2
         ii. Enter the database name of bart2

3. On the terminal type:
      a. script/runner script/all_after_migration_scripts/hiv_program_fix_for_patients_on_pre_art_but_have_disp_enc.rb

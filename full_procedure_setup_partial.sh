#!/bin/bash
usage(){
  echo "Usage: $0 SITE"
  echo
  echo "ENVIRONMENT should be: bart2"
  echo "Available SITES:"
  ls -1 db/data
} 

SITE=$1

if [ -z "$SITE" ] ; then
    usage
    exit
fi

set -x # turns on stacktrace mode which gives useful debug information

if [ ! -x config/database.yml ] ; then
  cp config/database.yml.example config/database.yml
fi

USERNAME=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['bart2']['username']"`
PASSWORD=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['bart2']['password']"`
DATABASE=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['bart2']['database']"`
HOST=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['bart2']['host']"`

now=$(date +"%F %T")
echo "start time : $now"

echo "loading import scripts.............................."

FILES=import_scripts/*.sql
for f in $FILES
do
	echo "loading $f..."
	mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < $f
done

echo "loading import scripts.............................."

FILES=import_scripts/partial_import_scripts/*.sql
for f in $FILES
do
	echo "loading $f..."
	mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < $f
done

echo "loading recalculating adherence scripts"
mysql --host=$HOST --user=$USERNAME --password=$PASSWORD $DATABASE < db/adherence_calculation.sql
mysql --host=$HOST --user=$USERNAME --password=$PASSWORD $DATABASE < db/recalculate_adherence.sql

#echo "importing data......................................."
#mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE<<EOFMYSQL
#CALL proc_import_patients_partial_llh;
#EOFMYSQL

#echo "creating dispensation, appointment and exit from HIV care encounters....."
#mysql --user=$USERNAME --password=$PASSWORD --host=$HOST $DATABASE<<EOFMYSQL
#CALL proc_import_from_temp;
#EOFMYSQL

echo "calculating adherence................................"

mysql --user=$USERNAME --password=$PASSWORD --host=$HOST $DATABASE<<EOFMYSQL
CALL proc_update_obs_order_id;
EOFMYSQL

echo "fixing retired drugs"
script/runner script/all_after_migration_scripts/fix_program_locations.rb

echo "fixing equivalent daily dose"
script/runner script/all_after_migration_scripts/fix_for_equivalent_daily_dose_llh.rb

echo "adding the hanging pills"
script/runner script/all_after_migration_scripts/include_hanging_pills_to_drug_orders_llh.rb

#echo "recalculating adherence"
#script/runner script/all_after_migration_scripts/recalculate_adherence.rb

echo "creating OPD program"
script/runner script/all_after_migration_scripts/creating_patient_opd_program.rb

echo "fixing earliest_start_date"
script/runner script/all_after_migration_scripts/fix_earliest_start_date.rb

echo "fixing arv numbers"
script/runner script/arv_format_fix.rb 

echo "fixing all patients on HIV program and on ARVs without any dispensing encounter"
script/runner script/all_after_migration_scripts/patients_on_hiv_prog_without_disp_enc_fix.rb 

echo "fixing all patients with Pre-ART state but are not on HIV program"
script/runner script/all_after_migration_scripts/pre_art_hiv_program_fix.rb

#echo "deleting temp_encounter and temp_obs tables..........."
#mysql --user=$USERNAME --password=$PASSWORD $DATABASE<<EOFMYSQL
#  DROP table temp_obs;
#  DROP table temp_encounter;
#EOFMYSQL

later=$(date +"%F %T")
echo "start time : $now"
echo "end time : $later"

echo "done"

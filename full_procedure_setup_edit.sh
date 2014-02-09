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

echo "fixing retired drugs"
script/runner script/all_after_migration_scripts/fix_program_locations.rb

echo "fixing equivalent daily dose"
script/runner script/all_after_migration_scripts/fix_for_equivalent_daily_dose.rb

echo "adding the hanging pills"
script/runner script/all_after_migration_scripts/include_hanging_pills_to_drug_orders.rb

echo "recalculating adherence"
script/runner script/all_after_migration_scripts/recalculate_adherence.rb

echo "creating OPD program"
script/runner script/all_after_migration_scripts/creating_patient_opd_program.rb

echo "fixing earliest_start_date"
script/runner script/all_after_migration_scripts/fix_earliest_start_date.rb

echo "fixing arv numbers"
script/runner script/arv_format_fix.rb 

echo "deleting temp_encounter and temp_obs tables..........."
mysql --user=$USERNAME --password=$PASSWORD $DATABASE<<EOFMYSQL
  DROP table temp_encounter;
  DROP table temp_obs;
EOFMYSQL

later=$(date +"%F %T")
echo "start time : $now"
echo "end time : $later"

echo "done"

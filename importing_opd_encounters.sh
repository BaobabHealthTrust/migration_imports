#!/bin/bash
usage(){
  echo "Usage"
  echo
  echo "ENVIRONMENT should be: bart2"
  echo "Available SITES:"
  ls -1 db/data
} 

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

echo "importing OPD data......................................."
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE<<EOFMYSQL
CALL proc_opd_encounters;
EOFMYSQL

echo "creating OPD program"
script/runner script/all_after_migration_scripts/creating_patient_opd_program.rb

later=$(date +"%F %T")
echo "start time : $now"
echo "end time : $later"

echo "done"

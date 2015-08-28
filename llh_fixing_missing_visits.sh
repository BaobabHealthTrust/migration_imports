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

FILES=script/all_after_migration_scripts/llh_fixes/llh_missing_visits_scripts/*.sql
for f in $FILES
do
	echo "loading $f..."
	mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < $f
done

FILES=import_scripts/*.sql
for f in $FILES
do
	echo "loading $f..."
	mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < $f
done

echo "Loading temporary tables"
mysql  --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/temporary_tables.sql

echo "Fixing Lighthouse missing visits"
script/runner script/all_after_migration_scripts/llh_fixes/llh_missing_visits_fix.rb

echo "creating dispensation, appointment and exit from HIV care encounters....."
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST $DATABASE<<EOFMYSQL
CALL proc_import_from_temp;
EOFMYSQL

later=$(date +"%F %T")
echo "start time : $now"
echo "end time : $later"

echo "done"

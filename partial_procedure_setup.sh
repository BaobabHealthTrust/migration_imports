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

echo "initializing $DATABASE (OpenMRS 1.7) destination database.............................."

echo "DROP DATABASE $DATABASE;" | mysql --user=$USERNAME --host=$HOST --password=$PASSWORD
echo "CREATE DATABASE $DATABASE;" | mysql --user=$USERNAME --host=$HOST --password=$PASSWORD
echo "loading concept_server_full_db"
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST $DATABASE < db/openmrs_1_7_2_concept_server_full_db.sql
echo "loading schema additions"
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST $DATABASE < db/schema_bart2_additions.sql
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST $DATABASE < db/bart2_views_schema_additions.sql
echo "loading defaults"
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST $DATABASE < db/defaults.sql
echo "loading user schema modifications"
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/malawi_regions.sql
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/mysql_functions.sql
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/drug_ingredient.sql
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/pharmacy.sql
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/national_id.sql
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/weight_for_heights.sql
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/data/${SITE}/${SITE}.sql
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/data/${SITE}/tasks.sql
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/moh_regimens_only.sql
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/retrospective_station_entries.sql
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/create_dde_server_connection.sql
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/migration_imports/create_weight_height_for_ages.sql
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/migration_imports/insert_weight_for_ages.sql
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/age_in_months.sql

echo "loading up-to-date concepts"
mysql  --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/openmrs_metadata_1_7.sql
mysql  --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < db/temporary_tables.sql

echo "loading import scripts.............................."

FILES=import_scripts/*.sql
for f in $FILES
do
	echo "loading $f..."
	mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < $f
done

echo "updating current_location_id"
script/runner script/current_location_id.rb

echo "importing users......................................"
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE<<EOFMYSQL
CALL proc_import_users;
EOFMYSQL

echo "fixing user with person_id 1........................."
script/runner script/fix_user_with_person_id1.rb


later=$(date +"%F %T")
echo "start time : $now"
echo "end time : $later"

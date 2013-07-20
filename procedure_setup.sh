#!/bin/bash

usage(){
    echo "Usage: $0 DATABASE USERNAME PASSWORD SITE"
    echo
    echo "Available SITES:"
    ls -1 db/data
}

DATABASE=$1
USERNAME=$2
PASSWORD=$3
SITE=$4

if [ -z "$DATABASE" ] || [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$SITE" ] ; then
    usage
    exit
fi
now=$(date +"%T")
echo "start time : $now"

echo "initializing $DATABASE (OpenMRS 1.7) destination database.............................."

echo "DROP DATABASE $DATABASE;" | mysql --user=$USERNAME --password=$PASSWORD
echo "CREATE DATABASE $DATABASE;" | mysql --user=$USERNAME --password=$PASSWORD
echo "loading concept_server_full_db"
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/openmrs_1_7_2_concept_server_full_db.sql
echo "loading schema additions"
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/schema_bart2_additions.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/bart2_views_schema_additions.sql
echo "loading defaults"
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/defaults.sql
echo "loading user schema modifications"
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/malawi_regions.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/mysql_functions.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/drug_ingredient.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/pharmacy.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/national_id.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/weight_for_heights.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/data/${SITE}/${SITE}.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/data/${SITE}/tasks.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/moh_regimens_only.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/retrospective_station_entries.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/create_dde_server_connection.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/migration_imports/create_weight_height_for_ages.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/migration_imports/insert_weight_for_ages.sql

echo "loading up-to-date concepts"
mysql  --user=$USERNAME --password=$PASSWORD $DATABASE < db/openmrs_metadata_1_7.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/temporary_tables.sql
#FILES=schema/*.sql
#for f in $FILES
#do
#	echo "Installing $f..."
#	mysql --user=$USERNAME --password=$PASSWORD $DATABASE < $f
#done

#FILES=triggers/*.sql
#for f in $FILES
#do
#	echo "Installing $f..."
#	mysql --user=$USERNAME --password=$PASSWORD $DATABASE < $f
#done

#FILES=procedures/*.sql
#for f in $FILES
#do
#	echo "Installing $f..."
#	mysql --user=$USERNAME --password=$PASSWORD $DATABASE < $f
#done

#FILES=procedures/sub-procedures/inserts/*.sql
#for f in $FILES
#do
#	echo "Installing $f..."
#	mysql --user=$USERNAME --password=$PASSWORD $DATABASE < $f
#done

#FILES=procedures/sub-procedures/updates/*.sql
#for f in $FILES
#do
#	echo "Installing $f..."
#	mysql --user=$USERNAME --password=$PASSWORD $DATABASE < $f
#done

echo "loading import scripts.............................."

FILES=import_scripts/*.sql
for f in $FILES
do
	echo "loading $f..."
	mysql --user=$USERNAME --password=$PASSWORD $DATABASE < $f
done

echo "importing users......................................"
mysql --user=$USERNAME --password=$PASSWORD $DATABASE<<EOFMYSQL
CALL proc_import_users;
EOFMYSQL

echo "importing data......................................."
mysql --user=$USERNAME --password=$PASSWORD $DATABASE<<EOFMYSQL
CALL proc_import_patients;
EOFMYSQL


echo "creating dispensation and appointment encounters......................................."
mysql --user=$USERNAME --password=$PASSWORD $DATABASE<<EOFMYSQL
CALL proc_import_from_temp;
EOFMYSQL

echo "calculating adherence................................"

mysql --user=$USERNAME --password=$PASSWORD $DATABASE<<EOFMYSQL
CALL proc_update_obs_order_id;
EOFMYSQL

later=$(date +"%T")
echo "start time : $now"
echo "end time : $later"

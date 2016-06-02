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

FILES=import_scripts/hotline_imports_scripts/*.sql
for f in $FILES
do
	echo "loading $f..."
	mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE < $f
done

echo "loading hotline_1_7 database.............."
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE< db/new_dump.sql

mysql --user=$USERNAME --password=$PASSWORD --host=$HOST --skip-column-names $DATABASE -e 'SHOW TRIGGERS;' | cut -f1 | sed -r 's/(.*)/DROP TRIGGER IF EXISTS \1;/' | mysql --user=$USERNAME --password=$PASSWORD --host=$HOST $DATABASE

#echo "importing users......................................"
#mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE<<EOFMYSQL
#CALL proc_import_users;
#EOFMYSQL

#echo "fixing user with person_id 1........................."
#script/runner script/fix_user_with_person_id1.rb

echo "importing data......................................."
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE<<EOFMYSQL
CALL proc_import_patients;
EOFMYSQL

later=$(date +"%F %T")
echo "start time : $now"
echo "end time : $later"

echo "done"

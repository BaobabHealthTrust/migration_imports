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

echo "Add new patient demographics....."
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST $DATABASE<<EOFMYSQL
CALL proc_import_patient_demographics;
EOFMYSQL

later=$(date +"%F %T")
echo "start time : $now"
echo "end time : $later"

echo "done"

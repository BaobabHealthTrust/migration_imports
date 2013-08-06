#!/bin/bash
usage(){
  echo "Usage:"
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


now=$(date +"%T")
echo "start time : $now"

echo "creating dispensation, appointment and exit from HIV care encounters....."
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST $DATABASE<<EOFMYSQL
CALL proc_import_from_temp;
EOFMYSQL

echo "calculating adherence................................"

mysql --user=$USERNAME --password=$PASSWORD --host=$HOST $DATABASE<<EOFMYSQL
CALL proc_update_obs_order_id;
EOFMYSQL

echo "deleting temp_encounter and temp_obs tables..........."

mysql --user=$USERNAME --password=$PASSWORD --host=$HOST  $DATABASE<<EOFMYSQL
DROP table temp_encounter;
DROP table temp_obs;
EOFMYSQL

later=$(date +"%T")
echo "start time : $now"
echo "end time : $later"

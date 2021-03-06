#!/bin/bash
usage(){
  echo "Usage: $0 LOWER_LIMIT UPPER_LIMIT"
  echo
  echo "ENVIRONMENT should be: bart2"
} 

LOWER_LIMIT=$1
UPPER_LIMIT=$2

if  [ -z "$LOWER_LIMIT" ] || [ -z "$UPPER_LIMIT" ]; then
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

echo "importing data......................................."
mysql --user=$USERNAME --password=$PASSWORD --host=$HOST $DATABASE<<EOFMYSQL
CALL proc_import_patients_in_batches($LOWER_LIMIT,$UPPER_LIMIT);
EOFMYSQL

later=$(date +"%F %T")
echo "start time : $now"
echo "end time : $later"

#!/bin/bash
usage(){
  echo "Usage: $0 ENVIRONMENT"
  echo
  echo "ENVIRONMENT should be: development|production"
} 

ENV=$1
ENV_bart2=bart2

if [ -z "$ENV" ] ; then
  usage
  exit
fi

set -x # turns on stacktrace mode which gives useful debug information

if [ ! -x config/database.yml ] ; then
  cp config/database.yml.example config/database.yml
fi

USERNAME=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['${ENV}']['username']"`
PASSWORD=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['${ENV}']['password']"`
DATABASE=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['${ENV}']['database']"`
HOST=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['${ENV}']['host']"`

BART2_USERNAME=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['bart2']['username']"`
BART2_PASSWORD=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['bart2']['password']"`
BART2_DATABASE=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['bart2']['database']"`
BART2_HOST=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['bart2']['host']"`

now=$(date +"%T")
echo "start time : $now"

echo "Creating intermediary storage"
 rake db:create
 rake db:migrate

echo "Exporting to the intermediary storage"
 script/runner script/encounter_exporter.rb

echo "Importing ART visit and HIV staging encounters"
mysql  --user=$BART2_USERNAME --password=$BART2_PASSWORD --host=$BART2_HOST  $BART2_DATABASE < import_scripts/import_art_and_hiv_staging_area_25_encounters.sql
mysql  --user=$BART2_USERNAME --password=$BART2_PASSWORD --host=$BART2_HOST  $BART2_DATABASE < import_scripts/import_art_visit_encounters.sql
mysql  --user=$BART2_USERNAME --password=$BART2_PASSWORD --host=$BART2_HOST  $BART2_DATABASE < import_scripts/import_hiv_staging_encounters.sql

mysql --user=$BART2_USERNAME --password=$BART2_PASSWORD --host=$BART2_HOST $BART2_DATABASE<<EOFMYSQL
CALL proc_import_area_25_art_and_hiv_staging;
EOFMYSQL

later=$(date +"%T")
echo "start time : $now"
echo "end time : $later"

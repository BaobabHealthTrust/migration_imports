#!/bin/bash
usage(){
  echo "Usage: $0 ENVIRONMENT"
  echo
  echo "ENVIRONMENT should be: development|production"
}

ENV=$1

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

now=$(date +"%F %T")
echo "start time : $now"
echo "Creating intermediary storage"
 rake db:drop
 rake db:create
 mysql --host=$HOST --user=$USERNAME --password=$PASSWORD $DATABASE < db/hotline_intermediate_tables.sql


 rake db:migrate

echo "Exporting to the intermediary storage"
 script/runner script/hotline_migrator.rb

later=$(date +"%F %T")
echo "start time : $now"
echo "end time : $later"

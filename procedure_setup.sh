#!/bin/bash

usage(){
    echo "Usage: $0 DATABASE USERNAME PASSWORD"
    echo
}

DB=$1
USER=$2
PASS=$3

if [ -z "$DB" ] || [ -z "$USER" ] || [ -z "$PASS" ] ; then
    usage
    exit
fi

FILES=import_scripts/*.sql
for f in $FILES
do
	echo "Installing $f..."
	mysql --user=$USER --password=$PASS $DB < $f
done


mysql --user=$USER --password=$PASS $DB<<EOFMYSQL
CALL proc_import_patients;
EOFMYSQL

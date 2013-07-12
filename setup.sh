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

FILES=schema/*.sql
for f in $FILES
do
	echo "Installing $f..."
	mysql --user=$USER --password=$PASS $DB < $f
done

FILES=triggers/*.sql
for f in $FILES
do
	echo "Installing $f..."
	mysql --user=$USER --password=$PASS $DB < $f
done

FILES=procedures/*.sql
for f in $FILES
do
	echo "Installing $f..."
	mysql --user=$USER --password=$PASS $DB < $f
done

FILES=procedures/sub-procedures/inserts/*.sql
for f in $FILES
do
	echo "Installing $f..."
	mysql --user=$USER --password=$PASS $DB < $f
done

FILES=procedures/sub-procedures/updates/*.sql
for f in $FILES
do
	echo "Installing $f..."
	mysql --user=$USER --password=$PASS $DB < $f
done

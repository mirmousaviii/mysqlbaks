#!/bin/sh
 
# mysqlbaks V0.1 <https://github.com/hydrogenws/mysqlbaks>
# mysqlbaks is shell script for backup from MySQL.
# Copyright (C) 2011 Free Software Foundation, Inc.
# License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.
# Written by Mostafa Mirmousavi <http://hydrogenws.com> <mirmousavi.m@gmail.com>


#----------------------Config--------------------#

# Server's name
SERVER="Hydrogen Web Solutions"

# Backup directory
BACKDIR=/home/server/backups/sql/

# Temp directory
TEMPDIR=/home/server/backups/sql/temp

# Date format filename's
#DATE=`date +'%m-%d-%Y-%H%M'`
DATENAME=`date +'%y-%m-%d__%H-%M-%S__%N'`

# Date format log's
DATELOG=`date +'%Y-%m-%d %H:%M:%S'`


# MySQL server
HOST=localhost

# MySQL username
USER=backup

# MySQL password
PASS=backup@password



# List all of the MySQL databases that you want to backup, separated by a space
# set to 'ALL' if you want to backup all your databases
DBS="smbind proftpd"


#------------------------------------------------#


echo "========================================================="
echo "Server: "$SERVER
echo "Date:   "$DATELOG
echo "---------------------------------------------------------"

# check of the backup directory exists
# if not, create it
if  [ ! -d $BACKDIR ]; then
	echo -n "Creating $BACKDIR: "
	mkdir -p $BACKDIR
	echo "Done"
fi

# check of the temp directory exists
# if not, create it
if  [ ! -d $TEMPDIR ]; then
	echo -n "Creating $TEMPDIR: "
	mkdir -p $TEMPDIR
	echo "Done"
fi




if  [ $DBS = "ALL" ]; then
	echo -n "Creating list of all your databases: "
	DBS=`mysql -h $HOST --user=$USER --password=$PASS -Bse "show databases;"`
	echo "Done"
fi



echo "Backing up MySQL databases... "
for database in $DBS
do
	echo -n "Database $database: "
	mysqldump -h $HOST -u$USER -p$PASS --opt $database > $TEMPDIR/$database.sql
	echo "Done"
done

echo "Make tgz: "
cd $TEMPDIR
tar -zcvf $BACKDIR/backup_mysql_$DATENAME.tgz *.sql
echo "Done"

rm $TEMPDIR/*.sql

echo "Backup successful";

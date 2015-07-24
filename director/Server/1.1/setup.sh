#!/bin/bash

echo "Welcome to SRVMON!"
echo "The following script will install the DIRECTOR SERVER version 1.0 on your system."
echo ""
read -r -p "Would you like to continue? [y/N] " response

case $response in
	[nN][oO]|[nN])
		echo "Exitting..."
		exit 0
	;;
esac

#read -r -p "Would you like to compare the checksums of the source files? [y/N] " response

#case $response in
#	[yY][eE][sS]|[yY])
#		echo "Retrieving checksums from the package maintainers site..."
#		wget http://srv04.scrubstudios.de/srvmon/checksums/director/server/checksums.tgz
#		tar xzvf checksums.tgz
#		echo "Checking files ..."
#		
#		SUMS=checksums/*
#
#		for SUM in $SUMS
#		do
#			sha1sum -c $SUM
#
#			if [ $? -eq 1 ]
#			then
#				echo "File integrity check has failed for $SUM!"
#				exit 1
#			fi
#		done
#
#		rm -rf checksums*
#	;;
#esac
echo ""

echo "We're now going to set up the configuration file for the server."
echo "Please have the following values ready:"
echo " -SQL server hostname"
echo " -SQL server username"
echo " -SQL server password"
echo " -SQL server database name"
echo " -Director encryption key"
echo ""

read -r -p "Would you like to continue? [y/N] " response

case $response in
	[nN][oO]|[nN])
		echo "Exitting..."
		exit 0
	;;
esac

read -r -p "SQL server hostname: " dbhostname
read -r -p "SQL server username: " dbusername
read -r -p "SQL server password: " dbpassword
read -r -p "SQL server database name: " dbname
read -r -p "Director encryption key: " enckey

echo "Writing init.php..."

sed -i 's/CHANGE-ME-1/'$dbhostname'/g' src/inc/init.php
sed -i 's/CHANGE-ME-2/'$dbusername'/g' src/inc/init.php
sed -i 's/CHANGE-ME-3/'$dbpassword'/g' src/inc/init.php
sed -i 's/CHANGE-ME-4/'$dbname'/g' src/inc/init.php
sed -i 's/CHANGE-ME-5/'$enckey'/g' src/inc/init.php

echo "Changes written!"
echo ""

echo "The files are ready to be copied to the web root."

read -r -p "Please enter the full path of the web root: " response

rsync -azP src/* $response

echo ""

if [ $? -eq 0 ]
then
	echo "You can delete this script now."
	echo "The setup is finished!"
	exit 0
else
	echo "Unable to copy files!"
	exit 1
fi

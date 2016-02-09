#!/bin/bash

echo "Welcome to the SRVMON Director installation script!"
echo "The following script will guide you through the installation of the Directror Server version 2.0 A1 on your system."
echo ""
read -r -p "Would you like to continue? [y/n]" response

case $response in
	[nN][oO]|[nN])
		echo "Exitting..."
		exit 0
	;;
esac

echo ""

echo "We're now going to set up the configuration file for the server."
echo "Please have the following values ready:"
echo " -SQL server hostname"
echo " -SQL server username"
echo " -SQL server password"
echo " -SQL server database name"
echo ""

read -r -p "Would you like to continue? [y/n]"

case $response in
	[nN][oO]|[nN])
		echo "Exitting..."
		exit 0
	;;
esac

read -r -p "SQL server hostname: " dbhostname
read -r -p "SQL server username: " dbusername
read -r -p "SQL server password: " dbpassword
read -r -p "SQL server database name : " dbname

echo "Wrinting to init.php..."

sed -i 's/CHANGE-ME-1/'$dbhostname'/g' src/inc/init.php
sed -i 's/CHANGE-ME-2/'$dbusername'/g' src/inc/init.php
sed -i 's/CHANGE-ME-3/'$dbpassword'/g' src/inc/init.php
sed -i 's/CHANGE-ME-4/'$dbname'/g' src/inc/init.php

echo "Changes written."
echo ""

echo "The files are now ready to be copied to the web root."

read -r -p "Please enter a valid path for the web root: " response

rsync -azP src/. $response

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
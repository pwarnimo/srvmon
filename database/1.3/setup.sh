#!/bin/bash

echo "Welcome to SRVMON!"
echo "The following script will install the datebase for the SRVMON project on your system."
echo ""
read -r -p "Would you like to continue? [y/N] " response

case $response in
	[nN][oO]|[nN])
		echo "Exitting..."
		exit 0
		;;
esac

echo "Please specify the appropriate values for your database server."
echo "Please have the following values ready:"
echo " -SQL server username"
echo " -SQL server password"
echo " -SQL server database name"
echo ""

read -r -p "Would you like to continue? [y/N] " response

case $response in
	[nN][oO]|[nN])
		echo "Exitting..."
		exit 0
		;;
esac

read -r -p "SQL server username: " dbusername
read -r -p "SQL server password: " dbpassword
read -r -p "SQL server database name: " dbname

sed -i 's/CHANGE-ME-1/'$dbusername'/g' tools/loadroutines.sh
sed -i 's/CHANGE-ME-2/'$dbpassword'/g' tools/loadroutines.sh
sed -i 's/CHANGE-ME-3/'$dbname'/g' tools/loadroutines.sh

echo "Changes written!"
echo ""

echo "I will now begin to copy the database..."

mysql -u$dbusername -p$dbpassword $dbname < sql/db/srvmon-1.3-1.sql
mysql -u$dbusername -p$dbpassword $dbname < sql/dump/srvmon-data-1.3.sql

tools/loadroutines.sh

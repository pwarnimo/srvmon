#!/bin/bash
#
# loadroutines.sh - A script which loads all routines into the DB.
# Copyright (C) 2015  Pol Warnimont
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

SQLUSR="srvmonusr"
SQLPW="q1w2e3!"
DBNAME="srvmon"

echo "Loading all stored routines into DB . . ."

FILES=sql/stored-procedures/servermgmt/*.sql

echo "PROCESSING SERVER ROUTINES"
echo "--------------------------"
for f in $FILES
do
  echo -n "> Parsing $f ..."
  mysql -u$SQLUSR -p$SQLPW $DBNAME < $f
  if [ $? -eq 0 ]
  then
    echo "Ok."
  else
    echo "Failed!"
    exit 1
  fi
done
echo ""

FILES=sql/stored-procedures/servicemgmt/*.sql

echo "PROCESSING SERVICE ROUTINES"
echo "---------------------------"
for f in $FILES
do
  echo -n "> Parsing $f ..."
  mysql -u$SQLUSR -p$SQLPW $DBNAME < $f
  if [ $? -eq 0 ]
  then
    echo "Ok."
  else
    echo "Failed!"
    exit 1
  fi
done
echo ""

FILES=sql/stored-procedures/settingsmgmt/*.sql

echo "PROCESSING SETTING ROUTINES"
echo "---------------------------"
for f in $FILES
do
  echo -n "> Parsing $f ..."
  mysql -u$SQLUSR -p$SQLPW $DBNAME < $f
  if [ $? -eq 0 ]
  then
    echo "Ok."
  else
    echo "Failed!"
    exit 1
  fi
done
echo ""

FILES=sql/stored-procedures/usermgmt/*.sql

echo "PROCESSING USER ROUTINES"
echo "------------------------"
for f in $FILES
do
  echo -n "> Parsing $f ..."
  mysql -u$SQLUSR -p$SQLPW $DBNAME < $f
  if [ $? -eq 0 ]
  then
    echo "Ok."
  else
    echo "Failed!"
    exit 1
  fi
done
echo ""
echo "*** ALL ROUTINES LOADED ***"
echo ""

exit 0

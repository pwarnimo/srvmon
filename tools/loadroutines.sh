#!/bin/bash

SQLUSR=""
SQLPW=""

echo "Loading all stored routines into DB . . ."

cd /home/pwarnimo/Documents/SRVMON/database/sql/stored-procedures

FILES=servermgmt/*.sql

echo "PROCESSING SERVER ROUTINES"
echo "--------------------------"
for f in $FILES
do
  echo -n "> Parsing $f ..."
  mysql -u$SQLUSR -p$SQLPW srvmon < $f
  if [ $? -eq 0 ]
  then
    echo "Ok."
  else
    echo "Failed!"
    exit 1
  fi
done
echo ""

FILES=servicemgmt/*.sql

echo "PROCESSING SERVICE ROUTINES"
echo "---------------------------"
for f in $FILES
do
  echo -n "> Parsing $f ..."
  mysql -u$SQLUSR -p$SQLPW srvmon < $f
  if [ $? -eq 0 ]
  then
    echo "Ok."
  else
    echo "Failed!"
    exit 1
  fi
done
echo ""

FILES=settingsmgmt/*.sql

echo "PROCESSING SETTING ROUTINES"
echo "---------------------------"
for f in $FILES
do
  echo -n "> Parsing $f ..."
  mysql -u$SQLUSR -p$SQLPW srvmon < $f
  if [ $? -eq 0 ]
  then
    echo "Ok."
  else
    echo "Failed!"
    exit 1
  fi
done
echo ""

FILES=usermgmt/*.sql

echo "PROCESSING USER ROUTINES"
echo "------------------------"
for f in $FILES
do
  echo -n "> Parsing $f ..."
  mysql -u$SQLUSR -p$SQLPW srvmon < $f
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

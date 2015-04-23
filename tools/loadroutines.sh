#!/bin/bash
#
# License information
# -------------------
#  Copyright (C) 2015  Pol Warnimont
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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

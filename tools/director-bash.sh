#!/bin/bash
#
# Script      : director-bash.sh
# Author(s)   : Pol Warnimont
# Create date : 2015-04-24
# Version     : 0.1
#
# Description : A simple director script for the SRVMON monitoring suite.
#
# Changelog
# ---------
#  2015-04-24 : Created script.
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

USER=""
PASS=""
DB=""

TMPFILE=/tmp/srvmon[$$]

logger -t srvmon[$$] "SRVMON DIRECTOR STARTED."
echo "SRVMON DIRECTOR SCRIPT 0.1"
echo "> Getting all hosts..."

while read line
do
  echo $line >> $TMPFILE
done < <(mysql --skip-column-names -u${USER} -p${PASS} ${DB} -e "SELECT idServer,dtHostname,dtIPAddress,dtEnabled FROM tblServer")

echo "> OK."
echo "> Beginning with checks . . ."

while read id hostname ipaddress enabled
do
  echo -n "> Checking $hostname($ipaddress)... "
  ping -c4 $ipaddress > /dev/null 2>&1

  if [ $? -eq 0 ]
  then
    echo "ONLINE!"
    mysql -u${USER} -p${PASS} ${DB} -e "CALL setSystemStatus(${id},TRUE,@err)"
  else
    echo "OFFLINE!"
    mysql -u${USER} -p${PASS} ${DB} -e "CALL setSystemStatus(${id},FALSE,@err)"
    echo "> Settings children offline."
    mysql -u${USER} -p${PASS} ${DB} -e "CALL disableChildrenChecks(${id},@err)"
  fi
done < $TMPFILE

#rm $TMPFILE

echo "> DIRECTOR FINISHED!"
logger -t srvmon[$$] "DIRECTOR FINISHED"

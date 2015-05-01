#!/bin/bash
#
# Script      : director-bash.sh
# Author(s)   : Pol Warnimont
# Create date : 2015-04-24
# Version     : 0.9
#
# Description : A simple director script for the SRVMON monitoring suite.
#
# Changelog
# ---------
#  2015-04-24 : Created script.
#  2015-04-30 : Changed license to AGPLv3.
#
# License information
# -------------------
#  Copyright (C) 2015  Pol Warnimont
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

USER="sqlusr"
PASS="q1w2e3!"
DB="srvmon"

TMPFILE=/tmp/srvmon[$$]

function showVersion {
  echo "SRVMON DIRECTOR (director-bash.sh) VERSION 0.9 (C) 2015 Pol Warnimont"
  echo "SRVMON DIRECTOR comes with ABSOLUTELY NO WARRANTY; for details"
  echo "type 'show w'. This is free software, and you are welcome"
  echo "to redistribute it under certain conditions; type 'show c'"
  echo "for details."
}

if [ $1 == "-v" ]
then
  showVersion
  exit 0
fi

showVersion

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

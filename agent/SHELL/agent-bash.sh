#!/bin/bash
#
# Script      : agent-bash.sh
# Author(s)   : Pol Warnimont
# Create date : 2015-04-24
# Version     : 0.9
#
# Description : A service checks scheduler script
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

USER=""
PASS=""
DB=""
DBHOST=""
HOSTNAME=`hostname -s`

BRED="\e[1;31m"
BGREEN="\e[1;32m"
BYELLOW="\e[1;33m"
BCYAN="\e[1;36m"
COFF="\e[0m"

SERVICES=/tmp/srvmon.services.$$

function cleanUp {
  echo "Cleaning up..."
  rm $SERVICES > /dev/null 2>&1
}

function showVersion {
  echo "SRVMON AGENT (agent-bash.sh) VERSION 0.9 (C) 2015 Pol Warnimont"
  echo "SRVMON AGENT comes with ABSOLUTELY NO WARRANTY; for details"
  echo "type 'show w'. This is free software, and you are welcome"
  echo "to redistribute it under certain conditions; type 'show c'"
  echo "for details."
}

if [ $1 == "-v" ]
then
  showVersion
  exit 0
fi

logger -t srvmonagent[$$] "Agent has started."
echo "Agent [$$] has started."
echo "Fetching server ID from database . . ."

SRVID=$(mysql $DB -u$USER -p$PASS --skip-column-names -h $DBHOST<<<"SELECT getServerID('$HOSTNAME')")

showVersion

case $SRVID in
  "-3")
    echo "Database error!"
    ;;

  "-4")
    echo "Database warning!"
    ;;

  "-5")
    echo "Server $HOSTNAME not found in database!"
    ;;
  *)
    echo -e "This server ($HOSTNAME) has the ID : ${BGREEN}$SRVID${COFF}"
    echo "Retrieving service list . . ."

    while read line
    do
      echo $line >> $SERVICES
    done < <(mysql --skip-column-names -u${USER} -p${PASS} -h${DBHOST} ${DB} -e "CALL getServicesForServer(${SRVID},-1,1,@err)")

    while read SVCID SVCCMD
    do
      echo -e "Executing check $SVCID (${BCYAN}$SVCCMD${COFF})..."
      RAW=`/usr/lib/srvmon/plugins/$SVCCMD`
      EXCODE=`echo $RAW | cut -d";" -f1`
      OUTPUT=`echo $RAW | cut -d";" -f2`

      case $EXCODE in
        "0")
	  echo -e "> Check output is: ${BGREEN}$OUTPUT ($EXCODE)${COFF}."
	  ;;

	"1")
	  echo -e "> Check output is: ${BYELLOW}$OUTPUT ($EXCODE)${COFF}."
	  ;;

	"2")
	  echo -e "> Check output is: ${BRED}$OUTPUT ($EXCODE)${COFF}."
	  ;;
      esac

      echo -n "Updating service values for check ID=$SVCID..."
      mysql -u${USER} -p${PASS} -h${DBHOST} -D${DB} -e "CALL updateServerServiceStatus(${SRVID},${SVCID},${EXCODE},'${OUTPUT}',@err)"
      echo "OK."
    done < $SERVICES
    
    ;;
esac

cleanUp

echo "Ok."

exit 0

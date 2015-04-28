#!/bin/bash

USER=""
PASS=""
DB=""
HOSTNAME=`hostname`

BRED="\e[1;31m"
BGREEN="\e[1;32m"
BYELLOW="\e[1;33m"
BCYAN="\e[1;36m"
COFF="\e[0m"

SERVICES=/tmp/srvmon.services.$$

logger -t srvmonagent[$$] "Agent has started."
echo "Agent [$$] has started."
echo "Fetching server ID from database . . ."

SRVID=$(mysql $DB -u$USER -p$PASS --skip-column-names<<<"SELECT getServerID('$HOSTNAME')")

function cleanUp {
  echo "Cleaning up..."
  rm $SERVICES > /dev/null 2>&1
}

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
    done < <(mysql --skip-column-names -u${USER} -p${PASS} ${DB} -e "CALL getServicesForServer(${SRVID},-1,1,@err)")

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
      mysql -u${USER} -p${PASS} -D${DB} -e "CALL updateServerServiceStatus(${SRVID},${SVCID},${EXCODE},'${OUTPUT}',@err)"
      echo "OK."
    done < $SERVICES
    
    ;;
esac

cleanUp

echo "Ok."

exit 0

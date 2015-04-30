#!/bin/bash
#
# Script      : srvmon-config.sh
# Author(s)   : Pol Warnimont
# Create date : 2015-04-29
# Version     : 0.1
#
# Description : A SRVMON configuration script.
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

function printVersion {
  echo "SRVMON CONFIGURATOR VERSION 0.1 (C) 2015 Pol Warnimont"
  echo "SRVMON CONFIGURATOR comes with ABSOLUTELY NO WARRANTY!"
}

function printHelp {
  echo ""
  echo "Usage ./srvmon-config.sh [OPTIONS...]"
  echo ""
  echo "Parameter list"
  echo "  -g GUI : Chose user interface"
  echo "             diag  = Graphical Console UI (Requires DIALOG)"
  echo "             graph = GTK UI (Requires ZENITY)"
  echo "             text  = Text UI"
  echo "  -v     : Shows the version of this script"
  echo "  -h     : Shows this help"
  echo ""
}

TITLE="SRVMON CONFIGURATOR 0.1"

function clearTmpFiles {
  rm -r /tmp/*.$$ > /dev/null 2>&1
}

function waitForKey {
  read -p "Press any key to continue..." -n1 -s
}

# -(BEGIN : UI = DIAG)---------------------------------------------------

function showDialog {
  case $1 in
    0) DLGTYPE="Information" ;;
    1) DLGTYPE="Warning" ;;
    2) DLGTYPE="Question" ;;
  esac

  dialog --clear --backtitle "$TITLE" --title "$DLGTYPE" --msgbox "$2" 6 70
}

function mainMenu {
  dialog --clear --backtitle "$TITLE" --title "Main Menu" --menu "Use [UP/DOWN] keys to move" 16 60 10 \
    "DEVMGMT" "Manage monitored devices" \
    "USRMGMT" "Manage users for web UI" \
    "SVCMGMT" "Manage service checks" \
    "GENMGMT" "Manage general settings" \
    "EXITMNU" "Return to shell" 2> /tmp/mm.$$

  RET=$?
  CHOICE=`cat /tmp/mm.$$`

  if [ $RET -eq 0 ]
  then
    case $CHOICE in
      DEVMGMT) echo "1" ;;
      USRMGMT) echo "2" ;;
      SVCMGMT) echo "3" ;;
      GENMGMT) echo "4" ;;
      EXITMNU) clear; exit 0 ;;
    esac
  else
    clear
    exit
  fi
}

# -(END : UI = DIAG)-----------------------------------------------------

trap "clearTmpFiles" EXIT

if [ $# -gt 0 ]
then
  case $1 in
    "-g")
        case $2 in
          "diag")
	    while :
	    do
              mainMenu
	    done

	    ;;

          *)
            echo "Invalid UI selected!"
            
            ;;
	esac
      ;;

    "-v")
      printVersion
      ;;

    "-h")
      printHelp
      ;;

    *)
      echo "srvmon-config.sh: Invalid option -- '$*'"
      echo "Try srvmon-config.sh -h for more information."
      ;;
  esac
else
  printVersion
  printHelp
fi

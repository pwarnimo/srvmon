#!/bin/bash
#
# Script      : setup.sh
# Author(s)   : Pol Warnimont
# Create date : 2015-04-28
# Version     : 0.1
#
# Description : A setup script for the SRVMON monitoring suite
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

clear

echo "Welcome to the SRVMON monitoring suite!"
echo "This script will help you to setup SRVMON on your system"
echo ""
echo "*** This is the SRVMON release 0.9 - Features may change ***"
echo ""
echo "Press <RETURN> to continue!"

read DUMMY

clear

echo "Step 1 : Prerequisites"
echo ""
echo "Please specify if this system is the monitoring server or a client."
echo ""
echo "> 1. MASTER"
echo "> 2. CLIENT"
echo ""

read -p ">:" TYPE

case $TYPE in
  1)
    echo "The following prerequisites are needed for the master server:"
    echo ""
    echo "> MariaDB Server"
    echo "> Apache2"
    echo "> PHP5"
    echo "> PHP5-MYSQL"
    echo "> PHP5-MCRYPT"
    echo "> PHP5-GD"
    echo "> PHP-FPDF"
    echo ""
    
    read DUMMY

    ;;

  2)
    echo "The following prerequisites are needed for the client:"
    echo ""
    echo "> MariaDB Client"

    read DUMMY

    ;;

  *)
    echo "Wrong input!"
    ;;
esac

exit 0

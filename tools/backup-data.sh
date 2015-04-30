#!/bin/bash
#
# License information
# -------------------
#  backup-data.sh - A script to create snapshots of the SRVMON suite.
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

filename=`date +%Y%m%d-%Hh%M_SRVMON.tgz`
echo "Copying data to file server (FSS-CLUSTER -> common) . . ."
rsync -azP /home/pwarnimo/Documents/SRVMON/ /home/pwarnimo/FSS-CLUSTER/common/Userdata/pwarnimo/SRVMON-WORKING/

if [ $? -eq 0 ]
then
  echo "Xfer OK!"
else
  echo "Xfer failed!"
  exit 1
fi

echo "Creating backup archive of working copy . . ."
cd /home/pwarnimo/Documents/SRVMON/
tar czvf /tmp/$filename .

if [ $? -eq 0 ]
then
  echo "Archive creation successful!"
else
  echo "Archive creation failed!"
  exit 1
fi

echo "Transferring backup archive to backup server (HAFSS-CLUSTER -> backup) . . ."
rsync -azP /tmp/$filename /home/pwarnimo/HAFSS-CLUSTER/backup/Userdata/pwarnimo/SRVMON/

if [ $? -eq 0 ]
then
  echo "Xfer OK!"
else
  echo "Xfer failed!"
  exit 1
fi

rm /tmp/$filename

exit 0

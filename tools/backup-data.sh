#!/bin/bash


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

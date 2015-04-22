#!/bin/bash

echo "Copying webclient files to www server . . ."
sudo rsync -azP /home/pwarnimo/Documents/SRVMON/webclient/* /var/www/SRVMON/

if [ $? -eq 0 ]
then
  echo "OK!"
else
  echo "Failure!"
  exit 1
fi

exit 0

#!/bin/bash

echo "Building srvmon-director"

g++ -Wall -I/usr/include/cppconn -o srvmon-director main.cpp db.h db.cpp check.h check.cpp server.h -L/usr/lib -lmysqlcppconn

echo "OK!"

exit 0

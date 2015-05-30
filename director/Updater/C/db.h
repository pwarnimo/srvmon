#ifndef DB_H_
#define DB_H_

#include <my_global.h>
#include <mysql.h>

struct Server {
	char *hostname;
	char *ipaddress;
};

void exitError(MYSQL *con);
void connectDB(char *dbhost, char *dbuser, char *dbpass, char *dbname);
void getServersFromDB(struct Server *servers);

#endif

#include <stdio.h>
#include <stdlib.h>
#include <my_global.h>
#include <mysql/mysql.h>
#include "db.h"

void returnErr(MYSQL *con) {
	fprintf(stderr, "%s\n", mysql_error(con));
	mysql_close(con);
	exit(1);
}

int main(int argc, char *argv[]) {
	printf("SRVMON-DIRECTOR UPDATER C EDITION 0.1\n");

	MYSQL *con = mysql_init(NULL);

	if (con == NULL) {
		fprintf(stderr, "mysql_init() has failed\n");	
		exit(1);
	}

	if (mysql_real_connect(con, "localhost", "sqlusr", "q1w2e3!", "srvmon", 0, NULL, 0) == NULL) {
		returnErr(con);
	}

	if (mysql_query(con, "SELECT dtHostname, dtIPAddress FROM tblServer")) {
		returnErr(con);
	}

	MYSQL_RES *result = mysql_store_result(con);

	if (result == NULL) {
		returnErr(con);
	}

	int rowCount = mysql_num_fields(result);

	MYSQL_ROW row;

	while ((row = mysql_fetch_row(result))) {
		int i;

		for (i = 0; i < rowCount; i++) {
			printf("%s ", row[i] ? row[i] : "NULL");
		}
		printf("\n");
	}

	mysql_free_result(result);
	mysql_close(con);

	exit(0);
}

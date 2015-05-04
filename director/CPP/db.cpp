#include "db.h"
#include <iostream>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <cppconn/prepared_statement.h>

DB::DB(void) {
	cout << "Connecting to database...\n";

	try {
		driver = get_driver_instance();
		con = driver->connect("tcp://127.0.0.1", "sqlusr", "q1w2e3!");
		con->setSchema("srvmon");
		cout << "DB OK!\n";
	}
	catch (sql::SQLException &e) {
		cout << "# ERR: SQLException in " << __FILE__;
		cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << endl;
		cout << "# ERR: " << e.what();
		cout << " (MySQL error code: " << e.getErrorCode();
		cout << ", SQLState: " << e.getSQLState() << " )" << endl;
	}
}

int DB::getHostID(string hostname) {
	int sid = -1;
	
	cout << "Retrieving ID for " << hostname << " from DB...\n";
	sql::PreparedStatement *stmt;
	sql::ResultSet *res;

	try {
		stmt = con->prepareStatement("SELECT getServerID(?) AS idServer");

		stmt->setString(1, hostname);
	
		stmt->execute();
		res = stmt->getResultSet();

		while (res->next()) {
			sid = res->getInt("idServer");
		}
	}
	catch (sql::SQLException &e) {
		cout << "# ERR: SQLException in " << __FILE__;
		cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << endl;
		cout << "# ERR: " << e.what();
		cout << " (MySQL error code: " << e.getErrorCode();
		cout << ", SQLState: " << e.getSQLState() << " )" << endl;
	}

	return sid;
}

void DB::getServerList() {
	cout << "Retrieving server list from DB...\n";
	sql::Statement *stmt;
	sql::ResultSet *res;

	try {
		stmt = con->createStatement();
		res = stmt->executeQuery("CALL getServer(-1,FALSE,@err)");

		while (res->next()) {
			cout << "SID[" + res->getString("idServer") + "] => " + res->getString("dtHostname") + 
				"@" + res->getString("dtIPAddress");

			if (res->getInt("dtEnabled") == 1) {
				cout << " ONLINE\n";
			}
			else {
				cout << " OFFLINE\n";
			}
		}
	}
	catch (sql::SQLException &e) {
		cout << "# ERR: SQLException in " << __FILE__;
		cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << endl;
		cout << "# ERR: " << e.what();
		cout << " (MySQL error code: " << e.getErrorCode();
		cout << ", SQLState: " << e.getSQLState() << " )" << endl;
	}
}

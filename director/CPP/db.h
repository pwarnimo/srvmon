#ifndef __DB_H_INCLUDED__
#define __DB_H_INCLUDED__

#include <cppconn/driver.h>
#include "server.h"
#include <vector>

using namespace std;

class DB {
	public:
		DB();

		int getHostID(string hostname);
		void getServerList();
		void printServers();
	private:
		sql::Driver *driver;
		sql::Connection *con;
		vector<Server> servers;
};

#endif

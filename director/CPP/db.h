#ifndef __DB_H_INCLUDED__
#define __DB_H_INCLUDED__

#include <cppconn/driver.h>

using namespace std;

class DB {
	public:
		DB();

		int getHostID(string hostname);
		void getServerList();
	private:
		sql::Driver *driver;
		sql::Connection *con;
};

#endif

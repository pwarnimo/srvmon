#include <stdlib.h>
#include <iostream>
#include "db.h"
#include "check.h"
#include <string.h>

using namespace std;

int main() {
	cout << "SRVMON DIRECTOR\n";
	DB db0;
	cout << "ID OF TEMPEST = " << db0.getHostID("tempest") << "\n";
	db0.getServerList();

	int ping_ret, status;

	char one[] = "ping -w 2 ";
	char two[] = "192.168.1.1";
	char thr[] = " > /dev/null 2>&1";

	char res[100];

	strcpy(res,one);
	strcat(res,two);
	strcat(res,thr);

	cout << res << "\n";

	status = system(res);

	if (-1 != status)
	ping_ret = WEXITSTATUS(status);	

	cout << "P=" << ping_ret << "\n";

	Check chk0;
	chk0.checkHost("test");
}

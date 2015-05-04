#include <stdlib.h>
#include <iostream>
#include "db.h"

using namespace std;

int main() {
	cout << "SRVMON DIRECTOR\n";
	DB db0;
	cout << "ID OF TEMPEST = " << db0.getHostID("tempest") << "\n";
	db0.getServerList();
}

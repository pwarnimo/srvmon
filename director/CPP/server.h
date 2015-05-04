#ifndef __SERVER_H_INCLUDED__
#define __SERVER_H_INCLUDED__

#include <string>

using namespace std;

struct Server {
	string hostname;
	string ipaddress;
	int enabled;
};

#endif

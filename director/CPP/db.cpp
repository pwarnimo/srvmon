#include <iostream>
#include "db.h"

using namespace std;

DB::DB() {
	cout << "Contructor\n";
}

DB::~DB() {
	cout << "Destructor\n";
}

void DB::performTest() {
	cout << "Hello\n";
}

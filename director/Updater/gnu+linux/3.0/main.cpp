/*
 * File : main.cpp
 * Author(s) : Pol Warnimont
 * Create date : 2016-02-01
 * Version : 3.0 A1
 * Description : This file is part of the SRVMON director.
 *               This file contains the main logic.
 *
 * Changelog
 * ---------
 *  2015-02-01 : Created file.
 *
 * License information
 * -------------------
 *  Copyright (C) 2016  Pol Warnimont
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#include "task.h"

void printVersion() {
	QTextStream out(stdout);

	out << "SRVMON Director -- Update daemon for GNU/Linux" << endl;
	out << "Version 3.0 A1 (using Qt Version 5.2.1)" << endl;
	out << "Copyright (C) 2016  Pol Warnimont" << endl;
	out << "Please use \"-l\" for license information" << endl;
	out << "\nThe SRVMON Updater daemon comes with ABSOLUTELY NO WARRANTY!\n" << endl;
}

void printLicense() {
	QTextStream out(stdout);

	out << "Copyright (C) 2016  Pol Warnimont\n" << endl;
	out << "This program is free software; you can redistribute it and/or" << endl;
	out << "modify it under the terms of the GNU General Public License" << endl;
	out << "as published by the Free Software Foundation; either version 2" << endl;
	out << "of the License, or (at your option) any later version.\n" << endl;
	out << "This program is distributed in the hope that it will be useful," << endl;
	out << "but WITHOUT ANY WARRANTY; without even the implied warranty of" << endl;
	out << "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the" << endl;
	out << "GNU General Public License for more details.\n" << endl;
	out << "You should have received a copy of the GNU General Public License" << endl;
	out << "along with this program; if not, write to the Free Software" << endl;
 	out << "Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA." << endl;
}

int main (int argc, char *argv[]) {
	if (argc > 1) {
		if (QString::compare(argv[1], "-v") == 0) {
			printVersion();
			
			return 0;
		}

		if (QString::compare(argv[1], "-l") == 0) {
			printLicense();

			return 0;
		}
	}
	else {
		QCoreApplication app(argc, argv);

		QSettings settings("ScrubStudios", "SRVMON");

		//if (settings.contains("db/host")) {
		if (QFile(settings.fileName()).exists()) {
			qDebug("Loading settings from file...");
		}
		else {
			qDebug("Settings file does not exists!");
			settings.beginGroup("db");
			settings.setValue("host", "127.0.0.1");
			settings.setValue("name", "srvmon");
			settings.setValue("username", "srvmonusr");
			settings.setValue("password", "q1w2e3!");
			settings.endGroup();
		}

		Task *task = new Task(&app);

		QObject::connect(task, SIGNAL(finished()), &app, SLOT(quit()));
		QTimer::singleShot(0, task, SLOT(run()));

		return app.exec();
	}

	return 1;
}

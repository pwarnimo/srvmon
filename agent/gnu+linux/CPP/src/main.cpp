/*
 * File        : main.cpp
 * Author(s)   : Pol Warnimont
 * Create date : 2016-02-03
 * Version     : 3.0 A1
 * Description : This file is part of the SRVMON Agent.
 *               This file contains the main logic.
 *
 * Changelog
 * ---------
 *  2016-02-03 : Created file.
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
#include "httprequestworker.h"

void printVersion() {
	qDebug() << "SRVMON Agent Daemon for GNU/Linux";
	qDebug() << "Version 3.0 A1 using Qt" << QT_VERSION_STR;
	qDebug() << "Copyright (C) 2016  Pol Warnimont";
	qDebug() << "Please use \"-l\" for license information";
	qDebug() << "\nThe SRVMON Agent Daemon comes with ABSOLUTELY NO WARRANTY!\n";
}

void printLicense() {
	qDebug() << "Copyright (C) 2016  Pol Warnimont\n";
	qDebug() << "This program is free software; you can redistribute it and/or";
	qDebug() << "modify it under the terms of the GNU General Public License";
	qDebug() << "as published by the Free Software Foundation; either version 2";
	qDebug() << "of the License, or (at your option) any later version.\n";
	qDebug() << "This program is distributed in the hope that it will be useful,";
	qDebug() << "but WITHOUT ANY WARRANTY; without even the implied warranty of";
	qDebug() << "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the";
	qDebug() << "GNU General Public License for more details.\n";
	qDebug() << "You should have received a copy of the GNU General Public License";
	qDebug() << "along with this program; if not, write to the Free Software";
	qDebug() << "Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.";
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
		QSettings settings("SRVMON", "Agent");

		/*if (QFile(settings.fileName()).exists()) {*/
			Task *task = new Task(&app);

			/*QObject::connect(task, SIGNAL(finished()), &app, SLOT(quit()));
			QTimer::singleShot(0, task, SLOT(run()));*/

		/*while (1) {
			QCoreApplication::processEvents();
			task->run();
		}*/

		//QTimer::singleShot(0, task, SLOT(getID()));
		QTimer::singleShot(0, task, SLOT(loadServices()));

		QTimer *timer = new QTimer(&app);
		
		//QObject::connect(timer, SIGNAL(timeout()), task, SLOT(run()));
		QObject::connect(task, SIGNAL(finished()), &app, SLOT(quit()));
		
		//timer->start(10000);


		/*}
		else {
			qDebug("Settings file does not exist!\nCreating placeholder file.");

			settings.beginGroup("director");
			settings.setValue("host", "localhost");
			settings.endGroup();
			settings.beginGroup("preferences");
			settings.setValue("exec_interval", 300);
			settings.endGroup();

			return 1;
		}*/

		/** TESTING */
		

		return app.exec();
	}

	return 1;
}

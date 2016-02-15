/*
 * File        : task.cpp
 * Author(s)   : Pol Warnimont
 * Create date : 2016-02-03
 * Version     : 3.0 A1
 * Description : Class for defining a worker Thread.
 *
 * Changelog
 * ---------
 *  2016-02-03 : Created class.
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
#include <QTextStream>
#include <QNetworkReply>

#include "service.h"

Task::Task(QObject *parent) : QObject(parent) {
	busy = false;
	qDebug("**Task created");
}

void Task::run() {
	qDebug(">> run()");
	if (busy == false) {
		mode = 1;
		busy = true;

		QString url_str = "http://localhost/director/servers/" + myid + "/keepalive";

		HttpRequestInput input(url_str, "PUT");

		HttpRequestWorker *worker = new HttpRequestWorker(this);
		connect(worker, SIGNAL(on_execution_finished(HttpRequestWorker*)), this, SLOT(handle_result(HttpRequestWorker*)));
		worker->execute(&input);
	}
}

void Task::testingFunc1() {
	qDebug() << "***TESTING AREA";

	Service svc0(0, 4, "chkping", "N/A", "", "16c02c1990231d13352d89a604f70933f2202d29");

	if (svc0.isValid()) {
		qDebug() << "[TASK] Script ok!";
	}
	else {
		qDebug() << "[TASK] Script tampered!!";
	}

	emit(finished());
	qDebug() << "***TESTING AREA";
}

void Task::loadServices() {
	qDebug(">> loadServices()");

	//test
	myid = "1";

	QString url_str = "http://localhost/director/servers/" + myid + "/services";

	HttpRequestInput input(url_str, "GET");

	HttpRequestWorker *worker = new HttpRequestWorker(this);
	connect(worker, SIGNAL(on_execution_finished(HttpRequestWorker*)), this, SLOT(handleServices(HttpRequestWorker*)));
	worker->execute(&input);
}

void Task::getID() {
	qDebug(">> getID()");
	if (busy == false) {
		mode = 0;
		busy = true;

		QString hname = "lbs4065";

		QString url_str = "http://localhost/director/servers/" + hname + "/getid";

		HttpRequestInput input(url_str, "GET");

		HttpRequestWorker *worker = new HttpRequestWorker(this);
		connect(worker, SIGNAL(on_execution_finished(HttpRequestWorker*)), this, SLOT(handle_result(HttpRequestWorker*)));
		worker->execute(&input);
	}
}

/*void Task::testRun(int mode) {
	qDebug("testRun()");

	QString url_str = "http://localhost/director/servers";

	HttpRequestInput input(url_str, "GET");

	HttpRequestWorker *worker = new HttpRequestWorker(this);
	connect(worker, SIGNAL(on_execution_finished(HttpRequestWorker*)), this, SLOT(handle_result(HttpRequestWorker*)));
	worker->execute(&input);
	
	qDebug("testRun() -> end");
}*/

void Task::handleServices(HttpRequestWorker *worker) {
	qDebug() << "[TASK] PARSING DATA...";

	if (worker->error_type == QNetworkReply::NoError) {
		qDebug() << "[TASK] Response received...";

		qDebug() << "[TASK] DATA = " << worker->response;

		QJsonDocument doc(QJsonDocument::fromJson(worker->response));
		QJsonObject jobj = doc.object();

		if (QString::compare(jobj["status"].toString(), "OK", Qt::CaseInsensitive) == 0) {
			qDebug() << "[TASK] Query data is valid.";
			QJsonArray arrServices = jobj["data"].toArray();

			for (auto it = arrServices.begin(); it != arrServices.end(); it++) {
				QJsonObject serviceObj = (*it).toObject();

				//qDebug() << serviceObj["idService"].toString() << " -- " << serviceObj["dtCheckCommand"].toString();

				//Service svcTmp(..);
				//if (svcTmp.isValid()) {..}
			}
		}
		else {
			qDebug() << "[TASK] Query data is invalid!!";
		}
	}
	else {
		qDebug() << "[TASK] ERROR!! >" << worker->error_str;
	}

	//test
	emit(finished());
}

void Task::handle_result(HttpRequestWorker *worker) {
	QString msg;

		qDebug() << "MODE == " << mode;

	    if (worker->error_type == QNetworkReply::NoError) {
			//switch (mode) {
				//case 0: {
				if (mode == 0) {

					qDebug() << "M0-RESP>" << worker->response;

					QJsonDocument doc(QJsonDocument::fromJson(worker->response));
					QJsonObject jobj = doc.object();

					//qDebug() << "JSON-OBJ = " << jobj["status"].toString();

					if (QString::compare(jobj["status"].toString(), "OK", Qt::CaseInsensitive) == 0) {
						qDebug() << "M0-QRY = OK";

						//qDebug() << "M0-DECODED = " << jobj["data"].toArray()[0].toObject()["idServer"].toString();
						myid = jobj["data"].toArray()[0].toObject()["idServer"].toString();
					}
					else {
						qDebug() << "M0-QRY = FAILED";
					}

				}

				//case 1: {
				else if (mode == 1) {
					qDebug() << "M1-RESP>" << worker->response;

					//break;
				}
			//}
			//msg = "Success - Response: " + worker->response;
		}
		else {
			msg = "Error: " + worker->error_str;
			qDebug() << msg;
		}

		busy = false;

		//qDebug() << msg;
}

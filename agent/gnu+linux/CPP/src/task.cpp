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

void Task::loadServices() {
	qDebug(">> loadServices()");
	if (busy == false) {
		mode = 2;
		busy = true;

		QString url_str = "http://localhost/director/servers/" + myid + "/services";
	}
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

void Task::handle_result(HttpRequestWorker *worker) {
	QString msg;

		qDebug() << "MODE == " << mode;

	    if (worker->error_type == QNetworkReply::NoError) {
			//switch (mode) {
				//case 0: {
				if (mode == 0) {

					qDebug() << "M0-RESP>" << worker->response;

					QJsonDocument d = QJsonDocument::fromJson(worker->response);
					QJsonObject jobj = d.object();
					QJsonValue val1 = jobj.value(QString("data"));

					QJsonObject item = val1.toObject();

					QJsonValue id = item["idServer"];

					myid =id.toString();

					qDebug() << "M0> The server ID is" << myid;

					//break;
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

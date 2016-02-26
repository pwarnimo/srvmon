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

void Task::keepAlive() {
	qDebug(">> keepAlive()");

	//test
	myid = "1";

	if (QString::compare(myid, "-1") != 0) {
		QString url_str = "http://localhost/director/servers/" + myid + "/keepalive";

		HttpRequestInput input(url_str, "PUT");

		HttpRequestWorker *worker = new HttpRequestWorker(this);
		connect(worker, SIGNAL(on_execution_finished(HttpRequestWorker*)), this, SLOT(handleKeepAlive(HttpRequestWorker*)));
		worker->execute(&input);
	}
	else {
		qDebug() << "[TASK] ID NOT SET!";
	}
}

void Task::updateService(Service svc) {
	qDebug() << ">> updateService(..)";
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

void Task::handleKeepAlive(HttpRequestWorker *worker) {
	qDebug() << "[TASK] PARSING DATA...";

	if (worker->error_type == QNetworkReply::NoError) {
		qDebug() << "[TASK] Response received...";
		qDebug() << "[TASK] DATA = " << worker->response;

		QJsonDocument doc(QJsonDocument::fromJson(worker->response));
		QJsonObject jobj = doc.object();

		if (QString::compare(jobj["status"].toString(), "OK", Qt::CaseInsensitive) == 0) {
			qDebug() << "[TASK] Query has been successfully executed on the server.";
		}
		else {
			qDebug() << "[TASK] The query has failed on the server!";
		}
	}
	else {
		qDebug() << "[TASK] ERROR!! >" << worker->error_str;
	}

	emit(finished());
}

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

				Service svcTmp(
					QString(serviceObj["idService"].toString()).toInt(),
					QString(serviceObj["dtValue"].toString()).toInt(),
					serviceObj["dtCheckCommand"].toString(),
					serviceObj["dtScriptOutput"].toString(),
					serviceObj["dtParameters"].toString(),
					serviceObj["dtChecksum"].toString()
				);
				//if (svcTmp.isValid()) {..}
				//qDebug() << svcTmp.toString();
				if (svcTmp.isValid()) {
					qDebug() << "[TASK] Script checksum test passed :D! Executing script...";

					// TESTING
					/*QProcess *process = new QProcess();

					process->setWorkingDirectory("/usr/share/srvmon/agent/scripts/");
					process->start("/bin/bash", QStringList() << svcTmp.getCmd() << " " << svcTmp.getParameters());
					process->waitForFinished();

					qDebug() << process->readAllStandardOutput();*/

					QProcess *process = new QProcess();

					process->setWorkingDirectory("/usr/share/srvmon/agent/scripts/");
					//process->start("./chkping 10.0.2.15 4 2");
					process->start("./" + svcTmp.getCmd() + " " + svcTmp.getParameters());
					process->waitForFinished(-1);

					QString chkData = process->readAllStandardOutput();
					//qDebug() << process->readAllStandardError();

					QStringList lstData = chkData.split(";");

					switch (lstData.at(0).toInt()) {
						case 0:
							qDebug() << "[TASK] >>Check OK => S0";
							break;

						case 1:
							qDebug() << "[TASK] >>Check WARN => S1";
							break;

						case 2:
							qDebug() << "[TASK] >>Check CRIT => S2";
							break;

						case 3:
							qDebug() << "[TASK] >>TIMED OUT => S3";
							break;
					}

					qDebug() << "[TASK] >>SVC-STR = " << lstData.at(1);

					updateService(svcTmp);
				}
				else {
					qDebug() << "[TASK] Script has been tampered :(! ABORTING!!";
				}
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
}

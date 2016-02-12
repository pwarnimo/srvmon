/*
 * File        : notificator.cpp
 * Author(s)   : Pol Warnimont
 * Create date : 2016-02-11
 * Version     : 0.1A1
 *
 * Description : Main form functions.
 *
 * Changelog
 * ---------
 *  2016-02-11 : Created file.
 *
 * License
 * -------
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

#include "notificator.h"
#include <QDebug>
#include <QNetworkReply>
#include <QMessageBox>

Notificator::Notificator(QMainWindow *parent) : QMainWindow(parent) {
	setupUi(this);

	connect(btnTest, SIGNAL(released()), this, SLOT(testJSON()));
}

Notificator::~Notificator() {}

void Notificator::testJSON() {
	QString url_str = "http://localhost/director/servers";

	HttpRequestInput input(url_str, "GET");

	HttpRequestWorker *worker = new HttpRequestWorker(this);
	connect(worker, SIGNAL(on_execution_finished(HttpRequestWorker*)), this, SLOT(handleResult(HttpRequestWorker*)));
	worker->execute(&input);
}

void Notificator::handleResult(HttpRequestWorker *worker) {
	QString msg;

	if (worker->error_type == QNetworkReply::NoError) {
		msg = "OK RES => " + worker->response;
	}
	else {
		msg = "FAILURE => " + worker->error_str;
	}

	QMessageBox::information(this, "", msg);
}

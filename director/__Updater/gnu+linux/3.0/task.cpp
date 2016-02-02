#include "task.h"
#include <QTextStream>
#include <QSqlDatabase>
#include <QtSql>

Task::Task(QObject *parent) : QObject(parent) {}

void Task::run() {
	testRun();

	emit finished();
}

void Task::testRun() {
	qDebug("Message from Task!");
	QSettings settings("ScrubStudios", "SRVMON");

	QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");

	db.setHostName(settings.value("db/host").toString());
	db.setDatabaseName(settings.value("db/name").toString());
	db.setUserName(settings.value("db/username").toString());
	db.setPassword(settings.value("db/password").toString());

	if (!db.open()) {
		qCritical() << "db.open() has failed with the following message: " << db.lastError().text() << endl;
	}
	else {
		QSqlQuery qry("CALL getServer(-1,TRUE,@err)");

		while (qry.next()) {
			qDebug() << "SRV=" << qry.value(1).toString() << endl;
		}
	}
}

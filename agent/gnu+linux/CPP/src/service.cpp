#include "service.h"
#include <QDebug>
#include <QFile>
#include <QCryptographicHash>

Service::Service(int id, int value, QString cmd, QString checkOutput, QString parameters, QString checksum) {
	this->id = id;
	this->value = value;
	this->cmd = cmd;
	this->checkOutput = checkOutput;
	this->parameters = parameters;
	this->checksum = checksum;
}

void Service::setID(int id) {
	this->id = id;
}

void Service::setValue(int value) {
	this->value = value;
}

void Service::setCmd(QString cmd) {
	this->cmd = cmd;
}

void Service::setCheckOutput(QString checkOutput) {
	this->checkOutput = checkOutput;
}

void Service::setParameters(QString parameters) {
	this->parameters = parameters;
}

void Service::setChecksum(QString checksum) {
	this->checksum = checksum;
}

int Service::getID() {
	return id;
}

int Service::getValue() {
	return value;
}

QString Service::getCmd() {
	return cmd;
}

QString Service::getCheckOutput() {
	return checkOutput;
}

QString Service::getParameters() {
	return parameters;
}

QString Service::getChecksum() {
	return checksum;
}

bool Service::isValid() {
	QFile file("/usr/share/srvmon/agent/scripts/" + cmd);

	if (file.open(QIODevice::ReadOnly)) {
		QByteArray fileData = file.readAll();
		QByteArray hashData = QCryptographicHash::hash(fileData, QCryptographicHash::Sha1);

		QString clcHash(hashData.toHex());

		qDebug() << "[SERVICE] Database Hash   = " << checksum;
		qDebug() << "[SERVICE] Calculated hash = " << clcHash;

		if (QString::compare(checksum, clcHash, Qt::CaseSensitive) == 0) {
			//qDebug() << "Check passed :D!";
			return true;
		}
	}

	//qDebug() << "Script has been tampered :(!";

	return false;
}

QString Service::toString() {
	return "SID-" + QString::number(id) + " => " + cmd;
}

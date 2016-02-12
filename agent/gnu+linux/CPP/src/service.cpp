#include "service.h"

Service::Service(int id, int value, QString cmd, QString checkOutput, QString parameters) {
	this->id = id;
	this->value = value;
	this->cmd = cmd;
	this->checkOutput = checkOutput;
	this->parameters = parameters;
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

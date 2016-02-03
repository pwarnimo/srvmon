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

Task::Task(QObject *parent) : QObject(parent) {}

void Task::run() {
	testRun();

	emit finished();
}

void Task::testRun() {
	qDebug("This is a test from the task class.");
}

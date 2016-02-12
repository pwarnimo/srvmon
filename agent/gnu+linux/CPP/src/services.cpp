/*
 * File : services.cpp
 * Author(s) : Pol Warnimont
 * Create date : 2016-02-12
 * Version : 3.0 A1
 *
 * Description : Class for service management.
 *
 * Changelog
 * ---------
 *  2016-02-12 : Created file.
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

#include "services.h"

Services::Services() {}

void Services::addServiceToVector(Service service) {
	v_services << service;
}

void Services::clearList() {}

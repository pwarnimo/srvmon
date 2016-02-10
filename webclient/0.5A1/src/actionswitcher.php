<?php
/*
 * File : actionswitcher.php
 * Author(s) : Pol Warnimont
 * Create date : 2016-02-09
 * Version : 0.5A1
 *
 * Description : Chooses the appropriate actions.
 *
 * Changelog
 * ---------
 *  2016-02-09 : Created file.
 *  2016-02-10 : Added action for displaying single server data.
 *               Support for services added.
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

require_once "inc/init.php";

if (Input::exists("get")) {
	switch (Input::get("action")) {
		case "getServers":
			echo \Httpful\Request::get(Config::get("director/host") . "/servers")->send();
			break;

		case "getServer":
			echo \Httpful\Request::get(Config::get("director/host") . "/servers/" . Input::get("id"))->send();
			break;

		case "getAllServicesForServer":
			echo \Httpful\Request::get(Config::get("director/host") . "/servers/" . Input::get("id") . "/services")->send();
			break;
	}
}

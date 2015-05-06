<?php
/* File        : action-switcher.inc.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-04-24
 * Version     : 0.5
 *
 * Description : Used to switch between actions for AJAX.
 * 
 * Changelog
 * ---------
 *  2015-04-24 : Create file.
 *  2015-05-06 : Added license and header.
 *
 * License
 * -------
 *  Copyright (C) 2015  Pol Warnimont
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

	include "settings/dbconfig.inc.php";
	
	function __autoload($class_name) {
		require_once "classes/" . $class_name . ".class.php";
	}

	$action = filter_input(INPUT_GET, "action");

	switch ($action) {
		case "getServers" :
			$servermngr = new serversmngr();
			echo $servermngr->printserver();
		break;

		case "getServer" :
			$sid = filter_input(INPUT_POST, "sid");
			$format = filter_input(INPUT_POST, "format");

			$servermngr = new serversmngr();
			echo $servermngr->getServer($sid, $format);
		break;

		case "getServicesForServer" :
			$sid = filter_input(INPUT_POST, "sid");
			$format = filter_input(INPUT_POST, "format");

			$servicesmngr = new ServicesMngr();

			echo $servicesmngr->getServicesForServer($sid, $format);
		break;
	}
?>

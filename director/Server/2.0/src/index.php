<?php
/*
 * File        : index.php
 * Author(s)   : Pol Warnimont
 * Create date : 2016-02-02
 * Version     : 2.0 A1
 * Description : This file is part of the SRVMON Director Server.
 *               This is a "Quick and Dirty" iplementation of the
 *               server using the Slim framework with the REST
 *               API.
 *
 * Changelog
 * ---------
 *  2016-02-02 : Created file.
 *  2016-02-03 : Switching to Slim framework.
 *  2016-02-04 : Adding keepAlive function.
 *  2016-02-06 : Server functions moved to new class.
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
require_once "inc/init.php";
require "vendor/autoload.php";

$app = new \Slim\Slim();

$app->get("/", function () {
	echo json_encode("Hello there!");
});

/* SERVER FUNCS */
$app->get("/servers", function () { echo ServerMngr::getServers(); });
$app->put("/servers/setfailedsystems", function () { echo ServerMngr::markFailedSystems(); });
$app->get("/servers/:name/getid", function ($name) { echo ServerMngr::getHostIDByName($name); });
$app->get("/servers/:id", function ($id) { echo ServerMngr::getServers($id); });
$app->put("/servers/:id/keepalive", function ($id) { echo ServerMngr::keepAlive($id); });
$app->put("/servers/:id/setstatus", function ($id) { echo ServerMngr::setServerStatus($id, \Slim\Slim::getInstance()->request()->getBody()); });
$app->put("/servers/:id/children/disablechecks", function ($id) { echo ServerMngr::disableChildHosts($id); });

/*$app->put("/servers/:hid/services/:sid/update", "updateServiceOfServer");
$app->get("/servers/:hid/services", "getAllServicesForServer");
$app->get("/servers/:hid/services/:sid", "getServiceForServer");*/

/* GENERAL FUNCS */
$app->get("/version", function () {
	echo json_encode(
		array(
			"status" => "OK",
			"data" => array(
				"program" => "SRVMON Director",
				"version" => "2.0 A1",
				"copyright" => "2016 Pol Warnimont",
				"license" => "GPLv2"
			)
		)
	);
});

$app->run();

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
$app->get("/servers", "getServers");
$app->get("/servers/:id", "getServer");
$app->put("/servers/:id/setstatus", "setServerStatus");
$app->put("/servers/:id/children/disablechecks", "disableChildrenChecks");
$app->put("/servers/setfailedsystems", "setFailedSystems");
$app->put("/servers/:hid/services/:sid/update", "updateServiceOfServer");
$app->get("/servers/:hid/services", "getAllServicesForServer");
$app->get("/servers/:hid/services/:sid", "getServiceForServer");

/* GENERAL FUNCS */
$app->get("/version", "showVersion");

$app->run();

//***********************

function getServers() {
	if (!DB::getInstance()->doQuery("CALL getServer(-1,TRUE,@err)")->error()) {
		echo json_encode(
			array(
				"status" => "OK",
				"servers" => DB::getInstance()->results()
			)
		);
	}
	else {
		echo json_encode(
			array(
				"status" => "QUERYFAIL"
			)
		);
	}
}

function getServer($id) {
	if (!DB::getInstance()->doQuery("CALL getServer(?,TRUE,@err)", array($id))->error()) {
		echo json_encode(
			array(
				"status" => "OK",
				"server" => DB::getInstance()->first()
			)
		);
	}
	else {
		echo json_encode(
			array(
				"status" => "QUERYFAIL"
			)
		);
	}
}

function setServerStatus($id) {
	$request = \Slim\Slim::getInstance()->request();	
	$data = json_decode($request->getBody());

	//print_r($data);
	//Create new input validation methods
	//This method is only temporary!

	if ($data->state == 0 || $data->state == 1) {
		if (!DB::getInstance()->doQuery("CALL setSystemStatus(?,?,@err)", array($id, $data->state))->error()) {
			echo json_encode(
				array(
					"status" => "OK"
				)
			);
		}
		else {
			echo json_encode(
				array(
					"status" => "QUERYFAIL"
				)
			);
		}
	}
	else {
		echo json_encode(
			array(
				"status" => "INVALID",
				"message" => "Data is invalid!"
			)
		);
	}
}

function disableChildrenChecks($id) {
	if (!DB::getInstance()->doQuery("CALL disableChildrenChecks(?,@err)", array($id))->error()) {
		echo json_encode(
			array(
				"status" => "OK"
			)
		);
	}
	else {
		echo json_encode(
			array(
				"status" => "QUERYFAIL"
			)
		);
	}
}

function setFailedSystems() {
	$failcnt = 0;

	if (!DB::getInstance()->doQuery("SELECT idServer, dtLastCheckTS FROM tblServer WHERE dtLastCheckTS < (NOW() - INTERVAL 5 MINUTE)")->error()) {
		//echo json_encode(DB::getInstance()->results());
		$results = DB::getInstance()->results();
		foreach ($results as $server) {
			if (!DB::getInstance()->doQuery("CALL setSystemStatus(?,0,@err)", array($server->idServer))->error()) {
				$failcnt++;
			}
			else {
				die(json_encode(
					array(
						"status" => "QUERYFAIL",
						"message" => "Query failed at ID = " . $server->idServer
					)
				));
			}
		}

		echo json_encode(
			array(
				"status" => "OK",
				"failedcount" => $failcnt
			)
		);
	}
	else {
		echo json_encode(
			array(
				"status" => "QUERYFAIL"
			)
		);
	}
}

function updateServiceOfServer($hid, $sid) {}

function getAllServicesForServer($hid) {
	if (!DB::getInstance()->doQuery("CALL getServicesForServer(?,-1,0,@err)", array($hid))->error()) {
		echo json_encode(
			array(
				"status" => "OK",
				"services" => DB::getInstance()->results()
			)
		);
	}
	else {
		echo json_encode(
			array(
				"status" => "QUERYFAIL"
			)
		);
	}
}

function getServiceForServer($hid, $sid) {
	if (!DB::getInstance()->doQuery("CALL getServicesForServer(?,?,0,@err)", array($hid, $sid))->error()) {
		$result = DB::getInstance()->first();
		echo json_encode(
			array(
				"status" => "OK",
				"service" => DB::getInstance()->first()
			)
		);
	}
	else {
		echo json_encode(
			array(
				"status" => "QUERYFAIL"
			)
		);
	}
}

function showVersion() {
	echo json_encode(
		array(
			"status" => "OK",
			"mesg" => array(
				"program" => "SRVMON Director",
				"version" => "2.0 A1",
				"copyright" => "2016 Pol Warnimont",
				"license" => "GPLv2"
			)
		)
	);
}

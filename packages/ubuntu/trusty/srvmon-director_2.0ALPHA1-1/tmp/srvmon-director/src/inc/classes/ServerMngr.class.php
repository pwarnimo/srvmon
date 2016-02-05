<?php
/**
 * Static class for manageing servers.
 *  
 * ### About
 *  
 * *	Filename : ServerMngr.class.php
 * *	Create date : 2016-02-06
 * *	Version : 2.0 A1
 *  
 * ### Description
 *  
 * This class is used to perform management operations for the servers.
 *  
 * ### List of changes
 *  
 * *	2016-02-06 : Created class. Alpha 2.0-1 package preparation.
 *  
 * ### License
 *  
 * Copyright (C) 2016  Pol Warnimont
 *  
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *  
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *  
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *  
 * @author Pol Warnimont <pwarnimo@gmail.com>
 * @copyright 2016 Pol Warnimont
 * @license GPLv2
 * @license https://www.gnu.org/licenses/old-licenses/gpl-2.0.de.html
 */
class ServerMngr {
	private static function generateError($type = "GENERAL-FAILURE", $message = "Unknown") {
		return json_encode(
			array(
				"status" => $type,
				"message" => $message
			)
		);
	}

	private static function generateOutput($data) {
		return json_encode(
			array(
				"status" => "OK",
				"data" => $data
			)
		);
	}

	// If param = -1 ret all servers.
	public static function getServers($id = -1) {
		if (!DB::getInstance()->doQuery("CALL getServer(?,TRUE,@err)", array($id))->error()) {
			return self::generateOutput(DB::getInstance()->results());
		}
		else {
			return self::generateError("QUERY-FAIL", "The SQL procedure getServer(..) has failed!");
		}
	}

	public static function keepAlive($id) {
		if (!DB::getInstance()->doQuery("CALL keepAlive(?,@err)", array($id))->error()) {
			return self::generateOutput(true);
		}
		else {
			return self::generateError("QUERY-FAIL", "The SQL procedure keepAlive(..) has failed!");
		}
	}

	public static function getHostIDByName($hostname) {
		if (!DB::getInstance()->doQuery("SELECT getServerID(?) AS idServer", array($hostname))->error()) {
			return self::generateOutput(DB::getInstance()->results());
		}
		else {
			return self::generateError("QUERY-FAIL", "The SQL procedure getServerID(..) has failed!");
		}
	}

	public static function setServerStatus($id, $data_json) {
		$data = json_decode($data_json);

		if ($data->state >= 0 && $data->state <= 1) {
			if (!DB::getInstance()->doQuery("CALL setSystemStatus(?,?,@err)", array($id, $data->state))->error()) {
				return self::generateOutput(true);
			}
			else {
				return self::generateError("QUERY-FAIL", "The SQL procedure setServerStatus(..) has failed!");
			}
		}
		else {
			return self::generateError("INVALID", "The \"state\" data is invalid!");
		}
	}

	public static function disableChildHosts($id) {
		if (!DB::getInstance()->doQuery("CALL disableChildrenChecks(?,@err)", array($id))->error()) {
			return self::generateOutput(true);
		}
		else {
			return self::generateError("QUERY-FAIL", "The SQL procedure disableChildrenChecks(..) has failed!");
		}
	}

	public static function markFailedSystems() {
		$failcnt = 0;

		if (!DB::getInstance()->doQuery("SELECT idServer, dtLastCheckTS FROM tblServer WHERE dtLastCheckTS < (NOW() - INTERVAL 5 MINUTE)")->error()) {
			$results = DB::getInstance()->results();

			foreach ($results as $server) {
				if (!DB::getInstance()->doQuery("CALL setSystemStatus(?,0,@err)", array($server->idServer))->error()) {
					$failcnt++;
				}
				else {
					return self::generateError("QUERY-FAIL", "The SQL procedure setSystemStatus(..) failed for host ID = " . $server->idServer);
				}
			}

			return self::generateOutput($failcnt . " host(s) marked as failed!");
		}
		else {
			return self::generateError("QUERY-FAIL", "The SQL query SELECT ... has failed!");
		}
	}
}

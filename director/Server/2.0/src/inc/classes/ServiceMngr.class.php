<?php
/**
 * Static class for service management.
 *  
 * ### About
 *  
 * *	Filename : ServiceMngr.class.php
 * *	Create date : 2016-02-10
 * *	Version : 2.0 A1
 *  
 * ### Description
 *  
 * This class is used to perform management operations for services.
 *  
 * ### List of changes
 *  
 * *	2016-02-10 : Created class.
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
class ServiceMngr {
	private static function generateError($type = "GENERAL-FAUILURE", $message = "Unknown") {
		return json_encode(
			array(
				"status"  => $type,
				"message" => $message
			)
		);
	}

	private static function generateOutput($data) {
		return json_encode(
			array(
				"status" => "OK",
				"data"   => $data
			)
		);
	}

	// If sid = -1, return all services for server.
	public static function getServicesForServer($hid, $sid = -1) {
		if (!DB::getInstance()->doQuery("CALL getServicesForServer(?,?,0,@err)", array($hid, $sid))->error()) {
			return self::generateOutput(DB::getInstance()->results());
		}
		else {
			return self::generateError("QUERY-FAIL", "The SQL procedure getServicesForServer(..) has failed!");
		}
	}
}

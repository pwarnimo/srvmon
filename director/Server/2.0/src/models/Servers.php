<?php
/*
 * File        : Servers.php
 * Author(s)   : Pol Warnimont
 * Create date : 2016-02-02
 * Version     : 2.0 A1
 * Description : This file is part of the SRVMON Director Server.
 *               This is a "Quick and Dirty" iplementation of the
 *               server using the Phalcon framework with the REST
 *               API.
 *
 * Changelog
 * ---------
 *  2016-02-02 : Created file.
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

use Phalcon\Mvc\Model;
use Phalcon\Mvc\Model\Message;
use Phalcon\Mvc\Model\Validator\Uniqueness;
use Phalcon\Mvc\Model\Validator\InclusionIn;

class Servers extends Model {
	public function validation() {
		$this->validate(
			new InclusionIn(
				array(
					"field" => "dtEnabled",
					"domain" => array(
						"0",
						"1"
					)
				)
			)
		);

		if ($this->validationHasFailed() == true) {
			return false;
		}
	}

	public function getSource() {
		return "tblServer";
	}

	public static function updateState() {
		$server = new Servers();

		$success = $server->getReadConnection()->update(
			"tblServer",
			array("dtEnabled"),
			array("0"),
			"dtLastCheckTS < (NOW() - INTERVAL 5 MINUTE)"
		); 

		return $success;
	}
}

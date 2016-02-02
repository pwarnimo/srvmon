<?php
/*
 * File        : ServersHaveServices.php
 * Author(s)   : Pol Warnimont
 * Create date : 2016-02-02
 * Version     : 2.0 A1
 * Description : This file is part of the SRVMON Director Server.
 *               This is a "Quick and Dirty" iplementation of thr
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
use Phalcon\Mvc\Model\Validator\StringLength;

public ServersHaveServices extends Model {
	public function validate() {
		$this->validator(
			new StringLength(
				array(
					"field" => "dtScriptOutput",
					"max" => 255,
					"min" => 1,
					"messageMaximum" => "Message to long (>255)!",
					"messageMinimum" => "Message to small (<1)!"
				),
				array(
					"field" => "dtChecksum",
					"max" => 255,
					"min" => 32,
					"messageMaximum" => "Checksum to long (>255)!",
					"messageMinimum" => "Checksum to small (<32)!"
				),
				array(
					"field" => "dtNotificationStatus",
					"max" => 45,
					"min" => 1,
					"messageMaximum" => "Notification status to long (>45)!",
					"messageMinimum" => "Notification status to small (<1)!"
				)
			)
		);

		if ($this->dtValue < 0 || $this->dtValue > 4) {
			$this->appendMessage(new Message("Illegal value (x>=0 && x <= 4)!"));
		}
	}

	public function getSource() {
		return "tblServer_has_tblService";
	}
}

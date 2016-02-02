<?php
/*
 * File        : Services.php
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
use Phalcon\Mvc\Model\Validator\StringLength;

public Services extends Model {
	public function validation() {
		$this->validate(
			new Uniqueness(
				array(
					"field" => "dtCaption",
					"message" => "The caption for the service must be unique!"
				)
			)
		);

		$this->validate(
			new StringLength(
				array(
					"field" => "dtCaption",
					"max" => 32,
					"min" => 4,
					"messageMaximum" => "Caption is to long (>32)!",
					"messageMinimum" => "Caption is to small (<4)!"
				),
				array(
					"field" => "dtCheckCommand",
					"max" => 255,
					"min" => 1,
					"messageMaximum" => "Check command is to long (>255)!",
					"messageMinimum" => "Check command is to small (<1)!"
				)
			)
		);

		if (!empty($this->dtParameters)) {
			$this->validate(
				new StringLength(
					array(
						"field" => "dtParameters",
						"max" => 45,
						"min" => 1,
						"messageMaximum" => "Parameter string to long (>45)!",
						"messageMinimum" => "Parameter string to small (<1)!"
					)
				)
			);
		}

		if (empty($this->dtCaption)) {
			$this->appendMessage(new Message("Caption is mandatory!"));
		}

		if (empty($this->dtCheckCommand)) {
			$this->appendMessage(new Message("Check command is mandatory!"));
		}

		if ($this->validationHasFailed() == true) {
			return false;
		}
	}

	public function getSource() {
		return "tblServices";
	}
}

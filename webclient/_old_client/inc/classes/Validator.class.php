<?php
/* File        : Validator.class.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 0.1
 *
 * Description : Form validation utilities.
 * 
 * Changelog
 * ---------
 *  2015-05-05 : Create file.
 *  2015-05-06 : Added license header.
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

class Validator {
	private $_passed = false;
	private $_errors = array();
	private $_db = null;

	public function __construct() {
		$this->_db = DB::getInstance();
	}

	public function check($source, $items = array()) {
		foreach ($items as $item => $rules) {
			foreach ($rules as $rule => $ruleVal) {
				$val = trim($source[$item]);

				if ($rule === "required" && empty($val)) {
					$this->addError($item . " is required!");
				}
				else if (!empty($val)) {
					switch ($rule) {
						case "min":
							if (strlen($val) < $ruleVal) {
								$this->addError($val . " must be a minimum of " . $ruleVal . " chars!");
							}
						break;

						case "max":
							if (strlen($val) > $ruleVal) {
								$this->addError($val . " must be a maximum of " . $ruleVal . " chars!");
							}
						break;

						case "matches":
							if ($val != $source[$ruleVal]) {
								$this->addError($ruleVal . " must match " . $item);
							}
						break;

						case "unique":
							$check = $this->_db->get($ruleVal, array($item, "=", $val));
							

							if ($check->rowCount() > 0) {
								$this->addError($item . " must be unique!");
							}
						break;
					}
				}
			}
		}

		if (empty($this->_errors)) {
			$this->_passed = true;
		}

		return $this;
	}

	private function addError($error) {
		$this->_errors[] = $error;
	}

	public function errors() {
		return $this->_errors;
	}

	public function passed() {
		return $this->_passed;
	}
}

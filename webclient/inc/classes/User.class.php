<?php
/* File        : User.class.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 0.1
 *
 * Description : Defines a user.
 * 
 * Changelog
 * ---------
 *  2015-05-05 : Create file.
 *  2015-05-06 : Added license header.
 *  2015-05-11 : Added method create().
 *  2015-05-16 : Worked on the login system.
 *  2015-05-17 : Worked on login() and added logout() method.
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

class User {
	private $_db;
	private $_data;
	private $_sessionName;
	private $_isLoggedIn;

	public function __construct($user = null) {
		$this->_db = DB::getInstance();
		$this->_sessionName = Config::get("session/session_name");

		if (!$user) {
			if (Session::exists($this->_sessionName)) {
				$user = Session::get($this->_sessionName);

				if ($this->find($user)) {
					$this->_isLoggedIn = true;
				}
				else {
				}
			}
		}
		else {
			$this->find($user);
		}
	}

	public function create($fields = array()) {
		if (!$this->_db->query("CALL addUser(?,?,?,?,?,?,@id)", $fields)->error()) {
			die(">>" . $this->_db->error());
			throw new Exception("Unable to add the user!");
		}
	}

	public function find($user = null) {
		if ($user) {
			$field = (is_numeric($user)) ? "idUser" : "dtUsername";
			$data = $this->_db->get("tblUser", array($field, "=", $user));

			if ($data->rowCount()) {
				$this->_data = $data->first();
				
				return true;
			}
		}

		return false;
	}

	public function login($username = null, $password = null) {
		$user = $this->find($username);

		if ($user) {
			if ($this->data()->dtHash === Hash::make($password, $this->data()->dtSalt)) {
				Session::put($this->_sessionName, $this->data()->idUser);

				return true;
			}
		}

		return false;
	}

	public function logout() {
		Session::delete($this->_sessionName);
	}

	public function data() {
		return $this->_data;
	}

	public function isLoggedIn() {
		return $this->_isLoggedIn;
	}
}

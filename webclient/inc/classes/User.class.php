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
 *  2015-05-18 : Adding remember me functionality.
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
	private $_cookieName;
	private $_isLoggedIn;

	public function __construct($user = null) {
		$this->_db = DB::getInstance();
		$this->_sessionName = Config::get("session/session_name");
		$this->_cookieName = Config::get("remember/cookie_name");

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

	public function login($username = null, $password = null, $remember = false) {
		if (!$username && !$password && $this->exists()) {
			Session::put($this->_sessionName, $this->data()->idUser);
		}
		else {
			$user = $this->find($username);

			if ($user) {
				if ($this->data()->dtHash === Hash::make($password, $this->data()->dtSalt)) {
					Session::put($this->_sessionName, $this->data()->idUser);

					if ($remember) {
						$hash = Hash::unique();
						$hashCheck = $this->_db->get("tblSession", array("idUser", "=", $this->data()->idUser));

						if (!$hashCheck->rowCount()) {
							$this->_db->query("INSERT INTO tblSession VALUES (NULL, ?, ?)", array(
								$this->data()->idUser,
								$hash
							));
						}
						else {
							$hash = $hashCheck->first()->dtHash;
						}

						Cookie::put($this->_cookieName, $hash, Config::get("remember/cookie_expiry"));
					}

					return true;
				}
			}
		}

		return false;
	}

	public function exists() {
		return (!empty($this->data())) ? true : false;
	}

	public function logout() {
		$this->_db->query("DELETE FROM tblSession WHERE idUser = ?", array($this->data()->idUser));

		Session::delete($this->_sessionName);
		Cookie::delete($this->_cookieName);
	}

	public function data() {
		return $this->_data;
	}

	public function isLoggedIn() {
		return $this->_isLoggedIn;
	}
}

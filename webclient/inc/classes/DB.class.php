<?php
/* File        : DB.class.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-04-24
 * Version     : 0.5
 *
 * Description : Defines the database and provides DB functions.
 * 
 * Changelog
 * ---------
 *  2015-05-05 : Create file.
 *  2015-05-06 : Added license and header.
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

class DB {
	private static $_instance = null;
	private $_pdo;
	private $_query;
	private $_error = false;
	private $_result;
	private $_count = 0;

	private function __construct() {
		try {
			$this->_pdo = new PDO("mysql:host=" . Config::get("mysql/host") . ";dbname=" . Config::get("mysql/dbname"), Config::get("mysql/user"), Config::get("mysql/pass"));
		}
		catch(PDOException $e) {
			die($e->getMessage());
		}
	}

	public static function getInstance() {
		if (!isset(self::$_instance)) {
			self::$_instance = new DB();
		}

		return self::$_instance;
	}

	public function query($sql, $params = array()) {
		$this->_error = false;
		
		if ($this->_query = $this->_pdo->prepare($sql)) {
			if (count($params)) {
				$x = 1;

				foreach ($params as $param) {
					$this->_query->bindValue($x, $param);
					$x++;
				}
			}

			if ($this->_query->execute()) {
				$this->_result = $this->_query->fetchAll(PDO::FETCH_OBJ);
				$this->_count = $this->_query->rowCount();
			}
			else {
				$this->_error = true;
			}
		}

		return $this;
	}

	public function error() {
		return $this->_error;
	}

	public function count() {
		return $this->_count;
	}

	public function results() {
		return $this->_result;
	}

	public function first() {
		return $this->results()[0];
	}

	private function action($action, $table, $where = array()) {
		if (count($where) === 3) {
			$operators = array(
				"=",
				">",
				"<",
				">=",
				"<="
			);

			$field = $where[0];
			$operator = $where[1];
			$val = $where[2];

			if (in_array($operator, $operators)) {
				$sql = $action . " FROM " . $table . " WHERE " . $field . " " . $operator . " ?";
				
				if (!$this->query($sql, array($val))->error()) {
					return $this;
				}
			}
		}

		return false;
	}

	public function get($table, $where) {
		return $this->action("SELECT *", $table, $where);	
	}
}

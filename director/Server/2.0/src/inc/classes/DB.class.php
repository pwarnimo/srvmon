<?php
/**
 * Database wrapper class.
 * 
 * ### About
 *  
 * *	Filename : DB.class.php
 * *	Create data : 2015-05-08
 * *	Version : 2.0 A1
 *  
 * ### Description
 *  
 * This class is used to perform multiple database operations. This class
 * is only created once by the getInstance() method. This has the advantage 
 * that the whole PHP application uses the same database instance and also 
 * prevent unnecessary database connections.
 *  
 * ### List of changes
 *  
 * *	2015-05-07 : Created file.
 * *	2015-05-08 : Added functions action() and get().
 * *	2015-05-11 : Adding comments + cleanup. Adding phpDocumentor comments.
 * *	2015-05-20 : Final bugfixing + Adding comments.
 * *	2015-07-24 : Preparing for package release.
 * *	2016-02-03 : Beginning with version 2.0.
 * *	2016-02-06 : Alpha 2.0-1 package preparation.
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
class DB {
	private static $instance = null;
	private $pdo;
	private $query;
	private $err = false;
	private $result;
	private $count = 0;

	private function __construct() {
		try {
			$this->pdo = new PDO("mysql:host=" . Config::get("mysql/host") . ";dbname=" . Config::get("mysql/dbname"), Config::get("mysql/user"), Config::get("mysql/pass"));
		}
		catch(PDOException $e) {
			die(json_encode(
				array(
					"status" => "DBFAIL",
					"message" => $e->getMessage()
				)
			));
		}
	}

	public static function getInstance() {
		if (!isset(self::$instance)) {
			self::$instance = new DB();
		}

		return self::$instance;
	}

	public function doQuery($sql, $params = array()) {
		$this->error = false;

		if ($this->query = $this->pdo->prepare($sql)) {
			if (count($params)) {
				$x = 1;

				foreach ($params as $param) {
					$this->query->bindValue($x, $param);
					$x++;
				}
			}

			if ($this->query->execute()) {
				$this->result = $this->query->fetchAll(PDO::FETCH_OBJ);
				$this->count = $this->query->rowCount();
			}
			else {
				$this->error = true;
			}
		}

		return $this;
	}

	public function error() {
		return $this->error;
	}

	public function results() {
		return $this->result;
	}
	
	public function first() {
		return $this->results()[0];
	}

	public function rowCount() {
		return $this->count;
	}
}

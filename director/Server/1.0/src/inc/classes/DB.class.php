<?php
/**
 * Database wrapper class.
 * 
 * ### About
 *  
 * *	Filename : DB.class.php
 * *	Create data : 2015-05-08
 * *	Version : 1.0
 *  
 * ### Description
 *  
 * This class is used to perform multiple database operations. This class
 * should only be created by the getInstance() method. This has the 
 * advantage that the whole PHP application uses the same database instance
 * and also prevent unnecessary database connections.
 *  
 * ### List of changes
 *  
 * *	2015-05-07 : Created file.
 * *	2015-05-08 : Added functions action() and get().
 * *	2015-05-11 : Adding comments + cleanup. Adding phpDocumentor comments.
 *  
 * ### License
 *  
 * Copyright (C) 2015  Pol Warnimont
 *  
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *  
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *  
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @author Pol Warnimont <pwarnimo@gmail.com>
 * @copyright 2015 Pol Warnimont
 * @license AGPLv3
 * @license http://www.gnu.org/licenses/agpl.html 
 */
class DB {
	/** @var DB $_instance Contains an instance of this class. */
	private static $_instance = null;
	/** @var PDO $_pdo Contains the PDO object. */
	private $_pdo;
	/** @var Object $_query Contains the PDO query object.  */
	private $_query;
	/** @var boolean $_error Contains the query execution status. */
	private $_error = false;
	/** @var Object $_result Contains the results of the executed query. */
	private $_result;
	/** @var int $_count Row count of the resultset. */
	private $_count = 0;

	/**
	 * Constructor for the DB class.
	 *
	 * The constructor creates a new PDO object and stores it in the $_pdo variable.
	 * The constructor is only called by the getInstance() method once. The
	 * configuration for the database is loaded from the config array by using the
	 * Conig class (Singelton pattern).
	 */
	private function __construct() {
		try {
			$this->_pdo = new PDO("mysql:host=" . Config::get("mysql/host") . ";dbname=" . Config::get("mysql/dbname"), Config::get("mysql/user"), Config::get("mysql/pass"));
		}
		catch (PDOException $e) {
			die($e->getMessage());
		}
	}

	/**
	 * Get an instance of the DB class.
	 *
	 * This function checks if there is an existing instance of this class. If not
	 * it will call the constructor __construct(). This ensures that there is only
	 * one instance of the DB class for the whole PHP application and prevents
	 * unnecessary database connections.
	 *
	 * @return DB Returns an instance of this class.
	 */
	public static function getInstance() {
		if (!isset(self::$_instance)) {
			self::$_instance = new DB();
		}

		return self::$_instance;
	}

	/**
	 * Perform a query.
	 *
	 * This method is used to perform a database query. The query is stored in the
	 * $sql parameter. The query is a prepared statement and all the parameters
	 * for the query will be bound to this query in the foreach loop. After the
	 * query has been executed, the results will be stored in $_result variable.
	 *
	 * @param String $sql SQL query which should be executed.
	 * @param Array $params A list of parameters for the query.
	 * @return Object Returns an instance of itself.
	 */
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

	/**
	 * Check for query error.
	 *  
	 * This method will return the error status for a query.
	 *
	 * @return boolean Returns the contents of $_error.
	 */
	public function error() {
		return $this->_error;
	}

	/**
	 * Get query results.
	 *
	 * This method returns a stored query resultset. This method is normally used
	 * after calling the query() method.
	 *
	 * @return Object Returns the resultset of a query stored in $_result.
	 */
	public function results() {
		return $this->_result;
	}

	/**
	 * Get first result of query.
	 *
	 * This method returns the first entry of a resultset. The method is 
	 * essentially the same as results() only that it is limited to one
	 * result.
	 *
	 * @return Object Returns the first item of a resultset stored in $_result.
	 */
	public function first() {
		return $this->results()[0];
	}

	/**
	 * Get row count.
	 *
	 * This method returns the count of rows from a resultset.
	 *
	 * @return int Returns a the count stored in $_count.
	 */
	public function rowCount() {
		return $this->_count;
	}
}

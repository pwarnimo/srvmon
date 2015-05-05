<?php
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
	}

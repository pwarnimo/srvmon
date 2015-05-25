<?php
	class ServerMngr {
		private $_servers = array();
		private $_OS = array();
		private $_manufacturers = array();
		private $_types = array();
		private $_db;

		public function __construct() {
			$this->_db = DB::getInstance();
		}

		public function getOS($id = -1) {
			if (!$this->_db->query("CALL getOS(?, @err)", array($id))->error()) {
				if ($this->_db->rowCount() === 1) {
					return $this->_db->first();
				}
				else {
					$arrReturn = array();

					foreach($this->_db->results() as $result) {
						//$arrReturn, $result;
					}

					return $arrReturn;
				}
			}

			return false;
		}

		public function getHardware($id = -1) {
			if (!$this->_db->query("CALL getHardware(?, @err)", array($id))->error()) {
			}

			return false;
		}

		public function getType() {
		}

		public function getServerFromDB($id = -1, $format = false) {
			if (!$this->_db->query("CALL getServer(?, ?, @err)", array($id, $format))->error()) {
				$arrTmp = array();

				foreach ($this->_db->results() as $server) {
					array_push($arrTmp, $server);
				}

				return $arrTmp;
			}
		}

		public function serverToJSON($id = -1) {
			if ($id === -1) {
				$arr = array();

				foreach ($this->_servers as $server) {
					array_push($arr, $server->getServerData());
				}

				return json_encode($arr);
			}
			else {
				return json_encode($this->_servers[$id]->getServerData());
			}

			return false;
		}
	}
?>

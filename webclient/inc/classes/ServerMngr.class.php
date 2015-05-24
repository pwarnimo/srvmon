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
					return json_encode($this->_db->first());
				}
				else {
					$arrReturn = array();

					foreach($this->_db->results() as $result) {
						array_push($arrReturn, $result);
					}

					return json_encode($arrReturn);
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
				foreach ($this->_db->results() as $server) {
					$this->_servers[$server->idServer] = new Server(
						$server->idServer,
						$server->dtHostname,
						$server->dtIPAddress,
						$server->dtDescription,
						$server->fiType,
						$server->fiOS,
						$server->fiHardware,
						$server->dtEnabled,
						$server->fiResponsible
					);
				}
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

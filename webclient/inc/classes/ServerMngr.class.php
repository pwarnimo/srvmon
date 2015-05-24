<?php
	class ServerMngr {
		private $_servers = array();
		private $_db;

		public function __construct() {
			$this->_db = DB::getInstance();
		}

		public function getServerFromDB($id = -1, $format = false) {
			if (!$this->_db->query("CALL getServer(?, ?, @err)", array($id, $format))->error()) {
				foreach ($this->_db->results() as $server) {
					//array_push($this->_servers, 
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
			$arr = array();

			foreach ($this->_servers as $server) {
				array_push($arr, $server->getServerData());
			}

			return json_encode($arr);
		}
	}
?>

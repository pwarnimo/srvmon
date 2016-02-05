<?php
class Server {
	private $_id;
	private $_data = array();
	private $_hostname;
	private $_ipaddress;
	private $_description;
	private $_type;
	private $_os;
	private $_model;
	private $_status;
	private $_responsible;
	private $_db;

	public function __construct($id = null, $hostname, $ipaddress, $description, $type, $os, $model, $status, $responsible) {
		$this->_data = array(
			"id" => $id,
			"hostname" => $hostname,
			"ipaddress" => $ipaddress,
			"description" => $description,
			"type" => $type,
			"os" => $os,
			"model" => $model,
			"status" => $status,
			"responsible" => $responsible
		);
	}

	public function getServerData() {
		return $this->_data;
	}

	public function createServer() {
	}

	public function updateServerData() {
	}

	public function deleteServer() {
	}
}

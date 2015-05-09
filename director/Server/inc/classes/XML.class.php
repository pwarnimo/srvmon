<?php
/* File        : XML.class.php
 * Author(s)   : Pol Warnimont 
 * Create date : 2015-05-08
 * Version     : 0.5
 *
 * Description : Generates XML code.
 * 
 * Changelog
 * ---------
 *  2015-05-08 : Created file.
 *  2015-05-09 : Adding methods sendServices() and getServiceResults().
 *               Adding method updateService().
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

class XML {
	private $db;

	public function __construct() {
		$this->db = DB::getInstance();
	}

	public function test() {
		$this->db->query("SELECT * FROM tblService");
		
		return $this->db->first()->dtCaption;
	}

	public function sendServices($hostid) {
		$xml = new DOMDocument("1.0");

		$root = $xml->createElement("message");
		
		$cmd = $xml->createAttribute("action");
		$cmd->value = "getServices";
		$hid = $xml->createAttribute("hostid");
		$hid->value = $hostid;
		$root->appendChild($cmd);
		$root->appendChild($hid);

		$this->db->query("CALL getServicesForServer(?,-1,1,@err)", array($hostid));
		$results = $this->db->results();

		//return print_r($results);

		foreach ($results as $result) {
			$service = $xml->createElement("service");
			$sid = $xml->createAttribute("sid");
			$sid->value = $result->idService;
			$cmd = $xml->createAttribute("cmd");
			$cmd->value = $result->dtCheckCommand;

			$service->appendChild($sid);
			$service->appendChild($cmd);

			$root->appendChild($service);
		}

		$xml->appendChild($root);

		return $xml->saveXML();
	}

	public function getServiceResults($hostid, $serviceid) {
		$xml = new DOMDocument("1.0");

		$root = $xml->createElement("message");

		$cmd = $xml->createAttribute("action");
		$cmd->value = "getServiceResults";
		$hid = $xml->createAttribute("hid");
		$hid->value = $hostid;
		$sid = $xml->createAttribute("sid");
		$sid->value = $serviceid;

		$root->appendChild($cmd);
		$root->appendChild($hid);
		$root->appendChild($sid);

		//$serviceid = 2;

		$this->db->query("CALL getServicesForServer(?, ?, 2, @err)", array($hostid, $serviceid));
		$result = $this->db->first();

		$service = $xml->createElement("service");

		$sid = $xml->createAttribute("sid");
		$sid->value = $result->idService;

		$val = $xml->createAttribute("val");
		$val->value = $result->dtValue;

		$service->appendChild($sid);
		$service->appendChild($val);

		$root->appendChild($service);

		$xml->appendChild($root);

		return $xml->saveXML();
	}

	public function getServiceUpdate($hostid, $serviceid, $value, $chkOutput) {
		$this->db->query("CALL updateServerServiceStatus(?, ?, ?, ?, @err)", array($hostid, $serviceid, $value, $chkOutput));

		$xml = new DOMDocument("1.0");

		$root = $xml->createElement("message");

		$action = $xml->createAttribute("action");
		$action->value = "updateServiceData";
		$status = $xml->createAttribute("status");
		$status->value = "0";

		$root->appendChild($action);
		$root->appendChild($status);

		$xml->appendChild($root);

		return $xml->saveXML();
	}
}

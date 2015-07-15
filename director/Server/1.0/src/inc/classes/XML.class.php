<?php
/**
 * XML generator class.
 *
 * ### About 
 *  
 * *	Filename : XML.class.php
 * *	Create date : 2015-05-08
 * *	Version : 1.0
 *  
 * ### Description
 *  
 * This class is used to generate the XML for the multiple service checks. A
 * service check is retrieved from the database and the XML class then 
 * generates the XML code which will be transmitted to the client agent.
 *  
 * ### List of changes
 *  
 *	*	2015-05-08 : Created file.
 * *	2015-05-09 : Adding methods sendService() + getServiceResults() + updateService.
 *	*	2015-05-11 : Reworked class. Adding phpDocumentor comments.
 * *	2015-05-14 : Added function for retrieving host ID.
 * *	2015-05-20 : Final bugfixing + Adding comments.
 * *  2015-07-13 : Adding additional functions.
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
class XML {
	/** @var DB $db_ Instance of the database */
	private $_db;

	/**
	 * Constructor for the XML class.
	 *
	 * When an instance is created of this class, then the constructor will
	 * try to get an instance of the database and stores it inside $_db.
	 */
	public function __construct() {
		$this->_db = DB::getInstance();
	}

	/**
	 * Create an XML document.
	 *
	 * This function is used to create an XML document. The standard XML
	 * document for the SRVMON agents contains the root node "srvmon" and
	 * has a single child node which is called "message". The message node
	 * must have the attributes "hid" (Host ID) and "action". Optionally
	 * other attributes can be defined in the $attrs array.
	 *
	 * @param String $action Name of the action which has been performed.
	 * @param int $hostid ID number of the agent host.
	 * @param Array $attrs Optional array with additional parameters.
	 * @return DOMDocument Returns the created XML document object.
	 */
	private function createNewXMLMessage($action, $hostid, $attrs = array()) {
		$xml = new DOMDocument("1.0");
		$root = $xml->createElement("srvmon");

		$msg = $xml->createElement("message");

		$cmd = $xml->createAttribute("action");
		$cmd->value = $action;
		$hid = $xml->createAttribute("hid");
		$hid->value = $hostid;

		foreach ($attrs as $attr => $val) {
			$tmpAttr = $xml->createAttribute($attr);
			$tmpAttr->value = $val;
			$msg->appendChild($tmpAttr);
		}

		$msg->appendChild($cmd);
		$msg->appendChild($hid);

		$root->appendChild($msg);
		$xml->appendChild($root);
		
		return $xml;
	}

	/**
	 * Output services XML.
	 *
	 * This method retrieves all available services for the given host by
	 * its ID and then generates the appropriate XML code for the retrieved
	 * services. A node called "service" will be created for each service.
	 * The service node is then going to be appended on the message node. A
	 * service node has an attribute "sid" for the service id number and
	 * has an attribute "cmd" for the check commad. Additionally, an 
	 * attribute "qrystatus" will be added to the message node. This 
	 * attribute is used to tell the agent if the query was successful.
	 *
	 * @param int $hostid ID number of the agent host.
	 * @return String Returns the XML document as string.
	 */
	public function sendServicesXML($hostid) {
		$xml = $this->createNewXMLMessage("getServices", $hostid);

		$msg = $xml->getElementsByTagName("message")->item(0);

		if (!$this->_db->query("CALL getServicesForServer(?,-1,1,@err)", array($hostid))->error()) {
			$stat = $xml->createAttribute("qrystatus");
			$stat->value = "0";

			foreach ($this->_db->results() as $result) {
				$service = $xml->createElement("service");

				$sid = $xml->createAttribute("sid");
				$sid->value = escape($result->idService);
				$cmd = $xml->createAttribute("cmd");
				$cmd->value = escape($result->dtCheckCommand);
				$param = $xml->createAttribute("param");
				$param->value = escape($result->dtParameters);

				$service->appendChild($sid);
				$service->appendChild($cmd);
				$service->appendChild($param);

				$msg->appendChild($service);
			}
		}
		else {
			$stat = $xml->createAttribute("qrystatus");
			$stat->value = "1";
		}

		$msg->appendChild($stat);

		return $xml->saveXML();
	}

	/**
	 * Return the check results for a service.
	 *
	 * This method returns the results of a service check from the database.
	 * This method generates a single "service" node, which has the
	 * attributes "sid" for the service ID, "value" for the check return 
	 * value and "output" for the check script output. This method also 
	 * makes use of the "qrystatus" attribute.
	 *
	 * @param int $hostid ID number of the agent host.
	 * @param int $serviceid ID number of the service check.
	 * @return String Returns the XML document as string.
	 */
	public function sendServiceResultsXML($hostid, $serviceid) {
		$xml = $this->createNewXMLMessage("getServices", $hostid, array("sid" => $serviceid));
		
		$msg = $xml->getElementsByTagName("message")->item(0);

		if (!$this->_db->query("CALL getServicesForServer(?,?,2,@err)", array($hostid, $serviceid))->error()) {
			$stat = $xml->createAttribute("qrystatus");
			$stat->value = "0";

			$service = $xml->createElement("service");

			$result = $this->_db->first();

			$sid = $xml->createAttribute("sid");
			$sid->value = escape($result->idService);
			$val = $xml->createAttribute("value");
			$val->value = escape($result->dtValue);

			$service->appendChild($sid);
			$service->appendChild($val);

			$msg->appendChild($service);
		}
		else {
			$stat = $xml->createAttribute("qrystatus");
			$stat->value = "1";
		}

		$msg->appendChild($stat);

		return $xml->saveXML();
	}

	/**
	 * Update a service check status.
	 *
	 * This method is used to update the values of a service check.
	 *
	 * @param int $hostid ID number of the agent host.
	 * @param int $serviceid ID number of the service check.
	 * @param int $value Return value of the service check script.
	 * @param String $chkOuput Output of the service check script.
	 * @return String Returns the XML document as string.
	 */
	public function updateServiceXML($hostid, $serviceid, $value, $chkOutput) {
		$xml = $this->createNewXMLMessage("updateService", $hostid, array("sid" => $serviceid));
		
		$msg = $xml->getElementsByTagName("message")->item(0);

		if (!$this->_db->query("CALL updateServerServiceStatus(?,?,?,?,@err)", array($hostid, $serviceid, $value, $chkOutput))->error()) {
			$stat = $xml->createAttribute("qrystatus");
			$stat->value = "0";
		}
		else {
			$stat = $xml->createAttribute("qrystatus");
			$stat->value = "1";
		}

		$msg->appendChild($stat);

		return $xml->saveXML();
	}

	/**
	 * Get the agent host ID.
	 *
	 * This method is used to get the host ID for a agent host. The
	 * ID will be determined by the hostname.
	 *
	 * @param String $hostname Hostname of the agent host.
	 * @return String Returns the XML document as a string.
	 */
	public function sendHostID($hostname) {
		$xml = $this->createNewXMLMessage("getHostID", $hostname);
		$msg = $xml->getElementsByTagName("message")->item(0);

		if (!$this->_db->query("SELECT getServerID(?) AS idServer", array($hostname))->error()) {
			$result = $this->_db->first();
			$hostid = escape($result->idServer);

			$hid = $xml->createAttribute("hostid");
			$hid->value = $hostid;
			$stat = $xml->createAttribute("qrystatus");
			$stat->value = "0";

			$msg->appendChild($hid);
		}
		else {
			$stat = $xml->createAttribute("qrystatus");
			$stat->value = "1";
		}

		$msg->appendChild($stat);

		return $xml->saveXML();
	}
	
	public function sendError($action, $hostid, $code) {
		$xml = $this->createNewXMLMessage($action, $hostid, array("error" => $code));

		return $xml->saveXML();
	}

	public function sendOfflineServers() {
		$xml = $this->createNewXMLMessage("getOfflineServers", -1);

		$msg = $xml->getElementsByTagName("message")->item(0);
		$stat = $xml->createAttribute("qrystatus");

		if (!DB::getInstance()->query("SELECT idServer, dtHostname, dtIPAddress, FROM tblServer WHERE dtEnabled = FALSE")->error()) {
			if (DB::getInstance()->rowCount() > 0) {
				foreach (DB::getInstance()->results() as $result) {
					$server = $xml->createElement("server");

					foreach ($result as $param => $val) {
						$tmpAttr = $xml->createAttribute($param);
						$tmpAttr->value = escape($val);

						$server->appendChild($tmpAttr);
					}

					$msg->appendChild($server);
				}
				
				$stat->value = "0";
			}
			else {
				$stat->value = "2";
			}
		}
		else {
			$stat->value = "1";
		}

		$msg->appendChild($stat);

		return $xml->saveXML();
	}

	public function sendServiceChecksum($hostid, $serviceid) {
		$xml = $this->createNewXMLMessage("sendServiceChecksum", $hostid, array("sid" => $serviceid));
		
		$msg = $xml->getElementsByTagName("message")->item(0);
	
		if (!DB::getInstance()->query("SELECT dtChecksum FROM tblServer_has_tblService WHERE idServer = ? AND idService = ?", array($hostid, $serviceid))->error()) {
			$checksum = $xml->createAttribute("checksum");
			$checksum->value = escape(DB::getInstance()->first()->dtChecksum);
			$stat = $xml->createAttribute("qrystatus");
			$stat->value = "0";

			$msg->appendChild($checksum);
		}
		else {
			$stat = $xml->createAttribute("qrystatus");
			$stat->value = "1";
		}

		$msg->appendChild($stat);

		return $xml->saveXML();
	}

	public function sendServerList() {
		$xml = $this->createNewXMLMessage("getServerList", -1);
		$msg = $xml->getElementsByTagName("message")->item(0);

		if (!DB::getInstance()->query("CALL getServer(-1,true,@err)", array())->error()) {
			$stat = $xml->createAttribute("qrystatus");
			$stat->value = 0;

			foreach (DB::getInstance()->results() as $server) {
				$serverElement = $xml->createElement("server");

				$hid = $xml->createAttribute("hid");
				$hid->value = escape($server->idServer);
				$hostname = $xml->createAttribute("hostname");
				$hostname->value = escape($server->dtHostname);
				$ipaddress = $xml->createAttribute("ipaddr");
				$ipaddress->value = escape($server->dtIPAddress);
				$enabled = $xml->createAttribute("enabled");
				$enabled->value = escape($server->dtEnabled);

				$serverElement->appendChild($hid);
				$serverElement->appendChild($hostname);
				$serverElement->appendChild($ipaddress);
				$serverElement->appendChild($enabled);

				$msg->appendChild($serverElement);
			}
		}
		else {
			$stat = $xml->createAttribute("qrystatus");
			$stat->value = 1;
		}

		$msg->appendChild($stat);

		return $xml->saveXML();
	}
}

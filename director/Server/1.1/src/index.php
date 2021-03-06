<?php
/* File        : index.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 1.1
 *
 * Description : Waits for XML input from the agents and returns the data.
 *
 * Changelog
 * ---------
 *  2015-05-07 : Created file.
 *  2015-05-09 : Adding methods for retrieving and updating services.
 *  2015-05-11 : Reworked everything.
 *  2015-05-14 : Added function for getting server ID.
 *  2015-05-20 : Final bugfixing + commenting code.
 *  2015-07-08 : Adding AES encryption support.
 *  2015-07-24 : Preparing for package release.
 *  
 * License information
 * -------------------
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

// This include loads all the settings for this web application
require_once "inc/init.php";

/*
 * The file_get_contents command retrieves POST data from the agent hosts.
 * The POST data contains the XML messages from the agents.
 *
 * If no POST data has been received, the default output will be the
 * server version. Else, the XML from the clients will be parsed and the
 * appropriate action will be executed.
 *
 * Please note that the current server version (1.1) needs the PHP option
 * always_populate_raw_post_data set to -1.
 */
if (file_get_contents('php://input') == NULL) {
	echo "<img src=\"img/srvmon.png\" style=\"float:left; padding-right:10px;\"><pre>SRVMON DIRECTOR - SERVER 1.1 P1 with AES support<br>Copyright &copy; 2015  Pol Warnimont<br>The SRVMON DIRECTOR SERVER comes with ABSOLUTELY NO WARRANTY!<br><br>Waiting for input . . .</pre>";
}
else {
	/*
	 * We will now create a new instance of the XML class and look for the
	 * appropriate action in the XML node tree.
	 */
	$xml0 = new XML();
	$xml = simplexml_load_string(Encryptor::decryptData(Config::get("encryption/masterkey"), file_get_contents("php://input")));

	$username = escape($xml->message[0]["username"]);
	$password = escape($xml->message[0]["password"]);

	$user = new User();

	/*
	 * If the user credentials are valid, we can then proceed to parse the
	 * actions.
	 */
	if ($user->checkUser($username, $password)) {
		$action = escape($xml->message[0]["action"]);

		switch ($action) {
			/*
			 * The action getServices will retrieve all available services for
			 * a host.
			 */
			case "getServices":
				$hostid = escape($xml->message[0]["hid"]);

				$xmlres = $xml0->sendServicesXML($hostid);
			break;

			/*
			 * The action getServiceData will retrieve the value of a service
			 * check.
			 */
			case "getServiceData":
				$hostid = escape($xml->message[0]["hid"]);
				$serviceid = escape($xml->message[0]["sid"]);

				$xmlres = $xml0->sendServiceResultsXML($hostid, $serviceid);
			break;
		
			/*
			 * The action updateServiceData will update the service for a host
			 * and also store the service check output in the database.
			 */
			case "updateServiceData":
				$hostid = escape($xml->message[0]["hid"]);
				$serviceid = escape($xml->message[0]["sid"]);
				$val = escape($xml->message[0]["val"]);
				$message = escape($xml->message[0]["msg"]);

				$xmlres = $xml0->updateServiceXML($hostid, $serviceid, $val, $message);
			break;

			/*
			 * The action getHostID return the ID to the agent host. The ID is
			 * fetched from the database by using the agent hosts hostname.
			 */
			case "getHostID":
				$hostname = escape($xml->message[0]["hostname"]);
			
				$xmlres = $xml0->sendHostID($hostname);
			break;

			/*
			 * This action will return the checksum of a service.
			 */
			case "getChecksum":
				$hostid = escape($xml->message[0]["hid"]);
				$serviceid = escape($xml->message[0]["sid"]);

				$xmlres = $xml0->sendServiceChecksum($hostid, $serviceid);
			break;

			/*
			 * This action will return a list of the currently monitored
			 * servers.
			 */
			case "getServerList":
				$xmlres = $xml0->sendServerList();
			break;

			/*
			 * This action will return a complete list of services for
			 * the given host, identified by its ID.
			 */
			case "getFullServiceListForHost":
				$hostid = escape($xml->message[0]["hid"]);

				$xmlres = $xml0->sendFullServicesForHost($hostid);
			break;
		}
	}
	else {
		$action = escape($xml->message[0]["action"]);

		$xmlres = $xml0->sendError($action, -1, 0);
	}

	/*
	 * This will change the document header to XML to make sure that no
	 * HTML will be generated.
	 */
	Header("Content-type: type/xml");
	echo Encryptor::encryptData(Config::get("encryption/masterkey"), $xmlres);
}

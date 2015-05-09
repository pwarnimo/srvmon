<?php
/* File        : index.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 0.1
 *
 * Description : Waits for XML input from the agents and returns the data.
 *
 * Changelog
 * ---------
 *  2015-05-07 : Created file.
 *  2015-05-09 : Adding methods for retrieving and updating services.
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
	require_once "inc/init.php";

	//TESTING
	//echo "<pre style=\"color:#f00;\">DEBUG BEGIN</pre>";

	/*echo "<pre>" . Config::get("mysql/user") . "</pre>";

	$db = DB::getInstance();
	$db->query("CALL getServer(?,TRUE,@err)", array("20"));
	echo "<pre>RES COUNT = " . $db->rowCount() . "</pre>";
	print_r($db->first());

	$xml0 = new XML();
	echo "<pre>" . $xml0->test() . "</pre>";*/

	$tmp = false;
	/*$tmpxml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><message action=\"getServices\" hostid=\"24\"></message>";
	*/
	/*$tmpxml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><message action=\"getServiceResults\" hid=\"24\" sid=\"2\"></message>";*/
	$tmpxml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><message action=\"updateServiceData\" hid=\"24\" sid=\"2\" val=\"0\" msg=\"Check Status OK!\"></message>";

	//echo "<pre style=\"color:#f00;\">DEBUG END</pre>";
	//TESTING

	//if (file_get_contents('php://input') == NULL) {
	if ($tmp === true) {
		echo "<img src=\"img/srvmon.png\" style=\"float:left; padding-right:10px;\"><pre>SRVMON DIRECTOR - SERVER 0.1<br>Copyright &copy; 2015  Pol Warnimont<br>The SRVMON DIRECTOR SERVER comes with ABSOLUTELY NO WARRANTY!<br><br>Waiting for input . . .</pre>";
	}
	else {
		$xml0 = new XML();
		$parser = xml_parser_create();

		xml_parse_into_struct($parser, $tmpxml, $vals, $index);
		xml_parser_free($parser);
	
		$action = $vals[0]["attributes"]["ACTION"];

		switch ($action) {
			case "getServices":
				$hostid = $vals[0]["attributes"]["HOSTID"];

				//echo "Getting services for " . $hostid;
				Header("Content-type: text/xml");
				echo $xml0->sendServices($hostid);
			break;

			case "getServiceData":
				$hid = $vals[0]["attributes"]["HID"];
				$sid = $vals[0]["attributes"]["SID"];

				Header("Content-type: text/xml");
				echo $xml0->getServiceResults($hid, $sid);
			break;

			case "updateServiceData":
				$hid = $vals[0]["attributes"]["HID"];
				$sid = $vals[0]["attributes"]["SID"];
				$val = $vals[0]["attributes"]["VAL"];
				$message = $vals[0]["attributes"]["MSG"];

				Header("Content-type: text/xml");
				echo $xml0->getServiceUpdate($hid, $sid, $val, $message);
			break;
		}
	}
?>

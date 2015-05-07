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
	echo "<pre style=\"color:#f00;\">DEBUG BEGIN</pre>";

	echo "<pre>" . Config::get("mysql/user") . "</pre>";

	$db = DB::getInstance();
	$db->query("CALL getServer(?,TRUE,@err)", array("20"));
	echo "<pre>RES COUNT = " . $db->rowCount() . "</pre>";
	print_r($db->first());

	echo "<pre style=\"color:#f00;\">DEBUG END</pre>";
	//TESTING

	if (file_get_contents('php://input') == NULL) {
		echo "<pre>SRVMON DIRECTOR - SERVER 0.1<br>Copyright &copy; 2015  Pol Warnimont<br>The SRVMON DIRECTOR SERVER comes with ABSOLUTELY NO WARRANTY!<br><br>Waiting for input . . .</pre>";
	}
	else {
		echo "MAIN";
	}
?>

<?php
	include "settings/dbconfig.inc.php";
	
	function __autoload($class_name) {
		require_once "classes/" . $class_name . ".class.php";
	}

	$action = filter_input(INPUT_GET, "action");

	switch ($action) {
		case "getServers" :
			$servermngr = new serversmngr();
			echo $servermngr->printserver();
		break;
	}
?>

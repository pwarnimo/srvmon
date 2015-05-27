<?php
require_once "inc/init.php";

$user = new User();

if (!$user->isLoggedIn()) {
	Redirect::to("index.php");
}

if (Input::exists("get")) {
	switch (Input::get("action")) {
		case "getServer":
			echo json_encode(ServerMngr::getServerFromDB(Input::get("id"), Input::get("format")));
		break;
	}
}

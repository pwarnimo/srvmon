<?php
if (!file_exists(__DIR__ . "/" . $_SERVER["REQUEST_URI"])) {
	$_GET["url"] = $_SERVER["REQUEST_URI"];
}

return false;

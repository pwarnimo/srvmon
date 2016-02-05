<?php
require_once "inc/init.php";

$user = new User();

if ($user->isLoggedIn()) {
	echo "<pre>Logged in : " . escape($user->data()->dtName) . " " . escape($user->data()->dtSurname) . "</pre>";
	echo "<pre><a href=\"logout.php\">LOGOUT</a></pre>";
}
else {
	echo "<pre>Not authorized!</pre>";
}

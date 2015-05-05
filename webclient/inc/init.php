<?php
	session_start();

	$GLOBALS["config"] = array(
		"mysql" => array(
			"host"   => "127.0.0.1",
			"user"   => "sqlusr",
			"pass"   => "q1w2e3!",
			"dbname" => "srvmon"
		),
		"remember" => array(
			"cookieName"   => "hash",
			"cookieExpire" => 604800
		),
		"session" => array(
			"sessionName" => "user"
		)
	);

	spl_autoload_register(function($class) {
		require_once "inc/classes/" . $class . ".class.php";
	});

	require_once "inc/functions/sanitize.php";

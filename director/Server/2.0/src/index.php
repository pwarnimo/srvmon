<?php
use Phalcon\Loader;
use Phalcon\Mvc\Micro;
use Phalcon\Di\FactoryDefault;
use Phalcon\Db\Adapter\Pdo\Mysql as PdoMysql;
use Phalcon\Http\Response;

$loader = new Loader();

$loader->registerDirs(
	array(
		__DIR__ . "/models/"
	)
)->register();

$di = new FactoryDefault();

$di->set("db", function () {
	return new PdoMysql(
		array(
			"host" => "localhost",
			"username" => "srvmonusr",
			"password" => "q1w2e3!",
			"dbname" => "srvmon"
		)
	);
});

$app = new Micro($di);

$app->get('/', function () {
	$response = new Response();

	$response->setJsonContent(
		array(
			"status" => "IDLE",
			"version" => "Director Server 2.0 A1"
		)
	);

	return $response;
});

/*---*/

$app->get("/api/servers", function () use ($app) {
	$phql = "SELECT * FROM Servers";
	$servers = $app->modelsManager->executeQuery($phql);

	$data = array();
	foreach ($servers as $server) {
		$data[] = array(
			"idServer" => $server->idServer,
			"dtHostname" => $server->dtHostname,
			"dtIPAddress" => $server->dtIPAddress,
			"dtEnabled" => $server->dtEnabled
		);
	}

	echo json_encode($data);
});

$app->get("/api/servers/search/{name}", function ($name) use ($app) {
	$phql = "SELECT * FROM Servers WHERE dtHostname LIKE :name:";
	$servers = $app->modelsManager->executeQuery(
		$phql,
		array(
			"name" => "%" . $name . "%"
		)
	);

	$data = array();
	foreach ($servers as $server) {
		$data[] = array(
			"idServer" => $server->idServer,
			"dtHostname" => $server->dtHostname,
			"dtIPAddress" => $server->dtIPAddress,
			"dtEnabled" => $server->dtEnabled
		);
	}

	echo json_encode($data);
});

$app->get("/api/servers/{hostname}/getid", function ($hostname) use ($app) {
	$phql = "SELECT idServer FROM Servers WHERE dtHostname = :hostname:";
	$server = $app->modelsManager->executeQuery(
		$phql,
		array(
			"hostname" => $hostname
		)
	)->getFirst();
	
	$response = new Response();

	if ($server == false) {
		$response->setJsonContent(
			array(
				"status" => "-1"
			)
		);
	}
	else {
		$response->setJsonContent(
			array(
				"status" => "1",
				"id" => $server->idServer
			)
		);
	}

	return $response;
});

$app->get("/api/servers/{id:[0-9]+}", function ($id) use ($app) {
	$phql = "SELECT * FROM Servers WHERE idServer = :id:";
	$server = $app->modelsManager->executeQuery(
		$phql,
		array(
			"id" => $id
		)
	)->getFirst();

	$response = new Response();

	if ($server == false) {
		$response->setJsonContent(
			array(
				"status" => "-1"
			)
		);
	}
	else {
		$response->setJsonContent(
			array(
				"status" => "1",
				"data" => array(
					"idServer" => $server->idServer,
					"dtHostname" => $server->dtHostname,
					"dtIPAddress" => $server->dtIPAddress,
					"dtEnabled" => $server->dtEnabled
				)
			)
		);
	}

	return $response;
});

$app->put("/api/servers/{id:[0-9]+}/enable", function ($id) use ($app) {
	$phql = "UPDATE Servers SET dtEnabled = 1 WHERE idServer = :id:";
	$status = $app->modelsManager->executeQuery(
		$phql,
		array(
			"id" => $id
		)
	);

	$response = new Response();

	if ($status->success() == true) {
		$response->setJsonContent(
			array(
				"status" => "1"
			)
		);
	}
	else {
		$response->setStatusCode(409, "Conflict");

		$errors = array();
		foreach ($status->getMessages() as $message) {
			$errors[] = $message->getMessage();
		}

		$response->setJsonContent(
			array(
				"status" => "-1",
				"messages" => $errors
			)
		);
	}

	return $response;
});

$app->put("/api/servers/{id:[0-9]+}/disable", function ($id) use ($app) {
	$phql = "UPDATE Servers SET dtEnabled = 0 WHERE idServer = :id:";
	$status = $app->modelsManager->executeQuery(
		$phql,
		array(
			"id" => $id
		)
	);

	$response = new Response();

	if ($status->success() == true) {
		$response->setJsonContent(
			array(
				"status" => "1"
			)
		);
	}
	else {
		$response->setStatusCode(409, "Conflict");

		$errors = array();
		foreach ($status->getMessages() as $message) {
			$errors[] = $message->getMessage();
		}

		$response->setJsonContent(
			array(
				"status" => "-1",
				"messages" => $errors
			)
		);
	}

	return $response;
});
/*---*/

$app->notFound(function () use ($app) {
	$app->response->setStatusCode(404, "Not Found")->sendHeaders();
	
	$response = new Response();

	$response->setJsonContent(
		array(
			"status" => "Unknown Operation"
		)
	);

	return $response;
});

$app->handle();

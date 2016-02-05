<?php
use Phalcon\Mvc\View;
use Phalcon\DI\FactoryDefault;
use Phalcon\Mvc\Dispatcher;
use Phalcon\Mvc\Url as UrlProvider;
use Phalcon\Mvc\View\Engine\Volt as VoltEngine;

$di = new FactoryDefault();

//$di->set("dispatcher", function () use ($di) {});

$di->set("url", function () use ($config) {
	$url = new UrlProvider();
	$url->setBaseUri($config->application->baseUri);

	return $url;
});

$di->set("view", function () use ($config) {
	$view = new View();

	$view->setViewsDir(APP_PATH . $config->application->viewsDir);

	$view->registerEngines(
		array(
			".volt" => "volt"
		)
	);

	return $view;
});

$di->set("volt", function($view, $di) {
	$volt = new VoltEngine($view, $di);

	$volt->setOptions(
		array(
			"compilePath" => APP_PATH . "cache/volt/"
		)
	);

	$compiler = $volt->getCompiler();
	$compiler->addFunction("is_a", "is_a");

	return $volt;
}, true);

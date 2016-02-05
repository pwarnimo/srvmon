<?php
use Phalcon\Mvc\Controller;

class ControllerBase extends Controller {
	protected function initialize() {
		$this->tag->prependTitle("SRVMON WebUI // ");
		$this->view->setTemplateAfter("main");
	}
}

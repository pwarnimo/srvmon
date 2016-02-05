<?php
class IndexController extends ControllerBase {
	public function initialize() {
		$this->tag->setTitle("Welcome");
		parent::initialize();
	}
}

<?php
use Phalcon\Mvc\Model;
use Phalcon\Mvc\Model\Message;
use Phalcon\Mvc\Model\Validator\Uniqueness;
use Phalcon\Mvc\Model\Validator\InclusionIn;

class Servers extends Model {
	public function validation() {
		$this->validate(
			new InclusionIn(
				array(
					"field" => "dtEnabled",
					"domain" => array(
						"0",
						"1"
					)
				)
			)
		);

		if ($this->validationHasFailed() == true) {
			return false;
		}
	}

	public function getSource() {
		return "tblServer";
	}
}

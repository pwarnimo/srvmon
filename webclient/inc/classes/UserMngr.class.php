<?php
class UserMngr {
	public static function getUsers() {
		if (!DB::getInstance()->query("SELECT idUser, dtUsername, dtEmail, fiRole, dtTelephone, dtName, dtSurname FROM tblUser")->error()) {
			$arrTmp = array();
			$users = DB::getInstance()->results();

			foreach ($users as $result) {
				array_push($arrTmp, $result);
			}

			return $arrTmp;
		}
		
		return false;
	}
}

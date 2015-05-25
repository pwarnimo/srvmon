<?php
class UserMngr {
	public static function getUsers() {
		//$db = DB::getInstance();

		if (!DB::getInstance()->query("SELECT * FROM tblUser")->error()) {
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

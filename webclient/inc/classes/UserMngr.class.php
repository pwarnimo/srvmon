<?php
class UserMngr {
	public static function getUsers() {
		if (!DB::query("SELECT * FROM tblUser")->error()) {
			$arrTmp = array();

			foreach (DB::results() as $result) {
				array_push($arrTmp, $result);
			}

			return $arrTmp;
		}
		
		return false
	}
}

<?php
class User {
	public function checkUser($username, $password) {
		$user = DB::getInstance()->query("SELECT idUser, dtUsername, dtHash, dtSalt FROM tblUser WHERE dtUsername = ?", array($username));

		if ($user->rowCount()) {
			if ($user->first()->dtHash === Hash::make($password, $user->first()->dtSalt)) {
				return true;
			}
		}

		return false;
	}
}

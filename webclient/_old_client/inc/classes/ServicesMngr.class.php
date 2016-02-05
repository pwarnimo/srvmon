<?php
	class ServicesMngr {
		public static function getServicesForServer($sid = -1, $format = 0, $hid) {
			if (!DB::getInstance()->query("CALL getServicesForServer(?,?,?,@err)", array($hid, $sid, $format))->error()) {
				$arrTmp = array();

				foreach (DB::getInstance()->results() as $service) {
					array_push($arrTmp, $service);
				}

				return $arrTmp;
			}

			return false;
		}
	}
?>

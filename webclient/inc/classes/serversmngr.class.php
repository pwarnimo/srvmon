<?php
/*
 * File        : serversmngr.class.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-04-29
 * Version     : 0.1
 *
 * Description : Class for managing servers.
 *
 * Changelog
 * ---------
 *  2015-04-29 : Created class.
 *  2015-04-30 : Added license and headers.
 *
 * License
 * -------
 *  Copyright (C) 2015  Pol Warnimont
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

	class serversmngr {
		private $dbh;

		public function __construct() {
		        $dsn = dbtype . ":dbname=" . database . ";host=" . hostname;
			
			try {
				$this->dbh = new PDO($dsn, username, password);
			}
			catch(PDOException $e) {
				echo "PDO has encountered an error: " + $e->getMessage();
				die();
			}
		}

		public function cltest() {
			echo "SERVERMNGR CLASS OK";
		}

		public function printserver() {
			$qry = "CALL getServer(-1,TRUE,@err)";

			try {
				$stmt = $this->dbh->prepare($qry);

				if ($stmt->execute()) {
					$res = $stmt->fetchAll(PDO::FETCH_ASSOC);

					return json_encode($res);
				}
				else {
					echo "FAIL";
				}
			}
			catch(PDOException $e) {
				echo "PDO has encountered an error: " + $e->getMessage();
				die();
			}
		}
	}
?>

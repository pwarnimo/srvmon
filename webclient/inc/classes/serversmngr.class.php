<?php
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

					print_r($res);
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

<?php
	class ServicesMngr {
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

		public function getServicesForServer($sid, $format) {
			$qry = "CALL getServicesForServer(:sid, -1, :format, @err)";

			try {
				$stmt = $this->dbh->prepare($qry);

				$stmt->bindValue(":sid", $sid);
				$stmt->bindValue(":format", $format);

				if ($stmt->execute()) {
					$res = $stmt->fetchAll(PDO::FETCH_ASSOC);

					return json_encode($res);
				}
				else {
					return json_encode($false);
				}
			}
			catch(PDOException $e) {
				echo "PDO has encountered an error: " + $e->getMessage();
			}
		}
	}
?>

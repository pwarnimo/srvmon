/*---------------------------------------------------------------------------------------------
| Routine     : updateServerServiceStatus.sql
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-22
| Version     : 1.1
| 
| Description : Update the status of a service a for the specified server.
|                 0 : Host OK
|                 1 : Warning
|                 2 : Critical
|                 3 : Unreachable
|                 4 : Pending
|
| Parameters
| ----------
|  IN  : pHID    : ID number of the host.
|  IN  : pSID    : ID number of the service.
|  IN  : pStatus : New status for the service.
|  IN  : pOutput : Output of the check script.
|  OUT : pErr    : Error code in case of a failure.
|                   -2 = Foreign key error
|                   -3 = General SQL error
|                   -4 = General SQL warning
|                   -5 = No data
|                   -6 = Host is down
|
| Changelog
| ---------
|  2015-04-21 : Created procedure.
|  2015-04-22 : Modified procedure for DB 0.41.
|  2015-04-23 : Added checks for host status.
|  2015-04-28 : Modified procedure to accept status messages.
|               Prepared procedure for DB release 1.0.
|  2015-04-29 : Modified procedure for DB 1.0.1.
|  2015-04-30 : Changed license to AGPLv3.
|  2015-05-05 : Using prepared statements.
|
| License information
| -------------------
|  Copyright (C) 2015  Pol Warnimont
|
|  This program is free software: you can redistribute it and/or modify
|  it under the terms of the GNU Affero General Public License as
|  published by the Free Software Foundation, either version 3 of the
|  License, or (at your option) any later version.
|
|  This program is distributed in the hope that it will be useful,
|  but WITHOUT ANY WARRANTY; without even the implied warranty of
|  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
|  GNU Affero General Public License for more details.
|
|  You should have received a copy of the GNU Affero General Public License
|  along with this program.  If not, see <http://www.gnu.org/licenses/>.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS updateServerServiceStatus $$
CREATE PROCEDURE updateServerServiceStatus(
	IN  pHID    MEDIUMINT,
	IN  pSID    MEDIUMINT,
	IN  pStatus TINYINT,
	IN  pOutput VARCHAR(45),
	OUT pErr    MEDIUMINT
)
BEGIN
	DECLARE l_enabled BOOLEAN;

	DECLARE no_data CONDITION FOR 1329;
	DECLARE cond_forkey CONDITION FOR 1452;
  
	DECLARE EXIT HANDLER FOR cond_forkey
	BEGIN
   	SET pErr = -2;
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR no_data
	BEGIN
   	SET pErr = -5;
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR sqlexception
	BEGIN
   	SET pErr = -3;
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR sqlwarning
 	BEGIN
   	SET pErr = -4;
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;

	SELECT dtEnabled 
	INTO l_enabled
	FROM tblServer
	WHERE idServer = pHID;

	IF l_enabled = TRUE THEN
		BEGIN
			SET @qry = "UPDATE tblServer_has_tblService SET dtValue = ?, dtScriptOutput = ? WHERE idServer = ? AND idService = ?";

      	START TRANSACTION;
				SET @p1 = pStatus;
				SET @p2 = pOutput;
				SET @p3 = pHID;
				SET @p4 = pSID;

				PREPARE STMT FROM @qry;
				EXECUTE STMT USING @p1, @p2, @p3, @p4;
				DEALLOCATE PREPARE STMT;

				SET pErr = 0;
			COMMIT;
		END;
	ELSE
		BEGIN
      	SET pErr = -6;
		END;
	END IF;
END $$

DELIMITER ;

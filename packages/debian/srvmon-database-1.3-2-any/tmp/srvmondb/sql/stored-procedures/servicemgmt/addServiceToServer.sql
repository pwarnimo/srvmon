/*---------------------------------------------------------------------------------------------
| Routine     : addServiceToServer
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 1.1 R1
| 
| Description : Add an existing service to a server. By default, dtValue will be set to 4.
|                0 = Host OK
|                1 = Warning
|                2 = Critical
|                3 = Unreachable
|                4 = Pending
|
| Parameters
| ----------
|  IN  : pHID : ID number of the host.
|  IN  : pSID : ID number of the service.
|  OUT : pErr : Exit code of the procedure.
|                 0 : Query OK
|                -1 : Duplicate ID
|                -2 : Foreign key error
|                -3 : General SQL error
|                -4 : General SQL warning
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
|  2015-04-21 : Bugfixing and cleanup.
|  2015-04-28 : Prepared procedure for DB release 1.0.
|  2015-04-29 : Modified procedure for DB 1.0.1.
|  2015-04-30 : Changed license to AGPLv3.
|  2015-05-02 : Fixed bug -> dtLastCheck = dtLastCheckTS.
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

DROP PROCEDURE IF EXISTS addServiceToServer $$
CREATE PROCEDURE addServiceToServer(
	IN  pHID MEDIUMINT,
	IN  pSID MEDIUMINT,
	OUT pErr MEDIUMINT
)
BEGIN
	DECLARE cond_dupkey CONDITION FOR 1062;
	DECLARE cond_forkey CONDITION FOR 1452;

	DECLARE EXIT HANDLER FOR cond_dupkey
	BEGIN
   	SET pErr = -1;
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR cond_forkey
	BEGIN
   	SET pErr = -2;
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

	SET @qry = "INSERT INTO tblServer_has_tblService (idServer, idService, dtValue, dtScriptOutput, dtLastCheckTS) VALUES (?, ?, 4, 'Check Pending!', NULL)";

	START TRANSACTION;
		SET @p1 = pHID;
		SET @p2 = pSID;

		PREPARE STMT FROM @qry;
		EXECUTE STMT USING @p1, @p2;
		DEALLOCATE PREPARE STMT;

   	SET pErr = 0;
	COMMIT;
END $$

DELIMITER ;

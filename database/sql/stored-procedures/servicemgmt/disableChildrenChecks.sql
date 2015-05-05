/*---------------------------------------------------------------------------------------------
| Routine     : disableChildrenChecks.sql
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-22
| Version     : 1.1
| 
| Description : Disable all children if parent is down and set services to unreachable.
|
| Parameters
| ----------
|  IN  : pID  : ID number of the parent.
|  OUT : pErr : Error code in case of a failure.
|                 0 = Query OK
|                -2 = Foreign key error
|                -3 = General SQL error
|                -4 = General SQL warning
|                -5 = No data
|
| Changelog
| ---------
|  2015-04-22 : Created procedure.
|  2015-04-23 : Minor modifications.
|  2015-04-28 : Modified procedure for DB release 1.0.
|  2015-04-29 : Modified procedure for DB 1.0.1.
|  2015-04-30 : Changed license to AGPLv3.
|  2015-05-02 : Fixed parent checks.
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

DROP PROCEDURE IF EXISTS disableChildrenChecks $$
CREATE PROCEDURE disableChildrenChecks(
	IN  pID  MEDIUMINT,
	OUT pErr MEDIUMINT
)
BEGIN
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

	SET @qry1 = "UPDATE tblServer_has_tblService SET dtValue = 3, dtScriptOutput = 'Service Unreachable!', dtLastCheckTS = NULL WHERE idServer = ?";
	SET @qry2 = "UPDATE tblServer_has_tblService SET dtValue = 3, dtScriptOutput = 'Service Unreachable!', dtLastCheckTS = NULL WHERE idServer IN (SELECT idChild FROM tblParent WHERE idParent = ?)";
	SET @qry3 = "UPDATE tblServer SET dtEnabled = FALSE WHERE idServer IN (SELECT idChild FROM tblParent WHERE idParent = ?)";

	START TRANSACTION;
		SET @p1 = pID;

		PREPARE STMT FROM @qry1;
		EXECUTE STMT USING @p1;
		DEALLOCATE PREPARE STMT;

		PREPARE STMT FROM @qry2;
		EXECUTE STMT USING @p1;
		DEALLOCATE PREPARE STMT;

		PREPARE STMT FROM @qry3;
		EXECUTE STMT USING @p1;
		DEALLOCATE PREPARE STMT;

		SET pErr = 0;
	COMMIT;
END $$

DELIMITER ;

/*---------------------------------------------------------------------------------------------
| Routine     : modifyServer.sql
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-21
| Version     : 1.1 R1
| 
| Description : Update records of a given server (By ID).
|
| Parameters
| ----------
|  IN  : pID          : ID of the server to modify.
|  IN  : pHostname    : New hostname of the server.
|  IN  : pIPAddress   : New IP address of the server.
|  IN  : pDescription : New description for the server.
|  IN  : pOS          : New operating system of the server (foreign key to tblOS).
|  IN  : pType        : New type of the server (foreign key to tblType).
|  IN  : pEnabled     : Set system status of the host (TRUE = Online & FALSE = Offline).
|  OUT : pErr         : Error ID in case of a failure.
|                         0 = Query OK
|                        -3 = General SQL error
|                        -4 = General SQL warning
|                        -5 = Server for ID not found.
|
| Changelog
| ---------
|  2015-04-21 : Created procedure.
|  2015-04-22 : Optimizing procedure for DB 0.42.
|  2015-04-28 : Prepared procedure for DB release 1.0.
|  2015-04-30 : Changed license to AGPLv3.
|  2015-05-06 : Using prepared statements.
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

DROP PROCEDURE IF EXISTS modifyServer $$
CREATE PROCEDURE modifyServer(
	IN  pID          MEDIUMINT,
	IN  pHostname    VARCHAR(32),
	IN  pIPAddress   VARCHAR(15),
	IN  pDescription TINYTEXT,
	IN  pOS          MEDIUMINT,
	IN  pType        MEDIUMINT,
	IN  pHardware    MEDIUMINT,
	IN  pResponsible MEDIUMINT,
	OUT pErr         MEDIUMINT
)
BEGIN
	DECLARE no_data CONDITION FOR 1329;

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

	SET @qry = "UPDATE tblServer SET dtHostname = ?, dtIPAddress = ?, dtDescription = ?, fiOS = ?, fiType = ?, fiHardware = ?, fiResponsible = ? WHERE idServer = ?";

	START TRANSACTION;
		SET @p1 = pHostname;
		SET @p2 = pIPAddress;
		SET @p3 = pDescription;
		SET @p4 = pOS;
		SET @p5 = pType;
		SET @p6 = pHardware;
		SET @p7 = pResponsible;
		SET @p8 = pID;
 
		PREPARE STMT FROM @qry;
		EXECUTE STMT USING @p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8;
		DEALLOCATE PREPARE STMT;

		SET pErr = 0;
	COMMIT;
END $$

DELIMITER ;

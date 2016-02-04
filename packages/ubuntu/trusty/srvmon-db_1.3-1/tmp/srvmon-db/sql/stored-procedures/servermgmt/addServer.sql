/*---------------------------------------------------------------------------------------------
| Routine     : addServer
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 1.1 R1
| 
| Description : This procedure is called in order to add a new server to the DB.
|
| Parameters
| ----------
|  IN  : pHostname    : Hostname of the new server.
|  IN  : pIPAddress   : IP Address of the server.
|  IN  : pDescription : Description of the server.
|  IN  : pOS          : Specify the operating system of the server (foreign key to tblOS).
|  IN  : pType        : Specify the type of the server (foreign key to tblType).
|  IN  : pEnabled     : System status of the host (TRUE = Online & FALSE = Offline).
|  OUT : pID          : ID of the newly added server or in case of an error the error id.
|                        -1 = Duplicate ID
|                        -2 = Foreign key error
|                        -3 = General SQL error
|                        -4 = General SQL warning
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
|  2015-04-21 : Bugfixing and cleanup.
|  2015-04-22 : Optimizing procedure for DB 0.42.
|  2015-04-28 : Prepared procedure for DB release 1.0.
|  2015-04-30 : Changed license to AGPLv3.
|  2015-05-06 : Using prepared statements.
|  2016-02-03 : Changed license.
|
| License information
| -------------------
|  Copyright (C) 2016  Pol Warnimont
|
|  This program is free software; you can redistribute it and/or modify
|  it under the terms of the GNU General Public License as published by
|  the Free Software Foundation; either version 2 of the License, or
|  (at your option) any later version.
|
|  This program is distributed in the hope that it will be useful,
|  but WITHOUT ANY WARRANTY; without even the implied warranty of
|  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
|  GNU General Public License for more details.
|
|  You should have received a copy of the GNU General Public License along
|  with this program; if not, write to the Free Software Foundation, Inc.,
|  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS addServer $$
CREATE PROCEDURE addServer(
	IN  pHostname    VARCHAR(32),
	IN  pIPAddress   VARCHAR(15),
	IN  pDescription TINYTEXT,
	IN  pOS          MEDIUMINT,
	IN  pType        MEDIUMINT,
	IN  pHardware    MEDIUMINT,
	IN  pResponsible MEDIUMINT,
	OUT pID          MEDIUMINT
)
BEGIN
	DECLARE dup_key MEDIUMINT DEFAULT 0;
	DECLARE for_key MEDIUMINT DEFAULT 0;
  
	DECLARE cond_dupkey CONDITION FOR 1062;
	DECLARE cond_forkey CONDITION FOR 1452;

	DECLARE EXIT HANDLER FOR cond_dupkey
	BEGIN
   	SET pID = -1;
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR cond_forkey
	BEGIN
   	SET pID = -2;
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR sqlexception
	BEGIN
   	SET pID = -3;
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR sqlwarning
	BEGIN
   	SET pID = -4;
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;

	SET @qry = "INSERT INTO tblServer (dtHostname, dtIPAddress, dtDescription, fiOS, fiType, dtEnabled, fiHardware, fiResponsible) VALUES (?, ?, ?, ?, ?, 0, ?, ?)";

	START TRANSACTION;
		SET @p1 = pHostname;
		SET @p2 = pIPAddress;
		SET @p3 = pDescription;
		SET @p4 = pOS;
		SET @p5 = pType;
		SET @p6 = pHardware;
		SET @p7 = pResponsible;
   	
		PREPARE STMT FROM @qry;
		EXECUTE STMT USING @p1, @p2, @p3, @p4, @p5, @p6, @p7;
		DEALLOCATE PREPARE STMT;

		SET pID = LAST_INSERT_ID();
	COMMIT;
END $$

DELIMITER ;

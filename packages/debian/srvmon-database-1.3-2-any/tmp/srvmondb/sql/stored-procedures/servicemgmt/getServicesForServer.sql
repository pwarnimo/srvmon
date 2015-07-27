/*---------------------------------------------------------------------------------------------
| Routine     : getServicesForServer
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-21
| Version     : 1.2 R1
| 
| Description : Display data of a service for a server.
|
| Parameters
| ----------
|  IN  : pHID  : ID number of the server
|  IN  : pSID  : ID number of a service (all services are displayed if -1).
|  IN  : pFRMT : Chose query.
|                  0 = Display everything
|                  1 = Display check commands only
|                  2 = Values only
|  OUT : pErr  : ID of the newly added service or in case of an error the error id.
|                 -3 = General SQL error
|                 -4 = General SQL warning
|                 -5 = No data
|
| Changelog
| ---------
|  2015-04-21 : Created procedure
|  2015-04-22 : Modified procedure for DB 0.41.
|  2015-04-28 : Modified procedure to display only check commands.
|               Prepared procedure for DB release 1.0.
|  2015-04-29 : Modified procedure for DB 1.0.1.
|  2015-04-30 : Changed license to AGPLv3.
|  2015-05-05 : Using prepared statements.
|  2015-07-09 : Adding field dtParameter to output.
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

DROP PROCEDURE IF EXISTS getServicesForServer $$
CREATE PROCEDURE getServicesForServer(
	IN  pHID  MEDIUMINT,
	IN  pSID  MEDIUMINT,
	IN  pFRMT MEDIUMINT,
	OUT pErr  MEDIUMINT
)
BEGIN
	DECLARE l_errcode MEDIUMINT DEFAULT 0;
  
	DECLARE no_data CONDITION FOR 1329;

	DECLARE CONTINUE HANDLER FOR no_data SET l_errcode = -5;
	DECLARE CONTINUE HANDLER FOR sqlexception SET l_errcode = -3;
	DECLARE CONTINUE HANDLER FOR sqlwarning SET l_errcode = -4;
  
	CASE pFRMT
   	WHEN 0 THEN SET @FIELDS = "SR.idService, dtCaption, dtDescription, dtCheckCommand, dtParameters, dtChecksum, dtValue, dtScriptOutput, dtLastCheckTS, dtNotificationStatus";
   	WHEN 1 THEN SET @FIELDS = "SR.idService, dtCheckCommand, dtParameters, dtChecksum";
   	WHEN 2 THEN SET @FIELDS = "SR.idService, dtValue";
	END CASE;

	IF pSID = -1 THEN
   	BEGIN
			SET @QRY = CONCAT("SELECT ", @FIELDS, " FROM tblServer_has_tblService SR, tblService SE WHERE idServer = ? AND SR.idService = SE.idService");
			SET @p1 = pHID;

			PREPARE STMT FROM @QRY;
			EXECUTE STMT USING @p1;
		END;
	ELSE
   	BEGIN
			SET @QRY = CONCAT("SELECT ", @FIELDS, " FROM tblServer_has_tblService SR, tblService SE WHERE idServer = ? AND SR.idService = SE.idService AND SE.idService = ?");
			SET @p1 = pHID;
			SET @p2 = pSID;
			
			PREPARE STMT FROM @QRY;
			EXECUTE STMT USING @p1, @p2;
   	END;
	END IF;
  
	DEALLOCATE PREPARE STMT;

	SET pErr = l_errcode;
END $$

DELIMITER ;

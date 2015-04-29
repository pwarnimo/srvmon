/*---------------------------------------------------------------------------------------------
| Routine     : getServicesForServer
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-21
| Version     : 1.0
| 
| Description : Display unformatted data for a server.
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
|
| License information
| -------------------
|  Copyright (C) 2015  Pol Warnimont
|
|  This program is free software; you can redistribute it and/or
|  modify it under the terms of the GNU General Public License
|  as published by the Free Software Foundation; either version 2
|  of the License, or (at your option) any later version.
|
|  This program is distributed in the hope that it will be useful,
|  but WITHOUT ANY WARRANTY; without even the implied warranty of
|  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
|  GNU General Public License for more details.
|
|  You should have received a copy of the GNU General Public License
|  along with this program; if not, write to the Free Software
|  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
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
    WHEN 0 THEN SET @FIELDS = "SR.idService, dtCaption, dtDescription, dtCheckCommand, dtValue, dtScriptOutput, dtLastCheckTS";
    WHEN 1 THEN SET @FIELDS = "SR.idService, dtCheckCommand";
    WHEN 2 THEN SET @FIELDS = "SR.idService, dtValue";
  END CASE;
  
  IF pSID = -1 THEN
    BEGIN
      SET @COND = CONCAT("WHERE idServer = ", pHID, " AND SR.idService = SE.idService");
    END;
  ELSE
    BEGIN
      SET @COND = CONCAT("WHERE idServer = ", pHID, " AND SR.idService = SE.idService AND SE.idService = ", pSID);
    END;
  END IF;
  
  SET @QRY = CONCAT("SELECT ", @FIELDS, " FROM tblServer_has_tblService SR, tblService SE ", @COND);
  
  PREPARE STMT FROM @QRY;
  EXECUTE STMT;
  DEALLOCATE PREPARE STMT;

  SET pErr = l_errcode;
END $$

DELIMITER ;

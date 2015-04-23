/*---------------------------------------------------------------------------------------------
| Routine     : getServicesForServer
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-21
| Version     : 0.5
| 
| Description : Display unformatted data for a server.
|
| Parameters
| ----------
|  IN  : pHID : ID number of the server
|  IN  : pSID : ID number of a service (all services are displayed if -1).
|  OUT : pErr : ID of the newly added service or in case of an error the error id.
|                -3 = General SQL error
|                -4 = General SQL warning
|                -5 = No data
|
| Changelog
| ---------
|  2015-04-21 : Created procedure
|  2015-04-22 : Modified procedure for DB 0.41.
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
  IN  pHID MEDIUMINT,
  IN  pSID MEDIUMINT,
  OUT pErr MEDIUMINT
)
BEGIN
  DECLARE l_errcode MEDIUMINT DEFAULT 0;
  
  DECLARE no_data CONDITION FOR 1329;

  DECLARE CONTINUE HANDLER FOR no_data SET l_errcode = -5;
  DECLARE CONTINUE HANDLER FOR sqlexception SET l_errcode = -3;
  DECLARE CONTINUE HANDLER FOR sqlwarning SET l_errcode = -4;
  
  IF pSID = -1 THEN
    BEGIN
      SELECT SR.idService, dtCaption, dtDescription, dtCheckCommand, dtValue
      FROM tblServer_has_tblService SR, tblService SE
      WHERE idServer = pHID
        AND SR.idService = SE.idService;
    END;
  ELSE
    BEGIN
      SELECT SR.idService, dtCaption, dtDescription, dtCheckCommand, dtValue
      FROM tblServer_has_tblService SR, tblService SE
      WHERE idServer = pHID
        AND SR.idService = SE.idService
        AND SE.idService = pSID;
    END;
  END IF;

  SET pErr = l_errcode;
END $$

DELIMITER ;

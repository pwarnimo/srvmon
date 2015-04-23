/*---------------------------------------------------------------------------------------------
| Routine     : getServer
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 0.6
| 
| Description : Display unformatted/formatted data for a server.
|
| Parameters
| ----------
|  IN  : pID     : ID number of the server (Displays all servers if -1).
|  IN  : pFormat : Show output formatted (true) or unformatted (false).
|  OUT : pErr    : Error ID in case of a failure.
|                   -3 = General SQL error
|                   -4 = General SQL warning
|                   -5 = No data
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
|  2015-04-21 : Bugfixing and cleanup.
|  2015-04-22 : Added formatted data function for DB 0.5.
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

DROP PROCEDURE IF EXISTS getServer $$
CREATE PROCEDURE getServer(
  IN  pID     MEDIUMINT,
  IN  pFormat BOOLEAN,
  OUT pErr    MEDIUMINT
)
BEGIN
  DECLARE l_errcode MEDIUMINT DEFAULT 0;
  
  DECLARE no_data CONDITION FOR 1329;

  DECLARE CONTINUE HANDLER FOR no_data SET l_errcode = -5;
  DECLARE CONTINUE HANDLER FOR sqlexception SET l_errcode = -3;
  DECLARE CONTINUE HANDLER FOR sqlwarning SET l_errcode = -4;
  
  IF pFormat = TRUE THEN
    BEGIN
      IF pID = -1 THEN
        BEGIN
          SELECT idServer, dtHostname, dtIPAddress, SR.dtDescription, OS.dtDescription AS dtOS, TY.dtDescription AS dtType, dtEnabled, GR.dtCaption AS dtResponsible, HW.dtModel, HW.dtManufacturer
          FROM tblServer SR, tblOS OS, tblType TY, tblGroup GR, tblHardware HW
          WHERE fiType = idType
            AND fiOS = idOS
            AND fiHardware = idHardware
            AND fiResponsible = idGroup;
        END;
      ELSE
        BEGIN
          SELECT idServer, dtHostname, dtIPAddress, SR.dtDescription, OS.dtDescription AS dtOS, TY.dtDescription AS dtType, dtEnabled, GR.dtCaption AS dtResponsible, HW.dtModel, HW.dtManufacturer
          FROM tblServer SR, tblOS OS, tblType TY, tblGroup GR, tblHardware HW
          WHERE idServer = pID
            AND fiType = idType
            AND fiOS = idOS
            AND fiHardware = idHardware
            AND fiResponsible = idGroup;
        END;
      END IF;
    END;
  ELSE
    BEGIN
      IF pID = -1 THEN
        BEGIN
          SELECT * 
          FROM tblServer;
        END;
      ELSE
        BEGIN
          SELECT *
          FROM tblServer
          WHERE idServer = pID;
        END;
      END IF;
    END;
  END IF;
  SET pErr = l_errcode;
END $$

DELIMITER ;

/*---------------------------------------------------------------------------------------------
| Routine     : getServer
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 1.0
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
|  2015-04-28 : Prepared procedure for DB release 1.0.
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
  
  IF pFORMAT = TRUE THEN
    BEGIN
      SET @FIELDS = "idServer, dtHostname, dtIPAddress, SR.dtDescription, OS.dtDescription AS dtOS, TY.dtDescription AS dtType, dtEnabled, GR.dtCaption AS dtResponsible, HW.dtModel, HW.dtManufacturer";
      SET @TABLES = "tblServer SR, tblOS OS, tblType TY, tblGroup GR, tblHardware HW";
      SET @COND = " WHERE fiType = idType AND fiOS = idOS AND fiHardware = idHardware AND fiResponsible = idGroup";
    END;
  ELSE
    BEGIN
      SET @FIELDS = "*";
      SET @TABLES = "tblServer";
      SET @COND = "";
    END;
  END IF;
  
  SET @QRY = CONCAT("SELECT ", @FIELDS, " FROM ", @TABLES, @COND);
  
  IF pID != -1 THEN
    BEGIN
      IF pFormat = TRUE THEN
        BEGIN
          SET @COND = CONCAT(" AND idServer = ", pID);
        END;
      ELSE
        BEGIN
          SET @COND = CONCAT(" WHERE idServer = ", pID);
        END;
      END IF;
      SET @QRY = CONCAT(@QRY, @COND);
    END;
  END IF;
  
  PREPARE STMT FROM @QRY;
  EXECUTE STMT;
  DEALLOCATE PREPARE STMT;
 
  SET pErr = l_errcode;
END $$

DELIMITER ;

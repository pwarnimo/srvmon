/*---------------------------------------------------------------------------------------------
| Routine     : updateVersionNumber
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 1.0
| 
| Description : Change the version string of the database.
|
| Parameters
| ----------
|  IN  : pVersion : Version string to update.
|  OUT : pErr     : ID of the newly added setting or in case of an error the error id.
|                    -3 = General SQL error
|                    -4 = General SQL warning
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
|  2015-04-21 : Bugfixing and cleanup.
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

DROP PROCEDURE IF EXISTS updateVersionNumber $$
CREATE PROCEDURE updateVersionNumber(
  IN  pVersion VARCHAR(45),
  OUT pErr     MEDIUMINT
)
BEGIN
  DECLARE EXIT HANDLER FOR sqlexception
  BEGIN
    SET pErr = -3;
    ROLLBACK;
  END;

  DECLARE EXIT HANDLER FOR sqlwarning
  BEGIN
    SET pErr = -4;
    ROLLBACK;
  END;

  START TRANSACTION;
    UPDATE tblSetting SET 
      dtValue = pVersion 
    WHERE dtCaption = "version";

    SET pErr = 0;
  COMMIT;
END $$

DELIMITER ;

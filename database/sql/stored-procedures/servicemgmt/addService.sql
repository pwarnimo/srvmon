/*---------------------------------------------------------------------------------------------
| Routine     : addService
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 0.5
| 
| Description : Procedure to add a new service which should be monitored.
|
| Parameters
| ----------
|  IN  : pCaption     : Caption of the service check.
|  IN  : pDescription : Description of the service.
|  IN  : pCommand     : Check command for the new service.
|  OUT : pID          : ID of the newly added service or in case of an error the error id.
|                        -1 = Duplicate ID
|                        -2 = Foreign key error
|                        -3 = General SQL error
|                        -4 = General SQL warning
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
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

DROP PROCEDURE IF EXISTS addService $$
CREATE PROCEDURE addService(
  IN  pCaption     VARCHAR(32),
  IN  pDescription TINYTEXT,
  IN  pCommand     VARCHAR(255),
  OUT pID          MEDIUMINT
)
BEGIN
  DECLARE cond_dupkey CONDITION FOR 1062;
  
  DECLARE EXIT HANDLER FOR cond_dupkey
  BEGIN
    SET pID = -1;
    ROLLBACK;
  END;

  DECLARE EXIT HANDLER FOR sqlexception
  BEGIN
    SET pID = -3;
    ROLLBACK;
  END;

  DECLARE EXIT HANDLER FOR sqlwarning
  BEGIN
    SET pID = -4;
    ROLLBACK;
  END;

  START TRANSACTION;
    INSERT INTO tblService (dtCaption, dtDescription, dtCheckCommand)
    VALUES (pCaption, pDescription, pCommand);

    SET pID = LAST_INSERT_ID();
  COMMIT;
END $$

DELIMITER ;

/*---------------------------------------------------------------------------------------------
| Routine     : addOS
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-22
| Version     : 0.5
| 
| Description : This procedure is called in order to add a new OS to the DB.
|
| Parameters
| ----------
|  IN  : pCaption     : Caption for the new OS.
|  IN  : pDescription : Description of the new OS.
|  OUT : pID          : ID of the newly OS or in case of an error the error id.
|                        -1 = Duplicate ID
|                        -3 = General SQL error
|                        -4 = General SQL warning
|
| Changelog
| ---------
|  2015-04-22 : Created procedure.
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

DROP PROCEDURE IF EXISTS addOS $$
CREATE PROCEDURE addOS(
  IN  pCaption     VARCHAR(32),
  IN  pDescription TINYTEXT,
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
    INSERT INTO tblOS (dtCaption, dtDescription)
      VALUES (pCaption, pDescription);

    SET pID = LAST_INSERT_ID();
  COMMIT;
END $$

DELIMITER ;

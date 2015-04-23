/*---------------------------------------------------------------------------------------------
| Routine     : addParent
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 0.4
| 
| Description : Procedure to add a an existing host as parent to a host.
|
| Parameters
| ----------
|  IN  : pCID : ID number of the child host.
|  IN  : pPID : ID number of the parent host.
|  OUT : pErr : Returns an error code in case of a failure.
|                 0 = Query OK
|                -1 = Duplicate ID
|                -2 = Foreign key error
|                -3 = General SQL error
|                -4 = General SQL warning
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

DROP PROCEDURE IF EXISTS addParent $$
CREATE PROCEDURE addParent(
  IN  pCID MEDIUMINT,
  IN  pPID MEDIUMINT,
  OUT pErr MEDIUMINT
)
BEGIN
  DECLARE cond_dupkey CONDITION FOR 1062;
  DECLARE cond_forkey CONDITION FOR 1452;

  DECLARE EXIT HANDLER FOR cond_dupkey
  BEGIN
    SET pErr = -1;
    ROLLBACK;
  END;

  DECLARE EXIT HANDLER FOR cond_forkey
  BEGIN
    SET pErr = -2;
    ROLLBACK;
  END;

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
    INSERT INTO tblParent 
    VALUES (pCID, pPID);

    SET pErr = 0;
  COMMIT;
END $$

DELIMITER ;

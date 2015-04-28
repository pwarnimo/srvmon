/*---------------------------------------------------------------------------------------------
| Routine     : enableChildrenChecks.sql
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-23
| Version     : 1.0
| 
| Description : Enable all children if parent is up.
|
| Parameters
| ----------
|  IN  : pID  : ID number of the parent.
|  OUT : pErr : Error code in case of a failure.
|                 0 = Query OK
|                -2 = Foreign key error
|                -3 = General SQL error
|                -4 = General SQL warning
|                -5 = No data
|
| Changelof
| ---------
|  2015-04-23 : Created procedure.
|  2015-04-28 : Modified procedure for DB release 1.0.
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

DROP PROCEDURE IF EXISTS enableChildrenChecks $$
CREATE PROCEDURE enableChildrenChecks(
  IN  pID  MEDIUMINT,
  OUT pErr MEDIUMINT
)
BEGIN
  DECLARE no_data CONDITION FOR 1329;
  DECLARE cond_forkey CONDITION FOR 1452;
  
  DECLARE EXIT HANDLER FOR cond_forkey
  BEGIN
    SET pErr = -2;
    ROLLBACK;
  END;

  DECLARE EXIT HANDLER FOR no_data
  BEGIN
    SET pErr = -5;
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
    UPDATE tblServer SET
      dtEnabled = TRUE
    WHERE idServer IN (
      SELECT idChild
      FROM tblParent
      WHERE idParent = pID
    );
 
    SET pErr = 0;
  COMMIT;
END $$

DELIMITER ;

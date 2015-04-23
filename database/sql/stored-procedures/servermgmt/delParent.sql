/*---------------------------------------------------------------------------------------------
| Routine     : delParent
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-21
| Version     : 0.4
| 
| Description : Procedure to delete an host as parent.
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
| Changelog
| ---------
|  2015-04-21 : Created procedure.
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

DROP PROCEDURE IF EXISTS delParent $$
CREATE PROCEDURE delParent(
  IN  pCID MEDIUMINT,
  IN  pPID MEDIUMINT,
  OUT pErr MEDIUMINT
)
BEGIN
  DECLARE no_data CONDITION FOR 1329;

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
    DELETE FROM tblParent 
    WHERE idChild = pCID 
      AND idParent = pPID;

    SET pErr = 0;
  COMMIT;
END $$

DELIMITER ;

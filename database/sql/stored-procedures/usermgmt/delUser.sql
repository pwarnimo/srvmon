/*---------------------------------------------------------------------------------------------
| Routine     : delUser
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-21
| Version     : 0.4
| 
| Description : This procedure deletes a user from the database.
|
| Parameters
| ----------
|  IN  : pID  : ID number of the user.
|  OUT : pErr : Return code of the query.
|                 0 = Duplicate ID
|                -3 = General SQL error
|                -4 = General SQL warning
|                -5 = User not found
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

DROP PROCEDURE IF EXISTS delUser $$
CREATE PROCEDURE delUser(
  IN  pID  MEDIUMINT,
  OUT pErr MEDIUMINT
)
BEGIN
  DECLARE no_data CONDITION FOR 1329;

  DECLARE EXIT HANDLER FOR no_data
  BEGIN
    SET pID = -5;
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
    DELETE FROM tblUser 
    WHERE idUser = pID;

    SET pErr = 0;
  COMMIT;
END $$

DELIMITER ;

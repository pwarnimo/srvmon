/*---------------------------------------------------------------------------------------------
| Routine     : modifyUser.sql
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-21
| Version     : 1.0
| 
| Description : Update records of a given user (By ID).
|
| Parameters
| ----------
|  IN  : pID   : ID of the user to modify.
|  IN  : pHash : New password hash for the user.
|  IN  : pEmail: New E-mail address for the user.
|  IN  : pRole : New user type.
|  OUT : pErr  : ID of the newly added setting or in case of an error the error id.
|                  0 = Query OK
|                 -3 = General SQL error
|                 -4 = General SQL warning
|                 -5 = User for ID not found.
|
| Changelog
| ---------
|  2015-04-21 : Created procedure.
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

DROP PROCEDURE IF EXISTS modifyUser $$
CREATE PROCEDURE modifyUser(
  IN  pID    MEDIUMINT,
  IN  pHash  VARCHAR(1024),
  IN  pEmail VARCHAR(255),
  IN  pRole  MEDIUMINT,
  OUT pErr   MEDIUMINT
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
    UPDATE tblUser SET
      dtHash  = pHash,
      dtEmail = pEmail,
      fiRole  = pRole
    WHERE idUser = pID;
 
    SET pErr = 0;
  COMMIT;
END $$

DELIMITER ;

/*---------------------------------------------------------------------------------------------
| Routine     : addGetUserFormatted
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 1.0
| 
| Description : Get a formatted view of the user data with the role description.
|
| Parameters
| ----------
|  IN  : pID  : User ID of the user. (All users are displayed if set to -1)
|  OUT : pErr : ID of the newly added user or in case of an error the error id.
|                 0 = Query OK
|                -2 = Foreign key error
|                -3 = General SQL error
|                -4 = General SQL warning
|                -5 = User not found
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
|  2015-04-21 : Bugfixing and cleanup.
|  2015-04-28 : Prepared procedure for DB release 1.0.
|  2015-04-30 : Changed license to AGPLv3.
|
| License information
| -------------------
|  Copyright (C) 2015  Pol Warnimont
|
|  This program is free software: you can redistribute it and/or modify
|  it under the terms of the GNU Affero General Public License as
|  published by the Free Software Foundation, either version 3 of the
|  License, or (at your option) any later version.
|
|  This program is distributed in the hope that it will be useful,
|  but WITHOUT ANY WARRANTY; without even the implied warranty of
|  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
|  GNU Affero General Public License for more details.
|
|  You should have received a copy of the GNU Affero General Public License
|  along with this program.  If not, see <http://www.gnu.org/licenses/>.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS getUserFormatted $$
CREATE PROCEDURE getUserFormatted(
	IN  pID  MEDIUMINT,
	OUT pErr MEDIUMINT
)
BEGIN
	DECLARE l_errcode MEDIUMINT DEFAULT 0;

	DECLARE no_data CONDITION FOR 1329;
	DECLARE cond_forkey CONDITION FOR 1452;

	DECLARE CONTINUE HANDLER FOR no_data SET l_errcode = -5;
	DECLARE CONTINUE HANDLER FOR cond_forkey SET l_errcode = -2;
	DECLARE CONTINUE HANDLER FOR sqlexception SET l_errcode = -3;
	DECLARE CONTINUE HANDLER FOR sqlwarning SET l_errcode = -4;

	SET @QRY = "SELECT idUser, dtUsername, dtEmail, dtDescription FROM tblUser, tblRole WHERE fiRole = idRole";

	IF pID != -1 THEN
   	BEGIN
     		SET @QRY = CONCAT(@QRY, " AND idUser = ", pID);
    	END;
	END IF;
  
	PREPARE STMT FROM @QRY;
	EXECUTE STMT;
	DEALLOCATE PREPARE STMT;

	SET pErr = l_errcode;
END $$

DELIMITER ;

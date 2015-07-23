/*---------------------------------------------------------------------------------------------
| Routine     : delUser
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-21
| Version     : 1.1 R1
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
|  2015-04-28 : Prepared procedure for DB release 1.0.
|  2015-04-30 : Changed license to AGPLv3.
|  2015-05-05 : Using prepared statements.
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
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR sqlexception
	BEGIN
   	SET pID = -3;
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR sqlwarning
	BEGIN
   	SET pID = -4;
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;
	
	SET @qry = "DELETE FROM tblUser WHERE idUser = ?";

	START TRANSACTION;
		SET @p1 = pID;

		PREPARE STMT FROM @qry;
		EXECUTE STMT USING @p1;
		DEALLOCATE PREPARE STMT;

		SET pErr = 0;
	COMMIT;
END $$

DELIMITER ;

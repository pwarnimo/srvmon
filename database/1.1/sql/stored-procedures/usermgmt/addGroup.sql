/*---------------------------------------------------------------------------------------------
| Routine     : addGroup
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 1.1 R1
| 
| Description : This function adds a new group to the database.
|
| Parameters
| ----------
|  IN  : pCaption     : Name of the new user group.
|  IN  : pDescription : Description of the new user group.
|  OUT : pID          : ID of the newly added group or error id.
|                        -1 = Duplicate ID
|                        -3 = General SQL error
|                        -4 = General SQL warning
|
| Changelog
| ---------
|  2015-05-05 : Created procedure.
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

DROP PROCEDURE IF EXISTS addGroup $$
CREATE PROCEDURE addGroup(
	IN pCaption     VARCHAR(32),
	IN pDescription VARCHAR(45),
	OUT pID         MEDIUMINT
)
BEGIN
	DECLARE cond_dupkey CONDITION FOR 1062;

	DECLARE EXIT HANDLER FOR cond_dupkey
	BEGIN
		SET pID = -1;
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

	SET @QRY = "INSERT INTO tblGroup (dtCaption, dtDescription) VALUES (?, ?)";

	START TRANSACTION;
		SET @p1 = pCaption;
		SET @p2 = pDescription;

		PREPARE STMT FROM @QRY;
		EXECUTE STMT USING @p1, @p2;
		DEALLOCATE PREPARE STMT;
		
		SET pID = LAST_INSERT_ID();
	COMMIT;
END $$

DELIMITER ;

/*---------------------------------------------------------------------------------------------
| Routine     : addUser
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 1.1
| 
| Description : This function adds a user with its role to the database.
|
| Parameters
| ----------
|  IN  : pUsername  : Username of the new user.
|  IN  : pHash      : Salted password hash of the new user.
|  IN  : pSalt      : Salt used for the password hash.
|  IN  : pEmail     : E-Mail address of the new user.
|  IN  : pRole      : User role (3 = Admin, 2 = Operator, 1 = User).
|  IN  : pTelephone : Phone number of the new user.
|  OUT : pID        : ID of the newly added user or in case of an error the error id.
|                      -1 = Duplicate ID
|                      -2 = Foreign key error
|                      -3 = General SQL error
|                      -4 = General SQL warning
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
|  2015-04-21 : Cleanup and bugfixing.
|  2015-04-28 : Prepared procedure for DB release 1.0.
|  2015-04-30 : Changed license to AGPLv3.
|  2015-05-05 : Using prepared statements for the query.
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

DROP PROCEDURE IF EXISTS addUser $$
CREATE PROCEDURE addUser(
	IN  pUsername  VARCHAR(255),
	IN  pHash      VARCHAR(1024),
	IN  pSalt      VARCHAR(1024),
	IN  pEmail     VARCHAR(255),
	IN  pRole      MEDIUMINT,
	IN  pTelephone VARCHAR(255),
	OUT pID        MEDIUMINT
)
BEGIN
	DECLARE cond_dupkey CONDITION FOR 1062;
	DECLARE cond_forkey CONDITION FOR 1452;

	DECLARE EXIT HANDLER FOR cond_dupkey
	BEGIN
		SET pID = -1;
		DEALLOCATE PREPARE STMT;
		ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR cond_forkey
	BEGIN
		SET pID = -2;
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

	SET @qry = "INSERT INTO tblUser (dtUsername, dtHash, dtSalt, dtEmail, fiRole, dtTelephone) VALUES (?,?,?,?,?,?)";

	START TRANSACTION;
		SET @p1 = pUsername;
		SET @p2 = pHash;
		SET @p3 = pSalt;
		SET @p4 = pEmail;
		SET @p5 = pRole;
		SET @p6 = pTelephone;

		PREPARE STMT FROM @qry;
		EXECUTE STMT USING @p1, @p2, @p3, @p4, @p5, @p6;
		DEALLOCATE PREPARE STMT;

		SET pID = LAST_INSERT_ID();
	COMMIT;
END $$

DELIMITER ;

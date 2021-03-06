/*---------------------------------------------------------------------------------------------
| Routine     : addSetting
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 1.1 R1
| 
| Description : Procedure to add a new service which should be monitored.
|
| Parameters
| ----------
|  IN  : pCaption : Caption of the new setting.
|  IN  : pValue   : Value of the setting.
|  OUT : pID      : ID of the newly added setting or in case of an error the error id.
|                    -1 = Duplicate ID
|                    -3 = General SQL error
|                    -4 = General SQL warning
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
|  2015-04-21 : Bugfixing and cleanup.
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

DROP PROCEDURE IF EXISTS addSetting $$
CREATE PROCEDURE addSetting(
	IN  pCaption VARCHAR(45),
	IN  pValue   VARCHAR(45),
	OUT pID      MEDIUMINT
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

	SET @qry = "INSERT INTO tblSetting (dtCaption, dtValue) VALUES (?, ?)";

	START TRANSACTION;
		SET @p1 = pCaption;
		SET @p2 = pValue;

		PREPARE STMT FROM @qry;
		EXECUTE STMT USING @p1, @p2;
		DEALLOCATE PREPARE STMT;

		SET pID = LAST_INSERT_ID();
	COMMIT;
END $$

DELIMITER ;

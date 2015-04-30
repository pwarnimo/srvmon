/*---------------------------------------------------------------------------------------------
| Routine     : modifyType.sql
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-22
| Version     : 1.0
| 
| Description : Update records of a given device type (By ID).
|
| Parameters
| ----------
|  IN  : pID          : ID of the type to modify.
|  IN  : pCaption     : New caption of the type.
|  IN  : pDescription : New description for the type.
|  OUT : pErr         : Error ID in case of a failure.
|                         0 = Query OK
|                        -3 = General SQL error
|                        -4 = General SQL warning
|                        -5 = No data
|
| Changelog
| ---------
|  2015-04-22 : Created procedure.
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

DROP PROCEDURE IF EXISTS modifyType $$
CREATE PROCEDURE modifyType(
	IN  pID          MEDIUMINT,
	IN  pCaption     VARCHAR(32),
	IN  pDescription TINYTEXT,
	OUT pErr         MEDIUMINT
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
   	UPDATE tblType SET
      	dtCaption = pCaption,
      	dtDescription = pDescription
		WHERE idType = pID;
 
		SET pErr = 0;
	COMMIT;
END $$

DELIMITER ;

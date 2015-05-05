/*---------------------------------------------------------------------------------------------
| Routine     : delHardware
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-05-05
| Version     : 1.0
| 
| Description : Procedure to delete a hardware entry.
|
| Parameters
| ----------
|  IN  : pID  : ID number of the hardware entry.
|  OUT : pErr : Returns an error code in case of a failure.
|                 0 = Query OK
|                -3 = General SQL error
|                -4 = General SQL warning
|                -5 = No data
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

DROP PROCEDURE IF EXISTS delHardware $$
CREATE PROCEDURE delHardware(
	IN  pID  MEDIUMINT,
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
   	DELETE FROM tblHardware 
   	WHERE idHardware = pID;

  		SET pErr = 0;
	COMMIT;
END $$

DELIMITER ;

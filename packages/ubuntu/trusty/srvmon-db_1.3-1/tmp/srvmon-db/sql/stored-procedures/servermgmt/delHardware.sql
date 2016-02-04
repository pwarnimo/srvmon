/*---------------------------------------------------------------------------------------------
| Routine     : delHardware
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-05-05
| Version     : 1.1 R1
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
|  2015-05-06 : Using prepared statements.
|  2016-02-03 : Switching license.
|
| License information
| -------------------
|  Copyright (C) 2016  Pol Warnimont
|
|  This program is free software; you can redistribute it and/or modify
|  it under the terms of the GNU General Public License as published by
|  the Free Software Foundation; either version 2 of the License, or
|  (at your option) any later version.
|
|  This program is distributed in the hope that it will be useful,
|  but WITHOUT ANY WARRANTY; without even the implied warranty of
|  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
|  GNU General Public License for more details.
|
|  You should have received a copy of the GNU General Public License along
|  with this program; if not, write to the Free Software Foundation, Inc.,
|  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
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
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR sqlexception
	BEGIN
   	SET pErr = -3;
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR sqlwarning
	BEGIN
   	SET pErr = -4;
		DEALLOCATE PREPARE STMT;
   	ROLLBACK;
	END;

	SET @qry = "DELETE FROM tblHardware WHERE idHardware = ?";

	START TRANSACTION;
		SET @p1 = pID;

		PREPARE STMT FROM @qry;
		EXECUTE STMT USING @p1;
		DEALLOCATE PREPARE STMT;

  		SET pErr = 0;
	COMMIT;
END $$

DELIMITER ;

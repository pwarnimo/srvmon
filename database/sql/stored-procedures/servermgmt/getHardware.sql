/*---------------------------------------------------------------------------------------------
| Routine     : getHardware
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-05-06
| Version     : 1.0
| 
| Description : Display the data for an hardware entry.
|
| Parameters
| ----------
|  IN  : pID  : ID number of the hw entry (Displays all types if -1).
|  OUT : pErr : Error code in a case of a failure.
|                 0 = Query OK
|                -3 = General SQL error
|                -4 = General SQL warning
|                -5 = No data
|
| Changelog
| ---------
|  2015-05-06 : Created procedure.
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

DROP PROCEDURE IF EXISTS getHardware $$
CREATE PROCEDURE getHardware(
	IN  pID  MEDIUMINT,
	OUT pErr MEDIUMINT
)
BEGIN
	DECLARE l_errcode MEDIUMINT DEFAULT 0;
  
	DECLARE no_data CONDITION FOR 1329;

	DECLARE CONTINUE HANDLER FOR no_data SET l_errcode = -5;
	DECLARE CONTINUE HANDLER FOR sqlexception SET l_errcode = -3;
	DECLARE CONTINUE HANDLER FOR sqlwarning SET l_errcode = -4;
   
	IF pID = -1 THEN
   	BEGIN
			SET @qry = "SELECT * FROM tblHardware";

			PREPARE STMT FROM @qry;
			EXECUTE STMT;
   	END;
	ELSE
		BEGIN
			SET @qry = "SELECT * FROM tblHardware WHERE idHardware = ?";
			
			SET @p1 = pID;

			PREPARE STMT FROM @qry;
			EXECUTE STMT USING @p1;
		END;
	END IF;
  
	DEALLOCATE PREPARE STMT;

	SET pErr = l_errcode;
END $$

DELIMITER ;

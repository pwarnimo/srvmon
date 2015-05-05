/*---------------------------------------------------------------------------------------------
| Routine     : getChildrenForParent
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-22
| Version     : 1.0
| 
| Description : Display the cilds of a parent server.
|
| Parameters
| ----------
|  IN  : pID  : ID number of the parent server.
|  OUT : pErr : Error ID in case of a failure.
|                 0 = Query OK
|                -3 = General SQL error
|                -4 = General SQL warning
|                -5 = No data
|
| Changelog
| ---------
|  2015-04-22 : Created procedure.
|  2015-04-28 : Prepared procedure for DB release 1.0.
|  2015-04-30 : Fixed name of procedure.
|               Changed license to AGPLv3.
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

DROP PROCEDURE IF EXISTS getChildrenForParent $$
CREATE PROCEDURE getChildrenForParent(
	IN  pID  MEDIUMINT,
	OUT pErr MEDIUMINT
)
BEGIN
	DECLARE l_errcode MEDIUMINT DEFAULT 0;
  
	DECLARE no_data CONDITION FOR 1329;

	DECLARE CONTINUE HANDLER FOR no_data SET l_errcode = -5;
	DECLARE CONTINUE HANDLER FOR sqlexception SET l_errcode = -3;
	DECLARE CONTINUE HANDLER FOR sqlwarning SET l_errcode = -4;
  
	SELECT idServer, dtHostname, dtEnabled
	FROM tblServer, tblParent
	WHERE idServer = idChild
		AND idParent = pID;
  
	SET pErr = l_errcode;
END $$

DELIMITER ;

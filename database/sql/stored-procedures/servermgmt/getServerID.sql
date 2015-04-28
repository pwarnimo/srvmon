/*---------------------------------------------------------------------------------------------
| Routine     : getServerID
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 1.0
| 
| Description : Return the ID of a server by using its hostname.
|
| Parameters
| ----------
|  IN  : pCaption : Name of the server to look up.
|                    -3 = Database exception.
|                    -4 = Database warning.
|                    -5 = ID for server not found.
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
|  2015-04-21 : Bugfixing and cleanup.
|  2015-04-28 : Prepared procedure for DB release 1.0.
|
| License information
| -------------------
|  Copyright (C) 2015  Pol Warnimont
|
|  This program is free software; you can redistribute it and/or
|  modify it under the terms of the GNU General Public License
|  as published by the Free Software Foundation; either version 2
|  of the License, or (at your option) any later version.
|
|  This program is distributed in the hope that it will be useful,
|  but WITHOUT ANY WARRANTY; without even the implied warranty of
|  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
|  GNU General Public License for more details.
|
|  You should have received a copy of the GNU General Public License
|  along with this program; if not, write to the Free Software
|  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP FUNCTION IF EXISTS getServerID $$
CREATE FUNCTION getServerID(
  pCaption VARCHAR(45)
) RETURNS MEDIUMINT
BEGIN
  DECLARE l_serverid MEDIUMINT DEFAULT 0;

  DECLARE no_data CONDITION FOR 1329;

  DECLARE CONTINUE HANDLER FOR no_data SET l_serverid = -5;
  DECLARE CONTINUE HANDLER FOR sqlexception SET l_serverid = -3;
  DECLARE CONTINUE HANDLER FOR sqlwarning SET l_serverid = -4;
  
  SELECT idServer 
  INTO l_serverid
  FROM tblServer
  WHERE dtHostname = pCaption;

  RETURN l_serverid;
END $$

DELIMITER ;

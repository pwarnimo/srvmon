/*---------------------------------------------------------------------------------------------
| Routine     : getServerID
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 0.4
| 
| Description : Return the ID of a server by using its hostname.
|
| Parameters
| ----------
|  IN  : pCaption : Name of the server to look up.
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
|  2015-04-21 : Bugfixing and cleanup.
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

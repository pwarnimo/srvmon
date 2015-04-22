/*---------------------------------------------------------------------------------------------
| Routine     : getChildsForParent
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-22
| Version     : 0.5
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
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS getChildsForParent $$
CREATE PROCEDURE getChildsForParent(
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

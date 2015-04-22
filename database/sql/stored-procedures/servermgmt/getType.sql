/*---------------------------------------------------------------------------------------------
| Routine     : getType
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-22
| Version     : 0.5
| 
| Description : Display the data for an OS.
|
| Parameters
| ----------
|  IN  : pID  : ID number of the device type (Displays all types if -1).
|  OUT : pErr : Error code in a case of a failure.
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

DROP PROCEDURE IF EXISTS getType $$
CREATE PROCEDURE getType(
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
      SELECT *
      FROM tblType;
    END;
  ELSE
    BEGIN
      SELECT *
      FROM tblType
      WHERE idType = pID;
    END;
  END IF;

  SET pErr = l_errcode;
END $$

DELIMITER ;

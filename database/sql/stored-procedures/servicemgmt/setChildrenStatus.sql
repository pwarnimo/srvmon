/*---------------------------------------------------------------------------------------------
| Routine     : setChildrenStatus.sql
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-23
| Version     : 0.6
| 
| Description : Disable all children if parent is down and set services to unreachable.
|
| Parameters
| ----------
|  IN  : pID  : ID number of the parent.
|  OUT : pErr : Error code in case of a failure.
|                 0 = Query OK
|                -2 = Foreign key error
|                -3 = General SQL error
|                -4 = General SQL warning
|                -5 = No data
|
| Changelof
| ---------
|  2015-04-23 : Created procedure.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS setChildrenStatus $$
CREATE PROCEDURE setChildrenStatus(
  IN  pID  MEDIUMINT,
  OUT pErr MEDIUMINT
)
BEGIN
  DECLARE no_data CONDITION FOR 1329;
  DECLARE cond_forkey CONDITION FOR 1452;
  
  DECLARE EXIT HANDLER FOR cond_forkey
  BEGIN
    SET pErr = -2;
    ROLLBACK;
  END;

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
    UPDATE tblServer_has_tblService SET
      dtValue = 4
    WHERE idServer IN (
      SELECT idChild
      FROM tblParent
      WHERE idParent = pID
    );
    
    UPDATE tblServer SET
      dtEnabled = FALSE
    WHERE idServer IN (
      SELECT idChild
      FROM tblParent
      WHERE idParent = pID
    );
 
    SET pErr = 0;
  COMMIT;
END $$

DELIMITER ;

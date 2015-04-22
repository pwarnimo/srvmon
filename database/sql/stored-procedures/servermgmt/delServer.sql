/*---------------------------------------------------------------------------------------------
| Routine     : delServer
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-21
| Version     : 0.4
| 
| Description : Procedure to delete a server.
|
| Parameters
| ----------
|  IN  : pID  : ID number of the server.
|  OUT : pErr : Returns an error code in case of a failure.
|                 0 = Query OK
|                -1 = Duplicate ID
|                -2 = Foreign key error
|                -3 = General SQL error
|                -4 = General SQL warning
|
| Changelog
| ---------
|  2015-04-21 : Created procedure.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS delServer $$
CREATE PROCEDURE delServer(
  IN  pCID MEDIUMINT,
  IN  pPID MEDIUMINT,
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
    DELETE FROM tblServer 
    WHERE idServer = pID;

    SET pErr = 0;
  COMMIT;
END $$

DELIMITER ;

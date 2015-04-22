/*---------------------------------------------------------------------------------------------
| Routine     : setSystemStatus.sql
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-22
| Version     : 0.5
| 
| Description : Update the system status of a server.
|
| Parameters
| ----------
|  IN  : pID     : ID of the server to modify.
|  IN  : pStatus : New system status (TRUE = Online & FALSE = Offline).
|  OUT : pErr    : Error ID in case of a failure.
|                     0 = Query OK
|                    -3 = General SQL error
|                    -4 = General SQL warning
|                    -5 = No data
|
| Changelog
| ---------
|  2015-04-22 : Created procedure.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS setSystemStatus $$
CREATE PROCEDURE setSystemStatus(
  IN  pID     MEDIUMINT,
  IN  pStatus BOOLEAN,
  OUT pErr    MEDIUMINT
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
    UPDATE tblServer SET
      dtEnabled = pStatus
    WHERE idServer = pID;
 
    SET pErr = 0;
  COMMIT;
END $$

DELIMITER ;

/*---------------------------------------------------------------------------------------------
| Routine     : updateServerServiceStatus.sql
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-22
| Version     : 0.5
| 
| Description : Update the status of a service a for the specified server.
|                 0 : Host OK
|                 1 : Warning
|                 2 : Critical
|                 3 : Unreachable
|                 4 : Pending
|
| Parameters
| ----------
|  IN  : pHID    : ID number of the host.
|  IN  : pSID    : ID number of the service.
|  IN  : pStatus : New status for the service.
|  OUT : pErr    : Error code in case of a failure.
|                   -2 = Foreign key error
|                   -3 = General SQL error
|                   -4 = General SQL warning
|                   -5 = No data
|
| Changelof
| ---------
|  2015-04-21 : Created procedure.
|  2015-04-22 : Modified procedure for DB 0.41.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS updateServerServiceStatus $$
CREATE PROCEDURE updateServerServiceStatus(
  IN  pHID    MEDIUMINT,
  IN  pSID    MEDIUMINT,
  IN  pStatus TINYINT,
  OUT pErr    MEDIUMINT
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
      dtValue = pStatus
    WHERE idServer = pHID
      AND idService = pSID;
 
    SET pErr = 0;
  COMMIT;
END $$

DELIMITER ;
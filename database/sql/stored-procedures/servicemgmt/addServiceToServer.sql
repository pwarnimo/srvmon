/*---------------------------------------------------------------------------------------------
| Routine     : addServiceToServer
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 0.4
| 
| Description : Add an existing service to a server. By default, dtValue will be set to 4.
|                0 = Host OK
|                1 = Warning
|                2 = Critical
|                3 = Unreachable
|                4 = Pending
|
| Parameters
| ----------
|  IN  : pHID : ID number of the host.
|  IN  : pSID : ID number of the service.
|  OUT : pErr : Exit code of the procedure.
|                 0 : Query OK
|                -1 : Duplicate ID
|                -2 : Foreign key error
|                -3 : General SQL error
|                -4 : General SQL warning
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
|  2015-04-21 : Bugfixing and cleanup.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS addServiceToServer $$
CREATE PROCEDURE addServiceToServer(
  IN  pHID MEDIUMINT,
  IN  pSID MEDIUMINT,
  OUT pErr MEDIUMINT
)
BEGIN
  DECLARE cond_dupkey CONDITION FOR 1062;
  DECLARE cond_forkey CONDITION FOR 1452;

  DECLARE EXIT HANDLER FOR cond_dupkey
  BEGIN
    SET pErr = -1;
    ROLLBACK;
  END;

  DECLARE EXIT HANDLER FOR cond_forkey
  BEGIN
    SET pErr = -2;
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
    INSERT INTO tblServer_has_tblService (idServer, idService, dtValue)
    VALUES (pHID, pSID, 4);

    SET pErr = 0;
  COMMIT;
END $$

DELIMITER ;

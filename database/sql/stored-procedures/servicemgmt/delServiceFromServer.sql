/*---------------------------------------------------------------------------------------------
| Routine     : delServiceFromServer
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 0.4
| 
| Description : Delete a linked service from a server.
|
| Parameters
| ----------
|  IN  : pHID : ID number of the host.
|  IN  : pSID : ID number of the service.
|  OUT : pErr : Exit code of the procedure.
|                 0 : Query OK
|                -3 : General SQL error
|                -4 : General SQL warning
|                -5 : No data
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
|  2015-04-21 : Bugfixing and cleanup.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS delServiceFromServer $$
CREATE PROCEDURE delServiceFromServer(
  IN  pHID MEDIUMINT,
  IN  pSID MEDIUMINT,
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
    DELETE FROM tblServer_has_tblService 
    WHERE idServer = pHID 
      AND idService = pSID;

    SET pErr = 0;
  COMMIT;
END $$

DELIMITER ;

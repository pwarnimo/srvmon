/*---------------------------------------------------------------------------------------------
| Routine     : modifyServer.sql
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-21
| Version     : 0.5
| 
| Description : Update records of a given server (By ID).
|
| Parameters
| ----------
|  IN  : pID          : ID of the server to modify.
|  IN  : pHostname    : New hostname of the server.
|  IN  : pIPAddress   : New IP address of the server.
|  IN  : pDescription : New description for the server.
|  IN  : pOS          : New operating system of the server (foreign key to tblOS).
|  IN  : pType        : New type of the server (foreign key to tblType).
|  IN  : pEnabled     : Set system status of the host (TRUE = Online & FALSE = Offline).
|  OUT : pErr         : Error ID in case of a failure.
|                         0 = Query OK
|                        -3 = General SQL error
|                        -4 = General SQL warning
|                        -5 = Server for ID not found.
|
| Changelog
| ---------
|  2015-04-21 : Created procedure.
|  2015-04-22 : Optimizing procedure for DB 0.42.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS modifyServer $$
CREATE PROCEDURE modifyServer(
  IN  pID          MEDIUMINT,
  IN  pHostname    VARCHAR(32),
  IN  pIPAddress   VARCHAR(15),
  IN  pDescription TINYTEXT,
  IN  pOS          MEDIUMINT,
  IN  pType        MEDIUMINT,
  IN  pEnabled     BOOLEAN,
  OUT pErr         MEDIUMINT
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
      dtHostname = pHostname,
      dtIPAddress = pIPAddress,
      dtDescription = pDescription,
      fiOS = pOS,
      fiType = pType,
      dtEnabled = pEnabled
    WHERE idServer = pID;
 
    SET pErr = 0;
  COMMIT;
END $$

DELIMITER ;

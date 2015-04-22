/*---------------------------------------------------------------------------------------------
| Routine     : addServer
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 0.5
| 
| Description : This procedure is called in order to add a new server to the DB.
|
| Parameters
| ----------
|  IN  : pHostname    : Hostname of the new server.
|  IN  : pIPAddress   : IP Address of the server.
|  IN  : pDescription : Description of the server.
|  IN  : pOS          : Specify the operating system of the server (foreign key to tblOS).
|  IN  : pType        : Specify the type of the server (foreign key to tblType).
|  IN  : pEnabled     : System status of the host (TRUE = Online & FALSE = Offline).
|  OUT : pID          : ID of the newly added server or in case of an error the error id.
|                        -1 = Duplicate ID
|                        -2 = Foreign key error
|                        -3 = General SQL error
|                        -4 = General SQL warning
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
|  2015-04-21 : Bugfixing and cleanup.
|  2015-04-22 : Optimizing procedure for DB 0.42.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS addServer $$
CREATE PROCEDURE addServer(
  IN  pHostname    VARCHAR(32),
  IN  pIPAddress   VARCHAR(15),
  IN  pDescription TINYTEXT,
  IN  pOS          MEDIUMINT,
  IN  pType        MEDIUMINT,
  IN  pEnabled     BOOLEAN,
  OUT pID          MEDIUMINT
)
BEGIN
  DECLARE dup_key MEDIUMINT DEFAULT 0;
  DECLARE for_key MEDIUMINT DEFAULT 0;
  
  DECLARE cond_dupkey CONDITION FOR 1062;
  DECLARE cond_forkey CONDITION FOR 1452;

  DECLARE EXIT HANDLER FOR cond_dupkey
  BEGIN
    SET pID = -1;
    ROLLBACK;
  END;

  DECLARE EXIT HANDLER FOR cond_forkey
  BEGIN
    SET pID = -2;
    ROLLBACK;
  END;

  DECLARE EXIT HANDLER FOR sqlexception
  BEGIN
    SET pID = -3;
    ROLLBACK;
  END;

  DECLARE EXIT HANDLER FOR sqlwarning
  BEGIN
    SET pID = -4;
    ROLLBACK;
  END;

  START TRANSACTION;
    INSERT INTO tblServer (dtHostname, dtIPAddress, dtDescription, fiOS, fiType, dtEnabled)
      VALUES (pHostname, pIPAddress, pDescription, pOS, pType, pEnabled);

    SET pID = LAST_INSERT_ID();
  COMMIT;
END $$

DELIMITER ;

/*---------------------------------------------------------------------------------------------
| Routine     : addSetting
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 0.4
| 
| Description : Procedure to add a new service which should be monitored.
|
| Parameters
| ----------
|  IN  : pCaption : Caption of the new setting.
|  IN  : pValue   : Value of the setting.
|  OUT : pID      : ID of the newly added setting or in case of an error the error id.
|                    -1 = Duplicate ID
|                    -2 = Foreign key error
|                    -3 = General SQL error
|                    -4 = General SQL warning
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
|  2015-04-21 : Bugfixing and cleanup.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS addSetting $$
CREATE PROCEDURE addSetting(
  IN  pCaption VARCHAR(45),
  IN  pValue   VARCHAR(45),
  OUT pID      MEDIUMINT
)
BEGIN
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
    INSERT INTO tblSetting (dtCaption, dtValue)
    VALUES (pCaption, pValue);

    SET pID = LAST_INSERT_ID();
  COMMIT;
END $$

DELIMITER ;

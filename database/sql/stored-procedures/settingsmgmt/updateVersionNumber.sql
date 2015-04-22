/*---------------------------------------------------------------------------------------------
| Routine     : updateVersionNumber
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 0.4
| 
| Description : Change the version string of the database.
|
| Parameters
| ----------
|  IN  : pVersion : Version string to update.
|  OUT : pErr     : ID of the newly added setting or in case of an error the error id.
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

DROP PROCEDURE IF EXISTS f_updateVersionNumber $$
CREATE PROCEDURE f_updateVersionNumber(
  IN  pVersion VARCHAR(45),
  OUT pErr     MEDIUMINT
)
BEGIN
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
    UPDATE tblSetting SET 
      dtValue = pVersion 
    WHERE dtCaption = "version";

    SET pErr = 0;
  COMMIT;
END $$

DELIMITER ;

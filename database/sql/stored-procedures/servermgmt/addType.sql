/*---------------------------------------------------------------------------------------------
| Routine     : addType
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-22
| Version     : 0.5
| 
| Description : This procedure is called in order to add a new device type to the DB.
|
| Parameters
| ----------
|  IN  : pCaption     : Caption for the new type.
|  IN  : pDescription : Description of the new type.
|  OUT : pID          : ID of the newly added type or in case of an error the error id.
|                        -1 = Duplicate ID
|                        -3 = General SQL error
|                        -4 = General SQL warning
|
| Changelog
| ---------
|  2015-04-22 : Created procedure.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS addType $$
CREATE PROCEDURE addType(
  IN  pCaption     VARCHAR(32),
  IN  pDescription TINYTEXT,
  OUT pID          MEDIUMINT
)
BEGIN  
  DECLARE cond_dupkey CONDITION FOR 1062;

  DECLARE EXIT HANDLER FOR cond_dupkey
  BEGIN
    SET pID = -1;
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
    INSERT INTO tblType (dtCaption, dtDescription)
      VALUES (pCaption, pDescription);

    SET pID = LAST_INSERT_ID();
  COMMIT;
END $$

DELIMITER ;

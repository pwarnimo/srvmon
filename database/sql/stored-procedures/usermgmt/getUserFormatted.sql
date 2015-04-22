/*---------------------------------------------------------------------------------------------
| Routine     : addUser
| Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
| Create date : 2015-04-20
| Version     : 0.4
| 
| Description : Get a formatted view of the user data with the role description.
|
| Parameters
| ----------
|  IN  : pID  : User ID of the user. (All users are displayed if set to -1)
|  OUT : pErr : ID of the newly added user or in case of an error the error id.
|                 0 = Query OK
|                -2 = Foreign key error
|                -3 = General SQL error
|                -4 = General SQL warning
|                -5 = User not found
|
| Changelog
| ---------
|  2015-04-20 : Created procedure.
|  2015-04-21 : Bugfixing and cleanup.
|
+--------------------------------------------------------------------------------------------*/

DELIMITER $$

DROP PROCEDURE IF EXISTS getUserFormatted $$
CREATE PROCEDURE getUserFormatted(
  IN  pID  MEDIUMINT,
  OUT pErr MEDIUMINT
)
BEGIN
  DECLARE l_errcode MEDIUMINT DEFAULT 0;

  DECLARE no_data CONDITION FOR 1329;
  DECLARE cond_forkey CONDITION FOR 1452;

  DECLARE CONTINUE HANDLER FOR no_data SET l_errcode = -5;
  DECLARE CONTINUE HANDLER FOR cond_forkey SET l_errcode = -2;
  DECLARE CONTINUE HANDLER FOR sqlexception SET l_errcode = -3;
  DECLARE CONTINUE HANDLER FOR sqlwarning SET l_errcode = -4;

  IF pID = -1 THEN
    BEGIN
      SELECT idUser, dtUsername, dtEmail, dtDescription
      FROM tblUser, tblRole
      WHERE fiRole = idRole;
    END;
  ELSE
    BEGIN
      SELECT idUser, dtUsername, dtEmail, dtDescription
      FROM tblUser, tblRole
      WHERE fiRole = idRole
        AND idUser = pID;
    END;
  END IF;

  SET pErr = l_errcode;
END $$

DELIMITER ;

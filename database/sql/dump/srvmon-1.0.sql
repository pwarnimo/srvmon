SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `srvmon` DEFAULT CHARACTER SET latin1 ;
USE `srvmon` ;

-- -----------------------------------------------------
-- Table `srvmon`.`tblOS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srvmon`.`tblOS` ;

CREATE  TABLE IF NOT EXISTS `srvmon`.`tblOS` (
  `idOS` INT NOT NULL AUTO_INCREMENT ,
  `dtCaption` VARCHAR(32) NOT NULL ,
  `dtDescription` TINYTEXT NOT NULL ,
  PRIMARY KEY (`idOS`) ,
  UNIQUE INDEX `dtCaption_UNIQUE` (`dtCaption` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srvmon`.`tblType`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srvmon`.`tblType` ;

CREATE  TABLE IF NOT EXISTS `srvmon`.`tblType` (
  `idType` INT NOT NULL AUTO_INCREMENT ,
  `dtCaption` VARCHAR(32) NOT NULL ,
  `dtDescription` TINYTEXT NOT NULL ,
  PRIMARY KEY (`idType`) ,
  UNIQUE INDEX `dtCaption_UNIQUE` (`dtCaption` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srvmon`.`tblHardware`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srvmon`.`tblHardware` ;

CREATE  TABLE IF NOT EXISTS `srvmon`.`tblHardware` (
  `idHardware` INT NOT NULL AUTO_INCREMENT ,
  `dtModel` VARCHAR(45) NOT NULL ,
  `dtManufacturer` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`idHardware`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srvmon`.`tblGroup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srvmon`.`tblGroup` ;

CREATE  TABLE IF NOT EXISTS `srvmon`.`tblGroup` (
  `idGroup` INT NOT NULL AUTO_INCREMENT ,
  `dtCaption` VARCHAR(32) NOT NULL ,
  `dtDescription` VARCHAR(45) NULL ,
  PRIMARY KEY (`idGroup`) ,
  UNIQUE INDEX `dtCaption_UNIQUE` (`dtCaption` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srvmon`.`tblServer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srvmon`.`tblServer` ;

CREATE  TABLE IF NOT EXISTS `srvmon`.`tblServer` (
  `idServer` INT NOT NULL AUTO_INCREMENT ,
  `dtHostname` VARCHAR(32) NOT NULL ,
  `dtIPAddress` VARCHAR(15) NOT NULL ,
  `dtDescription` TINYTEXT NULL ,
  `fiOS` INT NOT NULL ,
  `fiType` INT NOT NULL ,
  `dtEnabled` VARCHAR(45) NOT NULL ,
  `fiHardware` INT NOT NULL ,
  `fiResponsible` INT NOT NULL ,
  PRIMARY KEY (`idServer`) ,
  UNIQUE INDEX `dtHostname_UNIQUE` (`dtHostname` ASC) ,
  UNIQUE INDEX `dtIPAddress_UNIQUE` (`dtIPAddress` ASC) ,
  INDEX `fk_tblServer_tblOS1_idx` (`fiOS` ASC) ,
  INDEX `fk_tblServer_table11_idx` (`fiType` ASC) ,
  INDEX `fk_tblServer_tblHardware1_idx` (`fiHardware` ASC) ,
  INDEX `fk_tblServer_tblGroup1_idx` (`fiResponsible` ASC) ,
  CONSTRAINT `fk_tblServer_tblOS1`
    FOREIGN KEY (`fiOS` )
    REFERENCES `srvmon`.`tblOS` (`idOS` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblServer_table11`
    FOREIGN KEY (`fiType` )
    REFERENCES `srvmon`.`tblType` (`idType` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblServer_tblHardware1`
    FOREIGN KEY (`fiHardware` )
    REFERENCES `srvmon`.`tblHardware` (`idHardware` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblServer_tblGroup1`
    FOREIGN KEY (`fiResponsible` )
    REFERENCES `srvmon`.`tblGroup` (`idGroup` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srvmon`.`tblService`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srvmon`.`tblService` ;

CREATE  TABLE IF NOT EXISTS `srvmon`.`tblService` (
  `idService` INT NOT NULL AUTO_INCREMENT ,
  `dtCaption` VARCHAR(32) NOT NULL ,
  `dtDescription` TINYTEXT NULL ,
  `dtCheckCommand` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`idService`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srvmon`.`tblServer_has_tblService`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srvmon`.`tblServer_has_tblService` ;

CREATE  TABLE IF NOT EXISTS `srvmon`.`tblServer_has_tblService` (
  `idServer` INT NOT NULL ,
  `idService` INT NOT NULL ,
  `dtValue` TINYINT NOT NULL ,
  `dtScriptOutput` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`idService`, `idServer`) ,
  INDEX `fk_tblServer_has_tblService_tblService1_idx` (`idService` ASC) ,
  INDEX `fk_tblServer_has_tblService_tblServer_idx` (`idServer` ASC) ,
  CONSTRAINT `fk_tblServer_has_tblService_tblServer`
    FOREIGN KEY (`idServer` )
    REFERENCES `srvmon`.`tblServer` (`idServer` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblServer_has_tblService_tblService1`
    FOREIGN KEY (`idService` )
    REFERENCES `srvmon`.`tblService` (`idService` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srvmon`.`tblParent`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srvmon`.`tblParent` ;

CREATE  TABLE IF NOT EXISTS `srvmon`.`tblParent` (
  `idChild` INT NOT NULL ,
  `idParent` INT NOT NULL ,
  PRIMARY KEY (`idChild`, `idParent`) ,
  INDEX `fk_tblServer_has_tblServer_tblServer2_idx` (`idParent` ASC) ,
  INDEX `fk_tblServer_has_tblServer_tblServer1_idx` (`idChild` ASC) ,
  CONSTRAINT `fk_tblServer_has_tblServer_tblServer1`
    FOREIGN KEY (`idChild` )
    REFERENCES `srvmon`.`tblServer` (`idServer` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblServer_has_tblServer_tblServer2`
    FOREIGN KEY (`idParent` )
    REFERENCES `srvmon`.`tblServer` (`idServer` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srvmon`.`tblSetting`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srvmon`.`tblSetting` ;

CREATE  TABLE IF NOT EXISTS `srvmon`.`tblSetting` (
  `idSetting` INT NOT NULL AUTO_INCREMENT ,
  `dtCaption` VARCHAR(32) NOT NULL ,
  `dtValue` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`idSetting`) ,
  UNIQUE INDEX `dtCaption_UNIQUE` (`dtCaption` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srvmon`.`tblRole`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srvmon`.`tblRole` ;

CREATE  TABLE IF NOT EXISTS `srvmon`.`tblRole` (
  `idRole` INT NOT NULL AUTO_INCREMENT ,
  `dtCaption` VARCHAR(32) NOT NULL ,
  `dtDescription` TINYTEXT NULL ,
  PRIMARY KEY (`idRole`) ,
  UNIQUE INDEX `dtCaption_UNIQUE` (`dtCaption` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srvmon`.`tblUser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srvmon`.`tblUser` ;

CREATE  TABLE IF NOT EXISTS `srvmon`.`tblUser` (
  `idUser` INT NOT NULL AUTO_INCREMENT ,
  `dtUsername` VARCHAR(8) NOT NULL ,
  `dtHash` VARCHAR(512) NOT NULL ,
  `dtSalt` VARCHAR(512) NOT NULL ,
  `dtEmail` VARCHAR(255) NOT NULL ,
  `fiRole` INT NOT NULL ,
  `dtTelephone` VARCHAR(32) NULL ,
  PRIMARY KEY (`idUser`) ,
  UNIQUE INDEX `dtUsername_UNIQUE` (`dtUsername` ASC) ,
  INDEX `fk_tblUser_tblRole1_idx` (`fiRole` ASC) ,
  UNIQUE INDEX `dtSalt_UNIQUE` (`dtSalt` ASC) ,
  CONSTRAINT `fk_tblUser_tblRole1`
    FOREIGN KEY (`fiRole` )
    REFERENCES `srvmon`.`tblRole` (`idRole` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srvmon`.`tblGroupMember`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srvmon`.`tblGroupMember` ;

CREATE  TABLE IF NOT EXISTS `srvmon`.`tblGroupMember` (
  `idGroup` INT NOT NULL ,
  `idUser` INT NOT NULL ,
  PRIMARY KEY (`idGroup`, `idUser`) ,
  INDEX `fk_tblUserGroup_has_tblUser_tblUser1_idx` (`idUser` ASC) ,
  INDEX `fk_tblUserGroup_has_tblUser_tblUserGroup1_idx` (`idGroup` ASC) ,
  CONSTRAINT `fk_tblUserGroup_has_tblUser_tblUserGroup1`
    FOREIGN KEY (`idGroup` )
    REFERENCES `srvmon`.`tblGroup` (`idGroup` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblUserGroup_has_tblUser_tblUser1`
    FOREIGN KEY (`idUser` )
    REFERENCES `srvmon`.`tblUser` (`idUser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srvmon`.`tblMessage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srvmon`.`tblMessage` ;

CREATE  TABLE IF NOT EXISTS `srvmon`.`tblMessage` (
  `idMessage` INT NOT NULL ,
  `dtMessage` TINYTEXT NOT NULL ,
  PRIMARY KEY (`idMessage`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- procedure addOS
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`addOS`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `addOS`(
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
    INSERT INTO tblOS (dtCaption, dtDescription)
      VALUES (pCaption, pDescription);

    SET pID = LAST_INSERT_ID();
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addParent
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`addParent`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `addParent`(
  IN  pCID MEDIUMINT,
  IN  pPID MEDIUMINT,
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
    INSERT INTO tblParent 
    VALUES (pCID, pPID);

    SET pErr = 0;
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addServer
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`addServer`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `addServer`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addService
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`addService`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `addService`(
  IN  pCaption     VARCHAR(32),
  IN  pDescription TINYTEXT,
  IN  pCommand     VARCHAR(255),
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
    INSERT INTO tblService (dtCaption, dtDescription, dtCheckCommand)
    VALUES (pCaption, pDescription, pCommand);

    SET pID = LAST_INSERT_ID();
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addServiceToServer
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`addServiceToServer`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `addServiceToServer`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addSetting
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`addSetting`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `addSetting`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addType
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`addType`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `addType`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addUser
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`addUser`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `addUser`(
  IN  pUsername VARCHAR(255),
  IN  pHash     VARCHAR(1024),
  IN  pSalt     VARCHAR(1024),
  IN  pEmail    VARCHAR(255),
  IN  pRole     MEDIUMINT,
  OUT pID       MEDIUMINT
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
    INSERT INTO tblUser (dtUsername, dtHash, dtSalt, dtEmail, fiRole)
    VALUES (pUsername, pHash, pSalt, pEmail, pRole);

    SET pID = LAST_INSERT_ID();
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delOS
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`delOS`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `delOS`(
  IN  pID  MEDIUMINT,
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
    DELETE FROM tblOS 
    WHERE idOS = pID;

    SET pErr = 0;
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delParent
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`delParent`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `delParent`(
  IN  pCID MEDIUMINT,
  IN  pPID MEDIUMINT,
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
    DELETE FROM tblParent 
    WHERE idChild = pCID 
      AND idParent = pPID;

    SET pErr = 0;
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delServer
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`delServer`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `delServer`(
  IN  pCID MEDIUMINT,
  IN  pPID MEDIUMINT,
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
    DELETE FROM tblServer 
    WHERE idServer = pID;

    SET pErr = 0;
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delService
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`delService`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `delService`(
  IN  pID  MEDIUMINT,
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
    DELETE FROM tblService 
    WHERE idService = pID;

    SET pErr = 0;
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delServiceFromServer
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`delServiceFromServer`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `delServiceFromServer`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delType
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`delType`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `delType`(
  IN  pID  MEDIUMINT,
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
    DELETE FROM tblType 
    WHERE idType = pID;

    SET pErr = 0;
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delUser
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`delUser`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `delUser`(
  IN  pID  MEDIUMINT,
  OUT pErr MEDIUMINT
)
BEGIN
  DECLARE no_data CONDITION FOR 1329;

  DECLARE EXIT HANDLER FOR no_data
  BEGIN
    SET pID = -5;
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
    DELETE FROM tblUser 
    WHERE idUser = pID;

    SET pErr = 0;
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure disableChildrenChecks
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`disableChildrenChecks`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `disableChildrenChecks`(
  IN  pID  MEDIUMINT,
  OUT pErr MEDIUMINT
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
      dtValue = 4
    WHERE idServer IN (
      SELECT idChild
      FROM tblParent
      WHERE idParent = pID
    );
    
    UPDATE tblServer SET
      dtEnabled = FALSE
    WHERE idServer IN (
      SELECT idChild
      FROM tblParent
      WHERE idParent = pID
    );
 
    SET pErr = 0;
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure enableChildrenChecks
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`enableChildrenChecks`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `enableChildrenChecks`(
  IN  pID  MEDIUMINT,
  OUT pErr MEDIUMINT
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
    UPDATE tblServer SET
      dtEnabled = TRUE
    WHERE idServer IN (
      SELECT idChild
      FROM tblParent
      WHERE idParent = pID
    );
 
    SET pErr = 0;
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure f_updateVersionNumber
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`f_updateVersionNumber`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `f_updateVersionNumber`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getChildsForParent
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`getChildsForParent`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `getChildsForParent`(
  IN  pID  MEDIUMINT,
  OUT pErr MEDIUMINT
)
BEGIN
  DECLARE l_errcode MEDIUMINT DEFAULT 0;
  
  DECLARE no_data CONDITION FOR 1329;

  DECLARE CONTINUE HANDLER FOR no_data SET l_errcode = -5;
  DECLARE CONTINUE HANDLER FOR sqlexception SET l_errcode = -3;
  DECLARE CONTINUE HANDLER FOR sqlwarning SET l_errcode = -4;
  
  SELECT idServer, dtHostname, dtEnabled
  FROM tblServer, tblParent
  WHERE idServer = idChild
    AND idParent = pID;
  
  SET pErr = l_errcode;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getOS
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`getOS`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `getOS`(
  IN  pID  MEDIUMINT,
  OUT pErr MEDIUMINT
)
BEGIN
  DECLARE l_errcode MEDIUMINT DEFAULT 0;
  
  DECLARE no_data CONDITION FOR 1329;

  DECLARE CONTINUE HANDLER FOR no_data SET l_errcode = -5;
  DECLARE CONTINUE HANDLER FOR sqlexception SET l_errcode = -3;
  DECLARE CONTINUE HANDLER FOR sqlwarning SET l_errcode = -4;
  
  IF pID = -1 THEN
    BEGIN
      SELECT *
      FROM tblOS;
    END;
  ELSE
    BEGIN
      SELECT *
      FROM tblOS
      WHERE idOS = pID;
    END;
  END IF;

  SET pErr = l_errcode;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getParentsForServer
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`getParentsForServer`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `getParentsForServer`(
  IN  pID  MEDIUMINT,
  OUT pErr MEDIUMINT
)
BEGIN
  DECLARE l_errcode MEDIUMINT DEFAULT 0;
  
  DECLARE no_data CONDITION FOR 1329;

  DECLARE CONTINUE HANDLER FOR no_data SET l_errcode = -5;
  DECLARE CONTINUE HANDLER FOR sqlexception SET l_errcode = -3;
  DECLARE CONTINUE HANDLER FOR sqlwarning SET l_errcode = -4;
  
  SELECT idServer, dtHostname, dtEnabled
  FROM tblServer
  WHERE idServer IN (
    SELECT idParent
    FROM tblParent
    WHERE idChild = pID
  );
  
  SET pErr = l_errcode;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getServer
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`getServer`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `getServer`(
  IN  pID     MEDIUMINT,
  IN  pFormat BOOLEAN,
  OUT pErr    MEDIUMINT
)
BEGIN
  DECLARE l_errcode MEDIUMINT DEFAULT 0;
  
  DECLARE no_data CONDITION FOR 1329;

  DECLARE CONTINUE HANDLER FOR no_data SET l_errcode = -5;
  DECLARE CONTINUE HANDLER FOR sqlexception SET l_errcode = -3;
  DECLARE CONTINUE HANDLER FOR sqlwarning SET l_errcode = -4;
  
  IF pFormat = TRUE THEN
    BEGIN
      IF pID = -1 THEN
        BEGIN
          SELECT idServer, dtHostname, dtIPAddress, SR.dtDescription, OS.dtDescription AS dtOS, TY.dtDescription AS dtType, dtEnabled, GR.dtCaption AS dtResponsible, HW.dtModel, HW.dtManufacturer
          FROM tblServer SR, tblOS OS, tblType TY, tblGroup GR, tblHardware HW
          WHERE fiType = idType
            AND fiOS = idOS
            AND fiHardware = idHardware
            AND fiResponsible = idGroup;
        END;
      ELSE
        BEGIN
          SELECT idServer, dtHostname, dtIPAddress, SR.dtDescription, OS.dtDescription AS dtOS, TY.dtDescription AS dtType, dtEnabled, GR.dtCaption AS dtResponsible, HW.dtModel, HW.dtManufacturer
          FROM tblServer SR, tblOS OS, tblType TY, tblGroup GR, tblHardware HW
          WHERE idServer = pID
            AND fiType = idType
            AND fiOS = idOS
            AND fiHardware = idHardware
            AND fiResponsible = idGroup;
        END;
      END IF;
    END;
  ELSE
    BEGIN
      IF pID = -1 THEN
        BEGIN
          SELECT * 
          FROM tblServer;
        END;
      ELSE
        BEGIN
          SELECT *
          FROM tblServer
          WHERE idServer = pID;
        END;
      END IF;
    END;
  END IF;
  SET pErr = l_errcode;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function getServerID
-- -----------------------------------------------------

USE `srvmon`;
DROP function IF EXISTS `srvmon`.`getServerID`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` FUNCTION `getServerID`(
  pCaption VARCHAR(45)
) RETURNS mediumint(9)
BEGIN
  DECLARE l_serverid MEDIUMINT DEFAULT 0;

  DECLARE no_data CONDITION FOR 1329;

  DECLARE CONTINUE HANDLER FOR no_data SET l_serverid = -5;
  DECLARE CONTINUE HANDLER FOR sqlexception SET l_serverid = -3;
  DECLARE CONTINUE HANDLER FOR sqlwarning SET l_serverid = -4;
  
  SELECT idServer 
  INTO l_serverid
  FROM tblServer
  WHERE dtHostname = pCaption;

  RETURN l_serverid;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getServicesForServer
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`getServicesForServer`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `getServicesForServer`(
  IN  pHID  MEDIUMINT,
  IN  pSID  MEDIUMINT,
  IN  pFRMT MEDIUMINT,
  OUT pErr  MEDIUMINT
)
BEGIN
  DECLARE l_errcode MEDIUMINT DEFAULT 0;
  
  DECLARE no_data CONDITION FOR 1329;

  DECLARE CONTINUE HANDLER FOR no_data SET l_errcode = -5;
  DECLARE CONTINUE HANDLER FOR sqlexception SET l_errcode = -3;
  DECLARE CONTINUE HANDLER FOR sqlwarning SET l_errcode = -4;
  
  CASE pFRMT
    WHEN 0 THEN SET @FIELDS = "SR.idService, dtCaption, dtDescription, dtCheckCommand, dtValue";
    WHEN 1 THEN SET @FIELDS = "SR.idService, dtCheckCommand";
    WHEN 2 THEN SET @FIELDS = "SR.idService, dtValue";
  END CASE;
  
  IF pSID = -1 THEN
    BEGIN
      SET @COND = CONCAT("WHERE idServer = ", pHID, " AND SR.idService = SE.idService");
    END;
  ELSE
    BEGIN
      SET @COND = CONCAT("WHERE idServer = ", pHID, " AND SR.idService = SE.idService AND SE.idService = ", pSID);
    END;
  END IF;
  
  SET @QRY = CONCAT("SELECT ", @FIELDS, " FROM tblServer_has_tblService SR, tblService SE ", @COND);
  
  PREPARE STMT FROM @QRY;
  EXECUTE STMT;
  DEALLOCATE PREPARE STMT;

  SET pErr = l_errcode;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getType
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`getType`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `getType`(
  IN  pID  MEDIUMINT,
  OUT pErr MEDIUMINT
)
BEGIN
  DECLARE l_errcode MEDIUMINT DEFAULT 0;
  
  DECLARE no_data CONDITION FOR 1329;

  DECLARE CONTINUE HANDLER FOR no_data SET l_errcode = -5;
  DECLARE CONTINUE HANDLER FOR sqlexception SET l_errcode = -3;
  DECLARE CONTINUE HANDLER FOR sqlwarning SET l_errcode = -4;
  
  IF pID = -1 THEN
    BEGIN
      SELECT *
      FROM tblType;
    END;
  ELSE
    BEGIN
      SELECT *
      FROM tblType
      WHERE idType = pID;
    END;
  END IF;

  SET pErr = l_errcode;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getUserFormatted
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`getUserFormatted`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `getUserFormatted`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modifyOS
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`modifyOS`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `modifyOS`(
  IN  pID          MEDIUMINT,
  IN  pCaption     VARCHAR(32),
  IN  pDescription TINYTEXT,
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
    UPDATE tblOS SET
      dtCaption = pCaption,
      dtDescription = pDescription
    WHERE idOS = pID;
 
    SET pErr = 0;
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modifyServer
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`modifyServer`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `modifyServer`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modifyService
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`modifyService`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `modifyService`(
  IN  pID          MEDIUMINT,
  IN  pCaption     VARCHAR(32),
  IN  pDescription TINYTEXT,
  IN  pCommand     VARCHAR(255),
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
    UPDATE tblService SET
      dtCaption  = pCaption,
      dtDescription = pDescription,
      dtCheckCommand  = pCommand
    WHERE idService = pID;
 
    SET pErr = 0;
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modifyType
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`modifyType`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `modifyType`(
  IN  pID          MEDIUMINT,
  IN  pCaption     VARCHAR(32),
  IN  pDescription TINYTEXT,
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
    UPDATE tblType SET
      dtCaption = pCaption,
      dtDescription = pDescription
    WHERE idType = pID;
 
    SET pErr = 0;
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modifyUser
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`modifyUser`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `modifyUser`(
  IN  pID    MEDIUMINT,
  IN  pHash  VARCHAR(1024),
  IN  pEmail VARCHAR(255),
  IN  pRole  MEDIUMINT,
  OUT pErr   MEDIUMINT
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
    UPDATE tblUser SET
      dtHash  = pHash,
      dtEmail = pEmail,
      fiRole  = pRole
    WHERE idUser = pID;
 
    SET pErr = 0;
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure setChildrenStatus
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`setChildrenStatus`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `setChildrenStatus`(
  IN  pID  MEDIUMINT,
  OUT pErr MEDIUMINT
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
      dtValue = 4
    WHERE idServer IN (
      SELECT idChild
      FROM tblParent
      WHERE idParent = pID
    );
    
    UPDATE tblServer SET
      dtEnabled = FALSE
    WHERE idServer IN (
      SELECT idChild
      FROM tblParent
      WHERE idParent = pID
    );
 
    SET pErr = 0;
  COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure setSystemStatus
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`setSystemStatus`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `setSystemStatus`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure updateServerServiceStatus
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`updateServerServiceStatus`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `updateServerServiceStatus`(
  IN  pHID    MEDIUMINT,
  IN  pSID    MEDIUMINT,
  IN  pStatus TINYINT,
  OUT pErr    MEDIUMINT
)
BEGIN
  DECLARE l_enabled BOOLEAN;

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

  SELECT dtEnabled 
  INTO l_enabled
  FROM tblServer
  WHERE idServer = pHID;

  IF l_enabled = TRUE THEN
    BEGIN
      START TRANSACTION;
        UPDATE tblServer_has_tblService SET
          dtValue = pStatus
        WHERE idServer = pHID
          AND idService = pSID;
 
        SET pErr = 0;
      COMMIT;
    END;
  ELSE
    BEGIN
      SET pErr = -6;
    END;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure updateVersionNumber
-- -----------------------------------------------------

USE `srvmon`;
DROP procedure IF EXISTS `srvmon`.`updateVersionNumber`;

DELIMITER $$
USE `srvmon`$$
CREATE DEFINER=`sqlusr`@`localhost` PROCEDURE `updateVersionNumber`(
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
END$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

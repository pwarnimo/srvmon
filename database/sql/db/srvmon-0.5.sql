SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `srvmon` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
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
  INDEX `fk_tblServer_tblOS1` (`fiOS` ASC) ,
  INDEX `fk_tblServer_table11` (`fiType` ASC) ,
  INDEX `fk_tblServer_tblHardware1` (`fiHardware` ASC) ,
  INDEX `fk_tblServer_tblGroup1` (`fiResponsible` ASC) ,
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
  PRIMARY KEY (`idService`, `idServer`) ,
  INDEX `fk_tblServer_has_tblService_tblService1` (`idService` ASC) ,
  INDEX `fk_tblServer_has_tblService_tblServer` (`idServer` ASC) ,
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
  INDEX `fk_tblServer_has_tblServer_tblServer2` (`idParent` ASC) ,
  INDEX `fk_tblServer_has_tblServer_tblServer1` (`idChild` ASC) ,
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
  INDEX `fk_tblUser_tblRole1` (`fiRole` ASC) ,
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
  INDEX `fk_tblUserGroup_has_tblUser_tblUser1` (`idUser` ASC) ,
  INDEX `fk_tblUserGroup_has_tblUser_tblUserGroup1` (`idGroup` ASC) ,
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



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Copyright (C) 2015  Pol Warnimont
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
-- 
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `srvmon` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `srvmon` ;

-- -----------------------------------------------------
-- Table `srvmon`.`tblServer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srvmon`.`tblServer` ;

CREATE  TABLE IF NOT EXISTS `srvmon`.`tblServer` (
  `idServer` INT NOT NULL AUTO_INCREMENT ,
  `dtHostname` VARCHAR(32) NOT NULL ,
  `dtIPAddress` VARCHAR(15) NOT NULL ,
  `dtDescription` TINYTEXT NULL ,
  PRIMARY KEY (`idServer`) ,
  UNIQUE INDEX `dtHostname_UNIQUE` (`dtHostname` ASC) ,
  UNIQUE INDEX `dtIPAddress_UNIQUE` (`dtIPAddress` ASC) )
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
  PRIMARY KEY (`idUser`, `fiRole`) ,
  UNIQUE INDEX `dtUsername_UNIQUE` (`dtUsername` ASC) ,
  INDEX `fk_tblUser_tblRole1` (`fiRole` ASC) ,
  UNIQUE INDEX `dtSalt_UNIQUE` (`dtSalt` ASC) ,
  CONSTRAINT `fk_tblUser_tblRole1`
    FOREIGN KEY (`fiRole` )
    REFERENCES `srvmon`.`tblRole` (`idRole` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

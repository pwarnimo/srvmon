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
-- MySQL dump 10.13  Distrib 5.5.43, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: srvmon
-- ------------------------------------------------------
-- Server version	5.5.43-0+deb7u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tblParent`
--

DROP TABLE IF EXISTS `tblParent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblParent` (
  `idChild` int(11) NOT NULL,
  `idParent` int(11) NOT NULL,
  PRIMARY KEY (`idChild`,`idParent`),
  KEY `fk_tblServer_has_tblServer_tblServer2` (`idParent`),
  KEY `fk_tblServer_has_tblServer_tblServer1` (`idChild`),
  CONSTRAINT `fk_tblServer_has_tblServer_tblServer1` FOREIGN KEY (`idChild`) REFERENCES `tblServer` (`idServer`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblServer_has_tblServer_tblServer2` FOREIGN KEY (`idParent`) REFERENCES `tblServer` (`idServer`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblParent`
--

LOCK TABLES `tblParent` WRITE;
/*!40000 ALTER TABLE `tblParent` DISABLE KEYS */;
INSERT INTO `tblParent` VALUES (4,1),(3,2),(5,3),(5,4);
/*!40000 ALTER TABLE `tblParent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblRole`
--

DROP TABLE IF EXISTS `tblRole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRole` (
  `idRole` int(11) NOT NULL AUTO_INCREMENT,
  `dtCaption` varchar(32) NOT NULL,
  `dtDescription` tinytext,
  PRIMARY KEY (`idRole`),
  UNIQUE KEY `dtCaption_UNIQUE` (`dtCaption`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblRole`
--

LOCK TABLES `tblRole` WRITE;
/*!40000 ALTER TABLE `tblRole` DISABLE KEYS */;
INSERT INTO `tblRole` VALUES (1,'admin','Global administrator'),(2,'operator','System operator'),(3,'user','General user');
/*!40000 ALTER TABLE `tblRole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblServer`
--

DROP TABLE IF EXISTS `tblServer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblServer` (
  `idServer` int(11) NOT NULL AUTO_INCREMENT,
  `dtHostname` varchar(32) NOT NULL,
  `dtIPAddress` varchar(15) NOT NULL,
  `dtDescription` tinytext,
  PRIMARY KEY (`idServer`),
  UNIQUE KEY `dtHostname_UNIQUE` (`dtHostname`),
  UNIQUE KEY `dtIPAddress_UNIQUE` (`dtIPAddress`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblServer`
--

LOCK TABLES `tblServer` WRITE;
/*!40000 ALTER TABLE `tblServer` DISABLE KEYS */;
INSERT INTO `tblServer` VALUES (1,'tempest','192.168.1.3','Main ESX host'),(2,'flame','192.168.1.12','Backup ESX host'),(3,'clu1-ha-a','192.168.1.74','HA cluster node A'),(4,'clu1-ha-b','192.168.1.67','HA cluster node B'),(5,'ha-cluster','192.168.1.245','HA cluster');
/*!40000 ALTER TABLE `tblServer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblServer_has_tblService`
--

DROP TABLE IF EXISTS `tblServer_has_tblService`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblServer_has_tblService` (
  `idServer` int(11) NOT NULL,
  `idService` int(11) NOT NULL,
  `dtValue` tinyint(4) NOT NULL,
  PRIMARY KEY (`idService`,`idServer`),
  KEY `fk_tblServer_has_tblService_tblService1` (`idService`),
  KEY `fk_tblServer_has_tblService_tblServer` (`idServer`),
  CONSTRAINT `fk_tblServer_has_tblService_tblServer` FOREIGN KEY (`idServer`) REFERENCES `tblServer` (`idServer`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblServer_has_tblService_tblService1` FOREIGN KEY (`idService`) REFERENCES `tblService` (`idService`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblServer_has_tblService`
--

LOCK TABLES `tblServer_has_tblService` WRITE;
/*!40000 ALTER TABLE `tblServer_has_tblService` DISABLE KEYS */;
INSERT INTO `tblServer_has_tblService` VALUES (1,1,4),(2,1,4),(3,1,4),(4,1,4),(5,1,4),(3,2,4),(4,2,4);
/*!40000 ALTER TABLE `tblServer_has_tblService` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblService`
--

DROP TABLE IF EXISTS `tblService`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblService` (
  `idService` int(11) NOT NULL AUTO_INCREMENT,
  `dtCaption` varchar(32) NOT NULL,
  `dtDescription` tinytext,
  `dtCheckCommand` varchar(255) NOT NULL,
  PRIMARY KEY (`idService`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblService`
--

LOCK TABLES `tblService` WRITE;
/*!40000 ALTER TABLE `tblService` DISABLE KEYS */;
INSERT INTO `tblService` VALUES (1,'Ping','Simple ping check','chkping'),(2,'SSH','Check if SSH daemon is running','chkssh');
/*!40000 ALTER TABLE `tblService` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblSetting`
--

DROP TABLE IF EXISTS `tblSetting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSetting` (
  `idSetting` int(11) NOT NULL AUTO_INCREMENT,
  `dtCaption` varchar(32) NOT NULL,
  `dtValue` varchar(255) NOT NULL,
  PRIMARY KEY (`idSetting`),
  UNIQUE KEY `dtCaption_UNIQUE` (`dtCaption`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblSetting`
--

LOCK TABLES `tblSetting` WRITE;
/*!40000 ALTER TABLE `tblSetting` DISABLE KEYS */;
INSERT INTO `tblSetting` VALUES (1,'version','0.4b');
/*!40000 ALTER TABLE `tblSetting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblUser`
--

DROP TABLE IF EXISTS `tblUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUser` (
  `idUser` int(11) NOT NULL AUTO_INCREMENT,
  `dtUsername` varchar(8) NOT NULL,
  `dtHash` varchar(512) NOT NULL,
  `dtSalt` varchar(512) NOT NULL,
  `dtEmail` varchar(255) NOT NULL,
  `fiRole` int(11) NOT NULL,
  PRIMARY KEY (`idUser`,`fiRole`),
  UNIQUE KEY `dtUsername_UNIQUE` (`dtUsername`),
  UNIQUE KEY `dtSalt_UNIQUE` (`dtSalt`),
  KEY `fk_tblUser_tblRole1` (`fiRole`),
  CONSTRAINT `fk_tblUser_tblRole1` FOREIGN KEY (`fiRole`) REFERENCES `tblRole` (`idRole`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblUser`
--

LOCK TABLES `tblUser` WRITE;
/*!40000 ALTER TABLE `tblUser` DISABLE KEYS */;
INSERT INTO `tblUser` VALUES (1,'pwarnimo','$2a$10$BW7xCun9a45wl6fx2OGhHey/9D/YDmso32FXd3rvDAxmJmhsM/TTm','$2a$10$BW7xCun9a45wl6fx2OGhHg==','pwarnimo@gmail.com',1);
/*!40000 ALTER TABLE `tblUser` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-04-21 14:19:47

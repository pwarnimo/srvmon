-- MySQL dump 10.13  Distrib 5.5.41, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: srvmon
-- ------------------------------------------------------
-- Server version	5.5.41-0+wheezy1

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
INSERT INTO `tblParent` VALUES (4,1),(3,2);
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
  `dtCaption` varchar(45) DEFAULT NULL,
  `dtDescription` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idRole`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblRole`
--

LOCK TABLES `tblRole` WRITE;
/*!40000 ALTER TABLE `tblRole` DISABLE KEYS */;
INSERT INTO `tblRole` VALUES (1,'admin','Global administrator'),(2,'maintenance','Server operator'),(3,'user','Basic user');
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
  `dtHostname` varchar(45) DEFAULT NULL,
  `dtIPAddress` varchar(45) DEFAULT NULL,
  `dtDescription` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idServer`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblServer`
--

LOCK TABLES `tblServer` WRITE;
/*!40000 ALTER TABLE `tblServer` DISABLE KEYS */;
INSERT INTO `tblServer` VALUES (1,'tempest','192.168.1.3','Main ESXi host'),(2,'flame','192.168.1.12','Backup ESXi host'),(3,'clu1-ha-a','192.168.1.74','HA cluster node A'),(4,'clu1-ha-b','192.168.1.67','HA cluster node B');
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
  `dtValue` varchar(45) DEFAULT NULL,
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
INSERT INTO `tblServer_has_tblService` VALUES (1,1,'3'),(2,1,'3'),(3,1,'3'),(4,1,'3'),(3,2,'3'),(4,2,'3');
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
  `dtCaption` varchar(45) DEFAULT NULL,
  `dtDescription` varchar(45) DEFAULT NULL,
  `dtCheckCommand` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idService`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblService`
--

LOCK TABLES `tblService` WRITE;
/*!40000 ALTER TABLE `tblService` DISABLE KEYS */;
INSERT INTO `tblService` VALUES (1,'ping','Ping check host','pingv4'),(2,'ssh','Check SSH daemon','checkssh');
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
  `dtCaption` varchar(45) DEFAULT NULL,
  `dtValue` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idSetting`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblSetting`
--

LOCK TABLES `tblSetting` WRITE;
/*!40000 ALTER TABLE `tblSetting` DISABLE KEYS */;
INSERT INTO `tblSetting` VALUES (1,'version','0.3');
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
  `dtUsername` varchar(255) DEFAULT NULL,
  `dtHash` varchar(1024) DEFAULT NULL,
  `dtSalt` varchar(1024) DEFAULT NULL,
  `dtEmail` varchar(255) DEFAULT NULL,
  `fiRole` int(11) NOT NULL,
  PRIMARY KEY (`idUser`,`fiRole`),
  UNIQUE KEY `dtUsername_UNIQUE` (`dtUsername`),
  KEY `fk_tblUser_tblRole1` (`fiRole`),
  CONSTRAINT `fk_tblUser_tblRole1` FOREIGN KEY (`fiRole`) REFERENCES `tblRole` (`idRole`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblUser`
--

LOCK TABLES `tblUser` WRITE;
/*!40000 ALTER TABLE `tblUser` DISABLE KEYS */;
INSERT INTO `tblUser` VALUES (1,'pwarnimo','$2a$10$BP3M64701h47/jxd3jjiNemLhJZbgE2urAFsZkp/kp8kGhDjh0PY2','$2a$10$BP3M64701h47/jxd3jjiNg==','pwarnimo@gmail.com',1),(2,'dwarnimo','$2a$10$.yNe3NR0csgHSZsk3Lj1VeHHf9woT8TwizH2/IE.M0h9010/J2O4m','$2a$10$.yNe3NR0csgHSZsk3Lj1Vg==','dwarnimo@gmail.com',2);
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

-- Dump completed on 2015-04-20 11:11:12

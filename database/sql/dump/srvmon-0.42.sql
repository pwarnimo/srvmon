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
-- Table structure for table `tblOS`
--

DROP TABLE IF EXISTS `tblOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblOS` (
  `idOS` int(11) NOT NULL AUTO_INCREMENT,
  `dtCaption` varchar(32) NOT NULL,
  `dtDescription` tinytext NOT NULL,
  PRIMARY KEY (`idOS`),
  UNIQUE KEY `dtCaption_UNIQUE` (`dtCaption`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblOS`
--

LOCK TABLES `tblOS` WRITE;
/*!40000 ALTER TABLE `tblOS` DISABLE KEYS */;
INSERT INTO `tblOS` (`idOS`, `dtCaption`, `dtDescription`) VALUES (1,'esxi5.0','VMware ESXi 5.0'),(2,'esxi5.5','VMware ESXi 5.5'),(3,'debian7.8','Debian 7.8 Wheezy'),(4,'w2k8r2','Windows Server 2008 R2'),(5,'w2k12r2','Windows Server 2012 R2'),(6,'nas4free9.3','NAS4Free 9.3'),(7,'integrated','Integrated firmware'),(8,'hpux11i3','HP-UX 11i3 15/03');
/*!40000 ALTER TABLE `tblOS` ENABLE KEYS */;
UNLOCK TABLES;

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
INSERT INTO `tblParent` (`idChild`, `idParent`) VALUES (4,1),(6,1),(7,1),(8,1),(9,1),(10,1),(12,1),(3,2),(13,2),(14,2),(15,2),(5,3),(18,3),(5,4),(18,4),(19,10),(19,11),(17,12),(17,14),(23,16),(21,20),(2,21),(22,21),(1,22),(11,22),(24,22),(20,23);
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblRole`
--

LOCK TABLES `tblRole` WRITE;
/*!40000 ALTER TABLE `tblRole` DISABLE KEYS */;
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
  `fiOS` int(11) NOT NULL,
  `fiType` int(11) NOT NULL,
  `dtEnabled` varchar(45) NOT NULL,
  PRIMARY KEY (`idServer`),
  UNIQUE KEY `dtHostname_UNIQUE` (`dtHostname`),
  UNIQUE KEY `dtIPAddress_UNIQUE` (`dtIPAddress`),
  KEY `fk_tblServer_tblOS1` (`fiOS`),
  KEY `fk_tblServer_table11` (`fiType`),
  CONSTRAINT `fk_tblServer_tblOS1` FOREIGN KEY (`fiOS`) REFERENCES `tblOS` (`idOS`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblServer_table11` FOREIGN KEY (`fiType`) REFERENCES `tblType` (`idType`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblServer`
--

LOCK TABLES `tblServer` WRITE;
/*!40000 ALTER TABLE `tblServer` DISABLE KEYS */;
INSERT INTO `tblServer` (`idServer`, `dtHostname`, `dtIPAddress`, `dtDescription`, `fiOS`, `fiType`, `dtEnabled`) VALUES (1,'TEMPEST','192.168.1.3','Main ESX host',1,1,'1'),(2,'FLAME','192.168.1.12','Backup ESX host',2,1,'1'),(3,'CLU1-HA-A','192.168.1.74','HA cluster node A',3,2,'1'),(4,'CLU1-HA-B','192.168.1.67','HA cluster node B',3,2,'1'),(5,'HA-CLUSTER','192.168.1.245','HA cluster',3,7,'1'),(6,'DTEL-GSR01','192.168.1.231','Gameserver 1 -- KF1 + KF2',4,2,'1'),(7,'DTEL-ADS01','192.168.1.68','Domain controller',5,2,'1'),(8,'DTEL-BCK01','192.168.1.84','Backup server',3,2,'1'),(9,'DTEL-ACC0B','192.168.1.64','Access cluster node B',3,2,'1'),(10,'CLU2-FSS-A','192.168.1.61','Fileserver cluster node A',3,2,'1'),(11,'CLU2-FSS-B','192.168.1.2','Fileserver cluster node B',3,1,'1'),(12,'DTEL-RTR0B','192.168.1.86','Router cluster node B',3,2,'1'),(13,'DTEL-ACC0A','192.168.1.73','Access cluster node A',3,2,'1'),(14,'DTEL-RTR0A','192.168.1.88','Router cluster node A',3,2,'1'),(15,'DTEL-SAN01','192.168.1.78','Shared storage for cluster nodes',6,2,'1'),(16,'DTEL-GW1','192.168.1.1','DSL mainline',7,5,'1'),(17,'DTEL-RTR0','192.168.1.248','Router cluster',3,7,'1'),(18,'HAFSS-CLUSTER','192.168.1.246','HA fileserver cluster',3,7,'1'),(19,'FSS-CLUSTER','192.168.1.244','Fileserver cluster',3,7,'1'),(20,'DTEL-SW0','192.168.1.252','Main switch (Basement)',7,4,'1'),(21,'DTEL-SW1','192.168.1.250','Server switch 1',7,4,'1'),(22,'DTEL-SW2','192.168.1.251','Server switch 2',7,4,'1'),(23,'DTEL-SW3','192.168.1.253','Access switch (1st floor)',7,4,'1'),(24,'ORCHID','192.168.1.4','Unix development machine',8,1,'0');
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
INSERT INTO `tblServer_has_tblService` (`idServer`, `idService`, `dtValue`) VALUES (1,1,4),(2,1,4),(3,1,4),(4,1,4),(5,1,4),(3,2,4),(4,2,4),(3,3,4),(4,3,4),(5,3,4);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblService`
--

LOCK TABLES `tblService` WRITE;
/*!40000 ALTER TABLE `tblService` DISABLE KEYS */;
INSERT INTO `tblService` (`idService`, `dtCaption`, `dtDescription`, `dtCheckCommand`) VALUES (1,'ping','ICMP PING check','chkping'),(2,'ssh','SSH daemon check','chkssh'),(3,'cpu','CPU usage check','chkcpu');
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
INSERT INTO `tblSetting` (`idSetting`, `dtCaption`, `dtValue`) VALUES (1,'version','0.42b');
/*!40000 ALTER TABLE `tblSetting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblType`
--

DROP TABLE IF EXISTS `tblType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblType` (
  `idType` int(11) NOT NULL AUTO_INCREMENT,
  `dtCaption` varchar(32) NOT NULL,
  `dtDescription` tinytext NOT NULL,
  PRIMARY KEY (`idType`),
  UNIQUE KEY `dtCaption_UNIQUE` (`dtCaption`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblType`
--

LOCK TABLES `tblType` WRITE;
/*!40000 ALTER TABLE `tblType` DISABLE KEYS */;
INSERT INTO `tblType` (`idType`, `dtCaption`, `dtDescription`) VALUES (1,'server','Physical server'),(2,'vserver','Virtual server'),(3,'paraserver','Virtual container'),(4,'switch','Network switch'),(5,'router','Network router'),(6,'workstation','Workstation'),(7,'cluster','Server cluster');
/*!40000 ALTER TABLE `tblType` ENABLE KEYS */;
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
  PRIMARY KEY (`idUser`),
  UNIQUE KEY `dtUsername_UNIQUE` (`dtUsername`),
  UNIQUE KEY `dtSalt_UNIQUE` (`dtSalt`),
  KEY `fk_tblUser_tblRole1` (`fiRole`),
  CONSTRAINT `fk_tblUser_tblRole1` FOREIGN KEY (`fiRole`) REFERENCES `tblRole` (`idRole`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblUser`
--

LOCK TABLES `tblUser` WRITE;
/*!40000 ALTER TABLE `tblUser` DISABLE KEYS */;
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

-- Dump completed on 2015-04-22 14:21:36

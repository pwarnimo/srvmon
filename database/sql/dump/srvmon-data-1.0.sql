-- MySQL dump 10.13  Distrib 5.5.43, for debian-linux-gnu (x86_64)
--
-- Host: 192.168.20.51    Database: srvmon
-- ------------------------------------------------------
-- Server version	5.5.5-10.0.16-MariaDB-1

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
-- Dumping data for table `tblGroup`
--

LOCK TABLES `tblGroup` WRITE;
/*!40000 ALTER TABLE `tblGroup` DISABLE KEYS */;
INSERT INTO `tblGroup` (`idGroup`, `dtCaption`, `dtDescription`) VALUES (5,'dtel-gen','General notification group'),(6,'dtel-network','Network notification group'),(7,'dtel-file','Fileserver notification group'),(8,'dtel-game','Gameserver notification group');
/*!40000 ALTER TABLE `tblGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblGroupMember`
--

LOCK TABLES `tblGroupMember` WRITE;
/*!40000 ALTER TABLE `tblGroupMember` DISABLE KEYS */;
/*!40000 ALTER TABLE `tblGroupMember` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblHardware`
--

LOCK TABLES `tblHardware` WRITE;
/*!40000 ALTER TABLE `tblHardware` DISABLE KEYS */;
INSERT INTO `tblHardware` (`idHardware`, `dtModel`, `dtManufacturer`) VALUES (1,'Proliant ML370 G5','Hewlett Packard'),(2,'Proliant DL360 G3','Hewlett Packard'),(3,'Integrity rx4640','Hewlett Packard'),(4,'DC7900','Hewlett Packard'),(5,'Virtual Machine Version 8','VMware Inc.'),(6,'Omnistack LS6224','Alcatel'),(7,'GS108Ev3','Netgear'),(8,'FRITZ!Box 7330','AVM GmbH');
/*!40000 ALTER TABLE `tblHardware` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblMessage`
--

LOCK TABLES `tblMessage` WRITE;
/*!40000 ALTER TABLE `tblMessage` DISABLE KEYS */;
/*!40000 ALTER TABLE `tblMessage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblOS`
--

LOCK TABLES `tblOS` WRITE;
/*!40000 ALTER TABLE `tblOS` DISABLE KEYS */;
INSERT INTO `tblOS` (`idOS`, `dtCaption`, `dtDescription`) VALUES (1,'debian7.8','Debian 7.8 Wheezy'),(2,'debian8.0','Debian 8.0 Jessie'),(3,'esxi5.0','VMware ESXi 5.0'),(4,'esxi5.5','VMware ESXi 5.5'),(5,'windows7pro','Windows 7 Professional'),(6,'windows8.1pro','Windows 8.1 Pro'),(7,'windows2k8r2data','Windows Server 2008 R2 Datacenter'),(8,'windows2k12r2data','Windows Server 2012 R2 Datacenter'),(9,'nas4free9.3','NAS4Free 9.3'),(10,'integrated','Integrated OS'),(11,'hpux11i3','HP-UX 11i3');
/*!40000 ALTER TABLE `tblOS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblParent`
--

LOCK TABLES `tblParent` WRITE;
/*!40000 ALTER TABLE `tblParent` DISABLE KEYS */;
INSERT INTO `tblParent` (`idChild`, `idParent`) VALUES (14,16),(15,14),(16,17),(17,18),(19,15),(20,14),(21,14),(22,15),(23,20),(24,19),(25,23),(25,24),(26,23),(26,24),(30,19),(31,19),(31,21),(32,19),(33,19),(34,20),(35,20),(36,19),(37,35),(37,36),(38,20),(39,19),(40,38),(40,39);
/*!40000 ALTER TABLE `tblParent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblRole`
--

LOCK TABLES `tblRole` WRITE;
/*!40000 ALTER TABLE `tblRole` DISABLE KEYS */;
INSERT INTO `tblRole` (`idRole`, `dtCaption`, `dtDescription`) VALUES (1,'admin','Administrators'),(2,'operator','Server operators'),(3,'user','Generic user');
/*!40000 ALTER TABLE `tblRole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblServer`
--

LOCK TABLES `tblServer` WRITE;
/*!40000 ALTER TABLE `tblServer` DISABLE KEYS */;
INSERT INTO `tblServer` (`idServer`, `dtHostname`, `dtIPAddress`, `dtDescription`, `fiOS`, `fiType`, `dtEnabled`, `fiHardware`, `fiResponsible`) VALUES (14,'DTEL-SW1','192.168.1.251','Server switch (Rack 1.1)',10,5,'1',7,6),(15,'DTEL-SW2','192.168.1.252','Server switch (Rack 1.2)',10,5,'1',7,6),(16,'DTEL-SW0','192.168.1.250','Main switch (Rack 1.0)',10,5,'1',6,6),(17,'DTEL-SW3','192.168.1.253','Access switch (1st floor)',10,5,'1',6,6),(18,'DTEL-GW0','192.168.1.1','DSL Mainline',10,6,'1',8,6),(19,'TEMPEST','192.168.1.3','ESX Host 1',3,1,'1',1,5),(20,'FLAME','192.168.1.12','ESX Host 2',4,1,'1',4,5),(21,'SWAN','192.168.1.2','Backup Server',1,1,'0',2,5),(22,'ORCHID','192.168.1.4','Unix Test Server',11,1,'0',3,5),(23,'clu1-ha-a','192.168.1.74','HA Cluster Node 1',1,2,'1',5,5),(24,'clu1-ha-b','192.168.1.67','HA Cluster Node 2',1,2,'1',5,5),(25,'ha-cluster','192.168.1.245','HA Cluster',1,4,'1',5,5),(26,'hafss-cluster','192.168.1.246','HA Fileserver Cluster',1,4,'1',5,5),(30,'clu2-fss-a','192.168.1.61','Fileserver Cluster Node 1',1,4,'1',5,5),(31,'fss-cluster','192.168.1.244','Fileserver Cluster',1,4,'1',5,5),(32,'dtel-ads01','192.168.1.68','Domain Controller',8,2,'1',5,5),(33,'dtel-gsr01','192.168.1.231','Gameserver 1',7,2,'1',5,5),(34,'dtel-nas01','192.168.1.78','NAS For iSCSI Targets',9,2,'1',5,5),(35,'dtel-acc0a','192.168.1.73','Access Cluster Node 1',1,2,'1',5,5),(36,'dtel-acc0b','192.168.1.64','Access Cluster Node 2',1,2,'1',5,5),(37,'acc-cluster','192.168.1.89','Access Cluster',1,4,'1',5,5),(38,'dtel-rtr0a','192.168.1.88','Router Cluster Node 1',1,2,'1',5,6),(39,'dtel-rtr0b','192.168.1.86','Router Cluster Node 2',1,2,'1',5,6),(40,'dtel-rtr0','192.168.1.248','Router Cluster',1,4,'1',5,6);
/*!40000 ALTER TABLE `tblServer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblServer_has_tblService`
--

LOCK TABLES `tblServer_has_tblService` WRITE;
/*!40000 ALTER TABLE `tblServer_has_tblService` DISABLE KEYS */;
INSERT INTO `tblServer_has_tblService` (`idServer`, `idService`, `dtValue`, `dtScriptOutput`) VALUES (23,1,0,'Gateway is reachable'),(24,1,0,'Gateway is reachable'),(23,2,0,'SSH is running!'),(24,2,0,'SSH is running!'),(23,3,0,'Process count Ok (108).'),(24,3,0,'Process count Ok (117).');
/*!40000 ALTER TABLE `tblServer_has_tblService` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblService`
--

LOCK TABLES `tblService` WRITE;
/*!40000 ALTER TABLE `tblService` DISABLE KEYS */;
INSERT INTO `tblService` (`idService`, `dtCaption`, `dtDescription`, `dtCheckCommand`) VALUES (1,'ping','Check Gateway Connectivity','chkping'),(2,'ssh','Check SSH Daemon Status','chkssh'),(3,'processes','Check Process Count','checkproc');
/*!40000 ALTER TABLE `tblService` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblSetting`
--

LOCK TABLES `tblSetting` WRITE;
/*!40000 ALTER TABLE `tblSetting` DISABLE KEYS */;
INSERT INTO `tblSetting` (`idSetting`, `dtCaption`, `dtValue`) VALUES (1,'version','1.0');
/*!40000 ALTER TABLE `tblSetting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblType`
--

LOCK TABLES `tblType` WRITE;
/*!40000 ALTER TABLE `tblType` DISABLE KEYS */;
INSERT INTO `tblType` (`idType`, `dtCaption`, `dtDescription`) VALUES (1,'physical','Physical server'),(2,'virtual','Virtual server'),(3,'container','Linux container'),(4,'cluster','Server cluster'),(5,'switch','Network switch'),(6,'router','Network router'),(7,'printer','Network printer');
/*!40000 ALTER TABLE `tblType` ENABLE KEYS */;
UNLOCK TABLES;

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

-- Dump completed on 2015-04-29  8:56:44

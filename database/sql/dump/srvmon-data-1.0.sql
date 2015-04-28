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
-- Dumping data for table `tblGroup`
--

LOCK TABLES `tblGroup` WRITE;
/*!40000 ALTER TABLE `tblGroup` DISABLE KEYS */;
INSERT INTO `tblGroup` (`idGroup`, `dtCaption`, `dtDescription`) VALUES (1,'DTEL-ADMIN','Main infrastructure administrators'),(2,'DTEL-NETWORK','Network notification group'),(3,'DTEL-FILESERVER','Fileservers notification group'),(4,'DTEL-GAMESERVER','Gameservers notification group');
/*!40000 ALTER TABLE `tblGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblGroupMember`
--

LOCK TABLES `tblGroupMember` WRITE;
/*!40000 ALTER TABLE `tblGroupMember` DISABLE KEYS */;
INSERT INTO `tblGroupMember` (`idGroup`, `idUser`) VALUES (1,1),(2,1),(3,1),(4,1),(2,2),(3,2),(4,2),(4,3),(4,4);
/*!40000 ALTER TABLE `tblGroupMember` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblHardware`
--

LOCK TABLES `tblHardware` WRITE;
/*!40000 ALTER TABLE `tblHardware` DISABLE KEYS */;
INSERT INTO `tblHardware` (`idHardware`, `dtModel`, `dtManufacturer`) VALUES (1,'Proliant ML370 G5','Hewlett Packard'),(2,'Proliant DL360 G3','Hewlett Packard'),(3,'Integrity rx4640','Hewlett Packard'),(4,'DC7900','Hewlett Packard'),(5,'GS108Ev3','Netgear'),(6,'Omnistack LS6224','Alcatel'),(7,'FRITZ!Box 7330','AVM GmbH'),(8,'VM version 8','VMware Inc.');
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
INSERT INTO `tblOS` (`idOS`, `dtCaption`, `dtDescription`) VALUES (1,'esxi5.0','VMware ESXi 5.0'),(2,'esxi5.5','VMware ESXi 5.5'),(3,'debian7.8','Debian 7.8 Wheezy'),(4,'w2k8r2','Windows 2008 R2'),(5,'w2k12r2','Windows 2012 R2'),(6,'nas4free9.3','NAS4Free 9.3'),(7,'integrated','Integrated firmware'),(8,'hpux11i3','HP-UX 11i3');
/*!40000 ALTER TABLE `tblOS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblParent`
--

LOCK TABLES `tblParent` WRITE;
/*!40000 ALTER TABLE `tblParent` DISABLE KEYS */;
INSERT INTO `tblParent` (`idChild`, `idParent`) VALUES (4,1),(1,2),(6,3),(8,3),(9,3),(3,4),(7,4),(2,5),(18,6);
/*!40000 ALTER TABLE `tblParent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblRole`
--

LOCK TABLES `tblRole` WRITE;
/*!40000 ALTER TABLE `tblRole` DISABLE KEYS */;
INSERT INTO `tblRole` (`idRole`, `dtCaption`, `dtDescription`) VALUES (1,'admin','Global administrator'),(2,'operator','Server operator'),(3,'user','General user');
/*!40000 ALTER TABLE `tblRole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblServer`
--

LOCK TABLES `tblServer` WRITE;
/*!40000 ALTER TABLE `tblServer` DISABLE KEYS */;
INSERT INTO `tblServer` (`idServer`, `dtHostname`, `dtIPAddress`, `dtDescription`, `fiOS`, `fiType`, `dtEnabled`, `fiHardware`, `fiResponsible`) VALUES (1,'DTEL-SW0','192.168.1.252','Main switch (Basement)',7,4,'1',6,2),(2,'DTEL-SW3','192.168.1.253','Access switch (1st floor)',7,4,'1',6,2),(3,'DTEL-SW2','192.168.1.251','Server switch rack 1.2',7,4,'1',5,2),(4,'DTEL-SW1','192.168.1.250','Server switch rack 1.1',7,4,'1',5,2),(5,'DTEL-GW1','192.168.1.1','DSL main line',7,5,'1',7,2),(6,'TEMPEST','192.168.1.3','Main ESX host',1,1,'1',1,1),(7,'FLAME','192.168.1.12','Backup ESX host',2,1,'1',4,1),(8,'CLU2-FSS-B','192.168.1.2','File server cluster node B',3,1,'0',2,1),(9,'ORCHID','192.168.1.4','Unix development server',8,1,'0',3,1),(11,'CLU2-FSS-A','192.168.1.61','File server cluster node A',3,2,'1',8,3),(13,'CLU1-HA-A','192.168.1.74','HA cluster node A',3,2,'1',8,1),(14,'CLU1-HA-B','192.168.1.67','HA cluster node B',3,2,'1',8,1),(15,'HA-CLUSTER','192.168.1.245','HA cluster',3,6,'1',8,1),(16,'HAFSS-CLUSTER','192.168.1.246','HA fileserver cluster',3,6,'1',8,1),(17,'FSS-CLUSTER','192.168.1.244','Fileserver cluster',3,6,'1',8,3),(18,'DTEL-LIN01','192.168.20.65','Linux development machine',3,2,'1',8,1);
/*!40000 ALTER TABLE `tblServer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblServer_has_tblService`
--

LOCK TABLES `tblServer_has_tblService` WRITE;
/*!40000 ALTER TABLE `tblServer_has_tblService` DISABLE KEYS */;
INSERT INTO `tblServer_has_tblService` (`idServer`, `idService`, `dtValue`, `dtScriptOutput`) VALUES (1,1,4,'Check pending.'),(2,1,4,'Check pending.'),(3,1,4,'Check pending.'),(4,1,4,'Check pending.'),(5,1,4,'Check pending.'),(6,1,4,'Check pending.'),(7,1,4,'Check pending.'),(8,1,4,'Check pending.'),(9,1,4,'Check pending.'),(18,1,4,'Check pending.'),(6,2,4,'Check pending.'),(7,2,4,'Check pending.'),(8,2,4,'Check pending.'),(9,2,4,'Check pending.'),(18,2,4,'Check pending.'),(18,3,4,'Check pending.');
/*!40000 ALTER TABLE `tblServer_has_tblService` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblService`
--

LOCK TABLES `tblService` WRITE;
/*!40000 ALTER TABLE `tblService` DISABLE KEYS */;
INSERT INTO `tblService` (`idService`, `dtCaption`, `dtDescription`, `dtCheckCommand`) VALUES (1,'ping','ICMP ping check','chkping'),(2,'ssh','SSH daemon check','chkssh'),(3,'processes','Get process count','checkproc');
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
INSERT INTO `tblType` (`idType`, `dtCaption`, `dtDescription`) VALUES (1,'pserver','Physical server'),(2,'vserver','Virtual server'),(3,'paravirt','Virtual container'),(4,'switch','Network switch'),(5,'router','Network router'),(6,'cluster','Server cluster');
/*!40000 ALTER TABLE `tblType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblUser`
--

LOCK TABLES `tblUser` WRITE;
/*!40000 ALTER TABLE `tblUser` DISABLE KEYS */;
INSERT INTO `tblUser` (`idUser`, `dtUsername`, `dtHash`, `dtSalt`, `dtEmail`, `fiRole`, `dtTelephone`) VALUES (1,'pwarnimo','$2a$10$FvgQpkMAeup/HyGzxnGTJe6TR2idNpKTfxfz5AivQKF6mNQs5TZFS','$2a$10$FvgQpkMAeup/HyGzxnGTJg==','pwarnimo@gmail.com',1,'+352691664293'),(2,'dwarnimo','$2a$10$4MyAQS5ITR7OTv/cMQCsFOyT9s5oPijb9iAp6h9Nh.F8hjRhTaGbm','$2a$10$4MyAQS5ITR7OTv/cMQCsFQ==','d.warnimont@gmail.com',2,''),(3,'shilber','$2a$10$WHASrEY1ZPtNzKUolDOL9O2PHxVGwtZdwi7NFoPQEdnEax1o1kNEi','$2a$10$WHASrEY1ZPtNzKUolDOL9Q==','hilsteve@msn.de',3,''),(4,'cbiot','$2a$10$8d8UNd1DZEHJyfT6pyCFiu0SziwGGk93Vhe3b5xVdyNDDnFmwDBM2','$2a$10$8d8UNd1DZEHJyfT6pyCFiw==','bioch071@gmail.com',3,'');
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

-- Dump completed on 2015-04-28 15:16:52

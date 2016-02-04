-- MySQL dump 10.15  Distrib 10.0.16-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: srvmon
-- ------------------------------------------------------
-- Server version	10.0.16-MariaDB-1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `tblGroup`
--

LOCK TABLES `tblGroup` WRITE;
/*!40000 ALTER TABLE `tblGroup` DISABLE KEYS */;
INSERT INTO `tblGroup` (`idGroup`, `dtCaption`, `dtDescription`) VALUES (1,'default','SRVMON Default Group');
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
/*!40000 ALTER TABLE `tblOS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblParent`
--

LOCK TABLES `tblParent` WRITE;
/*!40000 ALTER TABLE `tblParent` DISABLE KEYS */;
/*!40000 ALTER TABLE `tblParent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblRole`
--

LOCK TABLES `tblRole` WRITE;
/*!40000 ALTER TABLE `tblRole` DISABLE KEYS */;
INSERT INTO `tblRole` (`idRole`, `dtCaption`, `dtDescription`) VALUES (1,'admin','Global Administrator'),(2,'operator','Server Operator'),(3,'user','General User');
/*!40000 ALTER TABLE `tblRole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblServer`
--

LOCK TABLES `tblServer` WRITE;
/*!40000 ALTER TABLE `tblServer` DISABLE KEYS */;
/*!40000 ALTER TABLE `tblServer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblServer_has_tblService`
--

LOCK TABLES `tblServer_has_tblService` WRITE;
/*!40000 ALTER TABLE `tblServer_has_tblService` DISABLE KEYS */;
/*!40000 ALTER TABLE `tblServer_has_tblService` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblService`
--

LOCK TABLES `tblService` WRITE;
/*!40000 ALTER TABLE `tblService` DISABLE KEYS */;
INSERT INTO `tblService` (`idService`, `dtCaption`, `dtDescription`, `dtCheckCommand`) VALUES (1,'ping','Check Gateway Connectivity','chkping'),(2,'ssh','SSH Daemon Status','chkssh'),(3,'processes','Process Count','chkproc');
/*!40000 ALTER TABLE `tblService` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblSession`
--

LOCK TABLES `tblSession` WRITE;
/*!40000 ALTER TABLE `tblSession` DISABLE KEYS */;
/*!40000 ALTER TABLE `tblSession` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblSetting`
--

LOCK TABLES `tblSetting` WRITE;
/*!40000 ALTER TABLE `tblSetting` DISABLE KEYS */;
INSERT INTO `tblSetting` (`idSetting`, `dtCaption`, `dtValue`) VALUES (1,'dbversion','1.2 R1');
/*!40000 ALTER TABLE `tblSetting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tblType`
--

LOCK TABLES `tblType` WRITE;
/*!40000 ALTER TABLE `tblType` DISABLE KEYS */;
INSERT INTO `tblType` (`idType`, `dtCaption`, `dtDescription`) VALUES (1,'physical','Physical Server'),(2,'virtual','Virtual Server'),(3,'container','Virtual Container'),(4,'cluster','Server Cluster'),(5,'nswitch','Network Switch'),(6,'nrouter','Network Router'),(7,'nprinter','Network Printer');
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
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-05-20 11:27:12

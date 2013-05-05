-- MySQL dump 10.13  Distrib 5.5.31, for Linux (x86_64)
--
-- Host: localhost    Database: dinstar
-- ------------------------------------------------------
-- Server version	5.5.31

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
-- Table structure for table `cdr`
--

DROP TABLE IF EXISTS `cdr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr` (
  `cdr_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `report` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `called` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `answer_dt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `end_dt` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `billsec` int(11) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `imsi` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ip` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`cdr_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cdr`
--

LOCK TABLES `cdr` WRITE;
/*!40000 ALTER TABLE `cdr` DISABLE KEYS */;
/*!40000 ALTER TABLE `cdr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `port`
--

DROP TABLE IF EXISTS `port`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `port` (
  `ip` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `port` tinyint(4) NOT NULL,
  `type` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `imsi` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `limit` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `carrier` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `signal` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `asr` int(11) DEFAULT NULL,
  `acd` int(11) DEFAULT NULL,
  `pdd` int(11) DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ip`,`port`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `port`
--

LOCK TABLES `port` WRITE;
/*!40000 ALTER TABLE `port` DISABLE KEYS */;
INSERT INTO `port` VALUES ('192.168.2.104',7,'GSM','744051200052261','Mobile Registered','No Limit','Personal','4',80,0,0,'2013-04-07 14:22:13'),('192.168.2.104',6,'GSM','744051200052266','Mobile Registered','No Limit','Personal','4',80,0,0,'2013-04-07 14:22:13'),('192.168.2.104',5,'GSM','744040010366020','Mobile Registered','No Limit','Telecel Paraguay','3',54,207,6,'2013-04-07 14:22:13'),('192.168.2.104',4,'GSM','744020008182383','Mobile Registered','No Limit','Hutchison Paraguay ','4',90,0,0,'2013-04-07 14:22:13'),('192.168.2.104',3,'GSM','','No SIM Card','No Limit','','0',0,0,0,'2013-04-07 14:22:13'),('192.168.2.104',2,'GSM','','No SIM Card','No Limit','','0',0,0,0,'2013-04-07 14:22:13'),('192.168.2.104',1,'GSM','','No SIM Card','No Limit','','0',0,0,0,'2013-04-07 14:22:13'),('192.168.2.104',0,'GSM','','No SIM Card','No Limit','','0',0,0,0,'2013-04-07 14:22:13');
/*!40000 ALTER TABLE `port` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `dinstar`.`tri_check_new_status` BEFORe update
    ON `dinstar`.`port`
    FOR EACH ROW BEGIN
	declare v_count int default 0;
	
	select count(*) into v_count from port_change where ip = new.ip and `port` = new.port;
	
	if v_count = 0 then
		insert into port_change values(new.ip, new.port, new.type, new.imsi, new.status, new.limit, new.carrier, new.signal, current_timestamp, null);
	end if;
	
	if old.imsi <> new.imsi or old.status <> new.status or old.carrier <> new.carrier then
		INSERT INTO port_change VALUES(new.ip, new.port, new.type, new.imsi, new.status, new.limit, new.carrier, new.signal, CURRENT_TIMESTAMP, null);
	end if;
	
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `port_change`
--

DROP TABLE IF EXISTS `port_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `port_change` (
  `ip` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `port` tinyint(4) NOT NULL,
  `type` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `imsi` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `limit` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `carrier` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `signal` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `port_change_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`port_change_id`),
  UNIQUE KEY `port_change_id` (`port_change_id`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `port_change`
--

LOCK TABLES `port_change` WRITE;
/*!40000 ALTER TABLE `port_change` DISABLE KEYS */;
INSERT INTO `port_change` VALUES ('192.168.2.104',7,'GSM','744020008182382','No SIM Card','No Limit','','0','2013-01-31 21:04:30',1),('192.168.2.104',7,'GSM','123','No SIM Card','No Limit','','0','2013-01-31 21:19:25',2),('192.168.2.104',7,'GSM','222','No SIM Card','No Limit','','0','2013-01-31 21:19:31',3),('192.168.2.104',0,'','','','','','0','2013-04-07 01:33:05',4),('192.168.2.104',0,'','','','','','0','2013-04-07 01:33:05',5),('192.168.2.104',0,'GSM','','No SIM Card','No Limit','','0','2013-04-07 01:41:47',6),('192.168.2.104',1,'GSM','','No SIM Card','No Limit','','0','2013-04-07 01:41:47',7),('192.168.2.104',1,'GSM','','No SIM Card','No Limit','','0','2013-04-07 01:41:47',8),('192.168.2.104',2,'GSM','','No SIM Card','No Limit','','0','2013-04-07 01:41:47',9),('192.168.2.104',2,'GSM','','No SIM Card','No Limit','','0','2013-04-07 01:41:47',10),('192.168.2.104',3,'GSM','','No SIM Card','No Limit','','0','2013-04-07 01:41:47',11),('192.168.2.104',3,'GSM','','No SIM Card','No Limit','','0','2013-04-07 01:41:47',12),('192.168.2.104',4,'GSM','744020008182383','Mobile Registered','No Limit','Hutchison Paraguay ','4','2013-04-07 01:41:47',13),('192.168.2.104',4,'GSM','744020008182383','Mobile Registered','No Limit','Hutchison Paraguay ','4','2013-04-07 01:41:47',14),('192.168.2.104',5,'GSM','744040010366020','Mobile Registered','No Limit','Telecel Paraguay','3','2013-04-07 01:41:47',15),('192.168.2.104',5,'GSM','744040010366020','Mobile Registered','No Limit','Telecel Paraguay','3','2013-04-07 01:41:47',16),('192.168.2.104',6,'GSM','744051200052266','Mobile Registered','No Limit','Personal','4','2013-04-07 01:41:47',17),('192.168.2.104',6,'GSM','744051200052266','Mobile Registered','No Limit','Personal','4','2013-04-07 01:41:47',18),('192.168.2.104',7,'GSM','744051200052261','Mobile Registered','No Limit','Personal','4','2013-04-07 01:41:47',19);
/*!40000 ALTER TABLE `port_change` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-05-05  0:46:16

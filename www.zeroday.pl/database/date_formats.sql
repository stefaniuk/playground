
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
DROP TABLE IF EXISTS `date_formats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `date_formats` (
  `dfid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The date format identifier.',
  `format` varchar(100) NOT NULL COMMENT 'The date format string.',
  `type` varchar(64) NOT NULL COMMENT 'The date format type, e.g. medium.',
  `locked` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Whether or not this format can be modified.',
  PRIMARY KEY (`dfid`),
  UNIQUE KEY `formats` (`format`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8 COMMENT='Stores configured date formats.';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `date_formats` WRITE;
/*!40000 ALTER TABLE `date_formats` DISABLE KEYS */;
INSERT INTO `date_formats` VALUES (1,'Y-m-d H:i','short',1);
INSERT INTO `date_formats` VALUES (2,'m/d/Y - H:i','short',1);
INSERT INTO `date_formats` VALUES (3,'d/m/Y - H:i','short',1);
INSERT INTO `date_formats` VALUES (4,'Y/m/d - H:i','short',1);
INSERT INTO `date_formats` VALUES (5,'d.m.Y - H:i','short',1);
INSERT INTO `date_formats` VALUES (6,'m/d/Y - g:ia','short',1);
INSERT INTO `date_formats` VALUES (7,'d/m/Y - g:ia','short',1);
INSERT INTO `date_formats` VALUES (8,'Y/m/d - g:ia','short',1);
INSERT INTO `date_formats` VALUES (9,'M j Y - H:i','short',1);
INSERT INTO `date_formats` VALUES (10,'j M Y - H:i','short',1);
INSERT INTO `date_formats` VALUES (11,'Y M j - H:i','short',1);
INSERT INTO `date_formats` VALUES (12,'M j Y - g:ia','short',1);
INSERT INTO `date_formats` VALUES (13,'j M Y - g:ia','short',1);
INSERT INTO `date_formats` VALUES (14,'Y M j - g:ia','short',1);
INSERT INTO `date_formats` VALUES (15,'D, Y-m-d H:i','medium',1);
INSERT INTO `date_formats` VALUES (16,'D, m/d/Y - H:i','medium',1);
INSERT INTO `date_formats` VALUES (17,'D, d/m/Y - H:i','medium',1);
INSERT INTO `date_formats` VALUES (18,'D, Y/m/d - H:i','medium',1);
INSERT INTO `date_formats` VALUES (19,'F j, Y - H:i','medium',1);
INSERT INTO `date_formats` VALUES (20,'j F, Y - H:i','medium',1);
INSERT INTO `date_formats` VALUES (21,'Y, F j - H:i','medium',1);
INSERT INTO `date_formats` VALUES (22,'D, m/d/Y - g:ia','medium',1);
INSERT INTO `date_formats` VALUES (23,'D, d/m/Y - g:ia','medium',1);
INSERT INTO `date_formats` VALUES (24,'D, Y/m/d - g:ia','medium',1);
INSERT INTO `date_formats` VALUES (25,'F j, Y - g:ia','medium',1);
INSERT INTO `date_formats` VALUES (26,'j F Y - g:ia','medium',1);
INSERT INTO `date_formats` VALUES (27,'Y, F j - g:ia','medium',1);
INSERT INTO `date_formats` VALUES (28,'j. F Y - G:i','medium',1);
INSERT INTO `date_formats` VALUES (29,'l, F j, Y - H:i','long',1);
INSERT INTO `date_formats` VALUES (30,'l, j F, Y - H:i','long',1);
INSERT INTO `date_formats` VALUES (31,'l, Y,  F j - H:i','long',1);
INSERT INTO `date_formats` VALUES (32,'l, F j, Y - g:ia','long',1);
INSERT INTO `date_formats` VALUES (33,'l, j F Y - g:ia','long',1);
INSERT INTO `date_formats` VALUES (34,'l, Y,  F j - g:ia','long',1);
INSERT INTO `date_formats` VALUES (35,'l, j. F Y - G:i','long',1);
/*!40000 ALTER TABLE `date_formats` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


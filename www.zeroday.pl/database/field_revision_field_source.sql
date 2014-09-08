
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
DROP TABLE IF EXISTS `field_revision_field_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `field_revision_field_source` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_source_value` varchar(255) DEFAULT NULL,
  `field_source_format` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`revision_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `field_source_format` (`field_source_format`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Revision archive storage for field 7 (field_source)';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `field_revision_field_source` WRITE;
/*!40000 ALTER TABLE `field_revision_field_source` DISABLE KEYS */;
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,1,1,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,2,2,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,3,3,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,4,4,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,5,5,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,6,6,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,7,7,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,8,8,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,9,9,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,10,10,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,11,11,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,12,12,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,13,13,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,14,14,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,15,15,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,16,16,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,17,17,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,18,18,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,19,19,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,20,20,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,21,21,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,22,22,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,23,23,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,24,24,'und',0,'<a href=\"http://zeroday.pl\">zeroday.pl</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,25,25,'und',0,'<a href=\"http://hitb.org\">hitb.org</a>','filtered_html');
INSERT INTO `field_revision_field_source` VALUES ('node','news',0,26,26,'und',0,'<a href=\"http://hitb.org\">hitb.org</a>','filtered_html');
/*!40000 ALTER TABLE `field_revision_field_source` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


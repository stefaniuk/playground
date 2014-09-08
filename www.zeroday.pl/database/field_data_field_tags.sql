
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
DROP TABLE IF EXISTS `field_data_field_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `field_data_field_tags` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned DEFAULT NULL COMMENT 'The entity revision id this data is attached to, or NULL if the entity type is not versioned',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_tags_tid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `field_tags_tid` (`field_tags_tid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Data storage for field 3 (field_tags)';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `field_data_field_tags` WRITE;
/*!40000 ALTER TABLE `field_data_field_tags` DISABLE KEYS */;
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,1,1,'und',0,1);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,1,1,'und',1,2);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,2,2,'und',0,1);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,2,2,'und',1,3);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,3,3,'und',0,4);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,3,3,'und',1,5);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,3,3,'und',2,6);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,3,3,'und',3,7);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,4,4,'und',0,8);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,4,4,'und',1,9);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,4,4,'und',2,10);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,4,4,'und',3,11);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,4,4,'und',4,12);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,4,4,'und',5,13);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,4,4,'und',6,14);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,4,4,'und',7,15);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,5,5,'und',0,16);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,5,5,'und',1,17);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,6,6,'und',0,18);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,6,6,'und',1,1);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,6,6,'und',2,19);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,7,7,'und',0,20);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,7,7,'und',1,21);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,7,7,'und',2,22);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,8,8,'und',0,23);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,8,8,'und',1,24);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,8,8,'und',2,25);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,9,9,'und',0,26);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,9,9,'und',1,27);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,9,9,'und',2,28);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,10,10,'und',0,29);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,10,10,'und',1,30);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,10,10,'und',2,31);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,11,11,'und',0,32);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,11,11,'und',1,33);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,12,12,'und',0,34);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,12,12,'und',1,35);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,13,13,'und',0,36);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,13,13,'und',1,37);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,13,13,'und',2,38);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,14,14,'und',0,39);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,14,14,'und',1,40);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,14,14,'und',2,41);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,15,15,'und',0,42);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,15,15,'und',1,43);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,16,16,'und',0,44);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,16,16,'und',1,19);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,17,17,'und',0,45);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,17,17,'und',1,46);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,17,17,'und',2,47);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,17,17,'und',3,48);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,18,18,'und',0,49);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,18,18,'und',1,50);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,18,18,'und',2,51);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,19,19,'und',0,52);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,19,19,'und',1,53);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,19,19,'und',2,54);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,20,20,'und',0,47);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,20,20,'und',1,55);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,20,20,'und',2,56);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,21,21,'und',0,57);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,21,21,'und',1,58);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,22,22,'und',0,59);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,22,22,'und',1,60);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,22,22,'und',2,61);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,23,23,'und',0,62);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,23,23,'und',1,63);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,24,24,'und',0,64);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,24,24,'und',1,65);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,25,25,'und',0,58);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,25,25,'und',1,66);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,26,26,'und',0,1);
INSERT INTO `field_data_field_tags` VALUES ('node','news',0,26,26,'und',1,20);
/*!40000 ALTER TABLE `field_data_field_tags` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


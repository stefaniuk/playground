
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
DROP TABLE IF EXISTS `xmlsitemap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xmlsitemap` (
  `id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary key with type; a unique id for the item.',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT 'Primary key with id; the type of item (e.g. node, user, etc.).',
  `subtype` varchar(128) NOT NULL DEFAULT '' COMMENT 'A sub-type identifier for the link (node type, menu name, term VID, etc.).',
  `loc` varchar(255) NOT NULL DEFAULT '' COMMENT 'The URL to the item relative to the Drupal path.',
  `language` varchar(12) NOT NULL DEFAULT '' COMMENT 'The languages.language of this link or an empty string if it is language-neutral.',
  `access` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'A boolean that represents if the item is viewable by the anonymous user. This field is useful to store the result of node_access() so we can retain changefreq and priority_override information.',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'An integer that represents if the item is included in the sitemap.',
  `status_override` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean that if TRUE means that the status field has been overridden from its default value.',
  `lastmod` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The UNIX timestamp of last modification of the item.',
  `priority` float DEFAULT NULL COMMENT 'The priority of this URL relative to other URLs on your site. Valid values range from 0.0 to 1.0.',
  `priority_override` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean that if TRUE means that the priority field has been overridden from its default value.',
  `changefreq` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The average time in seconds between changes of this item.',
  `changecount` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The number of times this item has been changed. Used to help calculate the next changefreq value.',
  PRIMARY KEY (`id`,`type`),
  KEY `loc` (`loc`),
  KEY `access_status_loc` (`access`,`status`,`loc`),
  KEY `type_subtype` (`type`,`subtype`),
  KEY `language` (`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='The base table for xmlsitemap links.';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `xmlsitemap` WRITE;
/*!40000 ALTER TABLE `xmlsitemap` DISABLE KEYS */;
INSERT INTO `xmlsitemap` VALUES (0,'frontpage','','','und',1,1,0,0,1,0,86400,0);
INSERT INTO `xmlsitemap` VALUES (1,'node','news','node/1','pl',1,1,0,1336382118,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (2,'node','news','node/2','pl',1,1,0,1336382162,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (3,'node','news','node/3','pl',1,1,0,1336386878,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (4,'node','news','node/4','pl',1,1,0,1336388398,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (4,'taxonomy_term','tags','taxonomy/term/4','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (5,'node','news','node/5','pl',1,1,0,1336389421,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (5,'taxonomy_term','tags','taxonomy/term/5','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (6,'node','news','node/6','pl',1,1,0,1336390703,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (6,'taxonomy_term','tags','taxonomy/term/6','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (7,'node','news','node/7','pl',1,1,0,1336822047,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (7,'taxonomy_term','tags','taxonomy/term/7','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (8,'node','news','node/8','pl',1,1,0,1336823398,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (8,'taxonomy_term','tags','taxonomy/term/8','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (9,'node','news','node/9','pl',1,1,0,1337090565,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (9,'taxonomy_term','tags','taxonomy/term/9','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (10,'node','news','node/10','pl',1,1,0,1337181978,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (10,'taxonomy_term','tags','taxonomy/term/10','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (11,'node','news','node/11','pl',1,1,0,1337182828,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (11,'taxonomy_term','tags','taxonomy/term/11','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (12,'node','news','node/12','pl',1,1,0,1337521087,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (12,'taxonomy_term','tags','taxonomy/term/12','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (13,'node','news','node/13','pl',1,1,0,1337522398,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (13,'taxonomy_term','tags','taxonomy/term/13','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (14,'node','news','node/14','pl',1,1,0,1337712105,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (14,'taxonomy_term','tags','taxonomy/term/14','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (15,'node','news','node/15','pl',1,1,0,1337713163,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (15,'taxonomy_term','tags','taxonomy/term/15','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (16,'node','news','node/16','pl',1,1,0,1337778582,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (16,'taxonomy_term','tags','taxonomy/term/16','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (17,'node','news','node/17','pl',1,1,0,1338387394,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (17,'taxonomy_term','tags','taxonomy/term/17','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (18,'node','news','node/18','pl',1,1,0,1338405419,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (18,'taxonomy_term','tags','taxonomy/term/18','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (19,'node','news','node/19','pl',1,1,0,1338406062,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (19,'taxonomy_term','tags','taxonomy/term/19','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (20,'node','news','node/20','pl',1,1,0,1338741119,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (20,'taxonomy_term','tags','taxonomy/term/20','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (21,'node','news','node/21','pl',1,1,0,1338899568,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (21,'taxonomy_term','tags','taxonomy/term/21','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (22,'node','news','node/22','pl',1,1,0,1338901255,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (22,'taxonomy_term','tags','taxonomy/term/22','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (23,'node','news','node/23','pl',1,1,0,1338923787,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (23,'taxonomy_term','tags','taxonomy/term/23','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (24,'node','news','node/24','pl',1,1,0,1338998232,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (24,'taxonomy_term','tags','taxonomy/term/24','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (25,'node','news','node/25','pl',1,1,0,1339000205,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (25,'taxonomy_term','tags','taxonomy/term/25','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (26,'node','news','node/26','pl',1,1,0,1339001085,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (26,'taxonomy_term','tags','taxonomy/term/26','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (27,'taxonomy_term','tags','taxonomy/term/27','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (28,'taxonomy_term','tags','taxonomy/term/28','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (29,'taxonomy_term','tags','taxonomy/term/29','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (30,'taxonomy_term','tags','taxonomy/term/30','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (31,'taxonomy_term','tags','taxonomy/term/31','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (32,'taxonomy_term','tags','taxonomy/term/32','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (33,'taxonomy_term','tags','taxonomy/term/33','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (34,'taxonomy_term','tags','taxonomy/term/34','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (35,'taxonomy_term','tags','taxonomy/term/35','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (36,'taxonomy_term','tags','taxonomy/term/36','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (37,'taxonomy_term','tags','taxonomy/term/37','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (38,'taxonomy_term','tags','taxonomy/term/38','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (39,'taxonomy_term','tags','taxonomy/term/39','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (40,'taxonomy_term','tags','taxonomy/term/40','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (41,'taxonomy_term','tags','taxonomy/term/41','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (42,'taxonomy_term','tags','taxonomy/term/42','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (43,'taxonomy_term','tags','taxonomy/term/43','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (44,'taxonomy_term','tags','taxonomy/term/44','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (45,'taxonomy_term','tags','taxonomy/term/45','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (46,'taxonomy_term','tags','taxonomy/term/46','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (47,'taxonomy_term','tags','taxonomy/term/47','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (48,'taxonomy_term','tags','taxonomy/term/48','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (49,'taxonomy_term','tags','taxonomy/term/49','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (50,'taxonomy_term','tags','taxonomy/term/50','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (51,'taxonomy_term','tags','taxonomy/term/51','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (52,'taxonomy_term','tags','taxonomy/term/52','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (53,'taxonomy_term','tags','taxonomy/term/53','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (54,'taxonomy_term','tags','taxonomy/term/54','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (55,'taxonomy_term','tags','taxonomy/term/55','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (56,'taxonomy_term','tags','taxonomy/term/56','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (57,'taxonomy_term','tags','taxonomy/term/57','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (58,'taxonomy_term','tags','taxonomy/term/58','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (59,'taxonomy_term','tags','taxonomy/term/59','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (60,'taxonomy_term','tags','taxonomy/term/60','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (61,'taxonomy_term','tags','taxonomy/term/61','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (62,'taxonomy_term','tags','taxonomy/term/62','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (63,'taxonomy_term','tags','taxonomy/term/63','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (64,'taxonomy_term','tags','taxonomy/term/64','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (65,'taxonomy_term','tags','taxonomy/term/65','und',1,0,0,0,0.5,0,0,0);
INSERT INTO `xmlsitemap` VALUES (66,'taxonomy_term','tags','taxonomy/term/66','und',1,0,0,0,0.5,0,0,0);
/*!40000 ALTER TABLE `xmlsitemap` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


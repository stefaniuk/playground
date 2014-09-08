
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
DROP TABLE IF EXISTS `node_comment_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_comment_statistics` (
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node.nid for which the statistics are compiled.',
  `cid` int(11) NOT NULL DEFAULT '0' COMMENT 'The comment.cid of the last comment.',
  `last_comment_timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp of the last comment that was posted within this node, from comment.changed.',
  `last_comment_name` varchar(60) DEFAULT NULL COMMENT 'The name of the latest author to post a comment on this node, from comment.name.',
  `last_comment_uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The user ID of the latest author to post a comment on this node, from comment.uid.',
  `comment_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The total number of comments on this node.',
  PRIMARY KEY (`nid`),
  KEY `node_comment_timestamp` (`last_comment_timestamp`),
  KEY `comment_count` (`comment_count`),
  KEY `last_comment_uid` (`last_comment_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Maintains statistics of node and comments posts to show ...';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `node_comment_statistics` WRITE;
/*!40000 ALTER TABLE `node_comment_statistics` DISABLE KEYS */;
INSERT INTO `node_comment_statistics` VALUES (1,0,1336381904,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (2,0,1336381972,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (3,0,1336386878,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (4,0,1336388398,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (5,0,1336389421,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (6,0,1336390703,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (7,0,1336822047,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (8,0,1336823398,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (9,0,1337090565,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (10,0,1337181978,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (11,0,1337182769,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (12,0,1337521087,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (13,0,1337522398,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (14,0,1337712105,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (15,0,1337713163,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (16,0,1337778582,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (17,0,1338387394,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (18,0,1338405419,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (19,0,1338406062,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (20,0,1338741119,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (21,0,1338899568,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (22,0,1338901255,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (23,0,1338923787,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (24,0,1338998232,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (25,0,1339000205,NULL,9,0);
INSERT INTO `node_comment_statistics` VALUES (26,0,1339001085,NULL,9,0);
/*!40000 ALTER TABLE `node_comment_statistics` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


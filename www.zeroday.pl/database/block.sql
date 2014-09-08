
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
DROP TABLE IF EXISTS `block`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `block` (
  `bid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique block ID.',
  `module` varchar(64) NOT NULL DEFAULT '' COMMENT 'The module from which the block originates; for example, ’user’ for the Who’s Online block, and ’block’ for any custom blocks.',
  `delta` varchar(32) NOT NULL DEFAULT '0' COMMENT 'Unique ID for block within a module.',
  `theme` varchar(64) NOT NULL DEFAULT '' COMMENT 'The theme under which the block settings apply.',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Block enabled status. (1 = enabled, 0 = disabled)',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'Block weight within region.',
  `region` varchar(64) NOT NULL DEFAULT '' COMMENT 'Theme region within which the block is set.',
  `custom` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Flag to indicate how users may control visibility of the block. (0 = Users cannot control, 1 = On by default, but can be hidden, 2 = Hidden by default, but can be shown)',
  `visibility` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Flag to indicate how to show blocks on pages. (0 = Show on all pages except listed pages, 1 = Show only on listed pages, 2 = Use custom PHP code to determine visibility)',
  `pages` text NOT NULL COMMENT 'Contents of the "Pages" block; contains either a list of paths on which to include/exclude the block or PHP code, depending on "visibility" setting.',
  `title` varchar(64) NOT NULL DEFAULT '' COMMENT 'Custom title for the block. (Empty string will use block default title, <none> will remove the title, text will cause block to use specified title.)',
  `cache` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Binary flag to indicate block cache mode. (-2: Custom cache, -1: Do not cache, 1: Cache per role, 2: Cache per user, 4: Cache per page, 8: Block cache global) See DRUPAL_CACHE_* constants in ../includes/common.inc for more detailed information.',
  PRIMARY KEY (`bid`),
  UNIQUE KEY `tmd` (`theme`,`module`,`delta`),
  KEY `list` (`theme`,`status`,`region`,`weight`,`module`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8 COMMENT='Stores block settings, such as region and visibility...';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `block` WRITE;
/*!40000 ALTER TABLE `block` DISABLE KEYS */;
INSERT INTO `block` VALUES (1,'system','main','bartik',1,0,'content',0,0,'','',-1);
INSERT INTO `block` VALUES (2,'search','form','bartik',1,-1,'sidebar_first',0,0,'','',-1);
INSERT INTO `block` VALUES (3,'node','recent','seven',1,10,'dashboard_main',0,0,'','',-1);
INSERT INTO `block` VALUES (4,'user','login','bartik',1,0,'sidebar_first',0,0,'','',-1);
INSERT INTO `block` VALUES (5,'system','navigation','bartik',1,0,'sidebar_first',0,0,'','',-1);
INSERT INTO `block` VALUES (6,'system','powered-by','bartik',1,10,'footer',0,0,'','',-1);
INSERT INTO `block` VALUES (7,'system','help','bartik',1,0,'help',0,0,'','',-1);
INSERT INTO `block` VALUES (8,'system','main','seven',1,0,'content',0,0,'','',-1);
INSERT INTO `block` VALUES (9,'system','help','seven',1,0,'help',0,0,'','',-1);
INSERT INTO `block` VALUES (10,'user','login','seven',1,10,'content',0,0,'','',-1);
INSERT INTO `block` VALUES (11,'user','new','seven',1,0,'dashboard_sidebar',0,0,'','',-1);
INSERT INTO `block` VALUES (12,'search','form','seven',1,-10,'dashboard_sidebar',0,0,'','',-1);
INSERT INTO `block` VALUES (13,'comment','recent','bartik',0,0,'-1',0,0,'','',1);
INSERT INTO `block` VALUES (14,'locale','language','bartik',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (15,'node','syndicate','bartik',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (16,'node','recent','bartik',0,0,'-1',0,0,'','',1);
INSERT INTO `block` VALUES (17,'shortcut','shortcuts','bartik',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (18,'system','management','bartik',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (19,'system','user-menu','bartik',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (20,'system','main-menu','bartik',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (21,'user','new','bartik',0,0,'-1',0,0,'','',1);
INSERT INTO `block` VALUES (22,'user','online','bartik',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (23,'comment','recent','seven',1,0,'dashboard_inactive',0,0,'','',1);
INSERT INTO `block` VALUES (24,'locale','language','seven',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (25,'node','syndicate','seven',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (26,'shortcut','shortcuts','seven',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (27,'system','powered-by','seven',0,10,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (28,'system','navigation','seven',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (29,'system','management','seven',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (30,'system','user-menu','seven',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (31,'system','main-menu','seven',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (32,'user','online','seven',1,0,'dashboard_inactive',0,0,'','',-1);
INSERT INTO `block` VALUES (33,'comment','recent','garland',0,0,'-1',0,0,'','',1);
INSERT INTO `block` VALUES (34,'locale','language','garland',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (35,'node','recent','garland',0,0,'-1',0,0,'','',1);
INSERT INTO `block` VALUES (36,'node','syndicate','garland',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (37,'search','form','garland',1,-1,'sidebar_first',0,0,'','',-1);
INSERT INTO `block` VALUES (38,'shortcut','shortcuts','garland',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (39,'system','help','garland',1,0,'help',0,0,'','',-1);
INSERT INTO `block` VALUES (40,'system','main','garland',1,0,'content',0,0,'','',-1);
INSERT INTO `block` VALUES (41,'system','main-menu','garland',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (42,'system','management','garland',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (43,'system','navigation','garland',1,0,'sidebar_first',0,0,'','',-1);
INSERT INTO `block` VALUES (44,'system','powered-by','garland',1,10,'footer',0,0,'','',-1);
INSERT INTO `block` VALUES (45,'system','user-menu','garland',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (46,'user','login','garland',1,0,'sidebar_first',0,0,'','',-1);
INSERT INTO `block` VALUES (47,'user','new','garland',0,0,'-1',0,0,'','',1);
INSERT INTO `block` VALUES (48,'user','online','garland',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (49,'menu','features','bartik',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (50,'menu','features','garland',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (51,'menu','features','seven',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (52,'views','og_members-block_1','bartik',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (53,'views','og_members-block_1','garland',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (54,'views','og_members-block_1','seven',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (55,'comment','recent','fusion_starter',0,0,'-1',0,0,'','',1);
INSERT INTO `block` VALUES (56,'locale','language','fusion_starter',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (57,'menu','features','fusion_starter',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (58,'node','recent','fusion_starter',0,0,'-1',0,0,'','',1);
INSERT INTO `block` VALUES (59,'node','syndicate','fusion_starter',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (60,'search','form','fusion_starter',0,-1,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (61,'shortcut','shortcuts','fusion_starter',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (62,'system','help','fusion_starter',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (63,'system','main','fusion_starter',1,0,'content',0,0,'','',-1);
INSERT INTO `block` VALUES (64,'system','main-menu','fusion_starter',1,0,'main_menu',0,0,'','',-1);
INSERT INTO `block` VALUES (65,'system','management','fusion_starter',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (66,'system','navigation','fusion_starter',1,2,'sidebar_second',0,0,'','',-1);
INSERT INTO `block` VALUES (67,'system','powered-by','fusion_starter',0,-9,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (68,'system','user-menu','fusion_starter',1,1,'sidebar_second',0,0,'','',-1);
INSERT INTO `block` VALUES (69,'user','login','fusion_starter',1,0,'sidebar_second',0,0,'','',-1);
INSERT INTO `block` VALUES (70,'user','new','fusion_starter',0,0,'-1',0,0,'','',1);
INSERT INTO `block` VALUES (71,'user','online','fusion_starter',0,0,'-1',0,0,'','',-1);
INSERT INTO `block` VALUES (72,'views','og_members-block_1','fusion_starter',0,0,'-1',0,0,'','',-1);
/*!40000 ALTER TABLE `block` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


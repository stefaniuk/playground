
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
DROP TABLE IF EXISTS `node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node` (
  `nid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for a node.',
  `vid` int(10) unsigned DEFAULT NULL COMMENT 'The current node_revision.vid version identifier.',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT 'The node_type.type of this node.',
  `language` varchar(12) NOT NULL DEFAULT '' COMMENT 'The languages.language of this node.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'The title of this node, always treated as non-markup plain text.',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The users.uid that owns this node; initially, this is the user that created it.',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT 'Boolean indicating whether the node is published (visible to non-administrators).',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp when the node was created.',
  `changed` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp when the node was most recently saved.',
  `comment` int(11) NOT NULL DEFAULT '0' COMMENT 'Whether comments are allowed on this node: 0 = no, 1 = closed (read only), 2 = open (read/write).',
  `promote` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the node should be displayed on the front page.',
  `sticky` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the node should be displayed at the top of lists in which it appears.',
  `tnid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The translation set id for this node, which equals the node id of the source post in each set.',
  `translate` int(11) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this translation page needs to be updated.',
  PRIMARY KEY (`nid`),
  UNIQUE KEY `vid` (`vid`),
  KEY `node_changed` (`changed`),
  KEY `node_created` (`created`),
  KEY `node_frontpage` (`promote`,`status`,`sticky`,`created`),
  KEY `node_status_type` (`status`,`type`,`nid`),
  KEY `node_title_type` (`title`,`type`(4)),
  KEY `node_type` (`type`(4)),
  KEY `uid` (`uid`),
  KEY `tnid` (`tnid`),
  KEY `translate` (`translate`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COMMENT='The base table for nodes.';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `node` WRITE;
/*!40000 ALTER TABLE `node` DISABLE KEYS */;
INSERT INTO `node` VALUES (1,1,'news','pl','Anonimowi otwierają Anontune',9,1,1335085904,1336382118,2,1,0,0,0);
INSERT INTO `node` VALUES (2,2,'news','pl','Anonymous atakuje oficjalna stronę F1',9,1,1335085972,1336382162,2,1,0,0,0);
INSERT INTO `node` VALUES (3,3,'news','pl','Poważna luka w PHP w trybie CGI',9,1,1336386878,1336406625,2,1,0,0,0);
INSERT INTO `node` VALUES (4,4,'news','pl','IGPRS odzyskuje hasła TrueCrypta, iPhone’a i sieci Wi-Fi',9,1,1336388398,1336406728,2,1,0,0,0);
INSERT INTO `node` VALUES (5,5,'news','pl','Dziurawy Skype',9,1,1336389421,1336389421,2,1,0,0,0);
INSERT INTO `node` VALUES (6,6,'news','pl','Anonimowi atakuja rządową strone Putina',9,1,1336390703,1336390703,2,1,0,0,0);
INSERT INTO `node` VALUES (7,7,'news','pl','55000 haseł Twittera wyciekło',9,1,1336822047,1336822047,2,1,0,0,0);
INSERT INTO `node` VALUES (8,8,'news','pl','Strona North Las Vegas Police Department (NLVPD) zhakowana',9,1,1336823398,1336823398,2,1,0,0,0);
INSERT INTO `node` VALUES (9,9,'news','pl','Pirate Pay blokuje torrenty',9,1,1337090565,1337090565,2,1,0,0,0);
INSERT INTO `node` VALUES (10,10,'news','pl','Domena najwyższego poziomu .secure',9,1,1337181978,1337181978,2,1,0,0,0);
INSERT INTO `node` VALUES (11,11,'news','pl','NVIDIA GeForce GRID - chmura przyspiesza',9,1,1337182769,1337182828,2,1,0,0,0);
INSERT INTO `node` VALUES (12,12,'news','pl','7% Polskich stron rządowych bezpieczna',9,1,1337521087,1337521087,2,1,0,0,0);
INSERT INTO `node` VALUES (13,13,'news','pl','Oficjalna strona Eurowizji 2012 zhakowana',9,1,1337522398,1337522398,2,1,0,0,0);
INSERT INTO `node` VALUES (14,14,'news','pl','Trojan w patch\'u Call Of Duty',9,1,1337712105,1337712105,2,1,0,0,0);
INSERT INTO `node` VALUES (15,15,'news','pl','Strony Liberalnej Partii Quebec i Ministerstwa Edukacji wyłączone',9,1,1337713163,1337713163,2,1,0,0,0);
INSERT INTO `node` VALUES (16,16,'news','pl','Płać albo giń',9,1,1337778582,1337778582,2,1,0,0,0);
INSERT INTO `node` VALUES (17,17,'news','pl','Flame - najbardziej zaawansowany robak na świecie?',9,1,1338387394,1338387394,2,1,0,0,0);
INSERT INTO `node` VALUES (18,18,'news','pl','Certyfikat SSL złamany',9,1,1338405419,1338405419,2,1,0,0,0);
INSERT INTO `node` VALUES (19,19,'news','pl','Używasz pirackiego oprogramowania?',9,1,1338406062,1338406062,2,1,0,0,0);
INSERT INTO `node` VALUES (20,20,'news','pl','Za Stuxnetem stoją USA i Izrael',9,1,1338741119,1338741119,2,1,0,0,0);
INSERT INTO `node` VALUES (21,21,'news','pl','CAPTCHA Googla złamana',9,1,1338899568,1338899568,2,1,0,0,0);
INSERT INTO `node` VALUES (22,22,'news','pl','Rozrusznik serca na celowniku hakerów?',9,1,1338901255,1338901255,2,1,0,0,0);
INSERT INTO `node` VALUES (23,23,'news','pl','6 czerwca - IPv6 Day',9,1,1338923787,1338923787,2,1,0,0,0);
INSERT INTO `node` VALUES (24,24,'news','pl','6.5 miliona hashy haseł z LinkedIn ujawnionych',9,1,1338998232,1338998232,2,1,0,0,0);
INSERT INTO `node` VALUES (25,25,'news','pl','Gogle ostrzega użytkowników Gmaila przed \"sponsorowanymi\" atakami',9,1,1339000205,1339000205,2,1,0,0,0);
INSERT INTO `node` VALUES (26,26,'news','pl','Anonymous polują na pedofilów na Twitterze',9,1,1339001085,1339001085,2,1,0,0,0);
/*!40000 ALTER TABLE `node` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


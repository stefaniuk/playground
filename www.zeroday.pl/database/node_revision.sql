
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
DROP TABLE IF EXISTS `node_revision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_revision` (
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node this version belongs to.',
  `vid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for this version.',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The users.uid that created this version.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'The title of this version.',
  `log` longtext NOT NULL COMMENT 'The log entry explaining the changes in this version.',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when this version was created.',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT 'Boolean indicating whether the node (at the time of this revision) is published (visible to non-administrators).',
  `comment` int(11) NOT NULL DEFAULT '0' COMMENT 'Whether comments are allowed on this node (at the time of this revision): 0 = no, 1 = closed (read only), 2 = open (read/write).',
  `promote` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the node (at the time of this revision) should be displayed on the front page.',
  `sticky` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the node (at the time of this revision) should be displayed at the top of lists in which it appears.',
  PRIMARY KEY (`vid`),
  KEY `nid` (`nid`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COMMENT='Stores information about each saved version of a node.';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `node_revision` WRITE;
/*!40000 ALTER TABLE `node_revision` DISABLE KEYS */;
INSERT INTO `node_revision` VALUES (1,1,1,'Anonimowi otwierają Anontune','',1336382118,1,2,1,0);
INSERT INTO `node_revision` VALUES (2,2,1,'Anonymous atakuje oficjalna stronę F1','',1336382162,1,2,1,0);
INSERT INTO `node_revision` VALUES (3,3,1,'Poważna luka w PHP w trybie CGI','',1336406625,1,2,1,0);
INSERT INTO `node_revision` VALUES (4,4,1,'IGPRS odzyskuje hasła TrueCrypta, iPhone’a i sieci Wi-Fi','',1336406728,1,2,1,0);
INSERT INTO `node_revision` VALUES (5,5,9,'Dziurawy Skype','',1336389421,1,2,1,0);
INSERT INTO `node_revision` VALUES (6,6,9,'Anonimowi atakuja rządową strone Putina','',1336390703,1,2,1,0);
INSERT INTO `node_revision` VALUES (7,7,9,'55000 haseł Twittera wyciekło','',1336822047,1,2,1,0);
INSERT INTO `node_revision` VALUES (8,8,9,'Strona North Las Vegas Police Department (NLVPD) zhakowana','',1336823398,1,2,1,0);
INSERT INTO `node_revision` VALUES (9,9,9,'Pirate Pay blokuje torrenty','',1337090565,1,2,1,0);
INSERT INTO `node_revision` VALUES (10,10,9,'Domena najwyższego poziomu .secure','',1337181978,1,2,1,0);
INSERT INTO `node_revision` VALUES (11,11,9,'NVIDIA GeForce GRID - chmura przyspiesza','',1337182828,1,2,1,0);
INSERT INTO `node_revision` VALUES (12,12,9,'7% Polskich stron rządowych bezpieczna','',1337521087,1,2,1,0);
INSERT INTO `node_revision` VALUES (13,13,9,'Oficjalna strona Eurowizji 2012 zhakowana','',1337522398,1,2,1,0);
INSERT INTO `node_revision` VALUES (14,14,9,'Trojan w patch\'u Call Of Duty','',1337712105,1,2,1,0);
INSERT INTO `node_revision` VALUES (15,15,9,'Strony Liberalnej Partii Quebec i Ministerstwa Edukacji wyłączone','',1337713163,1,2,1,0);
INSERT INTO `node_revision` VALUES (16,16,9,'Płać albo giń','',1337778582,1,2,1,0);
INSERT INTO `node_revision` VALUES (17,17,9,'Flame - najbardziej zaawansowany robak na świecie?','',1338387394,1,2,1,0);
INSERT INTO `node_revision` VALUES (18,18,9,'Certyfikat SSL złamany','',1338405419,1,2,1,0);
INSERT INTO `node_revision` VALUES (19,19,9,'Używasz pirackiego oprogramowania?','',1338406062,1,2,1,0);
INSERT INTO `node_revision` VALUES (20,20,9,'Za Stuxnetem stoją USA i Izrael','',1338741119,1,2,1,0);
INSERT INTO `node_revision` VALUES (21,21,9,'CAPTCHA Googla złamana','',1338899568,1,2,1,0);
INSERT INTO `node_revision` VALUES (22,22,9,'Rozrusznik serca na celowniku hakerów?','',1338901255,1,2,1,0);
INSERT INTO `node_revision` VALUES (23,23,9,'6 czerwca - IPv6 Day','',1338923787,1,2,1,0);
INSERT INTO `node_revision` VALUES (24,24,9,'6.5 miliona hashy haseł z LinkedIn ujawnionych','',1338998232,1,2,1,0);
INSERT INTO `node_revision` VALUES (25,25,9,'Gogle ostrzega użytkowników Gmaila przed \"sponsorowanymi\" atakami','',1339000205,1,2,1,0);
INSERT INTO `node_revision` VALUES (26,26,9,'Anonymous polują na pedofilów na Twitterze','',1339001085,1,2,1,0);
/*!40000 ALTER TABLE `node_revision` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;



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
DROP TABLE IF EXISTS `taxonomy_term_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taxonomy_term_data` (
  `tid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique term ID.',
  `vid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The taxonomy_vocabulary.vid of the vocabulary to which the term is assigned.',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The term name.',
  `description` longtext COMMENT 'A description of the term.',
  `format` varchar(255) DEFAULT NULL COMMENT 'The filter_format.format of the description.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The weight of this term in relation to other terms.',
  PRIMARY KEY (`tid`),
  KEY `taxonomy_tree` (`vid`,`weight`,`name`),
  KEY `vid_name` (`vid`,`name`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8 COMMENT='Stores term information.';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `taxonomy_term_data` WRITE;
/*!40000 ALTER TABLE `taxonomy_term_data` DISABLE KEYS */;
INSERT INTO `taxonomy_term_data` VALUES (1,1,'anonymous',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (2,1,'file sharing',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (3,1,'hacking',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (4,1,'PHP',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (5,1,'luka',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (6,1,'serwer',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (7,1,'zagrożenie',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (8,1,'IGPRS',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (9,1,'backup',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (10,1,'iOS',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (11,1,'BlackBerry',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (12,1,'TrueCrypt',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (13,1,'WPA',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (14,1,'WPA2',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (15,1,'łamanie haseł',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (16,1,'Skype',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (17,1,'IP',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (18,1,'Anonimowi',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (19,1,'DDOS',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (20,1,'Twitter',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (21,1,'hasła',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (22,1,'login',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (23,1,'ZHC',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (24,1,'NLVPD',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (25,1,'hakerzy',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (26,1,'Pirate Pay',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (27,1,'Microsoft',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (28,1,'Torrent',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (29,1,'Domena',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (30,1,'Secure',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (31,1,'Artemis',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (32,1,'NVIDIA GRID',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (33,1,'Chmura',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (34,1,'CERT',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (35,1,'gov.pl',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (36,1,'Eurowizja',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (37,1,'Azejberdżan',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (38,1,'Cyberwarriors for Freedom',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (39,1,'Call Of Duty',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (40,1,'Malware',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (41,1,'Trojan',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (42,1,'Bill 78',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (43,1,'Government Websites',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (44,1,'Hosting',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (45,1,'Flame',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (46,1,'Robak',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (47,1,'Stuxnet',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (48,1,'Duqu',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (49,1,'NASA',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (50,1,'SSL',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (51,1,'Certyfikat',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (52,1,'BSA',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (53,1,'Raport',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (54,1,'Oprogramowanie',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (55,1,'USA',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (56,1,'Izrael',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (57,1,'CAPTCHA',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (58,1,'Google',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (59,1,'Rozrusznika Serca',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (60,1,'Defibrylator',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (61,1,'Cyberatak',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (62,1,'IPv6',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (63,1,'Protokół',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (64,1,'LinkedIn',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (65,1,'GoldenLine',NULL,NULL,0);
INSERT INTO `taxonomy_term_data` VALUES (66,1,'Gmail',NULL,NULL,0);
/*!40000 ALTER TABLE `taxonomy_term_data` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


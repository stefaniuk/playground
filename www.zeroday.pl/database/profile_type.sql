
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
DROP TABLE IF EXISTS `profile_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique profile type ID.',
  `type` varchar(32) NOT NULL COMMENT 'The machine-readable name of this profile type.',
  `label` varchar(255) NOT NULL DEFAULT '' COMMENT 'The human-readable name of this profile type.',
  `weight` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'The weight of this profile type in relation to others.',
  `data` longtext COMMENT 'A serialized array of additional data related to this profile type.',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'The exportable status of the entity.',
  `module` varchar(255) DEFAULT NULL COMMENT 'The name of the providing module if the entity has been defined in code.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Stores information about all defined profile types.';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `profile_type` WRITE;
/*!40000 ALTER TABLE `profile_type` DISABLE KEYS */;
INSERT INTO `profile_type` VALUES (1,'main','Main profile',0,'a:2:{s:12:\"registration\";b:1;s:8:\"use_page\";b:1;}',1,NULL);
/*!40000 ALTER TABLE `profile_type` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


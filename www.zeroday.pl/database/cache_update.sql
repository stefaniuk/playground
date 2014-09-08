
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
DROP TABLE IF EXISTS `cache_update`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache_update` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Cache table for the Update module to store information...';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `cache_update` WRITE;
/*!40000 ALTER TABLE `cache_update` DISABLE KEYS */;
INSERT INTO `cache_update` VALUES ('fetch_task::advanced_help',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::captcha',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::cck',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::ctools',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::drupal',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::entity',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::features',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::field_permissions',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::fusion',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::fusion_accelerator',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::google_analytics',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::libraries',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::metatag',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::og',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::panels',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::pathauto',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::profile2',NULL,0,1336539477,0);
INSERT INTO `cache_update` VALUES ('fetch_task::recaptcha',NULL,0,1336539477,0);
INSERT INTO `cache_update` VALUES ('fetch_task::rules',NULL,0,1336539477,0);
INSERT INTO `cache_update` VALUES ('fetch_task::site_verify',NULL,0,1336539477,0);
INSERT INTO `cache_update` VALUES ('fetch_task::stringoverrides',NULL,0,1336539477,0);
INSERT INTO `cache_update` VALUES ('fetch_task::token',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::views',NULL,0,1336547078,0);
INSERT INTO `cache_update` VALUES ('fetch_task::webform',NULL,0,1336547263,0);
INSERT INTO `cache_update` VALUES ('fetch_task::xmlsitemap',NULL,0,1336547078,0);
/*!40000 ALTER TABLE `cache_update` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


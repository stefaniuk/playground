
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
DROP TABLE IF EXISTS `cache_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache_menu` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Cache table for the menu system to store router...';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `cache_menu` WRITE;
/*!40000 ALTER TABLE `cache_menu` DISABLE KEYS */;
INSERT INTO `cache_menu` VALUES ('menu_custom','a:5:{s:8:\"features\";a:3:{s:9:\"menu_name\";s:8:\"features\";s:5:\"title\";s:8:\"Features\";s:11:\"description\";s:36:\"Menu items for any enabled features.\";}s:9:\"main-menu\";a:3:{s:9:\"menu_name\";s:9:\"main-menu\";s:5:\"title\";s:13:\"Menu główne\";s:11:\"description\";s:145:\"<em>Główne</em> menu wykorzystywane jest na wielu witrynach do pokazywania najważniejszych sekcji serwisu, często w górnej części witryny.\";}s:10:\"management\";a:3:{s:9:\"menu_name\";s:10:\"management\";s:5:\"title\";s:10:\"Management\";s:11:\"description\";s:69:\"Menu <em>Zarządzania</em> zawiera linki do zadań administracyjnych.\";}s:10:\"navigation\";a:3:{s:9:\"menu_name\";s:10:\"navigation\";s:5:\"title\";s:9:\"Nawigacja\";s:11:\"description\";s:160:\"Menu <em>Nawigacyjne</em> zawiera linki przeznaczone dla odwiedzającego witrynę. Niektóre moduły automatycznie dodają linki do menu <em>Nawigacyjnego</em>.\";}s:9:\"user-menu\";a:3:{s:9:\"menu_name\";s:9:\"user-menu\";s:5:\"title\";s:9:\"User menu\";s:11:\"description\";s:116:\"Menu <em>Użytkownika</em> zawiera linki powiązane z kontem użytkownika, czyli między innymi link \'Wyloguj się\'.\";}}',0,1336547504,1);
/*!40000 ALTER TABLE `cache_menu` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


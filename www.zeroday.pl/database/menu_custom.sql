
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
DROP TABLE IF EXISTS `menu_custom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `menu_custom` (
  `menu_name` varchar(32) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique key for menu. This is used as a block delta so length is 32.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'Menu title; displayed at top of block.',
  `description` text COMMENT 'Menu description.',
  PRIMARY KEY (`menu_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Holds definitions for top-level custom menus (for example...';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `menu_custom` WRITE;
/*!40000 ALTER TABLE `menu_custom` DISABLE KEYS */;
INSERT INTO `menu_custom` VALUES ('features','Features','Menu items for any enabled features.');
INSERT INTO `menu_custom` VALUES ('main-menu','Menu główne','<em>Główne</em> menu wykorzystywane jest na wielu witrynach do pokazywania najważniejszych sekcji serwisu, często w górnej części witryny.');
INSERT INTO `menu_custom` VALUES ('management','Management','Menu <em>Zarządzania</em> zawiera linki do zadań administracyjnych.');
INSERT INTO `menu_custom` VALUES ('navigation','Nawigacja','Menu <em>Nawigacyjne</em> zawiera linki przeznaczone dla odwiedzającego witrynę. Niektóre moduły automatycznie dodają linki do menu <em>Nawigacyjnego</em>.');
INSERT INTO `menu_custom` VALUES ('user-menu','User menu','Menu <em>Użytkownika</em> zawiera linki powiązane z kontem użytkownika, czyli między innymi link \'Wyloguj się\'.');
/*!40000 ALTER TABLE `menu_custom` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


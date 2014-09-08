
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
DROP TABLE IF EXISTS `panels_layout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `panels_layout` (
  `lid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'A database primary key to ensure uniqueness.',
  `name` varchar(255) DEFAULT NULL COMMENT 'Unique ID for this content. Used to identify it programmatically.',
  `admin_title` varchar(255) DEFAULT NULL COMMENT 'Administrative title for this layout.',
  `admin_description` longtext COMMENT 'Administrative description for this layout.',
  `category` varchar(255) DEFAULT NULL COMMENT 'Administrative category for this layout.',
  `plugin` varchar(255) DEFAULT NULL COMMENT 'The layout plugin that owns this layout.',
  `settings` longtext COMMENT 'Serialized settings for the actual layout. The contents of this field are up to the plugin that uses it.',
  PRIMARY KEY (`lid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contains exportable customized layouts for this site.';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `panels_layout` WRITE;
/*!40000 ALTER TABLE `panels_layout` DISABLE KEYS */;
/*!40000 ALTER TABLE `panels_layout` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


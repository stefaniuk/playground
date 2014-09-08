
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
DROP TABLE IF EXISTS `filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `filter` (
  `format` varchar(255) NOT NULL COMMENT 'Foreign key: The filter_format.format to which this filter is assigned.',
  `module` varchar(64) NOT NULL DEFAULT '' COMMENT 'The origin module of the filter.',
  `name` varchar(32) NOT NULL DEFAULT '' COMMENT 'Name of the filter being referenced.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'Weight of filter within format.',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT 'Filter enabled status. (1 = enabled, 0 = disabled)',
  `settings` longblob COMMENT 'A serialized array of name value pairs that store the filter settings for the specific format.',
  PRIMARY KEY (`format`,`name`),
  KEY `list` (`weight`,`module`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table that maps filters (HTML corrector) to text formats ...';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `filter` WRITE;
/*!40000 ALTER TABLE `filter` DISABLE KEYS */;
INSERT INTO `filter` VALUES ('filtered_html','filter','filter_autop',2,1,'a:0:{}');
INSERT INTO `filter` VALUES ('filtered_html','filter','filter_html',1,1,'a:3:{s:12:\"allowed_html\";s:74:\"<a> <em> <strong> <cite> <blockquote> <code> <ul> <ol> <li> <dl> <dt> <dd>\";s:16:\"filter_html_help\";i:1;s:20:\"filter_html_nofollow\";i:0;}');
INSERT INTO `filter` VALUES ('filtered_html','filter','filter_htmlcorrector',10,1,'a:0:{}');
INSERT INTO `filter` VALUES ('filtered_html','filter','filter_html_escape',10,0,'a:0:{}');
INSERT INTO `filter` VALUES ('filtered_html','filter','filter_url',0,1,'a:1:{s:17:\"filter_url_length\";i:72;}');
INSERT INTO `filter` VALUES ('full_html','filter','filter_autop',1,1,'a:0:{}');
INSERT INTO `filter` VALUES ('full_html','filter','filter_html',10,0,'a:3:{s:12:\"allowed_html\";s:74:\"<a> <em> <strong> <cite> <blockquote> <code> <ul> <ol> <li> <dl> <dt> <dd>\";s:16:\"filter_html_help\";i:1;s:20:\"filter_html_nofollow\";i:0;}');
INSERT INTO `filter` VALUES ('full_html','filter','filter_htmlcorrector',10,1,'a:0:{}');
INSERT INTO `filter` VALUES ('full_html','filter','filter_html_escape',10,0,'a:0:{}');
INSERT INTO `filter` VALUES ('full_html','filter','filter_url',0,1,'a:1:{s:17:\"filter_url_length\";i:72;}');
INSERT INTO `filter` VALUES ('plain_text','filter','filter_autop',2,1,'a:0:{}');
INSERT INTO `filter` VALUES ('plain_text','filter','filter_html',10,0,'a:3:{s:12:\"allowed_html\";s:74:\"<a> <em> <strong> <cite> <blockquote> <code> <ul> <ol> <li> <dl> <dt> <dd>\";s:16:\"filter_html_help\";i:1;s:20:\"filter_html_nofollow\";i:0;}');
INSERT INTO `filter` VALUES ('plain_text','filter','filter_htmlcorrector',10,0,'a:0:{}');
INSERT INTO `filter` VALUES ('plain_text','filter','filter_html_escape',0,1,'a:0:{}');
INSERT INTO `filter` VALUES ('plain_text','filter','filter_url',1,1,'a:1:{s:17:\"filter_url_length\";i:72;}');
/*!40000 ALTER TABLE `filter` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


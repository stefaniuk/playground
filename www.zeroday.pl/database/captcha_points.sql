
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
DROP TABLE IF EXISTS `captcha_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `captcha_points` (
  `form_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'The form_id of the form to add a CAPTCHA to.',
  `module` varchar(64) DEFAULT NULL COMMENT 'The module that provides the challenge.',
  `captcha_type` varchar(64) DEFAULT NULL COMMENT 'The challenge type to use.',
  PRIMARY KEY (`form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table describes which challenges should be added to...';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `captcha_points` WRITE;
/*!40000 ALTER TABLE `captcha_points` DISABLE KEYS */;
INSERT INTO `captcha_points` VALUES ('comment_node_article_form',NULL,NULL);
INSERT INTO `captcha_points` VALUES ('comment_node_page_form',NULL,NULL);
INSERT INTO `captcha_points` VALUES ('contact_personal_form',NULL,NULL);
INSERT INTO `captcha_points` VALUES ('contact_site_form',NULL,NULL);
INSERT INTO `captcha_points` VALUES ('forum_node_form',NULL,NULL);
INSERT INTO `captcha_points` VALUES ('user_login',NULL,NULL);
INSERT INTO `captcha_points` VALUES ('user_login_block',NULL,NULL);
INSERT INTO `captcha_points` VALUES ('user_pass',NULL,NULL);
INSERT INTO `captcha_points` VALUES ('user_register_form',NULL,NULL);
/*!40000 ALTER TABLE `captcha_points` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


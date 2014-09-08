
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
DROP TABLE IF EXISTS `captcha_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `captcha_sessions` (
  `csid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'CAPTCHA session ID.',
  `token` varchar(64) DEFAULT NULL COMMENT 'One time CAPTCHA token.',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'User’s users.uid.',
  `sid` varchar(64) NOT NULL DEFAULT '' COMMENT 'Session ID of the user.',
  `ip_address` varchar(128) DEFAULT NULL COMMENT 'IP address of the visitor.',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the challenge was generated.',
  `form_id` varchar(128) NOT NULL COMMENT 'The form_id of the form where the CAPTCHA is added to.',
  `solution` varchar(128) NOT NULL DEFAULT '' COMMENT 'Solution of the challenge.',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT 'Status of the CAPTCHA session (unsolved, solved, ...)',
  `attempts` int(11) NOT NULL DEFAULT '0' COMMENT 'The number of attempts.',
  PRIMARY KEY (`csid`),
  KEY `csid_ip` (`csid`,`ip_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores the data about CAPTCHA sessions (solution, IP...';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `captcha_sessions` WRITE;
/*!40000 ALTER TABLE `captcha_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `captcha_sessions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


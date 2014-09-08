
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
DROP TABLE IF EXISTS `webform_emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webform_emails` (
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node identifier of a webform.',
  `eid` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'The e-mail identifier for this row’s settings.',
  `email` text COMMENT 'The e-mail address that will be sent to upon submission. This may be an e-mail address, the special key "default" or a numeric value. If a numeric value is used, the value of a component will be substituted on submission.',
  `subject` varchar(255) DEFAULT NULL COMMENT 'The e-mail subject that will be used. This may be a string, the special key "default" or a numeric value. If a numeric value is used, the value of a component will be substituted on submission.',
  `from_name` varchar(255) DEFAULT NULL COMMENT 'The e-mail "from" name that will be used. This may be a string, the special key "default" or a numeric value. If a numeric value is used, the value of a component will be substituted on submission.',
  `from_address` varchar(255) DEFAULT NULL COMMENT 'The e-mail "from" e-mail address that will be used. This may be a string, the special key "default" or a numeric value. If a numeric value is used, the value of a component will be substituted on submission.',
  `template` text COMMENT 'A template that will be used for the sent e-mail. This may be a string or the special key "default", which will use the template provided by the theming layer.',
  `excluded_components` text NOT NULL COMMENT 'A list of components that will not be included in the %email_values token. A list of CIDs separated by commas.',
  `html` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Determines if the e-mail will be sent in an HTML format. Requires Mime Mail module.',
  `attachments` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Determines if the e-mail will include file attachments. Requires Mime Mail module.',
  PRIMARY KEY (`nid`,`eid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Holds information regarding e-mails that should be sent...';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `webform_emails` WRITE;
/*!40000 ALTER TABLE `webform_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `webform_emails` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


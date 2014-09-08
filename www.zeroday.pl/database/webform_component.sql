
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
DROP TABLE IF EXISTS `webform_component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webform_component` (
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node identifier of a webform.',
  `cid` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'The identifier for this component within this node, starts at 0 for each node.',
  `pid` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'If this component has a parent fieldset, the cid of that component.',
  `form_key` varchar(128) DEFAULT NULL COMMENT 'When the form is displayed and processed, this key can be used to reference the results.',
  `name` varchar(255) DEFAULT NULL COMMENT 'The label for this component.',
  `type` varchar(16) DEFAULT NULL COMMENT 'The field type of this component (textfield, select, hidden, etc.).',
  `value` text NOT NULL COMMENT 'The default value of the component when displayed to the end-user.',
  `extra` text NOT NULL COMMENT 'Additional information unique to the display or processing of this component.',
  `mandatory` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Boolean flag for if this component is required.',
  `weight` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Determines the position of this component in the form.',
  PRIMARY KEY (`nid`,`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores information about components for webform nodes.';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `webform_component` WRITE;
/*!40000 ALTER TABLE `webform_component` DISABLE KEYS */;
/*!40000 ALTER TABLE `webform_component` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


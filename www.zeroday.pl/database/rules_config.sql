
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
DROP TABLE IF EXISTS `rules_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rules_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The internal identifier for any configuration.',
  `name` varchar(64) NOT NULL COMMENT 'The name of the configuration.',
  `label` varchar(255) NOT NULL DEFAULT 'unlabeled' COMMENT 'The label of the configuration.',
  `plugin` varchar(127) NOT NULL COMMENT 'The name of the plugin of this configuration.',
  `active` int(11) NOT NULL DEFAULT '1' COMMENT 'Boolean indicating whether the configuration is active. Usage depends on how the using module makes use of it.',
  `weight` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Weight of the configuration. Usage depends on how the using module makes use of it.',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'The exportable status of the entity.',
  `dirty` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Dirty configurations fail the integrity check, e.g. due to missing dependencies.',
  `module` varchar(255) DEFAULT NULL COMMENT 'The name of the providing module if the entity has been defined in code.',
  `access_exposed` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Whether to use a permission to control access for using components.',
  `data` longblob COMMENT 'Everything else, serialized.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `plugin` (`plugin`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `rules_config` WRITE;
/*!40000 ALTER TABLE `rules_config` DISABLE KEYS */;
INSERT INTO `rules_config` VALUES (1,'rules_og_member_active','OG member subscribe (Active)','reaction rule',1,0,2,0,'og',0,'O:17:\"RulesReactionRule\":13:{s:9:\"\0*\0parent\";N;s:2:\"id\";s:1:\"1\";s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:0:{}s:4:\"name\";s:22:\"rules_og_member_active\";s:6:\"module\";s:2:\"og\";s:6:\"status\";i:2;s:5:\"label\";s:28:\"OG member subscribe (Active)\";s:11:\"\0*\0children\";a:2:{i:0;O:11:\"RulesAction\":6:{s:9:\"\0*\0parent\";r:1;s:2:\"id\";N;s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:4:{s:18:\"#_needs_processing\";b:1;s:9:\"to:select\";s:12:\"account:mail\";s:7:\"subject\";s:72:\"Your membership request was approved for \'[og_membership:group:label]\'\r\n\";s:7:\"message\";s:119:\"[account:name],\r\n\r\nYou are now a member in the group \'[og_membership:group:label]\' located at [og_membership:group:url]\";}s:14:\"\0*\0elementName\";s:4:\"mail\";}i:1;O:11:\"RulesAction\":6:{s:9:\"\0*\0parent\";r:1;s:2:\"id\";N;s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:4:{s:18:\"#_needs_processing\";b:1;s:9:\"to:select\";s:32:\"og-membership:group:manager:mail\";s:7:\"subject\";s:49:\"[account:name] joined [og_membership:group:label]\";s:7:\"message\";s:117:\"[og-membership:group:manager:name],\r\n\r\n[account:name] joined [og_membership:group:label] in [og_membership:group:url]\";}s:14:\"\0*\0elementName\";s:4:\"mail\";}}s:7:\"\0*\0info\";a:0:{}s:13:\"\0*\0conditions\";O:8:\"RulesAnd\":8:{s:9:\"\0*\0parent\";r:1;s:2:\"id\";N;s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:0:{}s:11:\"\0*\0children\";a:1:{i:0;O:14:\"RulesCondition\":7:{s:9:\"\0*\0parent\";r:35;s:2:\"id\";N;s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:4:{s:18:\"#_needs_processing\";b:1;s:11:\"data:select\";s:19:\"og-membership:state\";s:2:\"op\";s:2:\"==\";s:5:\"value\";s:1:\"1\";}s:14:\"\0*\0elementName\";s:7:\"data_is\";s:9:\"\0*\0negate\";b:0;}}s:7:\"\0*\0info\";a:0:{}s:9:\"\0*\0negate\";b:0;}s:9:\"\0*\0events\";a:1:{i:0;s:14:\"og_user_insert\";}}');
INSERT INTO `rules_config` VALUES (2,'rules_og_member_pending','OG member subscribe (Pending)','reaction rule',1,0,2,0,'og',0,'O:17:\"RulesReactionRule\":13:{s:9:\"\0*\0parent\";N;s:2:\"id\";s:1:\"2\";s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:0:{}s:4:\"name\";s:23:\"rules_og_member_pending\";s:6:\"module\";s:2:\"og\";s:6:\"status\";i:2;s:5:\"label\";s:29:\"OG member subscribe (Pending)\";s:11:\"\0*\0children\";a:2:{i:0;O:11:\"RulesAction\":6:{s:9:\"\0*\0parent\";r:1;s:2:\"id\";N;s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:4:{s:18:\"#_needs_processing\";b:1;s:9:\"to:select\";s:12:\"account:mail\";s:7:\"subject\";s:57:\"Your membership request for \'[og_membership:group:label]\'\";s:7:\"message\";s:131:\"[account:name],\r\n\r\nYour membership to group \'[og_membership:group:label]\' located at [og_membership:group:url] is pending approval.\";}s:14:\"\0*\0elementName\";s:4:\"mail\";}i:1;O:11:\"RulesAction\":6:{s:9:\"\0*\0parent\";r:1;s:2:\"id\";N;s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:4:{s:18:\"#_needs_processing\";b:1;s:9:\"to:select\";s:32:\"og-membership:group:manager:mail\";s:7:\"subject\";s:61:\"[account:name] membership request [og_membership:group:label]\";s:7:\"message\";s:184:\"[og-membership:group:manager:name],\r\n\r\n[account:name] requests membership for group \'[og_membership:group:label]\' in [og_membership:group:url].\r\n\r\n[og_membership:og-membership-request]\";}s:14:\"\0*\0elementName\";s:4:\"mail\";}}s:7:\"\0*\0info\";a:0:{}s:13:\"\0*\0conditions\";O:8:\"RulesAnd\":8:{s:9:\"\0*\0parent\";r:1;s:2:\"id\";N;s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:0:{}s:11:\"\0*\0children\";a:1:{i:0;O:14:\"RulesCondition\":7:{s:9:\"\0*\0parent\";r:35;s:2:\"id\";N;s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:4:{s:18:\"#_needs_processing\";b:1;s:11:\"data:select\";s:19:\"og-membership:state\";s:2:\"op\";s:2:\"==\";s:5:\"value\";s:1:\"2\";}s:14:\"\0*\0elementName\";s:7:\"data_is\";s:9:\"\0*\0negate\";b:0;}}s:7:\"\0*\0info\";a:0:{}s:9:\"\0*\0negate\";b:0;}s:9:\"\0*\0events\";a:1:{i:0;s:14:\"og_user_insert\";}}');
INSERT INTO `rules_config` VALUES (3,'rules_og_group_content_notification','OG group content notification','reaction rule',1,0,2,0,'og',0,'O:17:\"RulesReactionRule\":13:{s:9:\"\0*\0parent\";N;s:2:\"id\";s:1:\"3\";s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:0:{}s:4:\"name\";s:35:\"rules_og_group_content_notification\";s:6:\"module\";s:2:\"og\";s:6:\"status\";i:2;s:5:\"label\";s:29:\"OG group content notification\";s:11:\"\0*\0children\";a:2:{i:0;O:11:\"RulesAction\":6:{s:9:\"\0*\0parent\";r:1;s:2:\"id\";N;s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:4:{s:18:\"#_needs_processing\";b:1;s:20:\"group_content:select\";s:4:\"node\";s:17:\"group_members:var\";s:13:\"group_members\";s:19:\"group_members:label\";s:21:\"List of group members\";}s:14:\"\0*\0elementName\";s:14:\"og_get_members\";}i:1;O:9:\"RulesLoop\":7:{s:9:\"\0*\0parent\";r:1;s:2:\"id\";N;s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:3:{s:8:\"item:var\";s:9:\"list_item\";s:10:\"item:label\";s:17:\"Current list item\";s:11:\"list:select\";s:13:\"group-members\";}s:11:\"\0*\0children\";a:1:{i:0;O:11:\"RulesAction\":6:{s:9:\"\0*\0parent\";r:23;s:2:\"id\";N;s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:5:{s:18:\"#_needs_processing\";b:1;s:9:\"to:select\";s:14:\"list-item:mail\";s:7:\"subject\";s:17:\"New post in group\";s:7:\"message\";s:140:\"Hello [list-item:name],\r\n\r\nThere is a new post called [node:title] that belongs to one of the groups you are subscribed to.\r\n\r\n[site:name]\r\n\";s:11:\"from:select\";s:0:\"\";}s:14:\"\0*\0elementName\";s:4:\"mail\";}}s:7:\"\0*\0info\";a:0:{}}}s:7:\"\0*\0info\";a:0:{}s:13:\"\0*\0conditions\";O:8:\"RulesAnd\":8:{s:9:\"\0*\0parent\";r:1;s:2:\"id\";N;s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:0:{}s:11:\"\0*\0children\";a:1:{i:0;O:14:\"RulesCondition\":7:{s:9:\"\0*\0parent\";r:47;s:2:\"id\";N;s:12:\"\0*\0elementId\";N;s:6:\"weight\";i:0;s:8:\"settings\";a:2:{s:18:\"#_needs_processing\";b:1;s:13:\"entity:select\";s:4:\"node\";}s:14:\"\0*\0elementName\";s:26:\"og_entity_is_group_content\";s:9:\"\0*\0negate\";b:0;}}s:7:\"\0*\0info\";a:0:{}s:9:\"\0*\0negate\";b:0;}s:9:\"\0*\0events\";a:1:{i:0;s:11:\"node_insert\";}}');
/*!40000 ALTER TABLE `rules_config` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


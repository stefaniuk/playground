
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
DROP TABLE IF EXISTS `field_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `field_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for a field',
  `field_name` varchar(32) NOT NULL COMMENT 'The name of this field. Non-deleted field names are unique, but multiple deleted fields can have the same name.',
  `type` varchar(128) NOT NULL COMMENT 'The type of this field.',
  `module` varchar(128) NOT NULL DEFAULT '' COMMENT 'The module that implements the field type.',
  `active` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the module that implements the field type is enabled.',
  `storage_type` varchar(128) NOT NULL COMMENT 'The storage backend for the field.',
  `storage_module` varchar(128) NOT NULL DEFAULT '' COMMENT 'The module that implements the storage backend.',
  `storage_active` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the module that implements the storage backend is enabled.',
  `locked` tinyint(4) NOT NULL DEFAULT '0' COMMENT '@TODO',
  `data` longblob NOT NULL COMMENT 'Serialized data containing the field properties that do not warrant a dedicated column.',
  `cardinality` tinyint(4) NOT NULL DEFAULT '0',
  `translatable` tinyint(4) NOT NULL DEFAULT '0',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `field_name` (`field_name`),
  KEY `active` (`active`),
  KEY `storage_active` (`storage_active`),
  KEY `deleted` (`deleted`),
  KEY `module` (`module`),
  KEY `storage_module` (`storage_module`),
  KEY `type` (`type`),
  KEY `storage_type` (`storage_type`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `field_config` WRITE;
/*!40000 ALTER TABLE `field_config` DISABLE KEYS */;
INSERT INTO `field_config` VALUES (1,'comment_body','text_long','text',1,'field_sql_storage','field_sql_storage',1,0,'a:6:{s:12:\"entity_types\";a:1:{i:0;s:7:\"comment\";}s:12:\"translatable\";b:0;s:8:\"settings\";a:0:{}s:7:\"storage\";a:4:{s:4:\"type\";s:17:\"field_sql_storage\";s:8:\"settings\";a:0:{}s:6:\"module\";s:17:\"field_sql_storage\";s:6:\"active\";i:1;}s:12:\"foreign keys\";a:1:{s:6:\"format\";a:2:{s:5:\"table\";s:13:\"filter_format\";s:7:\"columns\";a:1:{s:6:\"format\";s:6:\"format\";}}}s:7:\"indexes\";a:1:{s:6:\"format\";a:1:{i:0;s:6:\"format\";}}}',1,0,0);
INSERT INTO `field_config` VALUES (2,'body','text_with_summary','text',1,'field_sql_storage','field_sql_storage',1,0,'a:8:{s:12:\"entity_types\";a:1:{i:0;s:4:\"node\";}s:12:\"translatable\";s:1:\"0\";s:8:\"settings\";a:1:{s:16:\"profile2_private\";b:0;}s:7:\"storage\";a:5:{s:4:\"type\";s:17:\"field_sql_storage\";s:8:\"settings\";a:0:{}s:6:\"module\";s:17:\"field_sql_storage\";s:6:\"active\";s:1:\"1\";s:7:\"details\";a:1:{s:3:\"sql\";a:2:{s:18:\"FIELD_LOAD_CURRENT\";a:1:{s:15:\"field_data_body\";a:3:{s:5:\"value\";s:10:\"body_value\";s:7:\"summary\";s:12:\"body_summary\";s:6:\"format\";s:11:\"body_format\";}}s:19:\"FIELD_LOAD_REVISION\";a:1:{s:19:\"field_revision_body\";a:3:{s:5:\"value\";s:10:\"body_value\";s:7:\"summary\";s:12:\"body_summary\";s:6:\"format\";s:11:\"body_format\";}}}}}s:12:\"foreign keys\";a:1:{s:6:\"format\";a:2:{s:5:\"table\";s:13:\"filter_format\";s:7:\"columns\";a:1:{s:6:\"format\";s:6:\"format\";}}}s:7:\"indexes\";a:1:{s:6:\"format\";a:1:{i:0;s:6:\"format\";}}s:2:\"id\";s:1:\"2\";s:17:\"field_permissions\";a:1:{s:4:\"type\";s:1:\"0\";}}',1,0,0);
INSERT INTO `field_config` VALUES (3,'field_tags','taxonomy_term_reference','taxonomy',1,'field_sql_storage','field_sql_storage',1,0,'a:8:{s:8:\"settings\";a:2:{s:14:\"allowed_values\";a:1:{i:0;a:2:{s:10:\"vocabulary\";s:4:\"tags\";s:6:\"parent\";i:0;}}s:16:\"profile2_private\";b:0;}s:12:\"entity_types\";a:0:{}s:12:\"translatable\";s:1:\"0\";s:7:\"storage\";a:5:{s:4:\"type\";s:17:\"field_sql_storage\";s:8:\"settings\";a:0:{}s:6:\"module\";s:17:\"field_sql_storage\";s:6:\"active\";s:1:\"1\";s:7:\"details\";a:1:{s:3:\"sql\";a:2:{s:18:\"FIELD_LOAD_CURRENT\";a:1:{s:21:\"field_data_field_tags\";a:1:{s:3:\"tid\";s:14:\"field_tags_tid\";}}s:19:\"FIELD_LOAD_REVISION\";a:1:{s:25:\"field_revision_field_tags\";a:1:{s:3:\"tid\";s:14:\"field_tags_tid\";}}}}}s:12:\"foreign keys\";a:1:{s:3:\"tid\";a:2:{s:5:\"table\";s:18:\"taxonomy_term_data\";s:7:\"columns\";a:1:{s:3:\"tid\";s:3:\"tid\";}}}s:7:\"indexes\";a:1:{s:3:\"tid\";a:1:{i:0;s:3:\"tid\";}}s:2:\"id\";s:1:\"3\";s:17:\"field_permissions\";a:1:{s:4:\"type\";s:1:\"0\";}}',-1,0,0);
INSERT INTO `field_config` VALUES (4,'field_image','image','image',1,'field_sql_storage','field_sql_storage',1,0,'a:8:{s:7:\"indexes\";a:1:{s:3:\"fid\";a:1:{i:0;s:3:\"fid\";}}s:8:\"settings\";a:3:{s:10:\"uri_scheme\";s:6:\"public\";s:13:\"default_image\";i:0;s:16:\"profile2_private\";b:0;}s:7:\"storage\";a:5:{s:4:\"type\";s:17:\"field_sql_storage\";s:8:\"settings\";a:0:{}s:6:\"module\";s:17:\"field_sql_storage\";s:6:\"active\";s:1:\"1\";s:7:\"details\";a:1:{s:3:\"sql\";a:2:{s:18:\"FIELD_LOAD_CURRENT\";a:1:{s:22:\"field_data_field_image\";a:5:{s:3:\"fid\";s:15:\"field_image_fid\";s:3:\"alt\";s:15:\"field_image_alt\";s:5:\"title\";s:17:\"field_image_title\";s:5:\"width\";s:17:\"field_image_width\";s:6:\"height\";s:18:\"field_image_height\";}}s:19:\"FIELD_LOAD_REVISION\";a:1:{s:26:\"field_revision_field_image\";a:5:{s:3:\"fid\";s:15:\"field_image_fid\";s:3:\"alt\";s:15:\"field_image_alt\";s:5:\"title\";s:17:\"field_image_title\";s:5:\"width\";s:17:\"field_image_width\";s:6:\"height\";s:18:\"field_image_height\";}}}}}s:12:\"entity_types\";a:0:{}s:12:\"translatable\";s:1:\"0\";s:12:\"foreign keys\";a:1:{s:3:\"fid\";a:2:{s:5:\"table\";s:12:\"file_managed\";s:7:\"columns\";a:1:{s:3:\"fid\";s:3:\"fid\";}}}s:2:\"id\";s:1:\"4\";s:17:\"field_permissions\";a:1:{s:4:\"type\";s:1:\"0\";}}',1,0,0);
INSERT INTO `field_config` VALUES (5,'group_audience','group','og',1,'field_sql_storage','field_sql_storage',1,0,'a:7:{s:5:\"no_ui\";b:1;s:12:\"entity_types\";a:0:{}s:12:\"translatable\";b:0;s:8:\"settings\";a:0:{}s:7:\"storage\";a:4:{s:4:\"type\";s:17:\"field_sql_storage\";s:8:\"settings\";a:0:{}s:6:\"module\";s:17:\"field_sql_storage\";s:6:\"active\";i:1;}s:12:\"foreign keys\";a:1:{s:2:\"og\";a:2:{s:5:\"table\";s:2:\"og\";s:7:\"columns\";a:1:{s:3:\"gid\";s:3:\"gid\";}}}s:7:\"indexes\";a:1:{s:3:\"gid\";a:1:{i:0;s:3:\"gid\";}}}',-1,0,0);
INSERT INTO `field_config` VALUES (6,'og_membership_request','text_long','text',1,'field_sql_storage','field_sql_storage',1,0,'a:6:{s:12:\"entity_types\";a:1:{i:0;s:13:\"og_membership\";}s:12:\"translatable\";b:0;s:8:\"settings\";a:0:{}s:7:\"storage\";a:4:{s:4:\"type\";s:17:\"field_sql_storage\";s:8:\"settings\";a:0:{}s:6:\"module\";s:17:\"field_sql_storage\";s:6:\"active\";i:1;}s:12:\"foreign keys\";a:1:{s:6:\"format\";a:2:{s:5:\"table\";s:13:\"filter_format\";s:7:\"columns\";a:1:{s:6:\"format\";s:6:\"format\";}}}s:7:\"indexes\";a:1:{s:6:\"format\";a:1:{i:0;s:6:\"format\";}}}',1,0,0);
INSERT INTO `field_config` VALUES (7,'field_source','text','text',1,'field_sql_storage','field_sql_storage',1,0,'a:8:{s:12:\"translatable\";s:1:\"0\";s:12:\"entity_types\";a:0:{}s:8:\"settings\";a:2:{s:10:\"max_length\";s:3:\"255\";s:16:\"profile2_private\";b:0;}s:7:\"storage\";a:5:{s:4:\"type\";s:17:\"field_sql_storage\";s:8:\"settings\";a:0:{}s:6:\"module\";s:17:\"field_sql_storage\";s:6:\"active\";s:1:\"1\";s:7:\"details\";a:1:{s:3:\"sql\";a:2:{s:18:\"FIELD_LOAD_CURRENT\";a:1:{s:23:\"field_data_field_source\";a:2:{s:5:\"value\";s:18:\"field_source_value\";s:6:\"format\";s:19:\"field_source_format\";}}s:19:\"FIELD_LOAD_REVISION\";a:1:{s:27:\"field_revision_field_source\";a:2:{s:5:\"value\";s:18:\"field_source_value\";s:6:\"format\";s:19:\"field_source_format\";}}}}}s:12:\"foreign keys\";a:1:{s:6:\"format\";a:2:{s:5:\"table\";s:13:\"filter_format\";s:7:\"columns\";a:1:{s:6:\"format\";s:6:\"format\";}}}s:7:\"indexes\";a:1:{s:6:\"format\";a:1:{i:0;s:6:\"format\";}}s:2:\"id\";s:1:\"7\";s:17:\"field_permissions\";a:1:{s:4:\"type\";s:1:\"0\";}}',1,0,0);
/*!40000 ALTER TABLE `field_config` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


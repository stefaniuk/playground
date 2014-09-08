SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `code4gecmf` ;
CREATE SCHEMA IF NOT EXISTS `code4gecmf` DEFAULT CHARACTER SET utf8 ;
USE `code4gecmf` ;

-- -----------------------------------------------------
-- Table `code4gecmf`.`AclResourceTypeDict`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`AclResourceTypeDict` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`AclResourceTypeDict` (
  `name` VARCHAR(50) NOT NULL ,
  PRIMARY KEY (`name`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `code4gecmf`.`AclResources`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`AclResources` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`AclResources` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `idParent` INT(11) NULL DEFAULT NULL ,
  `name` VARCHAR(200) NOT NULL ,
  `type` VARCHAR(50) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE_name_type` (`name` ASC, `type` ASC) ,
  INDEX `FK_AclResources_self` (`idParent` ASC) ,
  INDEX `FK_AclResources_AclResourceTypeDict` (`type` ASC) ,
  CONSTRAINT `FK_AclResources_self`
    FOREIGN KEY (`idParent` )
    REFERENCES `code4gecmf`.`AclResources` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_AclResources_AclResourceTypeDict`
    FOREIGN KEY (`type` )
    REFERENCES `code4gecmf`.`AclResourceTypeDict` (`name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `code4gecmf`.`AclModels`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`AclModels` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`AclModels` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(50) NOT NULL ,
  `create` VARCHAR(200) NULL DEFAULT NULL ,
  `read` VARCHAR(200) NULL DEFAULT NULL ,
  `update` VARCHAR(200) NULL DEFAULT NULL ,
  `delete` VARCHAR(200) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE_name` (`name` ASC) ,
  INDEX `FK_AclModels_create_AclResources` (`create` ASC) ,
  INDEX `FK_AclModels_read_AclResources` (`read` ASC) ,
  INDEX `FK_AclModels_update_AclResources` (`update` ASC) ,
  INDEX `FK_AclModels_delete_AclResources` (`delete` ASC) ,
  CONSTRAINT `FK_AclModels_create_AclResources`
    FOREIGN KEY (`create` )
    REFERENCES `code4gecmf`.`AclResources` (`name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_AclModels_read_AclResources`
    FOREIGN KEY (`read` )
    REFERENCES `code4gecmf`.`AclResources` (`name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_AclModels_update_AclResources`
    FOREIGN KEY (`update` )
    REFERENCES `code4gecmf`.`AclResources` (`name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_AclModels_delete_AclResources`
    FOREIGN KEY (`delete` )
    REFERENCES `code4gecmf`.`AclResources` (`name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `code4gecmf`.`AclRoles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`AclRoles` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`AclRoles` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `idParent` INT(11) NULL DEFAULT NULL ,
  `name` VARCHAR(32) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE_name` (`name` ASC) ,
  INDEX `FK_AclRoles_self` (`idParent` ASC) ,
  CONSTRAINT `FK_AclRoles_self`
    FOREIGN KEY (`idParent` )
    REFERENCES `code4gecmf`.`AclRoles` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `code4gecmf`.`AclPrivilegeDict`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`AclPrivilegeDict` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`AclPrivilegeDict` (
  `name` VARCHAR(8) NOT NULL ,
  PRIMARY KEY (`name`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `code4gecmf`.`AclPermissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`AclPermissions` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`AclPermissions` (
  `idRole` INT(11) NOT NULL ,
  `idResource` INT(11) NOT NULL ,
  `privilege` VARCHAR(8) NOT NULL ,
  `access` VARCHAR(8) NOT NULL ,
  PRIMARY KEY (`idRole`, `idResource`, `privilege`) ,
  INDEX `FK_AclPermissions_AclRoles` (`idRole` ASC) ,
  INDEX `FK_AclPermissions_AclResources` (`idResource` ASC) ,
  INDEX `FK_AclPermissions_AclPrivilegeDict` (`privilege` ASC) ,
  CONSTRAINT `FK_AclPermissions_AclRoles`
    FOREIGN KEY (`idRole` )
    REFERENCES `code4gecmf`.`AclRoles` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_AclPermissions_AclResources`
    FOREIGN KEY (`idResource` )
    REFERENCES `code4gecmf`.`AclResources` (`id` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_AclPermissions_AclPermissionDict`
    FOREIGN KEY (`privilege` )
    REFERENCES `code4gecmf`.`AclPrivilegeDict` (`name` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `code4gecmf`.`AclRoleHomes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`AclRoleHomes` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`AclRoleHomes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `idRole` INT(11) NOT NULL ,
  `url` VARCHAR(200) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE_idRole` (`idRole` ASC) ,
  INDEX `FK_AclRoleHomes_AclRoles` (`idRole` ASC) ,
  CONSTRAINT `FK_AclRoleHomes_AclRoles`
    FOREIGN KEY (`idRole` )
    REFERENCES `code4gecmf`.`AclRoles` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `code4gecmf`.`Logs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`Logs` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`Logs` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATETIME NOT NULL ,
  `ip` VARCHAR(39) NOT NULL ,
  `username` VARCHAR(32) NULL DEFAULT NULL ,
  `useragent` TEXT NOT NULL ,
  `url` VARCHAR(256) NOT NULL ,
  `priority` INT(11) NOT NULL ,
  `message` TEXT NOT NULL ,
  INDEX `INDEX_date` (`date` DESC) ,
  INDEX `INDEX_ip` (`ip` ASC) ,
  INDEX `INDEX_username` (`username` ASC) ,
  INDEX `INDEX_url` (`url` ASC) ,
  INDEX `INDEX_priority` (`priority` ASC) ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `code4gecmf`.`Sessions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`Sessions` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`Sessions` (
  `name` VARCHAR(32) NOT NULL ,
  `id` VARCHAR(32) NOT NULL ,
  `ip` VARCHAR(39) NOT NULL ,
  `username` VARCHAR(32) NULL DEFAULT NULL ,
  `useragent` TEXT NOT NULL ,
  `modified` INT(11) NOT NULL ,
  `lifetime` INT(11) NOT NULL ,
  `data` TEXT NULL DEFAULT NULL ,
  PRIMARY KEY (`modified`, `name`, `id`) ,
  INDEX `INDEX_ip` (`ip` ASC) ,
  INDEX `INDEX_username` (`username` ASC) ,
  INDEX `INDEX_modified` (`modified` DESC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `code4gecmf`.`Languages`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`Languages` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`Languages` (
  `code` VARCHAR(8) NOT NULL ,
  `name` VARCHAR(50) NOT NULL ,
  `isDefault` TINYINT(1) NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`code`) ,
  INDEX `INDEX_name` (`name` ASC) ,
  INDEX `INDEX_isDefault` (`isDefault` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `code4gecmf`.`Users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`Users` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`Users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(32) NOT NULL ,
  `fullName` VARCHAR(256) NULL DEFAULT NULL ,
  `password` VARCHAR(256) NOT NULL ,
  `email` VARCHAR(254) NOT NULL ,
  `role` VARCHAR(32) NOT NULL ,
  `dateCreated` DATETIME NOT NULL ,
  `dateConfirmed` DATETIME NULL DEFAULT NULL ,
  `dateLastLogin` DATETIME NULL DEFAULT NULL ,
  `banned` TINYINT(1) NOT NULL DEFAULT 0 ,
  `editable` TINYINT(1) NOT NULL DEFAULT 1 ,
  `defaultLanguage` VARCHAR(8) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE_name` (`name` ASC) ,
  INDEX `FK_Users_AclRoles` (`role` ASC) ,
  INDEX `FK_Users_Languages` (`defaultLanguage` ASC) ,
  CONSTRAINT `FK_Users_AclRoles`
    FOREIGN KEY (`role` )
    REFERENCES `code4gecmf`.`AclRoles` (`name` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Users_Languages`
    FOREIGN KEY (`defaultLanguage` )
    REFERENCES `code4gecmf`.`Languages` (`code` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `code4gecmf`.`Events`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`Events` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`Events` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATETIME NOT NULL ,
  `module` VARCHAR(50) NOT NULL ,
  `ip` VARCHAR(39) NOT NULL ,
  `username` VARCHAR(32) NULL DEFAULT NULL ,
  `type` VARCHAR(50) NOT NULL ,
  `message` TEXT NOT NULL ,
  INDEX `INDEX_date` (`date` DESC) ,
  INDEX `INDEX_ip` (`ip` ASC) ,
  INDEX `INDEX_username` (`username` ASC) ,
  INDEX `INDEX_type` (`type` ASC) ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `code4gecmf`.`EmailConfirmationTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`EmailConfirmationTypes` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`EmailConfirmationTypes` (
  `name` VARCHAR(50) NOT NULL ,
  PRIMARY KEY (`name`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `code4gecmf`.`EmailConfirmationTemplates`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`EmailConfirmationTemplates` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`EmailConfirmationTemplates` (
  `type` VARCHAR(50) NOT NULL ,
  `language` VARCHAR(8) NOT NULL ,
  `template` TEXT NULL DEFAULT NULL ,
  PRIMARY KEY (`type`, `language`) ,
  INDEX `FK_EmailConfirmationTemplates_EmailConfirmationType` (`type` ASC) ,
  INDEX `FK_ConfirmEmailTemplates_Languages` (`language` ASC) ,
  CONSTRAINT `FK_EmailConfirmationTemplates_EmailConfirmationType`
    FOREIGN KEY (`type` )
    REFERENCES `code4gecmf`.`EmailConfirmationTypes` (`name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_ConfirmEmailTemplates_Languages`
    FOREIGN KEY (`language` )
    REFERENCES `code4gecmf`.`Languages` (`code` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `code4gecmf`.`EmailConfirmations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `code4gecmf`.`EmailConfirmations` ;

CREATE  TABLE IF NOT EXISTS `code4gecmf`.`EmailConfirmations` (
  `code` VARCHAR(100) NOT NULL ,
  `type` VARCHAR(50) NOT NULL ,
  `language` VARCHAR(8) NOT NULL ,
  `email` VARCHAR(254) NOT NULL ,
  `dateCreated` DATETIME NOT NULL ,
  `dateConfirmed` DATETIME NULL DEFAULT NULL ,
  `dateExpiry` DATETIME NULL DEFAULT NULL ,
  PRIMARY KEY (`code`) ,
  INDEX `INDEX_email` (`email` ASC) ,
  INDEX `INDEX_dateCreated` (`dateCreated` ASC) ,
  INDEX `INDEX_dateConfirmed` (`dateConfirmed` ASC) ,
  INDEX `INDEX_dateExpiry` (`dateExpiry` ASC) ,
  INDEX `FK_EmailConfirmations_EmailConfirmationType` (`type` ASC) ,
  INDEX `FK_ConfirmEmails_ConfirmEmailTemplates` (`type` ASC, `language` ASC) ,
  CONSTRAINT `FK_EmailConfirmations_EmailConfirmationType`
    FOREIGN KEY (`type` )
    REFERENCES `code4gecmf`.`EmailConfirmationTypes` (`name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_ConfirmEmails_ConfirmEmailTemplates`
    FOREIGN KEY (`type` , `language` )
    REFERENCES `code4gecmf`.`EmailConfirmationTemplates` (`type` , `language` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Placeholder table for view `code4gecmf`.`AclPermissionView`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `code4gecmf`.`AclPermissionView` (`roleId` INT, `roleName` INT, `resourceId` INT, `resourceName` INT, `resourceType` INT, `privilege` INT, `access` INT);

-- -----------------------------------------------------
-- View `code4gecmf`.`AclPermissionView`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `code4gecmf`.`AclPermissionView` ;
DROP TABLE IF EXISTS `code4gecmf`.`AclPermissionView`;
USE `code4gecmf`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `AclPermissionView` AS select `roles`.`id` AS `roleId`,`roles`.`name` AS `roleName`,`res`.`id` AS `resourceId`,`res`.`name` AS `resourceName`,`res`.`type` AS `resourceType`,`perm`.`privilege` AS `privilege`,`perm`.`access` AS `access` from ((`AclRoles` `roles` join `AclResources` `res`) join `AclPermissions` `perm`) where ((`roles`.`id` = `perm`.`idRole`) and (`perm`.`idResource` = `res`.`id`));


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `host4ge` ;
CREATE SCHEMA IF NOT EXISTS `host4ge` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `host4ge` ;

-- -----------------------------------------------------
-- Table `host4ge`.`customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`customers` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`customers` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `type` ENUM('company','person') NOT NULL DEFAULT 'person' ,
  `title` VARCHAR(10) NULL ,
  `forenames` VARCHAR(64) NULL ,
  `surname` VARCHAR(128) NULL ,
  `company` VARCHAR(64) NULL ,
  `phone` VARCHAR(32) NOT NULL ,
  `email` VARCHAR(128) NOT NULL ,
  `address1` VARCHAR(64) NOT NULL ,
  `address2` VARCHAR(64) NULL ,
  `address3` VARCHAR(64) NULL ,
  `address4` VARCHAR(64) NULL ,
  `postcode` VARCHAR(16) NOT NULL ,
  `country` VARCHAR(32) NOT NULL ,
  `language` VARCHAR(5) NOT NULL ,
  `created` TIMESTAMP NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE` (`email` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`services`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`services` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`services` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(32) NOT NULL ,
  `label` VARCHAR(64) NOT NULL ,
  `description` VARCHAR(512) NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE` (`name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`servers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`servers` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`servers` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(32) NOT NULL ,
  `domain` VARCHAR(128) NOT NULL ,
  `ipaddress` VARCHAR(15) NOT NULL ,
  `location` VARCHAR(8) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE` (`name` ASC) ,
  UNIQUE INDEX `unq_ipaddress` (`ipaddress` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`accounts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`accounts` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`accounts` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `customer_id` INT NOT NULL ,
  `servername` VARCHAR(32) NOT NULL ,
  `name` VARCHAR(64) NOT NULL ,
  `password` VARCHAR(128) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE` (`servername` ASC, `name` ASC) ,
  INDEX `fk_accounts_servername` (`servername` ASC) ,
  INDEX `fk_accounts_customer_id` (`customer_id` ASC) ,
  CONSTRAINT `fk_accounts_servername`
    FOREIGN KEY (`servername` )
    REFERENCES `host4ge`.`servers` (`name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accounts_customer_id`
    FOREIGN KEY (`customer_id` )
    REFERENCES `host4ge`.`customers` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`account_services`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`account_services` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`account_services` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `account_id` INT NOT NULL ,
  `service_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE` (`account_id` ASC, `service_id` ASC) ,
  INDEX `fk_account_services_account_id` (`account_id` ASC) ,
  INDEX `fk_account_services_service_id` (`service_id` ASC) ,
  CONSTRAINT `fk_account_services_account_id`
    FOREIGN KEY (`account_id` )
    REFERENCES `host4ge`.`accounts` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_account_services_service_id`
    FOREIGN KEY (`service_id` )
    REFERENCES `host4ge`.`services` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`server_services`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`server_services` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`server_services` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `servername` VARCHAR(32) NOT NULL ,
  `servicename` VARCHAR(32) NOT NULL ,
  `version` VARCHAR(16) NOT NULL ,
  `path` VARCHAR(128) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE` (`servername` ASC, `servicename` ASC) ,
  INDEX `fk_server_services_servername` (`servername` ASC) ,
  INDEX `fk_server_services_servicename` (`servicename` ASC) ,
  CONSTRAINT `fk_server_services_servername`
    FOREIGN KEY (`servername` )
    REFERENCES `host4ge`.`servers` (`name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_server_services_servicename`
    FOREIGN KEY (`servicename` )
    REFERENCES `host4ge`.`services` (`name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`account_permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`account_permissions` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`account_permissions` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `account_id` INT NOT NULL ,
  `service_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE` (`account_id` ASC, `service_id` ASC) ,
  INDEX `fk_account_permissions_account_id` (`account_id` ASC) ,
  INDEX `fk_account_permissions_service_id` (`service_id` ASC) ,
  CONSTRAINT `fk_account_permissions_account_id`
    FOREIGN KEY (`account_id` )
    REFERENCES `host4ge`.`accounts` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_account_permissions_service_id`
    FOREIGN KEY (`service_id` )
    REFERENCES `host4ge`.`services` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`server_cpu`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`server_cpu` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`server_cpu` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATETIME NOT NULL ,
  `servername` VARCHAR(32) NOT NULL ,
  `usr` DECIMAL(5,2) NOT NULL DEFAULT 0.0 ,
  `nice` DECIMAL(5,2) NOT NULL DEFAULT 0.0 ,
  `sys` DECIMAL(5,2) NOT NULL DEFAULT 0.0 ,
  `iowait` DECIMAL(5,2) NOT NULL DEFAULT 0.0 ,
  `irq` DECIMAL(5,2) NOT NULL DEFAULT 0.0 ,
  `soft` DECIMAL(5,2) NOT NULL DEFAULT 0.0 ,
  `steal` DECIMAL(5,2) NOT NULL DEFAULT 0.0 ,
  `guest` DECIMAL(5,2) NOT NULL DEFAULT 0.0 ,
  `idle` DECIMAL(5,2) NOT NULL DEFAULT 0.0 ,
  PRIMARY KEY (`id`) ,
  INDEX `INDEX` (`date` ASC, `servername` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`server_memory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`server_memory` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`server_memory` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATETIME NOT NULL ,
  `servername` VARCHAR(32) NOT NULL ,
  `mem_total` BIGINT NOT NULL ,
  `mem_used` BIGINT NOT NULL ,
  `swap_total` BIGINT NOT NULL ,
  `swap_used` BIGINT NOT NULL ,
  `buffers_used` BIGINT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `INDEX` (`date` ASC, `servername` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`server_traffic`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`server_traffic` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`server_traffic` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATETIME NOT NULL ,
  `servername` VARCHAR(32) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `INDEX` (`date` ASC, `servername` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`server_disk_space`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`server_disk_space` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`server_disk_space` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATETIME NOT NULL ,
  `servername` VARCHAR(32) NOT NULL ,
  `filesystem` VARCHAR(64) NOT NULL ,
  `mounted_on` VARCHAR(32) NOT NULL ,
  `used` BIGINT NOT NULL ,
  `avail` BIGINT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `INDEX` (`date` ASC, `servername` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`server_processes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`server_processes` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`server_processes` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATETIME NOT NULL ,
  `servername` VARCHAR(32) NOT NULL ,
  `command` VARCHAR(64) NOT NULL ,
  `username` VARCHAR(64) NOT NULL ,
  `pid` INT NOT NULL ,
  `cpu` DECIMAL(5,2) NOT NULL ,
  `mem` BIGINT NOT NULL ,
  `swap` BIGINT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `INDEX` (`date` ASC, `servername` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`server_network_connections`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`server_network_connections` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`server_network_connections` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATETIME NOT NULL ,
  `servername` VARCHAR(32) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `INDEX` (`date` ASC, `servername` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`variables`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`variables` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`variables` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(128) NOT NULL ,
  `value` LONGBLOB NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE` (`name` ASC) )
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

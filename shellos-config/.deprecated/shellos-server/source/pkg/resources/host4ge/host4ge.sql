SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `host4ge` ;
CREATE SCHEMA IF NOT EXISTS `host4ge` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `host4ge` ;

-- -----------------------------------------------------
-- Table `host4ge`.`cpu_usage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`cpu_usage` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`cpu_usage` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `timestamp` DATETIME NOT NULL ,
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
  INDEX `INDEX` (`timestamp` ASC, `servername` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`memory_usage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`memory_usage` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`memory_usage` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `timestamp` DATETIME NOT NULL ,
  `servername` VARCHAR(32) NOT NULL ,
  `mem_total` BIGINT NOT NULL ,
  `mem_used` BIGINT NOT NULL ,
  `swap_total` BIGINT NOT NULL ,
  `swap_used` BIGINT NOT NULL ,
  `buffers_used` BIGINT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `INDEX` (`timestamp` ASC, `servername` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`network_usage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`network_usage` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`network_usage` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `timestamp` DATETIME NOT NULL ,
  `servername` VARCHAR(32) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `INDEX` (`timestamp` ASC, `servername` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`disk_usage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`disk_usage` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`disk_usage` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `timestamp` DATETIME NOT NULL ,
  `servername` VARCHAR(32) NOT NULL ,
  `device` VARCHAR(64) NOT NULL ,
  `mountpoint` VARCHAR(32) NOT NULL ,
  `used` BIGINT NOT NULL ,
  `available` BIGINT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `INDEX` (`timestamp` ASC, `servername` ASC) ,
  INDEX `idx_device` (`device` ASC) ,
  INDEX `idx_mountpoint` (`mountpoint` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`memory_usage_processes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`memory_usage_processes` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`memory_usage_processes` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `timestamp` DATETIME NOT NULL ,
  `servername` VARCHAR(32) NOT NULL ,
  `size` BIGINT NOT NULL ,
  `rss` BIGINT NOT NULL ,
  `vsz` BIGINT NOT NULL ,
  `pid` INT NOT NULL ,
  `user` VARCHAR(32) NOT NULL ,
  `cmd` VARCHAR(1024) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `INDEX` (`timestamp` ASC, `servername` ASC) ,
  INDEX `idx_pid` (`pid` ASC) ,
  INDEX `idx_user` (`user` ASC) ,
  INDEX `idx_cmd` (`cmd` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `host4ge`.`network_connections`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`network_connections` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`network_connections` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `timestamp` DATETIME NOT NULL ,
  `servername` VARCHAR(32) NOT NULL ,
  `local_address` VARCHAR(256) NOT NULL ,
  `local_port` VARCHAR(8) NOT NULL ,
  `foreign_address` VARCHAR(256) NOT NULL ,
  `foreign_port` VARCHAR(8) NOT NULL ,
  `pid` INT NOT NULL ,
  `user` VARCHAR(32) NOT NULL ,
  `cmd` VARCHAR(1024) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `INDEX` (`timestamp` ASC, `servername` ASC) ,
  INDEX `idx_local_address` (`local_address` ASC) ,
  INDEX `idx_local_port` (`local_port` ASC) ,
  INDEX `idx_foreign_address` (`foreign_address` ASC) ,
  INDEX `idx_foreign_port` (`foreign_port` ASC) ,
  INDEX `idx_pid` (`pid` ASC) ,
  INDEX `idx_user` (`user` ASC) ,
  INDEX `idx_cmd` (`cmd` ASC) )
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

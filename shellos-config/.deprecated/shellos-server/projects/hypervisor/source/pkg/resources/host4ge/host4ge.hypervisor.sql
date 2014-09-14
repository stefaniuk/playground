SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `host4ge` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `host4ge` ;

-- -----------------------------------------------------
-- Table `host4ge`.`nodes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `host4ge`.`nodes` ;

CREATE  TABLE IF NOT EXISTS `host4ge`.`nodes` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `timestamp` DATETIME NOT NULL ,
  `servername` VARCHAR(32) NOT NULL ,
  `cpus` INT NOT NULL ,
  `mem` VARCHAR(20) NOT NULL ,
  `disk` VARCHAR(20) NOT NULL ,
  `ip` VARCHAR(15) NOT NULL ,
  `name` VARCHAR(32) NOT NULL ,
  `description` VARCHAR(1000) NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE` (`servername` ASC, `name` ASC) )
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

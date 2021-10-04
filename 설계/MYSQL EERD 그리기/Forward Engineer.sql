-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema socialbookmark
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema socialbookmark
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `socialbookmark` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `socialbookmark` ;

-- -----------------------------------------------------
-- Table `socialbookmark`.`User`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialbookmark`.`User` ;

CREATE TABLE IF NOT EXISTS `socialbookmark`.`User` (
  `Num` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Id` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(256) NOT NULL COMMENT '암호화 예정, 256정도면 충분\n',
  `Nick` VARCHAR(45) NOT NULL,
  `RegDate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `RecentLogin` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Status` INT NOT NULL COMMENT '0: 정지회원\n1:일반회원',
  `SuperUser` INT NOT NULL COMMENT '0:일반회원\n1:최고관리자',
  PRIMARY KEY (`Num`),
  UNIQUE INDEX `id_UNIQUE` (`Id` ASC) VISIBLE,
  UNIQUE INDEX `Nick_UNIQUE` (`Nick` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socialbookmark`.`Category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialbookmark`.`Category` ;

CREATE TABLE IF NOT EXISTS `socialbookmark`.`Category` (
  `Num` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `CreatedUser` INT UNSIGNED NOT NULL,
  `RegDate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Status` INT NOT NULL DEFAULT 0 COMMENT '0: Private(default)\n1: Public',
  PRIMARY KEY (`Num`),
  INDEX `fk_Category_User_CreatedUser_idx` (`CreatedUser` ASC) VISIBLE,
  CONSTRAINT `fk_Category_User_CreatedUser`
    FOREIGN KEY (`CreatedUser`)
    REFERENCES `socialbookmark`.`User` (`Num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socialbookmark`.`Bookmark`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialbookmark`.`Bookmark` ;

CREATE TABLE IF NOT EXISTS `socialbookmark`.`Bookmark` (
  `Num` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Category` INT UNSIGNED NOT NULL COMMENT '카테코리',
  `CreatedUser` INT UNSIGNED NOT NULL COMMENT '회원번호',
  `AuthorizedUser` INT UNSIGNED NULL COMMENT '접근가능 유저',
  `URL` VARCHAR(2083) NOT NULL,
  `Content` TEXT NULL,
  `RegDate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Num`),
  INDEX `fk_Bookmark_User_idx` (`CreatedUser` ASC) VISIBLE,
  INDEX `fk_Bookmark_Category_idx` (`Category` ASC) VISIBLE,
  INDEX `fk_Bookmark_User_AuthorizedUser_idx` (`AuthorizedUser` ASC) VISIBLE,
  CONSTRAINT `fk_Bookmark_User_CreatedUser`
    FOREIGN KEY (`CreatedUser`)
    REFERENCES `socialbookmark`.`User` (`Num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bookmark_Category`
    FOREIGN KEY (`Category`)
    REFERENCES `socialbookmark`.`Category` (`Num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bookmark_User_AuthorizedUser`
    FOREIGN KEY (`AuthorizedUser`)
    REFERENCES `socialbookmark`.`User` (`Num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socialbookmark`.`Vote`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialbookmark`.`Vote` ;

CREATE TABLE IF NOT EXISTS `socialbookmark`.`Vote` (
  `Num` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Bookmark` INT UNSIGNED NOT NULL,
  `VotedUser` INT UNSIGNED NOT NULL,
  `VotedLog` INT NOT NULL COMMENT '1: 추천\n-1 : 비추천',
  PRIMARY KEY (`Num`),
  INDEX `fk_Vote_User_VotedUser_idx` (`VotedUser` ASC) VISIBLE,
  INDEX `fk_Vote_Bookmark_Bookmark_idx` (`Bookmark` ASC) VISIBLE,
  CONSTRAINT `fk_Vote_User_VotedUser`
    FOREIGN KEY (`VotedUser`)
    REFERENCES `socialbookmark`.`User` (`Num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Vote_Bookmark_Bookmark`
    FOREIGN KEY (`Bookmark`)
    REFERENCES `socialbookmark`.`Bookmark` (`Num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socialbookmark`.`Comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialbookmark`.`Comment` ;

CREATE TABLE IF NOT EXISTS `socialbookmark`.`Comment` (
  `Num` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Bookmark` INT UNSIGNED NOT NULL,
  `RegDate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedUser` INT UNSIGNED NOT NULL,
  `Content` TEXT NULL,
  PRIMARY KEY (`Num`),
  INDEX `fk_Comment_Bookmark_Bookmark_idx` (`Bookmark` ASC) VISIBLE,
  INDEX `fk_Comment_User_CreatedUser_idx` (`CreatedUser` ASC) VISIBLE,
  CONSTRAINT `fk_Comment_Bookmark_Bookmark`
    FOREIGN KEY (`Bookmark`)
    REFERENCES `socialbookmark`.`Bookmark` (`Num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comment_User_CreatedUser`
    FOREIGN KEY (`CreatedUser`)
    REFERENCES `socialbookmark`.`User` (`Num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socialbookmark`.`Blamed`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socialbookmark`.`Blamed` ;

CREATE TABLE IF NOT EXISTS `socialbookmark`.`Blamed` (
  `Num` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Bookmark` INT UNSIGNED NOT NULL,
  `BlamedUser` INT UNSIGNED NOT NULL,
  `BlamedLog` INT NOT NULL COMMENT '1: 신고\n-1:신고취소',
  PRIMARY KEY (`Num`),
  INDEX `fk_Blamed_Bookmark_Bookmark_idx` (`Bookmark` ASC) VISIBLE,
  INDEX `fk_Blamed_User_BlamedUser_idx` (`BlamedUser` ASC) VISIBLE,
  CONSTRAINT `fk_Blamed_Bookmark_Bookmark`
    FOREIGN KEY (`Bookmark`)
    REFERENCES `socialbookmark`.`Bookmark` (`Num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Blamed_User_BlamedUser`
    FOREIGN KEY (`BlamedUser`)
    REFERENCES `socialbookmark`.`User` (`Num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

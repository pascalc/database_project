USE dbproject ;

-- -----------------------------------------------------
-- Table dbproject.Users
-- -----------------------------------------------------
DROP TABLE IF EXISTS dbproject.Users ;

CREATE  TABLE IF NOT EXISTS dbproject.Users (
  username VARCHAR(16) NOT NULL ,
  password VARCHAR(16) NOT NULL ,
  email VARCHAR(32) NOT NULL ,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (username) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table dbproject.Ads
-- -----------------------------------------------------
DROP TABLE IF EXISTS dbproject.Ads;

CREATE  TABLE IF NOT EXISTS dbproject.Ads (
  id INT NOT NULL AUTO_INCREMENT,
  title VARCHAR(128) NOT NULL ,
  description TEXT NOT NULL ,
  category VARCHAR(32) NOT NULL ,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  fk_username VARCHAR(16) NOT NULL,
  FOREIGN KEY (fk_username) REFERENCES dbproject.Users(username)
	ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (id))
ENGINE = InnoDB;

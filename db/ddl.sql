USE dbproject ;

DROP TABLE IF EXISTS dbproject.Ads;
DROP TABLE IF EXISTS dbproject.Users ;
DROP TABLE IF EXISTS dbproject.Categories;

-- -----------------------------------------------------
-- Table dbproject.Users
-- -----------------------------------------------------

CREATE  TABLE IF NOT EXISTS dbproject.Users (
  username VARCHAR(16) NOT NULL ,
  password VARCHAR(16) NOT NULL ,
  email VARCHAR(32) NOT NULL ,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (username) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table dbproject.Categories
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS dbproject.Categories(
  name VARCHAR(32) PRIMARY KEY)
ENGINE = InnoDB;

INSERT INTO dbproject.Categories VALUES('books');
INSERT INTO dbproject.Categories VALUES('electronics');
INSERT INTO dbproject.Categories VALUES('appliances');
INSERT INTO dbproject.Categories VALUES('housing');
INSERT INTO dbproject.Categories VALUES('jobs');
INSERT INTO dbproject.Categories VALUES('personal');

-- -----------------------------------------------------
-- Table dbproject.Ads
-- -----------------------------------------------------

CREATE  TABLE IF NOT EXISTS dbproject.Ads (
  id INT NOT NULL AUTO_INCREMENT,
  title VARCHAR(128) NOT NULL ,
  description TEXT NOT NULL ,
  fk_category VARCHAR(32) NOT NULL ,
  FOREIGN KEY (fk_category) REFERENCES dbproject.Categories(name)
	ON DELETE CASCADE ON UPDATE CASCADE,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  fk_username VARCHAR(16) NOT NULL,
  FOREIGN KEY (fk_username) REFERENCES dbproject.Users(username)
	ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (id))
ENGINE = InnoDB;

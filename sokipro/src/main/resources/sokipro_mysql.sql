

CREATE TABLE users (
	id int AUTO_INCREMENT,
	username varchar(30) NOT NULL,
	password varchar(40) NOT NULL,
	firstname varchar(30),
	lastname varchar(30),
	mail varchar(100),
	admin bit,
	last_login_on timestamp,
	language varchar(5),
	created_by varchar(30),
	created_on datetime,
	updated_by varchar(30),
	updated_on datetime,
	PRIMARY KEY (id)
)


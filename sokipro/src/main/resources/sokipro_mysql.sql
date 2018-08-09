
CREATE TABLE users (
	id int AUTO_INCREMENT,
	username varchar(30) NOT NULL,
	password varchar(40) NOT NULL,
	firstname varchar(30) NOT NULL,
	lastname varchar(30) NOT NULL,
	email varchar(100) NOT NULL,
	admin bit,
	last_login_on timestamp,
	language varchar(5),
	created_by varchar(30),
	created_on datetime,
	updated_by varchar(30),
	updated_on datetime,
	PRIMARY KEY (id)
);

CREATE TABLE projects (
	id int AUTO_INCREMENT NOT NULL,
	name varchar(30) NOT NULL,
	identifier varchar(20) NOT NULL,
	description text,
	homepage varchar(225),
	is_public bit,
	status int,
	created_by varchar(30),
	created_on datetime,
	updated_by varchar(30),
	updated_on datetime,
	PRIMARY KEY (id)
);

CREATE TABLE trackers (
	id int AUTO_INCREMENT NOT NULL,
	name varchar(30),
	description text,
	PRIMARY KEY (id)
);

CREATE TABLE projects_trackers (
	id int AUTO_INCREMENT NOT NULL,
	project_id int,
	tracker_id int,
	PRIMARY KEY (id)
);

CREATE TABLE statuses (
	id int AUTO_INCREMENT NOT NULL,
	name varchar(30),
	PRIMARY KEY (id)
);

CREATE TABLE priorities (
	id int AUTO_INCREMENT NOT NULL,
	name varchar(30),
	PRIMARY KEY (id)
);

CREATE TABLE attachments (
	id int AUTO_INCREMENT NOT NULL,
	filename varchar(225) NOT NULL,
	filepath varchar(225) NOT NULL,
	filesize int,
	downloads int,
	author_id int,
	created_on timestamp,
	description text,
	PRIMARY KEY (id)
);

CREATE TABLE issues (
	id int AUTO_INCREMENT NOT NULL,
	project_id int NOT NULL,
	tracker_id int NOT NULL,
	subject varchar(225) NOT NULL,
	due_date timestamp,
	status_id int,
	priority_id int,
	author_id int,
	start_date timestamp,
	done_ratio int,
	estimated_hours float,
	created_on timestamp,
	updated_on timestamp,
	PRIMARY KEY (id)
);

CREATE TABLE comments (
	id int AUTO_INCREMENT NOT NULL,
	commented_type varchar(30),
	commented_id int,
	author_id int NOT NULL,
	comments text NOT NULL,
	created_on timestamp,
	updated_on timestamp,
	PRIMARY KEY (id)
);


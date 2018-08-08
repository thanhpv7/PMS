USE sokipro;
GO

DROP TABLE users;
CREATE TABLE users (
	id int IDENTITY(1,1),
	username varchar(30),
	password varchar(40),
	firstname nvarchar(30),
	lastname nvarchar(30),
	mail varchar(100),
	admin bit,
	last_login_on timestamp,
	language varchar(5),
	created_by nvarchar(30),
	created_on datetime,
	updated_by nvarchar(30),
	updated_on datetime
);
GO

DROP TABLE project;
CREATE TABLE project (
	id int IDENTITY(1,1),
	name nvarchar(30),
	identifier varchar(20),
	description text,
	homepage varchar(225),
	is_public bit,
	status int,
	created_by varchar(30),
	created_on datetime,
	updated_by varchar(30),
	updated_on datetime
);
GO

DROP TABLE tracker;
CREATE TABLE tracker (
	id int IDENTITY(1,1),
	name varchar(30)
)

DROP TABLE projects_trackers;
CREATE TABLE projects_trackers (
	project_id int,
	tracker_id int
);
GO

DROP TABLE status;
CREATE TABLE status (
	id int IDENTITY(1,1),
	name varchar(30)
);
GO

DROP TABLE complexity;
CREATE TABLE complexity (
	id int IDENTITY(1,1),
	name varchar(30)
);
GO

DROP TABLE priority;
CREATE TABLE priority (
	id int IDENTITY(1,1),
	name varchar(30)
);
GO
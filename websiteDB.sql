# university
# TODO: create trigger to update u_numberstudentstud whenever new student is created
# may change to DEFAULT 0 later
CREATE TABLE university(
	u_id int(11) NOT NULL AUTO_INCREMENT,
	u_name varchar(30) NOT NULL,
	u_numberstudents int(11) NOT NULL DEFAULT 0 ,
	u_location varchar(100),
	u_description varchar(255),
	u_emaildomain varchar(20) NOT NULL,
	u_imgage varbinary(max) NOT NULL,
	PRIMARY KEY (u_id),
	UNIQUE (u_emaildomain)
);

# student
CREATE TABLE student(
	s_id int(11) NOT NULL AUTO_INCREMENT,
	s_firstname varchar(40) NOT NULL,
	s_lastname varchar(40) NOT NULL,
	s_username varchar(30),
	s_password varchar(20),
	s_email varchar(40),
	u_id int(11) NOT NULL,
	PRIMARY KEY (s_id),
	FOREIGN KEY (u_id) REFERENCES university(u_id) ON DELETE CASCADE,
	UNIQUE (s_username),
	UNIQUE (s_email)
);

# superadmin
CREATE TABLE superadmin(
	s_id int(11) NOT NULL,
	PRIMARY KEY (s_id),
	FOREIGN KEY (s_id) REFERENCES student(s_id) ON DELETE CASCADE
);

# admin
CREATE TABLE admin(
	s_id int(11) NOT NULL,
	PRIMARY KEY (s_id),
	FOREIGN KEY (s_id) REFERENCES student(s_id) ON DELETE CASCADE
);

# su_affliation (student-university)
CREATE TABLE su_affiliation(
	s_id int(11) NOT NULL,
	u_id int(11) NOT NULL,
	PRIMARY KEY (s_id),
	FOREIGN KEY (s_id) REFERENCES student(s_id) ON DELETE CASCADE,
	FOREIGN KEY (u_id) REFERENCES university(u_id) ON DELETE CASCADE
);

# rso
CREATE TABLE rso(
	rso_id int(11) NOT NULL AUTO_INCREMENT,
	rso_name varchar(50) NOT NULL,
	rso_location varchar(50) NOT NULL,
	rso_description varchar(255),
	owner_id int(11) NOT NULL,
	PRIMARY KEY (rso_id),
	FOREIGN KEY (owner_id) REFERENCES admin(s_id) ON DELETE CASCADE,
	UNIQUE (rso_id,owner_id)
);

# rso_member
CREATE TABLE rso_member(
	s_id int(11),
	rso_id int(11) NOT NULL,
	PRIMARY KEY (s_id,rso_id),
	FOREIGN KEY (s_id) REFERENCES student(s_id) ON DELETE CASCADE,
	FOREIGN KEY (rso_id) REFERENCES rso(rso_id) ON DELETE CASCADE
);

# event
CREATE TABLE event(
	e_id int(11) NOT NULL AUTO_INCREMENT,
	e_name varchar(50) NOT NULL,
	e_date date NOT NULL,
	e_time time NOT NULL,
	e_description varchar(255),
	e_phone varchar(20),
	e_email varchar(50),
	e_public boolean,
	e_private boolean,
	rso_id int(11),
	u_id int(11) NOT NULL,
	s_id int(11) NOT NULL,
	PRIMARY KEY (e_id),
	FOREIGN KEY (s_id) REFERENCES admin(s_id) ON DELETE CASCADE,
	FOREIGN KEY (rso_id) REFERENCES rso_member(rso_id) ON DELETE CASCADE,
	FOREIGN KEY (u_id) REFERENCES university(u_id) ON DELETE CASCADE
);

# location
CREATE TABLE location(
	loc_id int(11) NOT NULL AUTO_INCREMENT,
	loc_name varchar(50) NOT NULL,
	loc_address varchar(50) NOT NULL,
	loc_city varchar(50) NOT NULL,
	loc_state varchar(50) NOT NULL,
	loc_zip varchar(50) NOT NULL,
	loc_longitude varchar(255),
	loc_latitude varchar(255),
	PRIMARY KEY (loc_id)
);

# event_location
# add constraint to make sure all e_id and loc_id tuple is unique for a given time
CREATE TABLE event_location(
	e_id int(11) NOT NULL,
	loc_id int(11) NOT NULL,
	time datetime NOT NULL,
	PRIMARY KEY (e_id),
	FOREIGN KEY (loc_id) REFERENCES location(loc_id) ON DELETE CASCADE,
	FOREIGN KEY (e_id) REFERENCES event(e_id) ON DELETE CASCADE,
	CONSTRAINT loc_time UNIQUE (e_id,loc_id,time)
);

# comment
CREATE TABLE comment(
	e_id int(11) NOT NULL,
	s_id int(11) NOT NULL,
	time datetime NOT NULL,
	description varchar(255) NOT NULL,
	PRIMARY KEY (e_id, s_id, time),
	FOREIGN KEY (e_id) REFERENCES event(e_id) ON DELETE CASCADE,
	FOREIGN KEY (s_id) REFERENCES student(s_id) ON DELETE CASCADE
);

# create_rso
# check to make sure at least 5 students with same email domain before creating (front-end check)
# creating student will become admin of the rso

CREATE TABLE create_rso(
	rso_id int(11) NOT NULL,
	s_id int(11) NOT NULL,
	PRIMARY KEY (rso_id),
	FOREIGN KEY (s_id) REFERENCES student(s_id) ON DELETE CASCADE
);

# join_rso
# add requests to a table and have the appropriate rso admins approve the them
CREATE TABLE join_rso(
	rso_id int(11) NOT NULL,
	s_id int(11) NOT NULL,
	is_approved boolean NOT NULL DEFAULT 0,
	PRIMARY KEY (rso_id,s_id),
	FOREIGN KEY (rso_id) REFERENCES rso(rso_id) ON DELETE CASCADE,
	FOREIGN KEY (s_id) REFERENCES student(s_id) ON DELETE CASCADE
);

# approve_pub
# create trigger to add event to events table if is_approved == 1
CREATE TABLE approve_pub(
	e_id int(11) NOT NULL,
	s_id int(11) NOT NULL,
	is_approved boolean NOT NULL DEFAULT 0,
	PRIMARY KEY (e_id,s_id),
	FOREIGN KEY (e_id) REFERENCES event(e_id) ON DELETE CASCADE,
	FOREIGN KEY (s_id) REFERENCES superadmin(s_id) ON DELETE CASCADE
);

# approve_private_event
# create trigger to add event to events table if is_approved == 1
# once approved, add private event to events table
CREATE TABLE approve_private_event(
	e_id int(11) NOT NULL,
	s_id int(11) NOT NULL,
	is_approved boolean NOT NULL DEFAULT 0,
	PRIMARY KEY (e_id,s_id),
	FOREIGN KEY (e_id) REFERENCES event(e_id) ON DELETE CASCADE,
	FOREIGN KEY (s_id) REFERENCES superadmin(s_id) ON DELETE CASCADE
);

# subscriptions
CREATE TABLE subscriptions(
	sub_id int(11) NOT NULL AUTO_INCREMENT,
	s_id int(11) NOT NULL,
	e_id int (11),
	u_id int(11) NOT NULL,
	PRIMARY KEY (sub_id),
	FOREIGN KEY (s_id) REFERENCES student(s_id) ON DELETE CASCADE,
	FOREIGN KEY (e_id) REFERENCES event(e_id) ON DELETE CASCADE,
	FOREIGN KEY (u_id) REFERENCES university(u_id) ON DELETE CASCADE
);



# insertions used for testing

INSERT INTO student (s_firstname, s_lastname, s_username, s_password, s_email, u_id) VALUES ('Sally', 'Knight', 'sallyK', "asdf1234", 'SK@knights.ucf.edu', 1);
INSERT INTO student (s_firstname, s_lastname, s_username, s_password, s_email, u_id) VALUES ('Ken', 'Williamson', 'kenW', "abc123", 'KW@knights.ucf.edu', 1);
INSERT INTO student (s_firstname, s_lastname, s_username, s_password, s_email, u_id) VALUES ('Giani', 'Francis', 'gfrancis', "butthole", 'gfrancis@nyu.edu', 2);
INSERT INTO student (s_firstname, s_lastname, s_username, s_password, s_email, u_id) VALUES ('Miguel', 'Chavez', 'mac123', "buttface", 'mac2@georgiatech.edu', 3);
INSERT INTO student (s_firstname, s_lastname, s_username, s_password, s_email, u_id) VALUES ('Alexis', 'San Javier', 'ASJ', "ayaya", 'ASJ@ucberkley.edu', 4);

INSERT INTO university (u_name, u_numberstudents, u_location, u_description, u_emaildomain) VALUES('University of Central Florida', 60000, 'Florida', 'Big Beautiful School in the heart of Central Florida', 'knights.ucf.edu');
INSERT INTO university (u_name, u_numberstudents, u_location, u_description, u_emaildomain) VALUES('New York University', 20000, 'New York', 'Big Beautiful School in the heart of the Big Apple', 'nyu.edu');
INSERT INTO university (u_name, u_numberstudents, u_location, u_description, u_emaildomain) VALUES('Georgia Technical University', 40000, 'Georgia', 'Big Beautiful School in the heart of Georgia', 'georgiatech.edu');
INSERT INTO university (u_name, u_numberstudents, u_location, u_description, u_emaildomain) VALUES('University of California Berkley', 30000, 'California', 'Big Beautiful School in the heart of Southern California', 'ucberkley.edu');

INSERT INTO event (e_name, e_date, e_time, e_description, e_phone, e_email, e_public, e_private, rso_id, u_id, s_id) VALUES ('Knights Palooza', '2017-06-11', '20:00:00', 'Big Party for New Students', "555-555-555", "KnightsPalooza@gmail.com", 1, 0, 1, 1, 1);
INSERT INTO event (e_name, e_date, e_time, e_description, e_phone, e_email, e_public, e_private, rso_id, u_id, s_id) VALUES ('Knights Hacks', '2017-08-10', '12:00:00', 'Student Hackathon', '111-111-111', "KnightHacks@gmail.com", 1, 0, 1, 1, 2);
INSERT INTO event (e_name, e_date, e_time, e_description, e_phone, e_email, e_public, e_private, rso_id, u_id, s_id) VALUES ('NYU Hacks', '2017-04-25', '23:00:00', 'Student Hackathon', "222-555-555", "NYUHacksa@gmail.com", 1, 0, 2, 2, 3);
INSERT INTO event (e_name, e_date, e_time, e_description, e_phone, e_email, e_public, e_private, rso_id, u_id, s_id) VALUES ('NYU Womens March', '2017-09-10', '18:00:00', 'March to Celebrate Womens Rights', "444-555-555", "NYUWomen@gmail.com", 1, 0, 2, 2, 4);
INSERT INTO event (e_name, e_date, e_time, e_description, e_phone, e_email, e_public, e_private, rso_id, u_id, s_id) VALUES ('Georgia Tech Hacks', '2017-07-23', '14:00:00', 'Student Hackathon', "333-555-555", "GTUHacks@gmail.com", 1, 0, 3, 3, 5);
INSERT INTO event (e_name, e_date, e_time, e_description, e_phone, e_email, e_public, e_private, rso_id, u_id, s_id) VALUES ('UCB Hacks', '2017-12-16', '14:00:00', 'Student Hackathon', "666-555-555", "UCBHacks@gmail.com", 1, 0, 4, 4, 6);
INSERT INTO event (e_name, e_date, e_time, e_description, e_phone, e_email, e_public, e_private, rso_id, u_id, s_id) VALUES ('UCB Multiciltural Night', '2017-10-08', '20:00:00', 'Celebration of Diversity', "777-555-555", "UCBDiversitya@gmail.com", 1, 0, 4, 4, 7);

INSERT INTO comments (event_id, text) VALUES (2, "this presentation is awesome");
INSERT INTO comments (event_id, text) VALUES (2, "this presentation is okay");
INSERT INTO comments (event_id, text) VALUES (2, "this presentation is bad");

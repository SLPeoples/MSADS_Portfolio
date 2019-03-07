/*
	Samuel L. Peoples
	IST 659
	Music Database : Create Tables
*/

-- Create the member table
CREATE TABLE member(
	member_id int identity PRIMARY KEY,
	last_name varchar(30) NOT NULL, 
	first_name varchar(30) NOT NULL, 
	middle_name varchar(30), 
	home_city varchar(30) NOT NULL, 
	home_country varchar(30) NOT NULL
);

-- Create the instrument table
CREATE TABLE instrument( 
	instrument_id int identity PRIMARY KEY, 
	name varchar(30) UNIQUE NOT NULL, 
	type varchar(30) NOT NULL
);

-- Create the studio table
CREATE TABLE studio( 
	studio_id int identity PRIMARY KEY, 
	name varchar(50) NOT NULL, 
	address_1 varchar(30) NOT NULL, 
	address_2 varchar(30), 
	city varchar(30) NOT NULL, 
	state varchar(30), 
	zip varchar(7), 
	country varchar(30) NOT NULL, 
	phone varchar(10) 
);

-- Create the artist table
CREATE TABLE artist( 
	artist_id int identity PRIMARY KEY, 
	name varchar(30) NOT NULL, 
	formation_date date NOT NULL, 
	separation_date date, 
	url varchar(100) 
);

-- Create the album table
CREATE TABLE album( 
	album_id int identity PRIMARY KEY,
	name varchar(30) NOT NULL,  
	release_date date NOT NULL, 
	genre varchar(30) NOT NULL, 
	peak_chart_position int NOT NULL, 
	description varchar(100), 
	artist_id int FOREIGN KEY REFERENCES artist(artist_id) NOT NULL, 
	studio_id int FOREIGN KEY REFERENCES studio(studio_id) NOT NULL
);


-- Create the award table
CREATE TABLE award( 
	award_id int identity PRIMARY KEY, 
	name varchar(30) NOT NULL, 
	description varchar(100) 
);

-- Create the song table
CREATE TABLE song( 
	song_id int identity PRIMARY KEY, 
	name varchar(30) NOT NULL, 
	num_plays int NOT NULL, 
	album_id int FOREIGN KEY REFERENCES album(album_id) NOT NULL
);

-- Create the artist_award_list
CREATE TABLE artist_award_list( 
	artist_award_list_id int identity PRIMARY KEY, 
	artist_id int FOREIGN KEY REFERENCES artist(artist_id) NOT NULL, 
	award_id int FOREIGN KEY REFERENCES award(award_id) NOT NULL,
	CONSTRAINT award_list_info UNIQUE(artist_id, award_id)
);

-- Create the album_award_list
CREATE TABLE album_award_list( 
	album_award_list_id int identity PRIMARY KEY, 
	award_id int FOREIGN KEY REFERENCES award(award_ID) NOT NULL, 
	album_id int FOREIGN KEY REFERENCES album(album_id) NOT NULL
	CONSTRAINT album_list_info UNIQUE(album_id, award_id)
);

-- Create the instrument list table
CREATE TABLE instrument_list(
	instrument_list_id int identity PRIMARY KEY,
	member_id int FOREIGN KEY REFERENCES member(member_id) NOT NULL, 
	instrument_id int FOREIGN KEY REFERENCES instrument(instrument_id) NOT NULL
	CONSTRAINT instrument_list_info UNIQUE(member_id, instrument_id)
);

-- Create the member list table
CREATE TABLE member_list( 
	member_list_id int identity PRIMARY KEY, 
	artist_id int FOREIGN KEY REFERENCES artist(artist_id) NOT NULL, 
	member_id int FOREIGN KEY REFERENCES member(member_id) NOT NULL
	CONSTRAINT list_info UNIQUE(artist_id, member_id)
);

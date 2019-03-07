/*
	Samuel L. Peoples
	IST 659
	Music Database : Add Data
*/

-- Populate each table with some initial data

-- Add The Who to artist
INSERT INTO artist(name, formation_date, url)
VALUES('The Who', '1964-01-01', 'https://www.thewho.com/');

-- Add Led Zeppelin to arist
INSERT INTO artist(name, formation_date, separation_date, url)
VALUES('Led Zeppelin', '1968-01-01', '1980-12-04', 'http://www.ledzeppelin.com/');

-- Add Fleetwood Mac to artist
INSERT INTO artist(name, formation_date, url)
VALUES('Fleetwood Mac', '1967-01-01', 'https://www.fleetwoodmac.com/');

-- Add Red Hot Chili Peppers to artist
INSERT INTO artist(name, formation_date, url)
VALUES('Red Hot Chili Peppers', '1983-01-01','https://redhotchilipeppers.com/');

-- Add Ben Folds to artist
INSERT INTO artist(name, formation_date, url)
VALUES('Ben Folds', '1988-01-01', 'https://www.benfolds.com/');

-- Add the members from The Who
INSERT INTO member(last_name, first_name, middle_name, home_city, home_country)
VALUES('Daltrey','Roger','Harry','London', 'England');
INSERT INTO member(last_name, first_name, middle_name, home_city, home_country)
VALUES('Townshend','Peter','Dennis Blandford','Middlesex', 'England');
INSERT INTO member(last_name, first_name, middle_name, home_city, home_country)
VALUES('Entwistle','John','Alec','London', 'England');
INSERT INTO member(last_name, first_name, middle_name, home_city, home_country)
VALUES('Moon','Keith','John','Middlesex', 'England');
INSERT INTO member(last_name, first_name, middle_name, home_city, home_country)
VALUES('Jones','Kenney','Thomas','London', 'England');


-- Associate the members with The Who

INSERT INTO member_list(artist_id, member_id)
VALUES(1,1);
INSERT INTO member_list(artist_id, member_id)
VALUES(1,2);
INSERT INTO member_list(artist_id, member_id)
VALUES(1,3);
INSERT INTO member_list(artist_id, member_id)
VALUES(1,4);
INSERT INTO member_list(artist_id, member_id)
VALUES(1,5);

-- Add the instruments the Members play
INSERT INTO instrument(name, type)
VALUES('Lead Vocals', 'Vocals');
INSERT INTO instrument(name, type)
VALUES('Backup Vocals', 'Vocals');
INSERT INTO instrument(name, type)
VALUES('Guitar', 'String');
INSERT INTO instrument(name, type)
VALUES('Harmonica', 'Wind');
INSERT INTO instrument(name, type)
VALUES('Drums', 'Percussion');
INSERT INTO instrument(name, type)
VALUES('Keyboard', 'Percussion');
INSERT INTO instrument(name, type)
VALUES('Bass', 'String');
INSERT INTO instrument(name, type)
VALUES('General Percussion', 'Percussion');
INSERT INTO instrument(name, type)
VALUES('General Horn', 'Horn');

-- Associate the instruments with members
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('1','1');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('1','2');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('1','3');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('1','4');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('1','9');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('2','3');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('2','1');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('2','2');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('2','6');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('3','7');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('3','8');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('3','1');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('3','2');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('4','5');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('4','1');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('4','2');
INSERT INTO instrument_list(member_id, instrument_id)
VALUES('5','5');

-- Add an award
INSERT INTO award(name, description)
VALUES('UK Gold Certification', '100k Certified units sold');
INSERT INTO award(name, description)
VALUES('Lifetime Achievement Award','1988 British Phographic Industry');

-- Associate the award with The Who
INSERT INTO artist_award_list(award_id, artist_id)
VALUES(2,1);

-- Add The Who's first album's studio
INSERT INTO studio(name, address_1, city, country)
VALUES('IBC Studios','35 Portland Place','London','England');

-- Add the first album from The Who
INSERT INTO album(name, release_date, genre, peak_chart_position, artist_id, studio_id)
VALUES ('My Generation','1965-12-03','Classic Rock',5,1,1);

-- Associate the award with The Who's First Album
INSERT INTO album_award_list(award_id, album_id)
VALUES(1,1);

-- Add the songs from the first album (My Generation)
INSERT INTO song(name, num_plays, album_id)
VALUES('Out in the Street',3651,1);
INSERT INTO song(name, num_plays, album_id)
VALUES('I dont Mind',231,1);
INSERT INTO song(name, num_plays, album_id)
VALUES('The Goods Gone',321,1);
INSERT INTO song(name, num_plays, album_id)
VALUES('La-La-La-Lies',658,1);
INSERT INTO song(name, num_plays, album_id)
VALUES('Much too Much',31,1);
INSERT INTO song(name, num_plays, album_id)
VALUES('My Generation',3213,1);
INSERT INTO song(name, num_plays, album_id)
VALUES('The Kids are Alright',234,1);
INSERT INTO song(name, num_plays, album_id)
VALUES('Please, Please, Please',627,1);
INSERT INTO song(name, num_plays, album_id)
VALUES('Its Not True',3876,1);
INSERT INTO song(name, num_plays, album_id)
VALUES('Im a Man',682,1);
INSERT INTO song(name, num_plays, album_id)
VALUES('A Legal Matter',27,1);
INSERT INTO song(name, num_plays, album_id)
VALUES('The Ox',1246,1);

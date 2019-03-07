/*
	Samuel L. Peoples
	IST 659
	Music Database : Views
*/

-- Create a view for albums
GO
CREATE VIEW album_report AS
	SELECT
		album_id,
		album.name AS album_name,
		release_date,
		genre,
		peak_chart_position,
		artist.name AS artist_name,
		studio.name AS studio_name
	FROM album
	JOIN artist ON album.artist_id = artist.artist_id
	JOIN studio ON album.studio_id = studio.studio_id
GO;
-- Test the album_report view
SELECT * FROM album_report

-- Create a view for album awards
GO
CREATE VIEW album_award_report AS
	SELECT
		album_award_list_id,
		award.name AS award_name,
		award.description AS award_description,
		artist.name AS artist_name,
		album.name AS album_name
	FROM album_award_list
	JOIN award ON album_award_list.award_id = award.award_id
	JOIN album ON album_award_list.album_id = album.album_id
	JOIN artist ON album.artist_id = artist.artist_id
GO;

-- Test the album_award_report
SELECT * FROM album_award_report

-- Create a view for artist awards
GO
CREATE VIEW artist_award_report AS
	SELECT
		artist_award_list_id,
		award.name AS award_name,
		award.description AS award_description,
		artist.name AS artist_name
	FROM artist_award_list
	JOIN award ON artist_award_list.award_id = award.award_id
	JOIN artist ON artist_award_list.artist_id = artist.artist_id
GO;

-- Test the artist_award_report
SELECT * FROM artist_award_report

-- Create a view for the instrument list
GO
CREATE VIEW instrument_report AS
	SELECT
		instrument_list_id,
		member.last_name AS last_name,
		member.first_name AS first_name,
		artist.name AS artist_name,
		instrument.name AS instrument_name,
		instrument.type AS instrument_type
	FROM instrument_list
	JOIN member ON instrument_list.member_id = member.member_id
	JOIN instrument ON instrument_list.instrument_id = instrument.instrument_id
	JOIN member_list ON member.member_id = member_list.member_id
	JOIN artist ON member_list.artist_id = artist.artist_id
GO;

-- Test the instrument_report
SELECT * FROM instrument_report

-- Create a view for the member list
GO
CREATE VIEW member_report AS
	SELECT
		member_list_id,
		member.last_name,
		member.first_name,
		member.home_city,
		member.home_country,
		artist.name AS artist_name
	FROM member_list
	JOIN member ON member_list.member_id = member.member_id
	JOIN artist ON member_list.artist_id = artist.artist_id
GO;

-- Test the member_report
SELECT * FROM member_report
		
-- Create a view for the songs
CREATE VIEW song_report AS
	SELECT
		song_id,
		song.name AS song_name,
		num_plays,
		album.name AS album_name,
		artist.name AS artist_name,
		genre
	FROM song
	JOIN album ON song.album_id = album.album_id
	JOIN artist ON album.artist_id = artist.artist_id
GO;

-- Test the song_report
SELECT * FROM song_report


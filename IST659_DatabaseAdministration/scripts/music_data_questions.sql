/*
	Samuel L. Peoples
	IST 659
	Music Database : Data Questions
*/

-- 1. What is the range of album release dates in my music collection?
CREATE VIEW release_range AS
	SELECT
		MIN(release_date) AS earliest_release_date,
		MAX(release_date) AS latest_release_date
	FROM album
-- Answer:
SELECT * FROM release_range

-- 2. Which genre is the most popular in my music collection? (By count and plays)
CREATE VIEW popular_genre_count AS
	SELECT TOP 10
		genre,
		COUNT(genre) AS album_count
	FROM album
	GROUP BY genre
	ORDER BY album_count DESC
-- Answer:
SELECT * FROM popular_genre_count

CREATE VIEW popular_genre_plays AS
	SELECT TOP 10
		genre,
		SUM(num_plays) as total_plays
	FROM song_report
	GROUP BY genre
	ORDER BY total_plays DESC
-- Answer
SELECT * FROM popular_genre_plays
	
-- 3. Which artist/ album has the most awards in my music collection?
CREATE VIEW most_artist_awards AS
	SELECT TOP 10
		artist_name,
		COUNT(artist_name) AS count
	FROM artist_award_report
	GROUP BY artist_name
	ORDER BY count DESC
-- Answer
SELECT * FROM most_artist_awards

CREATE VIEW most_album_awards AS
	SELECT TOP 10
		album_name,
		artist_name,
		COUNT(album_name) AS count
	FROM album_award_report
	GROUP BY album_name, artist_name
	ORDER BY count DESC
-- Answer
SELECT * FROM most_album_awards

-- 4. Which member hometown is the most popular in my music collection?
CREATE VIEW most_popular_hometown AS
	SELECT TOP 10
		home_city,
		home_country,
		COUNT(home_city) AS count
	FROM member_report
	GROUP BY home_city, home_country
	ORDER BY count DESC
-- Answer
SELECT * FROM most_popular_hometown

-- 5. Which instrument/ instrument type is the most popular in my music collection 
CREATE VIEW most_popular_instrument AS
	SELECT TOP 10
		instrument_name,
		COUNT(instrument_name) AS count
	FROM instrument_report
	GROUP BY instrument_name
	ORDER BY count DESC
-- Answer
SELECT * FROM most_popular_instrument

CREATE VIEW most_popular_type AS
	SELECT TOP 10
		instrument_type,
		COUNT(instrument_type) AS count
	FROM instrument_report
	GROUP BY instrument_type
	ORDER BY count DESC
-- Answer
SELECT * FROM most_popular_type

-- 6. What are the most played songs in my music collection?
-- We're making a playlist of ten songs
CREATE VIEW best_songs AS
	SELECT TOP 10
		song_name,
		num_plays,
		artist_name,
		album_name
	FROM song_report
	GROUP BY num_plays, song_name, album_name, artist_name
	ORDER BY num_plays DESC
-- Answer:
SELECT * FROM best_songs
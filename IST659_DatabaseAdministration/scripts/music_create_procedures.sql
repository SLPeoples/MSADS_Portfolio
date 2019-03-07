/*
	Samuel L. Peoples
	IST 659
	Music Database : Stored Procedures
*/

-- Create a stored procedure to drop albums and their dependencies
GO
CREATE PROCEDURE drop_album(@name varchar(30)) AS
BEGIN
	DECLARE @id int
	SELECT @id = album_id FROM album WHERE album.name = @name
	DELETE FROM album_award_list WHERE album_id = @id
	DELETE FROM song WHERE album_id = @id
	DELETE FROM album WHERE album_id = @id
END
GO;

-- Test the removal of an album
EXEC drop_album 'My Generation'

-- Create a stored procedure to drop artists and their dependencies
GO
CREATE PROCEDURE drop_artist(@name varchar(30)) AS
BEGIN
	DECLARE @id int
	SELECT @id = artist_id FROM artist WHERE artist.name = @name
	DELETE FROM artist_award_list WHERE artist_id = @id
	DELETE FROM album WHERE artist_id = @id
	DELETE FROM member_list WHERE artist_id = @id
	DELETE FROM artist WHERE artist_id = @id
END
GO;

-- Test the removal of an artist
EXEC drop_artist 'Ben Folds'

-- Create a stored procedure to drop awards and their dependencies
GO
CREATE PROCEDURE drop_award(@name varchar(30)) AS
BEGIN
	DECLARE @id int
	SELECT @id = award_id FROM award WHERE award.name = @name
	DELETE FROM album_award_list WHERE award_id = @id
	DELETE FROM artist_award_list WHERE award_id = @id
	DELETE FROM award WHERE award_id = @id
END
GO;

-- Test the removal of an award
EXEC drop_award 'UK Gold Certification'

-- Create a stored procedure to drop instruments and their dependencies
GO
CREATE PROCEDURE drop_instrument(@name varchar(30)) AS
BEGIN
	DECLARE @id int
	SELECT @id = instrument_id FROM instrument WHERE instrument.name = @name
	DELETE FROM instrument_list WHERE instrument_id = @id
	DELETE FROM instrument WHERE instrument_id = @id
END
GO;

-- Test the removal of an instrument
EXEC drop_instrument 'Guitar'

-- Create a stored procedure to drop awards and their dependencies
GO
CREATE PROCEDURE drop_member(@first_name varchar(30), @last_name varchar(30)) AS
BEGIN
	DECLARE @id int
	SELECT @id = member_id FROM member WHERE member.last_name = @last_name AND member.first_name = @first_name
	DELETE FROM instrument_list WHERE member_id = @id
	DELETE FROM member_list WHERE member_id = @id
END
GO;

-- Test the removal of a member
EXEC drop_member 'Roger', 'Daltrey'

-- Create a stored procedure to drop studios and their dependencies
GO
CREATE PROCEDURE drop_studio(@name varchar(30)) AS
BEGIN
	DECLARE @id int
	SELECT @id = studio_id FROM studio WHERE studio.name = @name
	DELETE FROM album WHERE studio_id = @id
	DELETE FROM studio WHERE studio_id = @id
END
GO;

-- Test the removal of a studio
EXEC drop_studio 'IBC Studios'
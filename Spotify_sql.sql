CREATE DATABASE spotify_db;

DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);



-- EDA

SELECT * FROM spotify;

SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT COUNT(DISTINCT album) FROM spotify;

SELECT COUNT(DISTINCT track) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;

SELECT MIN(duration_min) FROM spotify;

DELETE FROM spotify
WHERE duration_min = 0;


-- Data Analysis [Easy category]


-- Problem 1. Retrieve the names of all tracks that have more than 1 billion streams.

SELECT DISTINCT track
FROM spotify
WHERE stream > 1000000000;
    
		
-- Problem 2. List all albums along with their respective artists.

SELECT DISTINCT album, artist
FROM spotify;


-- Problem 3. Get the total number of comments for tracks where licensed = TRUE.

SELECT track, SUM(comments) AS comments_count
FROM spotify
WHERE licensed = TRUE 	
GROUP BY track;
    
	
-- Problem 4. Find all tracks that belong to the album type single.

SELECT DISTINCT track
FROM spotify
WHERE album_type = 'single';	
    

--Problem 5. Count the total number of tracks by each artist.

SELECT artist, COUNT(track) AS no_of_tracks
FROM spotify
GROUP BY artist
ORDER BY 2;


-- Data Analysis [Medium Category]

-- Problem 1. Calculate the average danceability of tracks in each album.

SELECT album, 
	AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY 2 DESC;

-- Problem 2. Find the top 5 tracks with the highest energy values.

SELECT track, AVG(energy)
FROM spotify
GROUP BY track
ORDER BY 2 DESC
LIMIT 5;

-- Problem 3. List all tracks along with their views and likes where official_video = TRUE.

SELECT track,
	SUM(views) AS total_views,
	ROUND(SUM(likes)::numeric) AS total_likes
FROM spotify
WHERE official_video = True
GROUP BY track
ORDER BY 2 DESC, 3 DESC;

-- Problem 4. For each album, calculate the total views of all associated tracks.

SELECT album,
	track,
	SUM(views) AS total_views
FROM spotify
GROUP BY album, track
ORDER BY 3 DESC;

-- Problem 5. Retrieve the track names that have been streamed on Spotify more than YouTube.

WITH t1 AS(
SELECT track,
	COALESCE(ROUND(AVG(CASE WHEN most_played_on = 'Spotify' THEN stream END)),0) AS streamed_on_spotify,
	COALESCE(ROUND(AVG(CASE WHEN most_played_on = 'Youtube' THEN stream END)),0) AS streamed_on_youtube	
FROM spotify
GROUP BY track)
SELECT * FROM t1
WHERE streamed_on_spotify > streamed_on_youtube
	AND
	streamed_on_youtube <> 0;


-- Data Analysis [Advance Category]	


-- Problem 1. Find the top 3 most-viewed tracks for each artist using window functions.

WITH most_viewed_tracks AS(
SELECT artist, 
	track, 
	SUM(views) AS total_views,
	DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views)  DESC) AS rnk
FROM spotify
GROUP BY 1,2)
SELECT artist, track, total_views
FROM most_viewed_tracks
WHERE rnk <= 3;
	
	
-- Problem 2. Write a query to find tracks where the liveness score is above the average.

SELECT track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);

select * from spotify

-- Problem 3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH CTE 
AS(
SELECT
	album,
	MAX(energy) AS highest_energy,
	MIN(energy) AS lowest_energy
FROM spotify
GROUP BY 1
)
SELECT album, (highest_energy - lowest_energy) AS energy_difference
FROM CTE
ORDER BY 2 DESC;
	



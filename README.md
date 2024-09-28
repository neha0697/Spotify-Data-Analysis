# Spotify Advance SQL Project
![spotify Logo](https://github.com/neha0697/Spotify-Data-Analysis/blob/main/spotify_logo.jpg)

# Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using SQL. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
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
```

# Project Steps

##  Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
* `Artist`: The performer of the track.
* `Track`: The name of the song.
* `Album`: The album to which the track belongs.
* `Album_type`: The type of album (e.g., single or album).
* Various metrics such as `danceability`, `energy`, `loudness`, `tempo` and more.

##  Data Cleaning
Identify and remove any records with missing or null values.

## Quering the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into easy, medium, and advanced levels to help progressively develop SQL proficiency.

### Easy Queries
* Simple data retrieval, filtering, and basic aggregations.

### Medium Queries
* More complex queries involving grouping, aggregation functions, and joins.

### Advanced Queries
* Nested subqueries, window functions, CTEs, and performance optimization.

## Query Optimization
In advanced stages, the focus shifts to improving query performance. Some optimization strategies include:
* **Indexing:** Adding indexes on frequently queried columns.
* **Query Execution Plan:** Using `EXPLAIN ANALYZE` to review and refine query performance.

## Practice Questions

### Easy Level
**1. Calculate the average danceability of tracks in each album.**
```sql
SELECT DISTINCT track
FROM spotify
WHERE stream > 1000000000;
```

**2. List all albums along with their respective artists.**
```sql
SELECT DISTINCT album, artist
FROM spotify;
```

**3. Get the total number of comments for tracks where licensed = TRUE.**
```sql
SELECT track, SUM(comments) AS comments_count
FROM spotify
WHERE licensed = TRUE 	
GROUP BY track;
```

**4. Find all tracks that belong to the album type single.**
```sql
SELECT DISTINCT track
FROM spotify
WHERE album_type = 'single';
```

**5. Count the total number of tracks by each artist.**
```sql
SELECT artist, COUNT(track) AS no_of_tracks
FROM spotify
GROUP BY artist
ORDER BY 2;
```

### Medium Level

**1. Calculate the average danceability of tracks in each album.**
```sql
SELECT album, 
	AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY 2 DESC;
```

**2. Find the top 5 tracks with the highest energy values.**
```sql
SELECT track, AVG(energy)
FROM spotify
GROUP BY track
ORDER BY 2 DESC
LIMIT 5;
```

**3. List all tracks along with their views and likes where official_video = TRUE.**
```sql
SELECT track,
	SUM(views) AS total_views,
	ROUND(SUM(likes)::numeric) AS total_likes
FROM spotify
WHERE official_video = True
GROUP BY track
ORDER BY 2 DESC, 3 DESC;
```

**4. For each album, calculate the total views of all associated tracks.**
```sql
SELECT album,
	track,
	SUM(views) AS total_views
FROM spotify
GROUP BY album, track
ORDER BY 3 DESC;
```

**5. Retrieve the track names that have been streamed on Spotify more than YouTube.**
```sql
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
```

### Advanced Level

**1. Find the top 3 most-viewed tracks for each artist using window functions.**
```sql
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
```
**2. Write a query to find tracks where the liveness score is above the average.**
```sql
SELECT track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```

**3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
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
```







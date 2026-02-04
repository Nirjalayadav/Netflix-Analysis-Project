CREATE database netflix_db;
use netflix_db;
create table netflix (
show_id varchar(10),
content_type varchar(10),
title varchar(250),
director varchar(250),
cast TEXT,
country varchar(150),
date_added varchar(50),
release_year int,
rating varchar(10),
duration varchar(50),
listed_in varchar(250),
description TEXT
);
ALTER TABLE netflix CHANGE COLUMN `type` content_type VARCHAR(20);
LOAD DATA INFILE 'C:/netflix_titles.csv'
INTO TABLE netflix
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(content_type, title, director, cast, country, date_added, release_year, rating, duration, listed_in, description);
SELECT COUNT(*) FROM netflix;
SELECT * FROM netflix LIMIT 20;
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN content_type IS NULL OR content_type = '' THEN 1 ELSE 0 END) AS missing_content_type,
    SUM(CASE WHEN director IS NULL OR director = '' THEN 1 ELSE 0 END) AS missing_director,
    SUM(CASE WHEN cast IS NULL OR cast = '' THEN 1 ELSE 0 END) AS missing_cast,
    SUM(CASE WHEN country IS NULL OR country = '' THEN 1 ELSE 0 END) AS missing_country,
    SUM(CASE WHEN date_added IS NULL OR date_added = '' THEN 1 ELSE 0 END) AS missing_date_added,
    SUM(CASE WHEN rating IS NULL OR rating = '' THEN 1 ELSE 0 END) AS missing_rating
FROM netflix;
UPDATE netflix
SET director = 'Unknown'
WHERE director IS NULL OR director = '';

UPDATE netflix
SET rating = 'Not Rated'
WHERE rating IS NULL OR rating = '';
UPDATE netflix
SET title = TRIM(title),
    director = TRIM(director),
    cast = TRIM(cast),
    country = TRIM(country),
    listed_in = TRIM(listed_in),
    description = TRIM(description);
ALTER TABLE netflix ADD COLUMN date_added_new DATE;

UPDATE netflix
SET date_added_new = STR_TO_DATE(date_added, '%B %d, %Y');
ALTER TABLE netflix MODIFY release_year INT;
SELECT * FROM netflix LIMIT 100;
SELECT content_type, COUNT(*) AS total
FROM netflix
GROUP BY content_type;
SELECT listed_in AS genre, COUNT(*) AS total
FROM netflix
GROUP BY listed_in
ORDER BY total DESC
LIMIT 10;
SELECT country, COUNT(*) AS total
FROM netflix
GROUP BY country
ORDER BY total DESC
LIMIT 10;
SELECT release_year, COUNT(*) AS total
FROM netflix
GROUP BY release_year
ORDER BY release_year;
SELECT rating, COUNT(*) AS total
FROM netflix
GROUP BY rating
ORDER BY total DESC;
SELECT title, duration
FROM netflix
WHERE content_type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED) DESC
LIMIT 10;
SELECT director, COUNT(*) AS total
FROM netflix
WHERE director IS NOT NULL AND director != ''
GROUP BY director
ORDER BY total DESC
LIMIT 10;

















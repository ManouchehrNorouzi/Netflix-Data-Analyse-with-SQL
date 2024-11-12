-- Netflix Data Analysis using SQL
-- Solutions of 15 business problems

-- 1. Count the number of Movies vs TV Shows

SELECT
	type,
	COUNT(*) AS total_number
FROM netflix
GROUP BY type;



-- 2. Find the most common rating for movies and TV shows (for each type category)

SELECT type, rating, ranking
FROM(
	SELECT
		type,
		rating,
		COUNT(rating) AS counts,
		RANK() OVER(PARTITION BY type ORDER BY COUNT(rating) DESC) as ranking
	FROM netflix
	GROUP BY rating, type) AS t1
WHERE ranking= 1;



-- 3. List all movies released in a specific year (e.g., 2020)

SELECT *
FROM netflix
WHERE release_year= 2020 AND type= 'Movie';



-- 4. Find the top 5 countries with the most content on Netflix

SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country_list,
	COUNT(*) AS total_count
from netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;



-- 5. Identify the longest movie

SELECT *
FROM netflix
WHERE duration LIKE '%min%'
ORDER BY cast (SUBSTRING(duration, 1, LENGTH(duration) - 4) AS int) DESC
LIMIT 1;



-- 6. Find content added in the last 5 years
-- Response 1:
SELECT *
FROM netflix
WHERE release_year >= (
						SELECT MAX(release_year)-4
						FROM netflix
);

-- Response 2:
SELECT CURRENT_DATE - interval '5 days';

SELECT *
FROM netflix
WHERE
	TO_DATE(date_added, 'Month DD, yyyy') >= CURRENT_DATE - INTERVAL '5 years';

						


-- 7. Find all the movies/TV shows by director 'Stefan Westerwelle'!

SELECT *
FROM netflix
WHERE director LIKE 'Stefan Westerwelle';



-- 8. List all TV shows with more than 5 seasons
-- Response 1:
SELECT *
FROM netflix
WHERE duration LIKE '%Season%' AND duration IS NOT NULL
	AND CAST(SUBSTRING(duration, 1, LENGTH(duration) - 7) AS int) > 5


-- Response 2:
SELECT *,
		SPLIT_PART(duration, ' ', 1) AS Seasons
FROM netflix
WHERE type= 'TV Show' AND 
						CAST(split_part(duration, ' ', 1) AS INT) > 5 



-- 9. Count the number of content items in each genre

SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, COUNT(*) AS genre_count
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;



-- 10.Find each year and the average numbers of content release in Germany on netflix. return top 5 year with highest avg content release!

SELECT
	EXTRACT(YEAR FROM TO_DATE (date_added, 'Month DD, yyyy')) AS Year,
	COUNT(*),
	ROUND(COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM netflix WHERE country LIKE '%German%')::NUMERIC * 100, 3) AS average_count
FROM netflix
WHERE country LIKE '%German%' and date_added IS NOT NULL
GROUP BY 1
ORDER BY 1 DESC
LIMIT 5



-- 11. List all movies that are documentaries
-- Response 1:
SELECT *
FROM netflix
WHERE type = 'Movie' AND (listed_in ILIKE '%Docuseries%' OR listed_in ILIKE '%Documentaries%')

-- Response 2:
SELECT *
FROM netflix
WHERE listed_in ILIKE '%Documentaries%'


-- 12. Find all content without a director

SELECT *
FROM netflix
WHERE director IS NULL;



-- 13. Find movies actor 'Denzel Washington' appeared in last 10 years!

SELECT *
FROM netflix
WHERE casts ILIKE '%Denzel Washington%'
	AND release_year > EXTRACT(YEAR FROM CURRENT_DATE)- 10



-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in Germany.

SELECT
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
	COUNT(*) AS total_count
FROM netflix
WHERE country ILIKE '%German%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10



-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--		the description field. Label content containing these keywords as 'Bad' and all other 
--			content as 'Good'. Count how many items fall into each category.
-- Response 1:
WITH new_table AS
(SELECT *, 
		CASE
		WHEN
			description ILIKE '%kill%' OR
			description ILIKE '%violence%' THEN 'Bad_Content'
			ELSE 'Good_Content'
		END AS category
FROM netflix)
SELECT category, COUNT(*) AS total_content
FROM new_table
GROUP BY category



-- Response 2:
SELECT category, COUNT(*) AS total_content
FROM(
	SELECT *,
		CASE
		WHEN
			description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad_Content'
			ELSE 'Good_Content'
		END AS category
	FROM netflix
) AS new_table
GROUP BY category
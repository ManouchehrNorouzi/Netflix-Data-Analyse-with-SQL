# Netflix-Data-Analyse-with-SQL

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.
## Dataset
The data for this project is sourced FROM the Kaggle dataset:

- Dataset Link: [Kaggle dataset- Movies](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)
## Schema
```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
## Business Problems and Solutions
### 1. Count the Number of Movies vs TV Shows
```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```
Objective: Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows
```sql
SELECT type, rating, ranking
FROM(
	SELECT
		type,
		rating,
		COUNT(rating) AS counts,
		RANK() OVER(PARTITION BY type ORDER BY COUNT(rating) DESC) AS ranking
	FROM netflix
	GROUP BY rating, type
) AS t1
WHERE ranking= 1;
```
Objective: Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)
```sql
SELECT * 
FROM netflix
WHERE release_year = 2020;
```
Objective: Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country_list,
	COUNT(*) as total_COUNT
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```
Objective: Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie
```sql
SELECT *
FROM netflix
WHERE duration LIKE '%min%'
ORDER BY CAST(SUBSTRING(duration, 1, LENGTH(duration) - 4) AS INT) DESC
LIMIT 1;
```
Objective: Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years
```sql
SELECT *
FROM netflix
WHERE
	TO_DATE(date_added, 'Month DD, yyyy') >= CURRENT_DATE - INTERVAL '5 years';
```
Objective: Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Stefan Westerwelle'
```sql
SELECT *
FROM netflix
WHERE director LIKE 'Stefan Westerwelle';
```
Objective: List all content directed by 'Stefan Westerwelle'.

### 8. List All TV Shows with More Than 5 Seasons
```sql
SELECT *
FROM netflix
WHERE duration LIKE '%Season%' AND duration IS NOT NULL
	AND CAST(SUBSTRING(duration, 1, LENGTH(duration) - 7) AS INT) > 5;
```
Objective: Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre
```sql
SELECT
  UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
  COUNT(*) AS genre_count
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;
```
Objective: Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in Germany on netflix. return top 5 year with highest avg content release!

```sql
SELECT
	EXTRACT(YEAR FROM TO_DATE (date_added, 'Month DD, yyyy')) AS Year,
	COUNT(*),
	ROUND(COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM netflix WHERE country LIKE '%German%')::NUMERIC * 100, 3) AS average_count
FROM netflix
WHERE country LIKE '%German%' AND date_added IS NOT NULL
GROUP BY 1
ORDER BY 1 DESC
LIMIT 5;
```
Objective: Calculate and rank years by the average number of content releases by Germany.

### 11. List All Movies that are Documentaries
```sql
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';
```
Objective: Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director
```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```
Objective: List content that does not have a director.

### 13. Find How Many Movies Actor 'Denzel Washington' Appeared in the Last 10 Years
```sql
SELECT *
FROM netflix
WHERE casts ILIKE '%Denzel Washington%'
	AND release_year > EXTRACT(YEAR FROM current_date)- 10;
```
Objective: Count the number of movies featuring 'Denzel Washington' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in Germany
```sql
SELECT
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
	COUNT(*) AS total_COUNT
FROM netflix
WHERE country ILIKE '%German%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```
Objective: Identify the top 10 actors with the most appearances in Germany-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```sql
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
GROUP BY category;
```
Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion
- __Content Distribution:__ The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- __Common Ratings:__ Insights into the most common ratings provide an understanding of the content's target audience.
- __Geographical Insights:__ The top countries and the average content releases by Germany highlight regional content distribution.
- __Content Categorization:__ Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
  
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

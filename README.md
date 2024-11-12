# Netflix-Data-Analyse-with-SQL

# Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

# Objectives
Analyze the distribution of content types (movies vs TV shows).
Identify the most common ratings for movies and TV shows.
List and analyze content based on release years, countries, and durations.
Explore and categorize content based on specific criteria and keywords.
# Dataset
The data for this project is sourced from the Kaggle dataset:

Dataset Link: Movies Dataset
Schema
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
Business Problems and Solutions
1. Count the Number of Movies vs TV Shows
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
Objective: Determine the distribution of content types on Netflix.

2. Find the Most Common Rating for Movies and TV Shows
select type, rating, ranking
from(
	select
		type,
		rating,
		count(rating) as counts,
		rank() over(partition by type order by count(rating) desc) as ranking
	from netflix
	group by rating, type) as t1
where ranking= 1;
Objective: Identify the most frequently occurring rating for each type of content.

3. List All Movies Released in a Specific Year (e.g., 2020)
SELECT * 
FROM netflix
WHERE release_year = 2020;
Objective: Retrieve all movies released in a specific year.

4. Find the Top 5 Countries with the Most Content on Netflix

SELECT
	unnest(string_to_array(country, ',')) as new_country_list,
	count(*) as total_count
from netflix
group by 1
order by 2 DESC
limit 5;
Objective: Identify the top 5 countries with the highest number of content items.

5. Identify the Longest Movie
select *
from netflix
where duration like '%min%'
order by cast (substring(duration, 1, length(duration) - 4) as int) DESC
limit 1;
Objective: Find the movie with the longest duration.

6. Find Content Added in the Last 5 Years
select *
from netflix
where
	to_date(date_added, 'Month DD, yyyy') >= current_date - interval '5 years';
Objective: Retrieve content added to Netflix in the last 5 years.

7. Find All Movies/TV Shows by Director 'Stefan Westerwelle'
select *
from netflix
where director like 'Stefan Westerwelle';
Objective: List all content directed by 'Rajiv Chilaka'.

8. List All TV Shows with More Than 5 Seasons
select *
from netflix
where duration like '%Season%' and duration is not null
	and cast(substring(duration, 1, length(duration) - 7) as int) > 5;
Objective: Identify TV shows with more than 5 seasons.

9. Count the Number of Content Items in Each Genre
select
  unnest(string_to_array(listed_in, ',')) as genre,
  count(*) as genre_count
from netflix
group by 1
order by 2 desc;
Objective: Count the number of content items in each genre.

10.Find each year and the average numbers of content release in Germany on netflix.
return top 5 year with highest avg content release!

select
	Extract(year from to_date (date_added, 'Month DD, yyyy')) as Year,
	count(*),
	round(count(*)::numeric/(select count(*) from netflix where country like '%German%')::numeric * 100, 3) as average_count
from netflix
where country like '%German%' and date_added is not null
group by 1
order by 1 desc
limit 5;
Objective: Calculate and rank years by the average number of content releases by Germany.

11. List All Movies that are Documentaries
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';
Objective: Retrieve all movies classified as documentaries.

12. Find All Content Without a Director
SELECT * 
FROM netflix
WHERE director IS NULL;
Objective: List content that does not have a director.

13. Find How Many Movies Actor 'Denzel Washington' Appeared in the Last 10 Years
select *
from netflix
where casts ilike '%Denzel Washington%'
	and release_year > extract(year from current_date)- 10;
Objective: Count the number of movies featuring 'Denzel Washington' in the last 10 years.

14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in Germany
select
	unnest(string_to_array(casts, ',')) as actors,
	count(*) as total_count
from netflix
where country ilike '%German%'
group by 1
order by 2 desc
limit 10;
Objective: Identify the top 10 actors with the most appearances in Germany-produced movies.

15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
select category, count(*) as total_content
from(
	select *,
		case
		when
			description ilike '%kill%' or description ilike '%violence%' then 'Bad_Content'
			else 'Good_Content'
		end as category
	from netflix
) as new_table
group by category;
Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

Findings and Conclusion
Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
Geographical Insights: The top countries and the average content releases by Germany highlight regional content distribution.
Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

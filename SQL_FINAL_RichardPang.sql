USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT table_name, table_rows
FROM information_schema.tables
WHERE table_schema='imdb'
ORDER BY table_rows;





-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_nulls,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_nulls,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
    SUM(CASE WHEN worldwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worldwide_gross_income_nulls,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_nulls,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_nulls
FROM movie;



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year, COUNT(*) AS number_of_movies
FROM movie
GROUP BY year
ORDER BY year;








/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(*) AS movie_count
FROM imdb.movie
WHERE (country = 'USA' OR country = 'India') 
AND year = 2019;








/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


SELECT DISTINCT genre
FROM imdb.genre; 







/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre, COUNT(*) AS movie_count
FROM imdb.genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 1;








/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


SELECT COUNT(*) AS movie_count
FROM (
    SELECT movie_id
    FROM imdb.genre
    GROUP BY movie_id
    HAVING COUNT(*) = 1
) AS single_genre_movies;







/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT genre, AVG(movie.duration) AS avg_duration
FROM imdb.movie
INNER JOIN imdb.genre ON movie.id = genre.movie_id
GROUP BY genre
ORDER BY avg_duration DESC;






/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- List all the movies ranking in 2019
SELECT genre,
    COUNT(movie_id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM genre
JOIN movie m ON movie_id = id
WHERE m.year = 2019
GROUP BY genre
ORDER BY genre_rank;





/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


SELECT
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM imdb.ratings;



    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT title, avg_rating,
    RANK() OVER (ORDER BY avg_rating DESC) AS movie_rank
FROM ratings
JOIN movie ON ratings.movie_id = movie.id
ORDER BY movie_rank
LIMIT 10;







/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating, COUNT(*) AS movie_count
FROM imdb.ratings
GROUP BY median_rating
ORDER BY median_rating







/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

	
SELECT production_company, 
       COUNT(*) AS movie_count,
       RANK() OVER (ORDER BY AVG(avg_rating) DESC) AS prod_company_rank
FROM imdb.movie
INNER JOIN imdb.ratings ON movie.id = ratings.movie_id
GROUP BY production_company
HAVING AVG(avg_rating) > 8
ORDER BY prod_company_rank
LIMIT 1;







-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, COUNT(*) AS movie_count
FROM imdb.movie
INNER JOIN imdb.genre ON movie.id = genre.movie_id -- Join genre movie id to genre.moive_id
INNER JOIN imdb.ratings ON movie.id = ratings.movie_id -- join rating movie .id to rating movie _id
WHERE YEAR(date_published) = 2017 -- where it published in 2017
  AND MONTH(date_published) = 3 -- publish date 3
  AND country = 'USA' -- country USA
  AND total_votes > 1000 -- with the total vote of 1000
GROUP BY genre
ORDER BY movie_count;







-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title, AVG(avg_rating) AS avg_rating, genre
FROM imdb.movie
INNER JOIN imdb.genre ON movie.id = genre.movie_id
INNER JOIN imdb.ratings ON movie.id = ratings.movie_id
WHERE title LIKE 'The%'  
  AND avg_rating > 8
GROUP BY title, genre;







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- print movies release from 1 1 April 2018 and 1 April 2019 which gives you median rating of 8
SELECT COUNT(*) AS movie_count
FROM imdb.ratings r
JOIN imdb.movie m ON r.movie_id = m.id
WHERE r.median_rating = 8
  AND m.date_published BETWEEN '2018-04-01' AND '2019-04-01';




-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    m.country, 
    SUM(r.total_votes) AS total_votes
FROM imdb.ratings r
JOIN imdb.movie m ON r.movie_id = m.id
WHERE m.country IN ('Germany', 'Italy')
GROUP BY m.country;







-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;









/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH TopDirectors AS (
    SELECT g.genre
    FROM genre g
    JOIN ratings r ON g.movie_id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY g.genre
    ORDER BY COUNT(r.movie_id) DESC
    LIMIT 3
)
SELECT n.name AS director_name, COUNT(r.movie_id) AS movie_count
FROM director_mapping dm
JOIN ratings r ON dm.movie_id = r.movie_id
JOIN genre g ON g.movie_id = r.movie_id
JOIN TopDirectors tg ON tg.genre = g.genre
JOIN names n ON dm.name_id = n.id
WHERE r.avg_rating > 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 3;





/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT n.name AS actor_name, COUNT(r.movie_id) AS movie_count
FROM role_mapping rm
JOIN ratings r ON rm.movie_id = r.movie_id
JOIN names n ON rm.name_id = n.id
WHERE r.median_rating >= 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 3;





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, SUM(r.total_votes) AS vote_count,
       RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM genre g
JOIN movie m ON g.movie_id = m.id
JOIN ratings r ON g.movie_id = r.movie_id
GROUP BY m.production_company
ORDER BY vote_count DESC
LIMIT 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH IndiaMovies AS (
    SELECT rm.name_id, r.total_votes, r.avg_rating
    FROM role_mapping rm
    JOIN movie m ON rm.movie_id = m.id  
    JOIN ratings r ON rm.movie_id = r.movie_id
    WHERE m.country = 'India'
)
SELECT n.name AS actor_name, 
       SUM(im.total_votes) AS total_votes, 
       COUNT(im.total_votes) AS movie_count, 
       SUM(im.total_votes * im.avg_rating) / SUM(im.total_votes) AS actor_avg_rating,
       RANK() OVER (ORDER BY SUM(im.total_votes * im.avg_rating) / SUM(im.total_votes) DESC, 
                            SUM(im.total_votes) DESC) AS actor_rank
FROM IndiaMovies im
JOIN names n ON im.name_id = n.id
GROUP BY n.name
HAVING COUNT(im.total_votes) >= 5
ORDER BY actor_rank;



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


ZZ



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title AS movie_title,
       r.avg_rating,
       CASE
           WHEN r.avg_rating > 8 THEN 'Superhit movies'
           WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
           WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
           WHEN r.avg_rating < 5 THEN 'Flop movies'
           ELSE 'Uncategorized'
       END AS movie_category
FROM movie m
JOIN ratings r ON m.id = r.movie_id
JOIN genre g ON m.id = g.movie_id
WHERE g.genre = 'Thriller'
ORDER BY r.avg_rating DESC;



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT g.genre,
       AVG(m.duration) AS avg_duration,
       SUM(m.duration) OVER (PARTITION BY g.genre ORDER BY m.id) AS running_total_duration,
       AVG(m.duration) OVER (PARTITION BY g.genre ORDER BY m.id ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS moving_avg_duration
FROM genre g
JOIN movie m ON g.movie_id = m.id
GROUP BY g.genre, m.id
ORDER BY g.genre;








-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies


WITH TopGenres AS (
    SELECT genre
    FROM genre g
    JOIN movie m ON g.movie_id = m.id
    GROUP BY genre
    ORDER BY COUNT(m.id) DESC
    LIMIT 3
),
RankedMovies AS (
    SELECT g.genre, m.year, m.title AS movie_name, m.worldwide_gross_income,
           RANK() OVER (PARTITION BY g.genre, m.year ORDER BY m.worldwide_gross_income DESC) AS movie_rank
    FROM genre g
    JOIN movie m ON g.movie_id = m.id
    WHERE g.genre IN (SELECT genre FROM TopGenres)
)
SELECT genre, year, movie_name, worldwide_gross_income, movie_rank
FROM RankedMovies
WHERE movie_rank <= 5
ORDER BY genre, year, movie_rank;









-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH MultilingualHits AS (
    SELECT m.production_company, r.avg_rating
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE LENGTH(m.languages) - LENGTH(REPLACE(m.languages, ',', '')) >= 1  -- Multilingual condition
    AND r.avg_rating >= 8  -- Median rating (assuming avg_rating represents the median in this case)
)
SELECT production_company, 
       COUNT(*) AS movie_count,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS prod_comp_rank
FROM MultilingualHits
GROUP BY production_company
ORDER BY prod_comp_rank
LIMIT 2;







-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH HitDramaMovies AS (
    SELECT rm.name_id, r.total_votes, r.avg_rating
    FROM role_mapping rm
    JOIN movie m ON rm.movie_id = m.id
    JOIN ratings r ON rm.movie_id = r.movie_id
    JOIN genre g ON m.id = g.movie_id
    WHERE g.genre = 'Drama' 
    AND r.avg_rating > 8  -- Super Hit condition
)
SELECT n.name AS actress_name, 
       SUM(shm.total_votes) AS total_votes, 
       COUNT(*) AS movie_count, 
       SUM(shm.total_votes * shm.avg_rating) / SUM(shm.total_votes) AS actress_avg_rating,
       RANK() OVER (ORDER BY SUM(shm.total_votes * shm.avg_rating) / SUM(shm.total_votes) DESC, SUM(shm.total_votes) DESC) AS actress_rank
FROM HitDramaMovies shm
JOIN names n ON shm.name_id = n.id
GROUP BY n.name
ORDER BY actress_rank
LIMIT 3;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH DirectorMovieCount AS (
    SELECT dm.name_id AS director_id,
        n.name AS director_name,
        COUNT(dm.movie_id) AS number_of_movies
    FROM director_mapping dm
    JOIN names n ON dm.name_id = n.id
    GROUP BY dm.name_id, n.name
    ORDER BY number_of_movies DESC
    LIMIT 9
),
MovieStats AS (
    SELECT 
        dm.name_id AS director_id,
        m.duration,
        m.date_published,
        r.avg_rating,
        r.total_votes,
        r.median_rating,
        DATEDIFF(LEAD(m.date_published) OVER (PARTITION BY dm.name_id ORDER BY m.date_published), m.date_published) AS inter_movie_days
    FROM director_mapping dm
    JOIN movie m ON dm.movie_id = m.id
    LEFT JOIN ratings r ON m.id = r.movie_id
),
DirectorStats AS (
    SELECT 
        dmc.director_id,
        dmc.director_name,
        dmc.number_of_movies,
        AVG(ms.inter_movie_days) AS avg_inter_movie_days,
        AVG(ms.avg_rating) AS avg_rating,
        SUM(ms.total_votes) AS total_votes,
        MIN(ms.median_rating) AS min_rating,
        MAX(ms.median_rating) AS max_rating,
        SUM(ms.duration) AS total_duration
    FROM DirectorMovieCount dmc
    JOIN MovieStats ms ON dmc.director_id = ms.director_id
    GROUP BY dmc.director_id, dmc.director_name, dmc.number_of_movies
)
SELECT 
    director_id,
    director_name,
    number_of_movies,
    ROUND(avg_inter_movie_days, 2) AS avg_inter_movie_days,
    ROUND(avg_rating, 2) AS avg_rating,
    total_votes,
    ROUND(min_rating, 1) AS min_rating,
    ROUND(max_rating, 1) AS max_rating,
    total_duration
FROM DirectorStats
ORDER BY number_of_movies DESC, director_name;








-- List the films where the yr is 1962 [Show id, title]

SELECT id, title
FROM movie
WHERE yr = 1962;

-- Give the year of 'Citizen Kane'

SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

-- List all of the Star Trek movies, include the id, title and yr.
-- Order results by year.

SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;

-- What id number does the actor 'Glenn Close' have?

SELECT id
FROM actor
WHERE name = 'Glenn Close';

-- What is the id of the film 'Casablanca'?

SELECT id
FROM movie
WHERE title = 'Casablanca';

-- Obtain the cast list for 'Casablanca'. Use movieid=11768

SELECT name
FROM actor JOIN casting
ON actor.id = casting.actorid
WHERE movieid = 11768;

-- Obtain the cast list for the film 'Alien'

SELECT name
FROM actor JOIN casting
ON actor.id = casting.actorid
JOIN movie
ON casting.movieid = movie.id
WHERE title = 'Alien';

-- List the films in which 'Harrison Ford' has appeared.

SELECT title
FROM movie JOIN casting
ON movie.id = casting.movieid
JOIN actor
ON casting.actorid = actor.id
WHERE name = 'Harrison Ford';

-- List the films where 'Harrison Ford' has appeared - but not in the
-- starring role.

SELECT title
FROM movie JOIN casting
ON movie.id = casting.movieid
JOIN actor
ON casting.actorid = actor.id
WHERE name = 'Harrison Ford' AND ord <> 1;

-- List the films together with the leading star for all 1962 films.

SELECT title, name
FROM movie JOIN casting
ON movie.id = casting.movieid
JOIN actor
ON casting.actorid = actor.id
WHERE ord = 1 AND yr = 1962;

-- Which were the busiest years for 'Rock Hudosn'? Show the year and the
-- number of movies he made each year for any year in which he made more
-- than 2 movies.

SELECT yr, COUNT(title)
FROM movie JOIN casting
ON movie.id = casting.movieid
JOIN actor
ON casting.actorid = actor.id
WHERE actor.name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

-- List the film title and the leading actor for all of the films
-- 'Julie Andrews' played in.

SELECT title, name
FROM movie
JOIN casting
ON movie.id = casting.movieid
JOIN actor
ON casting.actorid = actor.id
WHERE movie.id IN (
  SELECT movieid
  FROM casting
  WHERE actorid = (
    SELECT actor.id
    FROM actor
    WHERE name = 'Julie Andrews'
  )
) AND ord = 1

-- Obtain a list, in alphabetical order, of actors who've had at least 15
-- starring roles

SELECT actor.name
FROM casting
JOIN actor
ON actor.id = casting.actorid
WHERE ord = 1
GROUP BY actor.name
HAVING COUNT(*) >= 15
ORDER BY name;

-- List the films realeased in the year 1978 ordered by the number of actors
-- in the cast, then by title.

SELECT title, COUNT(actorid)
FROM movie
JOIN casting
ON movie.id = casting.movieid
WHERE yr = 1978
GROUP BY title
ORDER BY COUNT(actorid) DESC, title;

-- List all the poeple who have worked with 'Art Garfunkel'

SELECT name
FROM casting
JOIN actor
ON casting.actorid = actor.id
WHERE movieid IN (
  -- Movies 'Art Garfunkel' has been in
  SELECT movieid
  FROM casting
  JOIN movie
  ON casting.movieid = movie.id
  WHERE actorid = (
    SELECT id
    FROM actor
    WHERE name = 'Art Garfunkel'
  )
) AND actor.name != 'Art Garfunkel'

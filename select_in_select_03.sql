-- List each country name where the population is larger than that of 'Russia'

SELECT name
FROM world
WHERE population > (
        SELECT population
        FROM world
        WHERE name = 'Russia'
      );

-- Show the countries in Europe with a per capita GDP greater than 'United Kingdom'

SELECT name
FROM world
WHERE continent = 'Europe' AND
      gdp / population > (
        SELECT gdp / population
        FROM world
        WHERE name = 'United Kingdom'
      );

-- List the name and continent of countries in the continents containing either Argentina or
-- Australia. Order by name of the country.

SELECT name, continent
FROM world
WHERE continent IN (
        SELECT continent
        FROM world
        WHERE name IN ('Argentina', 'Australia')
      )
ORDER BY name;

-- Which country has a population that is more than Canada but less than Poland?
-- Show the name and the population.

SELECT name, population
FROM world
WHERE population > (
        SELECT population
        FROM world
        WHERE name = 'Canada'
      )
      AND population < (
        SELECT population
        FROM world
        WHERE name = 'Poland'
      );

-- Show the name and the population of each country in Europe. Show the population as a
-- percentage of the population of Germany.


SELECT name, CONCAT(
  ROUND(population / (
      SELECT population
      FROM world
      WHERE name = 'Germany'
  ) * 100 , 0), '%') AS percentage
FROM world
WHERE continent = 'Europe';

-- Which countries have a GDP greater than every country in Europe? [Give the name only.]

SELECT name
FROM world
WHERE gdp > ALL (SELECT gdp
                FROM world
                WHERE continent = 'Europe' AND
                      gdp > 0);

-- Find the largest country (by area) in each continent, show the continent, the name and the area.

SELECT continent, name, area
FROM world original
WHERE area > ALL (SELECT area
                  FROM world copy
                  WHERE original.continent = copy.continent AND
                        area > 0 AND
                        original.name <> copy.name);

-- List each continent and the name of the country that comes first alphabetically.

SELECT continent, name
FROM world original
WHERE name = (SELECT name
              FROM world copy
              WHERE original.continent = copy.continent
              ORDER BY name
              LIMIT 1);

-- Find the continents where all countries have a population <= 25000000. Then find the names
-- of the countries associated with these continents. Show name, continent and population.

SELECT name, continent, population
FROM world original
WHERE 25000000 > ALL(SELECT population
          FROM world copy
          WHERE original.continent = copy.continent);

-- Some countries have population more than three times that of any of their
-- neighbours (in the same continent). Give the countries and continents.

SELECT name, continent
FROM world original
WHERE population > ALL (SELECT population * 3
                    FROM world copy
                    WHERE original.continent = copy.continent
                    AND original.name <> copy.name);
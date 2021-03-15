-- How many stops are in the database?

SELECT id
FROM stops
WHERE name = 'Craiglockhart';

-- Give the id and the name for the stops on the '4' 'LRT' service.

SELECT stops.id, stops.name
FROM stops JOIN route
ON stops.id = route.stop
WHERE company = 'LRT' AND num = '4';

-- The query shown gives the nubmer of routes that visit either
-- London Road (149) or Craiglockhart (53). Run the query and notice the two
-- services that link these stops have a count of 2. Add a HAVING clause to
-- restrict the output to these two routes.

SELECT company, num, COUNT(*)
FROM route
WHERE stop = 149 OR
      stop = 53
GROUP BY company, num
HAVING COUNT(*) = 2;

-- Execute the self join shown and observe that b.stop gives all the places
-- you can get to from Craiglockhart, without changing routes. Change the
-- query so that it shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b
ON (a.company = b.company AND a.num = b.num)
WHERE a.stop = 53 AND b.stop = 149;

-- The query shown is siilar to the previous one, however by joining two
-- copies of the stops table we can refer to stop by name rather than by
-- number. Change the query so that the services between 'Craiglockhart'
-- and 'London Road' are shown

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b
ON a.company = b.company AND a.num = b.num
JOIN stops stopa
ON a.stop = stopa.id
JOIN stops stopb
ON b.stop = stopb.id
WHERE stopa.name = 'Craiglockhart' AND
      stopb.name = 'London Road';

-- Give a list of all the services which connect stops 115 and 137
-- ('Haymarket' and 'Leith')

SELECT DISTINCT a.company, a.num
FROM route a JOIN route b
ON a.num = b.num AND a.company = b.company
WHERE a.stop = 115 AND b.stop = 137;

-- Give a list of the services which connect the stops 'Craiglockhart' and
-- 'Tollcross'

SELECT DISTINCT a.company, a.num
FROM route a JOIN route b
ON a.num = b.num AND a.company = b.company
JOIN stops stopsa
ON stopsa.id = a.stop
JOIN stops stopsb
ON stopsb.id = b.stop
WHERE stopsa.name = 'Craiglockhart' AND
      stopsb.name = 'Tollcross';

-- Give a distinct list of the stops which may be reached from 'Craiglockart'
-- by taking one bus, including 'Craiglockhart' itself, offered by the
-- LRT company. Include the company and bus no. of the relevant services.

SELECT stopsb.name, a.company, a.num
FROM route a JOIN route b
ON a.company = b.company AND
   a.num = b.num
JOIN stops stopsa
ON a.stop = stopsa.id
JOIN stops stopsb
ON b.stop = stopsb.id
WHERE stopsa.name = 'Craiglockhart';

-- Find the routes involving two buses that can go from Craiglockhart to
-- Lochend. Show the bus no. and company for the first bus, the name of the
-- stop for the transfer, and the bus no. and company for the second bus.

SELECT trip1.num, trip1.company, trip1.transfer, trip2.num, trip2.company
FROM (
  SELECT DISTINCT a.num, a.company, stopsb.name AS transfer
  FROM route AS a JOIN route AS b
  ON a.company = b.company AND a.num = b.num
  JOIN stops AS stopsa
  ON a.stop = stopsa.id
  JOIN stops AS stopsb
  ON b.stop = stopsb.id
  WHERE stopsa.name = 'Craiglockhart'
) AS trip1
JOIN (
  SELECT DISTINCT c.num, c.company, stopsc.name AS departure
  FROM route AS c JOIN route AS d
  ON c.company = d.company AND c.num = d.num
  JOIN stops AS stopsc
  ON c.stop = stopsc.id
  JOIN stops AS stopsd
  ON d.stop = stopsd.id
  WHERE stopsd.name = 'Lochend'
) AS trip2
ON trip1.transfer = trip2.departure
ORDER BY trip1.num, trip1.transfer, trip2.num
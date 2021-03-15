-- Show the matchid and player name for all goals scored by Germany.

SELECT matchid, player
FROM goal
WHERE teamid = 'GER';

-- Show id, stadium, team1, team2 for just game 1012

SELECT id, stadium, team1, team2
FROM game
WHERE id = 1012;

-- Show the player, teamid, stadium and mdate for every German goal

SELECT player, teamid, stadium, mdate
FROM goal JOIN game
ON game.id = goal.matchid
WHERE goal.teamid = 'GER'

-- Show the team1, team2 and player for every goal scored by a player
-- called Mario

SELECT team1, team2, player
FROM goal JOIN game
ON goal.matchid = game.id
WHERE goal.player LIKE 'Mario%';

-- Show player, teamid, coach, gtime for all goals scored in the first
-- 10 minutes

SELECT player, teamid, coach, gtime
FROM goal JOIN eteam
ON goal.teamid = eteam.id
WHERE gtime <= 10;

-- List the dates of the matches and the name of the team in which
-- 'Fernando Santos' was the team1 coach.

SELECT mdate, teamname
FROM game JOIN eteam
ON game.team1 = eteam.id
WHERE coach = 'Fernando Santos';

-- List the player for every goal scored in a game where the stadium
-- was 'National Stadium, Warsaw'

SELECT player
FROM goal JOIN game
ON goal.matchid = game.id
WHERE game.stadium = 'National Stadium, Warsaw';

-- Show the name of all players who scored a goal against Germany.

SELECT DISTINCT player
FROM goal JOIN game
ON goal.matchid = game.id
WHERE 'GER' IN (team1, team2) AND teamid <> 'GER';

-- Show teamname and the total number of goals scored.

SELECT teamname, COUNT(player)
FROM eteam JOIN goal
ON eteam.id = goal.teamid
GROUP BY teamname;

-- Show the stadium and the number of goals scored in each stadium.

SELECT stadium, COUNT(player)
FROM game JOIN goal
ON game.id = goal.matchid
GROUP BY stadium;

-- For every match involving 'POL', show the matchid, date and the
-- number of goals scored.

SELECT matchid, mdate, COUNT(player) AS goals_scored
FROM game JOIN goal
ON game.id = goal.matchid
WHERE 'POL' IN (team1, team2)
GROUP BY matchid, mdate;

-- For every match where 'GER' scored, show matchid, match date and the
-- number of goals scored by 'GER'

SELECT matchid, mdate, COUNT(player)
FROM game JOIN goal
ON game.id = goal.matchid
WHERE goal.teamid = 'GER'
GROUP BY matchid, mdate;

-- List every match with the goals scored by each team as shown.
-- (mdate, team1, score1, team2, score2)

SELECT mdate, team1, SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) AS score1,
              team2, SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) AS score2
FROM game LEFT JOIN goal
-- Didn't take into account that a game could have ended 0-0. So a
-- LEFT JOIN fitted quite nicely here
ON game.id = goal.matchid
GROUP BY mdate, matchid, team1, team2
ORDER BY mdate, matchid, team1, team2;

CREATE TABLE game (Team varchar(50));
-----------------------------------------------------------------------------------
INSERT INTO game (Team)
VALUES ('India'),('Pak'),('Aus'),('Eng');
-----------------------------------------------------------------------------------
WITH cte As(
SELECT *, row_number() OVER(ORDER BY Team) AS Id 
FROM game)
SELECT a.Team As TeamA, b.Team AS TeamB 
FROM cte AS a
JOIN cte AS b
ON a.Team <> b.Team
WHERE a.Id < b.Id
ORDER BY a.Team
-----------------------------------------------------------------------------------

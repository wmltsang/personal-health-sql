/* find the max values of prayer,skin, exercise and when they occur*/
SELECT *
FROM interest_over_time t1
RIGHT JOIN
(SELECT 
MAX(skin) max_skin,
MAX(exercise) max_exercise,
MAX(prayer) max_prayer
FROM interest_over_time) t2
ON t1.skin = t2.max_skin
OR t1.exercise = t2.max_exercise
OR t1.prayer = t2.max_prayer

SELECT *
FROM interest_over_time t1
RIGHT JOIN
(SELECT 
MIN(skin) min_skin,
MIN(exercise) min_exercise,
MIN(prayer) min_prayer
FROM interest_over_time) t2
ON t1.skin = t2.min_skin
OR t1.exercise = t2.min_exercise
OR t1.prayer = t2.min_prayer

SELECT *
FROM interest_over_time t1
RIGHT JOIN
(SELECT 
AVG(skin) avg_skin,
AVG(exercise) avg_exercise,
AVG(prayer) avg_prayer
FROM interest_over_time) t2
ON t1.skin = t2.avg_skin
OR t1.exercise = t2.avg_exercise
OR t1.prayer = t2.avg_prayer

/*the tables do not have primary keys but would use region to do join and making sure all tables have the same numbers of region*/
SELECT COUNT(DISTINCT s.region) AS skin_region, 
COUNT(DISTINCT e.region) as exercise_region,
COUNT (DISTINCT p.region) as prayer_region
FROM skin_subregion s
FULL OUTER JOIN exercise_subregion e
ON s.region = e.region
FULL OUTER JOIN prayer_subregion p
ON e.region = p.region


/* delete record region = 'Region' becasue the values are strings with dates*/
DELETE FROM topics_subregion
WHERE region = 'Region'

/*topics_subregion columns is nvarchar , you need to take out % and change datatype to do aggregation*/


--UPDATE [SomeTable] SET [SomeColumn] = REPLACE([SomeColumn], 'somestring', '')
UPDATE topics_subregion 
SET skin_value = REPlACE(skin_value, '%',''), --note: the column values are percentage in unit
exercise_value = REPlACE(exercise_value, '%',''),
prayer_value = REPlACE(prayer_value, '%','') --troubleshoot success, I replace prayer value with exercise value by typing error

--change datatype so can perform aggregation functions
--ALTER TABLE TableName 
--ALTER COLUMN ColumnName NVARCHAR(200) [NULL | NOT NULL]
ALTER TABLE topics_subregion
ALTER COLUMN skin_value INT 
--inner query
/*SELECT AVG(skin_value)
FROM topics_subregion*/

SELECT TOP 5 region,
skin_value AS skin_percent --only need alias here not others
FROM topics_subregion
--exercise_value AS exercise_percent,
--prayer_value AS prayer_percent
WHERE skin_value >
(SELECT AVG(skin_value)
FROM topics_subregion)
ORDER BY skin_value DESC

--do same query for other two columns on topics_subregion to find out top 5 regions with values more than national average
ALTER TABLE topics_subregion
ALTER COLUMN exercise_value INT 

SELECT TOP 5 region,
exercise_value AS exercise_percent --only need alias here not others
FROM topics_subregion
--prayer_value AS prayer_percent
WHERE exercise_value >
(SELECT AVG(exercise_value)
FROM topics_subregion)
ORDER BY exercise_value DESC

ALTER TABLE topics_subregion
ALTER COLUMN prayer_value INT

SELECT TOP 5 region,
prayer_value AS prayer_percent --only need alias here not others
FROM topics_subregion
--prayer_value AS prayer_percent
WHERE prayer_value >
(SELECT AVG(prayer_value)
FROM topics_subregion)
ORDER BY prayer_value DESC


SELECT TOP 5 region,
skin_value AS skin_percent,
exercise_value AS exercise_percent,
prayer_value AS prayer_percent--only need alias here not others
FROM topics_subregion
WHERE prayer_value >
(SELECT AVG(prayer_value)
FROM topics_subregion)
AND exercise_value >
(SELECT AVG(exercise_value)
FROM topics_subregion)
AND skin_value >
(SELECT AVG(skin_value)
FROM topics_subregion)
ORDER BY skin_value DESC; --there are no region that can go above avg of the three values combined

--top 5 region sort by skin value desc
SELECT TOP 5 region,
skin_value AS skin_percent,
exercise_value AS exercise_percent,
prayer_value AS prayer_percent
FROM topics_subregion
ORDER BY skin_value DESC

/*delete the 'Region' record under region which is irrelevant to the analyis*/
DELETE FROM skin_subregion
WHERE region = 'Region'

ALTER TABLE skin_subregion --found out the value column is a string 
ALTER COLUMN value INT

--table skin_subregion
SELECT TOP 5 region, 
value as skin_value
FROM skin_subregion
ORDER BY value DESC


--do an inner join on region with other tables exercise_subregion and prayer_subregion to see what their values are
SELECT TOP 5 s.region,
s.value as skin_value,
e.value as exercise_value,
p.value as prayer_value
FROM skin_subregion s
INNER JOIN exercise_subregion e
ON s.region = e.region
INNER JOIN prayer_subregion p
ON e.region = p.region
ORDER BY s.value DESC --conclusion: when people care their skin based on key word search interest, they tend to also pay higher attention to 
                      -- exercise and prayer

SELECT TOP 5 s.region,
s.value as skin_value,
e.value as exercise_value,
p.value as prayer_value
FROM skin_subregion s
INNER JOIN exercise_subregion e
ON s.region = e.region
INNER JOIN prayer_subregion p
ON e.region = p.region
ORDER BY s.value ASC -- conlusion: when people not care skin based on key word search interest, they tend to also pay lower attention to exercise
                     -- as well as prayer

--Examine what are interested keywords people search related to respective topics
SELECT *
FROM skin_related_queries
WHERE skin_queries LIKE '%covid%'

SELECT *
FROM skin_related_queries
WHERE skin_queries LIKE '%ord%'

UPDATE skin_related_queries 
SET value = REPlACE(REPLACE(value, '+',''),'%','') --note: the column values are percentage in unit

SELECT *
FROM skin_related_queries

--bonus:after all analysis, try to see if you can group region into larger division such as west,east coast for comparison.

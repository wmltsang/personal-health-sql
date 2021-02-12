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

SELECT region, skin_value,exercise_value,prayer_value
FROM 
(SELECT *
FROM topics_subregion 
HAVING skin_value >= AVG(skin_value
GROUP BY region) 
)




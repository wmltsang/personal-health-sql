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



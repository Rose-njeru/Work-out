SELECT * FROM workout.`daily record`;
DESCRIBE workout.`daily record`;

/*Data Cleaning and Transformation
1.Remove the km in distance and convert from texr to float
2.Convert the time taken from text to time then separate the column in minutes and seconds
3.Convert the avg pace from text to time then separate into diffrent columns avg_minutes and avg_seconds*/
-- 1. Cleaning the date column

-- Removing the km from Distance_Covered_km
SELECT
Distance_Covered_km,
CASE 
WHEN Distance_Covered_km LIKE '%km'THEN trim('km' from Distance_Covered_km)
END AS Distance_Covered_km
FROM workout.`daily record`;

UPDATE workout.`daily record`
SET Distance_Covered_km=CASE 
WHEN Distance_Covered_km LIKE '%km'THEN trim('km' from Distance_Covered_km)
END;
-- convert distance coverved as float and update the table
SELECT 
CAST(Distance_Covered_km AS FLOAT)
FROM workout.`daily record`;
UPDATE workout.`daily record`
SET Distance_Covered_km =CAST(Distance_Covered_km AS FLOAT);
SELECT
Distance_Covered_km
FROM workout.`daily record`;

-- Converting Time_taken from text to time and removing the microseconds
SELECT 
time(Time_taken)
FROM workout.`daily record`;
UPDATE workout.`daily record`
SET Time_taken=time(Time_taken);
SELECT 
Time_taken
FROM workout.`daily record`;
-- removing the microseconds 
SELECT
time_format(Time_taken,"%H:%i:%s")
FROM workout.`daily record`;
UPDATE workout.`daily record`
SET Time_taken=time_format(Time_taken,"%H:%i:%s");
SELECT
Time_taken
FROM workout.`daily record`;
-- separting time taken to individual columns
SELECT
SUBSTRING_INDEX(Time_taken, ':', 1) as hours,
SUBSTRING_INDEX(SUBSTRING_INDEX(Time_taken, ':', -2), ':', -1) as minutes,
SUBSTRING_INDEX(Time_taken, ':', -1) as seconds
FROM workout.`daily record`;
-- Altering and updating the table
ALTER TABLE workout.`daily record`
ADD COLUMN hour TIME;
UPDATE workout.`daily record`
SET hour= SUBSTRING_INDEX(Time_taken, ':', 1);
ALTER TABLE workout.`daily record`
DROP column minutes;
ALTER TABLE workout.`daily record`
ADD COLUMN taken_minutes INT;
UPDATE workout.`daily record`
SET taken_minutes= REPLACE(SUBSTRING_INDEX(SUBSTRING_INDEX(Time_taken, ':', -2), ':', 1), ':', '');
ALTER TABLE workout.`daily record`
DROP column seconds;
ALTER TABLE workout.`daily record`
ADD COLUMN taken_seconds INT;
UPDATE workout.`daily record`
SET taken_seconds =CAST(SUBSTRING_INDEX(Time_taken, ':', -1) AS UNSIGNED);
SELECT 
hour,
taken_minutes,
taken_seconds
FROM workout.`daily record`;
ALTER TABLE workout.`daily record`
DROP COLUMN hour;

-- Converting Avg_pace to time 
SELECT 
time( Avg_Pace)
FROM workout.`daily record`;
UPDATE workout.`daily record`
SET Avg_Pace=time( Avg_Pace);
-- removing the microseconds 
SELECT 
time_format(Avg_Pace,"%H:%i:%s")
FROM workout.`daily record`;
UPDATE workout.`daily record`
SET Avg_Pace=time_format(Avg_Pace,"%H:%i:%s");
-- breaking avg_pace into individual columns avg_minute,avg_seconds and drop the avg-hour 
SELECT 
Avg_Pace,
SUBSTRING_INDEX(Avg_Pace, ':', 1) as avg_hours,
SUBSTRING_INDEX(SUBSTRING_INDEX(Avg_pace, ':', -2), ':', 1) as  avg_minutes,
SUBSTRING_INDEX(Avg_Pace, ':', -1) as  avg_seconds
FROM workout.`daily record`;
ALTER TABLE workout.`daily record`
ADD COLUMN avg_hour INT;
UPDATE workout.`daily record`
SET avg_hour=SUBSTRING_INDEX(Avg_Pace, ':', 1);
ALTER TABLE workout.`daily record`
ADD COLUMN avg_minutes INT;
UPDATE workout.`daily record`
SET avg_minutes=REPLACE(SUBSTRING_INDEX(SUBSTRING_INDEX(Avg_Pace, ':', -2), ':', 1), ':', '');
ALTER TABLE workout.`daily record`
ADD COLUMN avg_seconds INT;
UPDATE workout.`daily record`
SET avg_seconds=SUBSTRING_INDEX(Avg_Pace, ':', -1);
SELECT 
avg_hour,
avg_minutes,
avg_seconds
FROM workout.`daily record`;
ALTER TABLE workout.`daily record`
DROP COLUMN avg_hour;

-- Cleaning the Interaction column and updating the table
SELECT
Interaction,
CASE 
WHEN Interaction='no' THEN 'No'
WHEN Interaction ='yes' THEN 'Yes'
WHEN Interaction =' no' THEN 'No'
WHEN Interaction ='no ' THEN 'No'
WHEN Interaction ='yes ' THEN 'Yes'
END AS Interaction 
FROM workout.`daily record`;
UPDATE workout.`daily record`
SET Interaction=CASE 
WHEN Interaction='no' THEN 'No'
WHEN Interaction ='yes' THEN 'Yes'
WHEN Interaction =' no' THEN 'No'
WHEN Interaction ='no ' THEN 'No'
WHEN Interaction ='yes ' THEN 'Yes'
END;
SELECT
Interaction
FROM workout.`daily record`;
-- drop columns Time_taken and Avg_pace
ALTER TABLE workout.`daily record`
DROP COLUMN Time_taken;
ALTER TABLE workout.`daily record`
DROP COLUMN Avg_Pace;
/* Converting calories into Kg
1 kcal=0.00013kg*/
SELECT
Calories,
round((Calories*0.00013),3) AS Kg
FROM workout.`daily record`;
ALTER TABLE workout.`daily record`
ADD COLUMN Kg FLOAT;
UPDATE workout.`daily record`
SET Kg=round((Calories*0.00013),3);
SELECT
Kg
FROM workout.`daily record`;
SELECT *
from workout.`daily record`;

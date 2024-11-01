USE laboration1;

-- MOON MISSIONS

-- 1.
CREATE TABLE successful_mission AS SELECT * FROM moon_mission WHERE outcome = 'Successful';

-- 2.
ALTER TABLE successful_mission MODIFY COLUMN mission_id INT PRIMARY KEY AUTO_INCREMENT;

-- 3.
UPDATE moon_mission SET operator = TRIM(REPLACE(operator, ' ', '')) WHERE operator LIKE '% %';
UPDATE successful_mission SET operator = TRIM(REPLACE(operator, ' ', '')) WHERE operator LIKE '% %';

-- 4.
DELETE FROM successful_mission WHERE launch_date > '2010-01-01';

-- 5.
SELECT *,
       CONCAT(first_name, ' ', last_name) AS name,
       IF(SUBSTRING(ssn, LENGTH(ssn) - 1, 1) % 2 = 0, 'female', 'male') AS gender
FROM account;

-- 6.
DELETE FROM account
WHERE SUBSTRING(REPLACE(ssn, '-', ''), LENGTH(REPLACE(ssn, '-', '')) - 1, 1) % 2 = 0
  AND REPLACE(ssn, '-', '') < '700101';

-- 7.
SELECT gender,AVG(YEAR(CURDATE()) -
                  IF(SUBSTRING(ssn, 1, 2) > SUBSTRING(YEAR(CURDATE()), 3, 2), CONCAT('19', SUBSTRING(ssn, 1, 2)),
                     CONCAT('20', SUBSTRING(ssn, 1, 2)))) AS average_age
FROM (
         SELECT *,
                IF(SUBSTRING(ssn, LENGTH(ssn) - 1, 1) % 2 = 0, 'female', 'male') AS gender
         FROM account
     ) AS subquery
GROUP BY gender;
SELECT *FROM worldlifeexpectancy;
SET SQL_SAFE_UPDATES = 0;


#remove duplicated rows from a dataset,
DELETE FROM worldlifeexpectancy
WHERE Row_ID IN (SELECT Row_ID
FROM 
(SELECT 
Row_ID, ROW_NUMBER() OVER(PARTITION BY CONCAT(COUNTRY, YEAR)) AS row_n FROM worldlifeexpectancy ) as R
WHERE row_n >1);

#Checking for missing Status
SELECT COUNT(*) FROM worldlifeexpectancy
WHERE Status='';

#Populating missing Status 
UPDATE worldlifeexpectancy as t1
JOIN worldlifeexpectancy as t2
ON t1.Country=t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status='' AND t2.Status<>'' AND t2.Status='Developing';

UPDATE worldlifeexpectancy as t1
JOIN worldlifeexpectancy as t2
ON t1.Country=t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status='' AND t2.Status<>'' AND t2.Status='Developed';


#Populating missing Life expectancy with average from year before and year after 
UPDATE worldlifeexpectancy as t1
JOIN worldlifeexpectancy as t2
ON t1.Country=t2.Country AND t1.Year=t2.Year-1
JOIN worldlifeexpectancy as t3
ON t1.Country=t3.Country AND t1.Year=t3.Year+1
SET t1.`Life expectancy`=ROUND((t2.`Life expectancy`+t3.`Life expectancy`)/2,2)
WHERE t1.`Life expectancy`='' OR t1.`Life expectancy`=0;

SELECT *FROM worldlifeexpectancy;
SELECt COUNT(*) FROM worldlifeexpectancy
WHERE GDP=0 ;
#Populating missing GDP with average from year before and year after 
UPDATE worldlifeexpectancy as t1
JOIN worldlifeexpectancy as t2
ON t1.Country=t2.Country AND t1.Year=t2.Year-1
JOIN worldlifeexpectancy as t3
ON t1.Country=t3.Country AND t1.Year=t3.Year+1
SET t1.GDP=ROUND((t2.GDP +t3.GDP)/2,2)
WHERE t1.GDP=0;

#Delet rows where GDP=0 AND `Life expectancy`=0

DELETE FROM worldlifeexpectancy
WHERE GDP=0 AND `Life expectancy`=0;




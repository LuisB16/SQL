CREATE TABLE appleStore_description_combined AS 

SELECT * from appleStore_description1

UNION ALL 

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

union all 

SELECT * FROM appleStore_description4






**EXPLORATORY DATA ANALYSIS**

-- check the number of unique apps in both tablesAppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description_combined

-- Check for any missing values in key fieldsAppleStore

SELECT COUNT(*) as MissingValues
FROM AppleStore
WHERE track_name IS null or user_rating IS null OR prime_genre is null 

SELECT COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc is null 

--Find out the number of apps per genre

SELECT prime_genre, COUNT(*) as NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

--Get an overview of the apps ratings 

SELECT min(user_rating) AS MinRating,
       max(user_rating) AS MaxRating,
       avg(user_rating) as AvgRating
FROM AppleStore

--Get the distribution of app pricesAppleStore

SELECT
	(price / 2) *2 AS PriceBinStart,
    ((price / 2) *2) +2 as PriceBinEnd,
    COUNT(*) as NumApps
FROM AppleStore

GROUP BY PriceBinStart
ORDER BY PriceBinStart


**DATA ANALYSIS**

--Determine wheather paid apps have higher ratings than free apps

SELECT CASE
			WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
       END AS App_Type,
       avg(user_rating) as Avg_Rating
FROM AppleStore
GROUP BY App_Type

--Check if apps with more supported languages have higher ratings 

SELECT CASE
			WHEN lang_num < 10 THEN '<10 languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            ELSE '>30 languages'
       end AS language_bucket,
       avg(user_rating) as Avg_Rating
FROM AppleStore
GROUP by language_bucket
ORDER BY Avg_Rating DESC

--Check genres with low ratingsAppleStore

SELECT prime_genre,
	   avg(user_rating) as Avg_Rating
FROM AppleStore
GROUP By prime_genre
order BY Avg_Rating ASC
LIMIT 10

--Check if there is correlation between the length of the app description and the user ratingAppleStore

SELECT CASE
			when length(b.app_desc) <500 THEN 'Short'
            WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
            ELSE 'Long'
       end as description_lenght_bucket,
       avg(a.user_rating) as average_rating

FROM
	 AppleStore as A 
JOIN
	 appleStore_description_combined as b 
ON 
	 a.id = b.id
     
GROUP BY description_lenght_bucket
ORDER by average_rating DESC

--Check the top-rated apps for each genre 

SELECT
	prime_genre,
    track_name,
    user_rating
FROM (
  	   SELECT
  	   prime_genre,
       track_name,
       user_rating,
       RANK () OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
       FROM
  	   AppleStore
     ) as a 
WHERE
a.rank = 1








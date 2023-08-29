-- Comparing GDP and World Happiness Report over time
SELECT gdp.entity AS Country, gdp.year AS Year, gdp.gdp AS 'GDP', whr.Happiness_Score
FROM gdp
JOIN whr ON gdp.year = whr.year
    AND gdp.entity = whr.entity
ORDER BY gdp.entity, year

-- Average happiness score in each continent
SELECT continent.continent AS 'Continent', ROUND(AVG(Happiness_Score), 2) AS 'Average Happiness Score'
FROM (SELECT gdp.entity, gdp.year, gdp.gdp, whr.Happiness_Score
FROM gdp
JOIN whr ON gdp.year = whr.year
    AND gdp.entity = whr.entity) AS newgdp
JOIN continent ON newgdp.Entity = continent.country
GROUP BY continent.[continent]
ORDER BY AVG(Happiness_Score) DESC
-------------------------------------------------------------------------------------------------
-- Analyzing distribution of happiness score by income bracket across the world.
-- First, obtain the desired bracket and happiness information.
SELECT CASE
        WHEN Happiness_Score <= 4.5 THEN '0-4.5'
        WHEN Happiness_Score > 4.5 AND Happiness_Score <= 6 THEN '>4.5-6'
        ELSE '>6-10'
    END AS Happiness, bracket.country, bracket.income_bracket, bracket.medianincome, whr.Happiness_Score
    INTO income_whr
FROM
    (SELECT CASE
            WHEN medianincome <= 1085 THEN 'Low'
            WHEN medianincome >= 1086 AND medianincome <= 4255 THEN 'Lower-Middle'
            WHEN medianincome >= 4256 AND medianincome <= 13205 THEN 'Upper-Middle'
        ELSE 'High'
        END AS income_bracket, country, medianincome
    FROM Income) as bracket
JOIN whr ON bracket.country = whr.entity
WHERE whr.year = 2021
ORDER BY bracket.medianincome

-- Overall average happiness score by income bracket in 2021
SELECT income_bracket AS 'Income Bracket', ROUND(AVG(Happiness_Score), 2) AS 'Avg Happiness Score (0-10)'
FROM income_whr
GROUP BY income_bracket
ORDER BY AVG(Happiness_Score)

-- Happiness score distribution by income bracket in 2021
SELECT income_bracket, Happiness, COUNT(Happiness) AS '#_of_Countries' 
FROM income_whr
GROUP BY Happiness, income_bracket
-------------------------------------------------------------------------------------------------
-- Analyzing happiness score by household consumption vs GDP
SELECT consumption.Entity AS Country, consumption.Year, consumption.Consumption, consumption.GDP, whr.Happiness_Score
FROM consumption
JOIN whr ON consumption.Entity = whr.Entity
    AND whr.[Year] = consumption.Year
WHERE consumption.consumption IS NOT NULL
    AND consumption.GDP IS NOT NULL
-------------------------------------------------------------------------------------------------
-- Comparing happiest and unhappiest countries (Finland vs Afghanistan)
-- 1. Finding happiest and unhappies countries
SELECT * FROM (SELECT TOP 1 Entity AS Country, ROUND(AVG(Happiness_Score), 2) AS 'Happiness_Score'
                FROM whr
                WHERE [Year] = 2021
                GROUP BY Entity
                ORDER BY AVG(Happiness_Score) DESC) AS A
UNION 
SELECT * FROM (SELECT TOP 1 Entity AS Country, ROUND(AVG(Happiness_Score), 2) AS 'Happiness_Score'
                FROM whr
                WHERE [Year] = 2021
                GROUP BY Entity) AS B
-- 2. Country and income bracket of Finland and Afghanistan
SELECT * FROM (SELECT country AS Country, CASE
                        WHEN medianincome <= 1085 THEN 'Low'
                        WHEN medianincome >= 1086 AND medianincome <= 4255 THEN 'Lower-Middle'
                        WHEN medianincome >= 4256 AND medianincome <= 13205 THEN 'Upper-Middle'
                    ELSE 'High'
                    END AS 'Income_Bracket'
                    FROM Income
                    WHERE Country = 'Finland') AS C
UNION
SELECT * FROM (SELECT Entity AS Country, CASE
                        WHEN GDP <= 1085 THEN 'Low'
                    ELSE 'Higher'
                    END AS 'Income_Bracket'
                    FROM gdp
                    WHERE Entity = 'Afghanistan') AS D
-- 3. Country and household consumption of Finland and Afghanistan
SELECT * FROM (SELECT TOP 1 Entity AS Country, ROUND(Consumption, 2)
            FROM consumption
            WHERE Entity = 'Afghanistan' AND Consumption IS NOT NULL
            ORDER BY [Year] DESC) AS E
UNION 
SELECT * FROM (SELECT TOP 1 Entity AS Country, ROUND(Consumption, 2)
        FROM consumption
        WHERE Entity = 'Finland' AND Consumption IS NOT NULL
        ORDER BY [Year] DESC) AS F
-- 4. Then, join different tables of Finland and Afghanistan
SELECT AB.Country, AB.Happiness_Score AS 'Happiness Score', CD.Income_Bracket AS 'Income Bracket', EF.Consumption AS 'Consumption/GDP(%)',
        CONCAT(Income_Bracket, 'est Happiness Score in 2021') AS Summary
FROM AB
JOIN CD ON AB.Country = CD.Country
JOIN EF ON AB.Country = EF.Country

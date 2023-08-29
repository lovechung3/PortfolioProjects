-- GDP was updated to 2 decimal places.
UPDATE gdp
SET GDP = ROUND(GDP, 2)

-- Updating cells missing 'median income'
UPDATE income
SET medianincome = 7311
WHERE country = 'China'

UPDATE income
SET medianincome = 1153
WHERE country = 'India'

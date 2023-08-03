-- Table to visualize zip codes of unique homes with violations. Includes 'property type' and 'year(date)' for filtering purposes in Tableau --
SELECT DISTINCT[address], zip_code, YEAR([date]) AS 'Year of Violation', property_type
FROM bostonnew
ORDER BY YEAR([date])
-- Table to visualize homes with the most violations --
SELECT [address], neighborhood, zip_code, YEAR([date]) AS 'Year of Violation'
FROM bostonnew
ORDER BY YEAR([date])
-- Table to visualize when homes were built and remodeled --
SELECT DISTINCT([address]), zip_code, year_built, year_remodeled
FROM bostonnew
ORDER BY [address]
-- Table to visualize top violations of each home --
SELECT [address], zip_code, violation_type, edited_description, YEAR([date]) AS 'Year of Violation'
FROM bostonnew

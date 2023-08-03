---- Cleaning Data ----
-- Adding "0" in front of ZIP codes --
UPDATE boston
  SET zip_code = RIGHT('0' + zip_code, 5)
WHERE LEN(zip_code) < 5
-- Checking updates --
SELECT
    DISTINCT(zip_code) as zip_code
FROM boston
-- Removing ZIP code from 'address' column --
UPDATE boston
   SET [address] = SUBSTRING([address],1,LEN([address])-7)
-- Updating 'neighborhood' column to correct or more-accurate neighborhoods --
UPDATE boston
    SET neighborhood = 'Central Boston'
WHERE zip_code = '02109' OR zip_code ='02110' OR zip_code ='02111' OR zip_code ='02113' OR zip_code ='02114'

UPDATE boston
    SET neighborhood = 'Back Bay/Beacon Hill'
WHERE zip_code = '02108' OR zip_code ='02116' OR zip_code = '02199'

UPDATE boston
    SET neighborhood = 'Fenway/Kenmore'
WHERE zip_code = '02115' OR zip_code = '02215'

UPDATE boston
    SET neighborhood ='Roxbury'
WHERE zip_code = '02120'

UPDATE boston
    SET neighborhood = 'South Boston'
WHERE zip_code = '02210'
-- checking updates --
SELECT
    DISTINCT(neighborhood)
FROM boston
ORDER BY neighborhood ASC
-- Updating 'property_type' column labels --
UPDATE boston
    SET property_type = 'Residential & Commercial'
WHERE property_type = 'Mixed Use (Res. and Comm.)'

UPDATE boston
    SET property_type = 'Condominium'
WHERE property_type = 'Condominium Main*'
-- Checking updates --
SELECT
    DISTINCT(property_type)
FROM boston
-- Making cleaned table with edited descriptions (edited in Excel) called 'bostonnew' --
SELECT boston.date, boston.violation_type, editeddescription.edited_description, boston.address, boston.neighborhood, boston.zip_code, boston.[owner], boston.year_built, boston.year_remodeled, boston.property_type, boston.latitude, boston.longitude
    INTO bostonnew
FROM editeddescription
RIGHT JOIN boston ON editeddescription.description = boston.[description]
ORDER BY boston.[date] ASC
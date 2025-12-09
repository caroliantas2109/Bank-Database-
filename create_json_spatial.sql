/* 
   Purpose:
   - Add JSON support to an existing table.
   - Add spatial support for bank branches.
*/

USE BankDB;
GO

/* =========================================================
   1) JSON SUPPORT
   ========================================================= */

-- Add JSON column only if it doesn't exist yet
IF COL_LENGTH('dbo.customer', 'profile_json') IS NULL
BEGIN
    ALTER TABLE dbo.customer
        ADD profile_json NVARCHAR(MAX) NULL;

    -- Enforce that data stored in profile_json is valid JSON
    ALTER TABLE dbo.customer WITH CHECK
        ADD CONSTRAINT CK_customer_profile_json_is_valid
        CHECK (profile_json IS NULL OR ISJSON(profile_json) = 1);
END
GO

-- Populate sample JSON data for some customers
UPDATE dbo.customer
SET profile_json = N'{
  "contact": {
    "email": "john.smith@gmail.com",
    "phone": "+1-416-555-0101"
  },
  "preferences": {
    "preferred_branch_id": 1,
    "notifications": {
      "email": true,
      "sms": false
    }
  },
  "risk_profile": "medium"
}'
WHERE customer_id = 1;

UPDATE dbo.customer
SET profile_json = N'{
  "contact": {
    "email": "maria.gonzalez@icloud.com",
    "phone": "+1-604-555-0202"
  },
  "preferences": {
    "preferred_branch_id": 2,
    "notifications": {
      "email": true,
      "sms": true
    }
  },
  "risk_profile": "low"
}'
WHERE customer_id = 2;

UPDATE dbo.customer
SET profile_json = N'{
  "contact": {
    "email": "william.jones@yahoo.com",
    "phone": "+1-514-555-0303"
  },
  "preferences": {
    "preferred_branch_id": 3,
    "notifications": {
      "email": false,
      "sms": true
    }
  },
  "risk_profile": "high"
}'
WHERE customer_id = 3;

UPDATE dbo.customer
SET profile_json = N'{
  "contact": {
    "email": "linda.miller@hotmail.com",
    "phone": "+1-403-555-0404"
  },
  "preferences": {
    "preferred_branch_id": 4,
    "notifications": {
      "email": true,
      "sms": false
    }
  },
  "risk_profile": "medium"
}'
WHERE customer_id = 4;

UPDATE dbo.customer
SET profile_json = N'{
  "contact": {
    "email": "richard.davis@hotmail.com",
    "phone": "+1-613-555-0505"
  },
  "preferences": {
    "preferred_branch_id": 5,
    "notifications": {
      "email": false,
      "sms": false
    }
  },
  "risk_profile": "low"
}'
WHERE customer_id = 5;
GO


/* =========================================================
   2) SPATIAL SUPPORT
   In this project, we added a spatial (geography) column to the branch table to store the physical 
   location of each bank branch using latitude and longitude coordinates.

   We added spatial data to store the exact location of each bank branch using latitude and longitude. 
   This allows the system to identify where branches are on a map, find the closest branch to a customer, 
   support route planning, and make the database more realistic. 
   It also fulfills the project requirement to include spatial data in the design.
   ========================================================= */

-- Add spatial column (geography) to branch only if it doesn't exist yet
IF COL_LENGTH('dbo.branch', 'branch_location') IS NULL
BEGIN
    ALTER TABLE dbo.branch
        ADD branch_location GEOGRAPHY NULL;
END
GO
 /*
 Add one column to a table to store spatial information of the bank’s 
 branches and populate with sample data
 */


/*
Banks also use spatial data to plan routes for cash transportation or maintenance teams. 
Knowing the exact distance between branches helps with planning, scheduling, and saving time.
*/

UPDATE dbo.branch
SET branch_location = geography::Point(43.6532, -79.3832, 4326)  -- Toronto
WHERE branch_id = 1;  -- Toronto Main Branch

UPDATE dbo.branch
SET branch_location = geography::Point(49.2827, -123.1207, 4326) -- Vancouver
WHERE branch_id = 2;  -- Vancouver Downtown

UPDATE dbo.branch
SET branch_location = geography::Point(45.5017, -73.5673, 4326)  -- Montreal
WHERE branch_id = 3;  -- Montreal Central

UPDATE dbo.branch
SET branch_location = geography::Point(51.0447, -114.0719, 4326) -- Calgary
WHERE branch_id = 4;  -- Calgary Tower Branch

UPDATE dbo.branch
SET branch_location = geography::Point(45.4215, -75.6972, 4326)  -- Ottawa
WHERE branch_id = 5;  -- Ottawa Parliament

UPDATE dbo.branch
SET branch_location = geography::Point(53.5461, -113.4938, 4326) -- Edmonton
WHERE branch_id = 6;  -- Edmonton North

UPDATE dbo.branch
SET branch_location = geography::Point(49.8951, -97.1384, 4326)  -- Winnipeg
WHERE branch_id = 7;  -- Winnipeg Exchange

UPDATE dbo.branch
SET branch_location = geography::Point(44.6488, -63.5752, 4326)  -- Halifax
WHERE branch_id = 8;  -- Halifax Waterfront

UPDATE dbo.branch
SET branch_location = geography::Point(48.4284, -123.3656, 4326) -- Victoria
WHERE branch_id = 9;  -- Victoria Harbor

UPDATE dbo.branch
SET branch_location = geography::Point(52.1332, -106.6700, 4326) -- Saskatoon
WHERE branch_id = 10; -- Saskatoon University

UPDATE dbo.branch
SET branch_location = geography::Point(50.4452, -104.6189, 4326) -- Regina
WHERE branch_id = 11; -- Regina Downtown

UPDATE dbo.branch
SET branch_location = geography::Point(46.8139, -71.2080, 4326)  -- Quebec City
WHERE branch_id = 12; -- Quebec Old Port

UPDATE dbo.branch
SET branch_location = geography::Point(42.9849, -81.2453, 4326)  -- London, ON
WHERE branch_id = 13; -- London Central

UPDATE dbo.branch
SET branch_location = geography::Point(43.4516, -80.4925, 4326)  -- Kitchener
WHERE branch_id = 14; -- Kitchener Tech Hub

UPDATE dbo.branch
SET branch_location = geography::Point(43.5890, -79.6441, 4326)  -- Mississauga
WHERE branch_id = 15; -- Mississauga Square
GO

PRINT 'JSON and spatial columns successfully added and populated.';
GO
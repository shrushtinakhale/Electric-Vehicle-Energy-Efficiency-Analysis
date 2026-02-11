CREATE DATABASE ev_analysis;
USE ev_analysis;
CREATE TABLE ev_data (
    model_year INT,
    make NVARCHAR(100),
    model NVARCHAR(100),
    vehicle_class NVARCHAR(100),
    motor_kw INT,
    recharge_time_h FLOAT,
    energy_efficiency_km_per_kwh FLOAT
);
BULK INSERT ev_data
FROM 'C:\Users\Dell\Downloads\EV Energy Efficiency Dataset.csv'
WITH (
    FIRSTROW = 2,              -- skips header
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
SELECT COUNT(*) AS total_rows FROM ev_data;
SELECT TOP 10 * FROM ev_data;
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ev_data';


SELECT
    Model_year,
    AVG(energy_efficiency_km_per_kwh) AS avg_efficiency
FROM ev_data
GROUP BY Model_year
ORDER BY Model_year;

CREATE OR REPLACE VIEW vw_yearly_efficiency AS
SELECT
    Model_year,
    AVG(energy_efficiency_km_per_kwh) AS avg_efficiency
FROM ev_data
WHERE energy_efficiency_km_per_kwh IS NOT NULL
GROUP BY Model_year;

-- Drop the view if it exists
IF OBJECT_ID('vw_yearly_efficiency', 'V') IS NOT NULL
    DROP VIEW vw_yearly_efficiency;
GO

-- Create the view
CREATE VIEW vw_yearly_efficiency AS
SELECT
    Model_year,
    AVG(energy_efficiency_km_per_kwh) AS avg_efficiency
FROM ev_data
WHERE energy_efficiency_km_per_kwh IS NOT NULL
GROUP BY Model_year;
GO
SELECT * FROM vw_yearly_efficiency ORDER BY Model_year;

-- Drop view if it already exists
IF OBJECT_ID('vw_top_brands_efficiency', 'V') IS NOT NULL
    DROP VIEW vw_top_brands_efficiency;
GO

-- Create view
CREATE VIEW vw_top_brands_efficiency AS
SELECT
    make,
    AVG(energy_efficiency_km_per_kwh) AS avg_efficiency
FROM ev_data
WHERE energy_efficiency_km_per_kwh IS NOT NULL
GROUP BY make;
GO
SELECT *
FROM vw_top_brands_efficiency
ORDER BY avg_efficiency DESC;
IF OBJECT_ID('vw_motor_vs_efficiency', 'V') IS NOT NULL
    DROP VIEW vw_motor_vs_efficiency;
GO

CREATE VIEW vw_motor_vs_efficiency AS
SELECT
    motor_kw,
    AVG(energy_efficiency_km_per_kwh) AS avg_efficiency
FROM ev_data
WHERE motor_kw IS NOT NULL
GROUP BY motor_kw;
GO
ALTER TABLE ev_data
ADD Battery_Capacity_kWh FLOAT,
    Range_km FLOAT;

SELECT
    model_year,
    AVG(energy_efficiency_km_per_kwh) AS efficiency
FROM ev_data
GROUP BY model_year
ORDER BY model_year;
SELECT TOP 5
    make,
    AVG(energy_efficiency_km_per_kwh) AS efficiency
FROM ev_data
GROUP BY make
ORDER BY efficiency DESC;

SELECT
    COUNT(*) AS total_rows,
    COUNT(energy_efficiency_km_per_kwh) AS efficiency_available,
    COUNT(motor_kw) AS motor_power_available
FROM ev_data;



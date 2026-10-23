-- ============================================================
-- ENTERPRISE ENERGY DATA PLATFORM
-- OPERATIONAL REPORTS
-- Database: PostgreSQL
-- ============================================================


-- ============================================================
-- REPORT 1: TOTAL ENERGY CONSUMPTION
-- ============================================================

SELECT
    SUM(electricity_consumed) AS total_electricity_consumed
FROM fact_energy;


-- ============================================================
-- REPORT 2: AVERAGE ENERGY CONSUMPTION
-- ============================================================

SELECT
    AVG(electricity_consumed) AS average_electricity_consumed
FROM fact_energy;


-- ============================================================
-- REPORT 3: MINIMUM AND MAXIMUM ENERGY CONSUMPTION
-- ============================================================

SELECT
    MIN(electricity_consumed) AS minimum_consumption,
    MAX(electricity_consumed) AS maximum_consumption
FROM fact_energy;


-- ============================================================
-- REPORT 4: TOTAL NUMBER OF ENERGY READINGS
-- ============================================================

SELECT
    COUNT(*) AS total_readings
FROM fact_energy;


-- ============================================================
-- REPORT 5: ENERGY CONSUMPTION BY DATE
-- ============================================================

SELECT
    DATE("fact_energy.Timestamp") AS reading_date,
    COUNT(*) AS number_of_readings,
    SUM(electricity_consumed) AS total_energy,
    AVG(electricity_consumed) AS average_energy
FROM fact_energy
GROUP BY DATE(date_key)
ORDER BY reading_date;


-- ============================================================
-- REPORT 6: HOURLY ENERGY CONSUMPTION
-- ============================================================

SELECT
    EXTRACT(HOUR FROM date_key)::INTEGER AS hour,
    COUNT(*) AS number_of_readings,
    SUM(electricity_consumed) AS total_energy,
    AVG(electricity_consumed) AS average_energy
FROM fact_energy
GROUP BY EXTRACT(HOUR FROM date_key)
ORDER BY hour;


-- ============================================================
-- REPORT 7: ENERGY CONSUMPTION BY MONTH
-- ============================================================

SELECT
    DATE_TRUNC('month', date_key)::DATE AS month,
    COUNT(*) AS number_of_readings,
    SUM(electricity_consumed) AS total_energy,
    AVG(electricity_consumed) AS average_energy
FROM fact_energy
GROUP BY DATE_TRUNC('month', date_key)
ORDER BY month;


-- ============================================================
-- REPORT 8: ANOMALY ANALYSIS
-- ============================================================

SELECT
    anomaly_label,
    COUNT(*) AS reading_count
FROM fact_energy
GROUP BY anomaly_label
ORDER BY reading_count DESC;


-- ============================================================
-- REPORT 9: ENERGY CONSUMPTION BY ANOMALY TYPE
-- ============================================================

SELECT
    anomaly_label,
    COUNT(*) AS number_of_readings,
    SUM(electricity_consumed) AS total_energy,
    AVG(electricity_consumed) AS average_energy,
    MIN(electricity_consumed) AS minimum_energy,
    MAX(electricity_consumed) AS maximum_energy
FROM fact_energy
GROUP BY anomaly_label
ORDER BY total_energy DESC;


-- ============================================================
-- REPORT 10: AVERAGE TEMPERATURE AND HUMIDITY
-- ============================================================

SELECT
    AVG(temperature) AS average_temperature,
    AVG(humidity) AS average_humidity
FROM fact_energy;


-- ============================================================
-- REPORT 11: WEATHER / SENSOR ANALYSIS
-- ============================================================

SELECT
    ROUND(AVG(temperature), 2) AS average_temperature,
    ROUND(MIN(temperature), 2) AS minimum_temperature,
    ROUND(MAX(temperature), 2) AS maximum_temperature,
    ROUND(AVG(humidity), 2) AS average_humidity,
    ROUND(MIN(humidity), 2) AS minimum_humidity,
    ROUND(MAX(humidity), 2) AS maximum_humidity,
    ROUND(AVG(wind_speed), 2) AS average_wind_speed
FROM fact_energy;


-- ============================================================
-- REPORT 12: HIGH ENERGY CONSUMPTION READINGS
-- Readings above the overall average
-- ============================================================

SELECT
    date_key,
    electricity_consumed,
    temperature,
    humidity,
    wind_speed,
    anomaly_label
FROM fact_energy
WHERE electricity_consumed > (
    SELECT AVG(electricity_consumed)
    FROM fact_energy
)
ORDER BY electricity_consumed DESC;


-- ============================================================
-- REPORT 13: TOP 10 HIGHEST ENERGY CONSUMPTION READINGS
-- ============================================================

SELECT
    date_key,
    electricity_consumed,
    temperature,
    humidity,
    wind_speed,
    anomaly_label
FROM fact_energy
ORDER BY electricity_consumed DESC
LIMIT 10;


-- ============================================================
-- REPORT 14: TOP 10 LOWEST ENERGY CONSUMPTION READINGS
-- ============================================================

SELECT
    date_key,
    electricity_consumed,
    temperature,
    humidity,
    wind_speed,
    anomaly_label
FROM fact_energy
ORDER BY electricity_consumed ASC
LIMIT 10;


-- ============================================================
-- REPORT 15: DAILY ANOMALY COUNT
-- ============================================================

SELECT
    DATE(date_key) AS reading_date,
    anomaly_label,
    COUNT(*) AS anomaly_count
FROM fact_energy
GROUP BY DATE(date_key), anomaly_label
ORDER BY reading_date, anomaly_count DESC;


-- ============================================================
-- REPORT 16: DAILY ENERGY AND SENSOR SUMMARY
-- ============================================================

SELECT
    DATE(date_key) AS reading_date,
    COUNT(*) AS readings,
    ROUND(SUM(electricity_consumed), 2) AS total_energy,
    ROUND(AVG(electricity_consumed), 2) AS average_energy,
    ROUND(AVG(temperature), 2) AS average_temperature,
    ROUND(AVG(humidity), 2) AS average_humidity,
    ROUND(AVG(wind_speed), 2) AS average_wind_speed
FROM fact_energy
GROUP BY DATE(date_key)
ORDER BY reading_date;


-- ============================================================
-- REPORT 17: ENERGY CONSUMPTION BY HOUR AND ANOMALY
-- ============================================================

SELECT
    EXTRACT(HOUR FROM date_key)::INTEGER AS hour,
    anomaly_label,
    COUNT(*) AS readings,
    ROUND(SUM(electricity_consumed), 2) AS total_energy,
    ROUND(AVG(electricity_consumed), 2) AS average_energy
FROM fact_energy
GROUP BY
    EXTRACT(HOUR FROM date_key),
    anomaly_label
ORDER BY hour, anomaly_label;


-- ============================================================
-- REPORT 18: COMPARE CURRENT VS AVERAGE PAST CONSUMPTION
-- ============================================================

SELECT
    date_key,
    electricity_consumed,
    avg_past_consumption,
    ROUND(
        electricity_consumed - avg_past_consumption,
        2
    ) AS consumption_difference,
    anomaly_label
FROM fact_energy
ORDER BY date_key;


-- ============================================================
-- REPORT 19: READINGS WHERE CURRENT CONSUMPTION
-- IS GREATER THAN PAST AVERAGE
-- ============================================================

SELECT
    date_key,
    electricity_consumed,
    avg_past_consumption,
    ROUND(
        electricity_consumed - avg_past_consumption,
        2
    ) AS increase,
    anomaly_label
FROM fact_energy
WHERE electricity_consumed > avg_past_consumption
ORDER BY increase DESC;


-- ============================================================
-- REPORT 20: COMPLETE FACT TABLE SUMMARY
-- ============================================================

SELECT
    COUNT(*) AS total_readings,
    ROUND(SUM(electricity_consumed), 2) AS total_energy,
    ROUND(AVG(electricity_consumed), 2) AS average_energy,
    ROUND(MIN(electricity_consumed), 2) AS minimum_energy,
    ROUND(MAX(electricity_consumed), 2) AS maximum_energy,
    ROUND(AVG(temperature), 2) AS average_temperature,
    ROUND(AVG(humidity), 2) AS average_humidity,
    ROUND(AVG(wind_speed), 2) AS average_wind_speed
FROM fact_energy;


-- ============================================================
-- END OF OPERATIONAL REPORTS
-- ============================================================
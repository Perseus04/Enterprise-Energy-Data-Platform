-- ============================================================
-- ENERGY DATA WAREHOUSE
-- SPRINT 2
-- STAR SCHEMA + FACT AND DIMENSION TABLES
-- ============================================================


-- ============================================================
-- 1. DIMENSION TABLE: CUSTOMER
-- ============================================================

DROP TABLE IF EXISTS dim_customer CASCADE;

CREATE TABLE dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id VARCHAR(100),
    customer_name VARCHAR(255),
    state VARCHAR(100),
    customer_type VARCHAR(100),
    residential_customers NUMERIC,
    commercial_customers NUMERIC,
    industrial_customers NUMERIC,
    transportation_customers NUMERIC,
    total_customers NUMERIC
);


-- ============================================================
-- 2. DIMENSION TABLE: ASSET
-- ============================================================

DROP TABLE IF EXISTS dim_asset CASCADE;

CREATE TABLE dim_asset (
    asset_key SERIAL PRIMARY KEY,
    asset_id VARCHAR(100),
    product_id VARCHAR(100),
    asset_type VARCHAR(100),
    failure_target VARCHAR(100),
    failure_type VARCHAR(255)
);


-- ============================================================
-- 3. DIMENSION TABLE: GRID
-- ============================================================

DROP TABLE IF EXISTS dim_grid CASCADE;

CREATE TABLE dim_grid (
    grid_key SERIAL PRIMARY KEY,
    grid_segment_id VARCHAR(100)
);


-- ============================================================
-- 4. DIMENSION TABLE: DATE
-- ============================================================

DROP TABLE IF EXISTS dim_date CASCADE;

CREATE TABLE dim_date (
    date_key SERIAL PRIMARY KEY,
    full_date DATE UNIQUE,
    year INTEGER,
    quarter INTEGER,
    month INTEGER,
    month_name VARCHAR(20),
    day INTEGER,
    day_name VARCHAR(20)
);


-- ============================================================
-- 5. FACT TABLE: ENERGY
-- ============================================================

DROP TABLE IF EXISTS fact_energy CASCADE;

CREATE TABLE fact_energy (
    energy_key SERIAL PRIMARY KEY,

    date_key TIMESTAMP NOT NULL,

    energy_consumed NUMERIC(18,2),
    temperature NUMERIC(10,2),
    humidity NUMERIC(10,2),
    wind_speed NUMERIC(10,2),
    avg_past_consumption NUMERIC(18,2),
    anomaly_label VARCHAR(50)
);


-- ============================================================
-- STAR SCHEMA
--
--                  dim_date
--                     |
--                     |
-- dim_customer -- fact_energy -- dim_asset
--                     |
--                     |
--                  dim_grid
--
-- ============================================================


-- ============================================================
-- END OF SPRINT 2 STAR SCHEMA
-- ============================================================
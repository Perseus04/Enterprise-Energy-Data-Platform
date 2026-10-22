CREATE TABLE IF NOT EXISTS real_time_energy_readings (
    event_id UUID PRIMARY KEY,
    meter_id VARCHAR(50) NOT NULL,
    voltage NUMERIC(10, 2) NOT NULL,
    frequency NUMERIC(6, 3) NOT NULL,
    power_kw NUMERIC(12, 3) NOT NULL,
    energy_kwh NUMERIC(12, 4) NOT NULL,
    signal_strength INTEGER,
    event_timestamp TIMESTAMPTZ NOT NULL,
    ingested_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_energy_meter_timestamp
ON real_time_energy_readings (meter_id, event_timestamp);

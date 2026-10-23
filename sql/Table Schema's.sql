CREATE TABLE "public".Smart_meter
(
  "Timestamp" TIMESTAMP
, Electricity_Consumed NUMERIC(36, 17)
, Temperature NUMERIC(36, 17)
, Humidity NUMERIC(36, 17)
, Wind_Speed NUMERIC(36, 17)
, Avg_Past_Consumption NUMERIC(36, 17)
, Anomaly_Label VARCHAR(8)
)
;

CREATE TABLE "public".scada_pipeline
(
  "timestamp" VARCHAR(16)
, segment_id BIGINT
, pressure NUMERIC(8, 2)
, flow_rate NUMERIC(6, 2)
, temperature NUMERIC(7, 2)
, valve_status BIGINT
, pump_state BIGINT
, pump_speed NUMERIC(7, 1)
, compressor_state BIGINT
, energy_consumption NUMERIC(7, 2)
, alarm_triggered BIGINT
, event_type VARCHAR(11)
, target BIGINT
)
;

CREATE TABLE "public".omsdata
(
  "Event Description" VARCHAR(100)
, "Year" BIGINT
, "Date Event Began" TEXT
, "Date of Restoration" TIMESTAMP
, "Time of Restoration" VARCHAR(8)
, Respondent VARCHAR(55)
, "Geographic Areas" VARCHAR(42)
, "NERC Region" VARCHAR(5)
, "Number of Customers Affected" VARCHAR(9)
, Tags VARCHAR(34)
)
;

CREATE TABLE "public".iotsmartgrid
(
  "Timestamp" TIMESTAMP
, Power_Consumption_kWh NUMERIC(34, 16)
, Voltage_V NUMERIC(32, 14)
, Current_A NUMERIC(34, 16)
, Power_Factor NUMERIC(34, 16)
, Grid_Frequency_Hz NUMERIC(33, 15)
, Reactive_Power_kVAR NUMERIC(36, 17)
, Active_Power_kW NUMERIC(34, 16)
, Demand_Response_Event BIGINT
, Temperature_C NUMERIC(36, 17)
, "Humidity_%" NUMERIC(33, 15)
, Weather_Condition VARCHAR(6)
, Solar_Power_Generation_kW NUMERIC(38, 18)
, Wind_Power_Generation_kW NUMERIC(36, 17)
, Previous_Day_Consumption_kWh NUMERIC(34, 16)
, Peak_Load_Hour BIGINT
, Energy_Source_Type BIGINT
, User_Type BIGINT
, Normalized_Consumption NUMERIC(40, 19)
, Energy_Efficiency_Score NUMERIC(33, 15)
)
;

CREATE TABLE "public".billing_payment
(
  "Utility.Number" BIGINT
, "Utility.Name" VARCHAR(37)
, "Utility.State" VARCHAR(2)
, "Utility.Type" VARCHAR(21)
, "Demand.Summer Peak" NUMERIC(8, 1)
, "Demand.Winter Peak" NUMERIC(8, 1)
, "Sources.Generation" NUMERIC(11, 1)
, "Sources.Purchased" NUMERIC(11, 1)
, "Sources.Other" NUMERIC(9, 1)
, "Sources.Total" NUMERIC(11, 1)
, "Uses.Retail" NUMERIC(11, 1)
, "Uses.Resale" NUMERIC(10, 1)
, "Uses.No Charge" NUMERIC(7, 1)
, "Uses.Consumed" NUMERIC(9, 1)
, "Uses.Losses" NUMERIC(10, 1)
, "Uses.Total" NUMERIC(11, 1)
, "Revenues.Retail" NUMERIC(10, 1)
, "Revenue.Delivery" NUMERIC(7, 1)
, "Revenue.Resale" NUMERIC(9, 1)
, "Revenue.Adjustments" NUMERIC(9, 1)
, "Revenue.Transmission" NUMERIC(9, 1)
, "Revenue.Other" NUMERIC(9, 1)
, "Revenue.Total" NUMERIC(10, 1)
, "Retail.Residential.Revenue" NUMERIC(30, 12)
, "Retail.Residential.Sales" NUMERIC(11, 1)
, "Retail.Residential.Customers" NUMERIC(10, 1)
, "Retail.Commercial.Revenue" NUMERIC(29, 12)
, "Retail.Commercial.Sales" NUMERIC(11, 1)
, "Retail.Commercial.Customers" NUMERIC(9, 1)
, "Retail.Industrial.Revenue" NUMERIC(29, 11)
, "Retail.Industrial.Sales" NUMERIC(11, 1)
, "Retail.Industrial.Customers" NUMERIC(8, 1)
, "Retail.Transportation.Revenue" NUMERIC(5, 1)
, "Retail.Transportation.Sales" NUMERIC(6, 1)
, "Retail.Transportation.Customers" NUMERIC(4, 1)
, "Retail.Total.Revenue" NUMERIC(10, 1)
, "Retail.Total.Sales" NUMERIC(11, 1)
, "Retail.Total.Customers" NUMERIC(10, 1)
)
;

CREATE TABLE "public".assetmaintainence
(
  ï»¿UDI BIGINT
, "Product ID" VARCHAR(6)
, "Type" VARCHAR(1)
, "Air temperature [K]" NUMERIC(6, 1)
, "Process temperature [K]" NUMERIC(6, 1)
, "Rotational speed [rpm]" BIGINT
, "Torque [Nm]" NUMERIC(5, 1)
, "Tool wear [min]" BIGINT
, Target BIGINT
, "Failure Type" VARCHAR(17)
)
;

CREATE TABLE "public".renewableenergydata
(
  country TEXT
, "year" DOUBLE PRECISION
, iso_code TEXT
, population TEXT
, gdp TEXT
, biofuel_cons_change_pct TEXT
, biofuel_cons_change_twh TEXT
, biofuel_cons_per_capita TEXT
, biofuel_consumption TEXT
, biofuel_elec_per_capita TEXT
, biofuel_electricity DOUBLE PRECISION
, biofuel_share_elec DOUBLE PRECISION
, biofuel_share_energy TEXT
, carbon_intensity_elec DOUBLE PRECISION
, coal_cons_change_pct TEXT
, coal_cons_change_twh TEXT
, coal_cons_per_capita TEXT
, coal_consumption TEXT
, coal_elec_per_capita TEXT
, coal_electricity DOUBLE PRECISION
, coal_prod_change_pct TEXT
, coal_prod_change_twh TEXT
, coal_prod_per_capita TEXT
, coal_production TEXT
, coal_share_elec DOUBLE PRECISION
, coal_share_energy TEXT
, electricity_demand DOUBLE PRECISION
, electricity_demand_per_capita TEXT
, electricity_generation DOUBLE PRECISION
, electricity_share_energy TEXT
, energy_cons_change_pct TEXT
, energy_cons_change_twh TEXT
, energy_per_capita TEXT
, energy_per_gdp TEXT
, fossil_cons_change_pct TEXT
, fossil_cons_change_twh TEXT
, fossil_elec_per_capita TEXT
, fossil_electricity DOUBLE PRECISION
, fossil_energy_per_capita TEXT
, fossil_fuel_consumption TEXT
, fossil_share_elec DOUBLE PRECISION
, fossil_share_energy TEXT
, gas_cons_change_pct TEXT
, gas_cons_change_twh TEXT
, gas_consumption TEXT
, gas_elec_per_capita TEXT
, gas_electricity DOUBLE PRECISION
, gas_energy_per_capita TEXT
, gas_prod_change_pct TEXT
, gas_prod_change_twh TEXT
, gas_prod_per_capita TEXT
, gas_production TEXT
, gas_share_elec DOUBLE PRECISION
, gas_share_energy TEXT
, greenhouse_gas_emissions DOUBLE PRECISION
, hydro_cons_change_pct TEXT
, hydro_cons_change_twh TEXT
, hydro_consumption TEXT
, hydro_elec_per_capita TEXT
, hydro_electricity DOUBLE PRECISION
, hydro_energy_per_capita TEXT
, hydro_share_elec DOUBLE PRECISION
, hydro_share_energy TEXT
, low_carbon_cons_change_pct TEXT
, low_carbon_cons_change_twh TEXT
, low_carbon_consumption TEXT
, low_carbon_elec_per_capita TEXT
, low_carbon_electricity DOUBLE PRECISION
, low_carbon_energy_per_capita TEXT
, low_carbon_share_elec DOUBLE PRECISION
, low_carbon_share_energy TEXT
, net_elec_imports TEXT
, net_elec_imports_share_demand TEXT
, nuclear_cons_change_pct TEXT
, nuclear_cons_change_twh TEXT
, nuclear_consumption TEXT
, nuclear_elec_per_capita TEXT
, nuclear_electricity DOUBLE PRECISION
, nuclear_energy_per_capita TEXT
, nuclear_share_elec DOUBLE PRECISION
, nuclear_share_energy TEXT
, oil_cons_change_pct TEXT
, oil_cons_change_twh TEXT
, oil_consumption TEXT
, oil_elec_per_capita TEXT
, oil_electricity DOUBLE PRECISION
, oil_energy_per_capita TEXT
, oil_prod_change_pct TEXT
, oil_prod_change_twh TEXT
, oil_prod_per_capita TEXT
, oil_production TEXT
, oil_share_elec DOUBLE PRECISION
, oil_share_energy TEXT
, other_renewable_consumption TEXT
, other_renewable_electricity DOUBLE PRECISION
, other_renewable_exc_biofuel_electricity DOUBLE PRECISION
, other_renewables_cons_change_pct TEXT
, other_renewables_cons_change_twh TEXT
, other_renewables_elec_per_capita TEXT
, other_renewables_elec_per_capita_exc_biofuel TEXT
, other_renewables_energy_per_capita TEXT
, other_renewables_share_elec DOUBLE PRECISION
, other_renewables_share_elec_exc_biofuel DOUBLE PRECISION
, other_renewables_share_energy TEXT
, per_capita_electricity TEXT
, primary_energy_consumption TEXT
, renewables_cons_change_pct TEXT
, renewables_cons_change_twh TEXT
, renewables_consumption TEXT
, renewables_elec_per_capita TEXT
, renewables_electricity DOUBLE PRECISION
, renewables_energy_per_capita TEXT
, renewables_share_elec DOUBLE PRECISION
, renewables_share_energy TEXT
, solar_cons_change_pct TEXT
, solar_cons_change_twh TEXT
, solar_consumption TEXT
, solar_elec_per_capita TEXT
, solar_electricity DOUBLE PRECISION
, solar_energy_per_capita TEXT
, solar_share_elec DOUBLE PRECISION
, solar_share_energy TEXT
, wind_cons_change_pct TEXT
, wind_cons_change_twh TEXT
, wind_consumption TEXT
, wind_elec_per_capita TEXT
, wind_electricity DOUBLE PRECISION
, wind_energy_per_capita TEXT
, wind_share_elec DOUBLE PRECISION
, wind_share_energy TEXT
)
;

CREATE TABLE "public".energymanagementdata
(
  "year" TEXT
, biofuel_electricity TEXT
, biofuel_share_elec TEXT
, carbon_intensity_elec TEXT
, coal_electricity TEXT
, coal_share_elec TEXT
, electricity_demand TEXT
, electricity_generation TEXT
, fossil_electricity TEXT
, fossil_share_elec TEXT
, gas_electricity TEXT
, gas_share_elec TEXT
, greenhouse_gas_emissions TEXT
, hydro_electricity TEXT
, hydro_share_elec TEXT
, low_carbon_electricity TEXT
, low_carbon_share_elec TEXT
, nuclear_electricity TEXT
, nuclear_share_elec TEXT
, oil_electricity TEXT
, oil_share_elec TEXT
, other_renewable_electricity TEXT
, other_renewable_exc_biofuel_electricity TEXT
, other_renewables_share_elec TEXT
, other_renewables_share_elec_exc_biofuel TEXT
, renewables_electricity TEXT
, renewables_share_elec TEXT
, solar_electricity TEXT
, solar_share_elec TEXT
, wind_electricity TEXT
, wind_share_elec TEXT
, year_1 TEXT
, population TEXT
, coal_prod_per_capita TEXT
, coal_production TEXT
, gas_prod_per_capita TEXT
, gas_production TEXT
, coal_prod_change_twh TEXT
, gas_prod_change_twh TEXT
, gdp TEXT
, coal_prod_change_pct TEXT
, gas_prod_change_pct TEXT
)
;

CREATE TABLE "public".CISData
(
  xml_data_type_description VARCHAR(25)
, xml_element_id BIGINT
, xml_parent_element_id BIGINT
, xml_element_level BIGINT
, xml_path VARCHAR(1024)
, xml_parent_path VARCHAR(1024)
, xml_data_name VARCHAR(1024)
, xml_data_value VARCHAR(1024)
)
;


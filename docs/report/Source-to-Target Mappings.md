# Enterprise Energy Data Platform — Source-to-Target Mapping Document

**Document version:** 1.0  
**Prepared from:** the uploaded repository ZIP, including `datasets/`, `pentaho/transformations/`, `pentaho/jobs/`, and `sql/Table Schema's.sql`.  
**Mapping status:** This document distinguishes mappings explicitly configured in the current Pentaho files from downstream designs that are not implemented in the ZIP.

## 1. Purpose and scope

This document records how the supplied source files are read and mapped into PostgreSQL tables by the Pentaho Data Integration transformations currently present in the repository. It includes the source file, configured input step, source fields, target table/columns, configured transformations, load behavior, and known schema or data-quality gaps.

**Important scope finding:** the current repository implements direct source-to-PostgreSQL table loads. It does **not** yet contain populated Silver staging/curated tables or a defined Gold star schema with fact/dimension targets. The `bronze/`, `silver/transformations/`, `gold/`, `lineage/`, `metadata/`, and `sql/` directories mostly contain placeholders or notebooks rather than a complete downstream ETL chain. Therefore, mappings to Silver and Gold are not represented as implemented mappings here.

## 2. Current end-to-end lineage

```text
Source files in datasets/
  ├─ CSV: smart_meter_data.csv ────────────────> Pentaho Smart Meter.ktr ───────────────> public.Smart_meter
  ├─ CSV: scada_pipeline.csv ──────────────────> Pentaho Scada Pipeline.ktr ────────────> public.scada_pipeline
  ├─ CSV: OMS_data.csv ────────────────────────> Pentaho OMS Data.ktr ─────────────────> public.omsdata
  ├─ CSV: iiot_smart_grid_dataset.csv ─────────> Pentaho IoT Smart Grid.ktr ────────────> public.iotsmartgrid
  ├─ CSV: Billing_payments.csv ────────────────> Pentaho Billing.ktr ──────────────────> public.billing_payment
  ├─ CSV: asset_maintenance.csv ───────────────> Pentaho Asset.ktr ────────────────────> public.assetmaintainence
  ├─ XML: CIS.xml ─────────────────────────────> Pentaho Customer.ktr ─────────────────> public.CISData
  ├─ XLSX: Renewable Energy monitoring.xlsx ──> Pentaho Renewable Energy Monitoring.ktr -> public.renewableenergydata
  └─ JSON: owid-energy-data.json ──────────────> Pentaho Energy Management System.ktr ─> public.energymanagementdata
```

Each `TableOutput` step is configured with `truncate=Y`; this indicates a full-refresh load (target rows are removed before the new batch is written), not an incremental/upsert load. The target database connection name in the transformations is `DE`, schema `public`.

## 3. Source inventory

| Source file | Source format | Observed source size | Configured target | Pentaho transformation |
|---|---|---:|---|---|
| smart_meter_data.csv | CSV | 5,000 rows × 7 columns | public.Smart_meter | Smart Meter.ktr |
| scada_pipeline.csv | CSV | 1,000 rows × 13 columns | public.scada_pipeline | Scada Pipeline.ktr |
| OMS_data.csv | CSV | 1,652 rows × 12 columns | public.omsdata | OMS Data.ktr |
| iiot_smart_grid_dataset.csv | CSV | 8,737 rows × 20 columns | public.iotsmartgrid | IoT Smart Grid.ktr |
| Billing_payments.csv | CSV | 3,174 rows × 38 columns | public.billing_payment | Billing.ktr |
| asset_maintenance.csv | CSV | 10,000 rows × 10 columns | public.assetmaintainence | Asset.ktr |
| CIS.xml | XML | XML hierarchy; no flat row/column count | public.CISData | Customer.ktr |
| Renewable Energy monitoring.xlsx | Excel (sheet `data`) | 23,377 rows × 130 columns | public.renewableenergydata | Renewable Energy Monitoring.ktr |
| owid-energy-data.json | JSON | JSON input; Pentaho extracts 42 configured paths | public.energymanagementdata | Energy Management System.ktr |

**Dataset size note:** CSV and workbook dimensions above were measured directly from the uploaded files. The OWID JSON is a nested/column-oriented JSON structure and is not safely represented as a simple row × column CSV shape; the Pentaho JSON Input step is configured to extract 42 named fields using JSONPath. `CIS.xml` is ingested as XML stream metadata, not as a conventional relational customer record layout.

## 4. Field-level source-to-target mappings

Mappings below follow the actual field lists in the individual `.ktr` files. Where source and target names are identical, Pentaho maps the stream field to a same-named PostgreSQL column; no rename is implied unless stated.

### 4.1 asset_maintenance.csv → `public.assetmaintainence`

- **Transformation:** `pentaho/transformations/Asset.ktr`
- **Input step:** `CsvInput`
- **Load mode:** full refresh (`truncate=Y`)
- **Configured non-logging transformation steps:** none; direct field pass-through

| Source field / JSONPath | Source type or interpretation | Target column | Mapping rule |
|---|---|---|---|
| `UDI` in CSV header (UTF-8 BOM is present) | Integer identifier; BOM/header handling needs verification | `ï»¿UDI` | Configured as `ï»¿UDI`; likely BOM-related column-name mismatch |
| `Product ID` | object | `Product ID` | Direct pass-through; same name |
| `Type` | object | `Type` | Direct pass-through; same name |
| `Air temperature [K]` | float64 | `Air temperature [K]` | Direct pass-through; same name |
| `Process temperature [K]` | float64 | `Process temperature [K]` | Direct pass-through; same name |
| `Rotational speed [rpm]` | int64 | `Rotational speed [rpm]` | Direct pass-through; same name |
| `Torque [Nm]` | float64 | `Torque [Nm]` | Direct pass-through; same name |
| `Tool wear [min]` | int64 | `Tool wear [min]` | Direct pass-through; same name |
| `Target` | int64 | `Target` | Direct pass-through; same name |
| `Failure Type` | object | `Failure Type` | Direct pass-through; same name |

### 4.2 Billing_payments.csv → `public.billing_payment`

- **Transformation:** `pentaho/transformations/Billing.ktr`
- **Input step:** `CsvInput`
- **Load mode:** full refresh (`truncate=Y`)
- **Configured non-logging transformation steps:** none; direct field pass-through

| Source field / JSONPath | Source type or interpretation | Target column | Mapping rule |
|---|---|---|---|
| `Utility.Number` | int64 | `Utility.Number` | Direct pass-through; same name |
| `Utility.Name` | object | `Utility.Name` | Direct pass-through; same name |
| `Utility.State` | object | `Utility.State` | Direct pass-through; same name |
| `Utility.Type` | object | `Utility.Type` | Direct pass-through; same name |
| `Demand.Summer Peak` | float64 | `Demand.Summer Peak` | Direct pass-through; same name |
| `Demand.Winter Peak` | float64 | `Demand.Winter Peak` | Direct pass-through; same name |
| `Sources.Generation` | float64 | `Sources.Generation` | Direct pass-through; same name |
| `Sources.Purchased` | float64 | `Sources.Purchased` | Direct pass-through; same name |
| `Sources.Other` | float64 | `Sources.Other` | Direct pass-through; same name |
| `Sources.Total` | float64 | `Sources.Total` | Direct pass-through; same name |
| `Uses.Retail` | float64 | `Uses.Retail` | Direct pass-through; same name |
| `Uses.Resale` | float64 | `Uses.Resale` | Direct pass-through; same name |
| `Uses.No Charge` | float64 | `Uses.No Charge` | Direct pass-through; same name |
| `Uses.Consumed` | float64 | `Uses.Consumed` | Direct pass-through; same name |
| `Uses.Losses` | float64 | `Uses.Losses` | Direct pass-through; same name |
| `Uses.Total` | float64 | `Uses.Total` | Direct pass-through; same name |
| `Revenues.Retail` | float64 | `Revenues.Retail` | Direct pass-through; same name |
| `Revenue.Delivery` | float64 | `Revenue.Delivery` | Direct pass-through; same name |
| `Revenue.Resale` | float64 | `Revenue.Resale` | Direct pass-through; same name |
| `Revenue.Adjustments` | float64 | `Revenue.Adjustments` | Direct pass-through; same name |
| `Revenue.Transmission` | float64 | `Revenue.Transmission` | Direct pass-through; same name |
| `Revenue.Other` | float64 | `Revenue.Other` | Direct pass-through; same name |
| `Revenue.Total` | float64 | `Revenue.Total` | Direct pass-through; same name |
| `Retail.Residential.Revenue` | float64 | `Retail.Residential.Revenue` | Direct pass-through; same name |
| `Retail.Residential.Sales` | float64 | `Retail.Residential.Sales` | Direct pass-through; same name |
| `Retail.Residential.Customers` | float64 | `Retail.Residential.Customers` | Direct pass-through; same name |
| `Retail.Commercial.Revenue` | float64 | `Retail.Commercial.Revenue` | Direct pass-through; same name |
| `Retail.Commercial.Sales` | float64 | `Retail.Commercial.Sales` | Direct pass-through; same name |
| `Retail.Commercial.Customers` | float64 | `Retail.Commercial.Customers` | Direct pass-through; same name |
| `Retail.Industrial.Revenue` | float64 | `Retail.Industrial.Revenue` | Direct pass-through; same name |
| `Retail.Industrial.Sales` | float64 | `Retail.Industrial.Sales` | Direct pass-through; same name |
| `Retail.Industrial.Customers` | float64 | `Retail.Industrial.Customers` | Direct pass-through; same name |
| `Retail.Transportation.Revenue` | float64 | `Retail.Transportation.Revenue` | Direct pass-through; same name |
| `Retail.Transportation.Sales` | float64 | `Retail.Transportation.Sales` | Direct pass-through; same name |
| `Retail.Transportation.Customers` | float64 | `Retail.Transportation.Customers` | Direct pass-through; same name |
| `Retail.Total.Revenue` | float64 | `Retail.Total.Revenue` | Direct pass-through; same name |
| `Retail.Total.Sales` | float64 | `Retail.Total.Sales` | Direct pass-through; same name |
| `Retail.Total.Customers` | float64 | `Retail.Total.Customers` | Direct pass-through; same name |

### 4.3 CIS.xml → `public.CISData`

- **Transformation:** `pentaho/transformations/Customer.ktr`
- **Input step:** `XMLInputStream`
- **Load mode:** full refresh (`truncate=Y`)
- **Configured non-logging transformation steps:** none; direct field pass-through
- **XML handling:** XML is parsed into structural metadata/value fields. These are not business-level customer attributes; the target is a generic XML element representation.

| Source field / JSONPath | Source type or interpretation | Target column | Mapping rule |
|---|---|---|---|
| `xml_data_type_description` | XML stream metadata/value | `xml_data_type_description` | Direct pass-through; same name |
| `xml_element_id` | XML stream metadata/value | `xml_element_id` | Direct pass-through; same name |
| `xml_parent_element_id` | XML stream metadata/value | `xml_parent_element_id` | Direct pass-through; same name |
| `xml_element_level` | XML stream metadata/value | `xml_element_level` | Direct pass-through; same name |
| `xml_path` | XML stream metadata/value | `xml_path` | Direct pass-through; same name |
| `xml_parent_path` | XML stream metadata/value | `xml_parent_path` | Direct pass-through; same name |
| `xml_data_name` | XML stream metadata/value | `xml_data_name` | Direct pass-through; same name |
| `xml_data_value` | XML stream metadata/value | `xml_data_value` | Direct pass-through; same name |

### 4.4 owid-energy-data.json → `public.energymanagementdata`

- **Transformation:** `pentaho/transformations/Energy Management System.ktr`
- **Input step:** `JsonInput`
- **Load mode:** full refresh (`truncate=Y`)
- **Configured non-logging transformation steps:** none; direct field pass-through
- **JSON extraction:** each field uses the JSONPath shown in the mapping table.

| Source field / JSONPath | Source type or interpretation | Target column | Mapping rule |
|---|---|---|---|
| `year` (`$..[*].year`) | JSON value (Pentaho field type is `None`; implicit conversion) | `year` | Direct pass-through; same name |
| `biofuel_electricity` (`$..[*].biofuel_electricity`) | JSON value (Pentaho field type is `None`; implicit conversion) | `biofuel_electricity` | Direct pass-through; same name |
| `biofuel_share_elec` (`$..[*].biofuel_share_elec`) | JSON value (Pentaho field type is `None`; implicit conversion) | `biofuel_share_elec` | Direct pass-through; same name |
| `carbon_intensity_elec` (`$..[*].carbon_intensity_elec`) | JSON value (Pentaho field type is `None`; implicit conversion) | `carbon_intensity_elec` | Direct pass-through; same name |
| `coal_electricity` (`$..[*].coal_electricity`) | JSON value (Pentaho field type is `None`; implicit conversion) | `coal_electricity` | Direct pass-through; same name |
| `coal_share_elec` (`$..[*].coal_share_elec`) | JSON value (Pentaho field type is `None`; implicit conversion) | `coal_share_elec` | Direct pass-through; same name |
| `electricity_demand` (`$..[*].electricity_demand`) | JSON value (Pentaho field type is `None`; implicit conversion) | `electricity_demand` | Direct pass-through; same name |
| `electricity_generation` (`$..[*].electricity_generation`) | JSON value (Pentaho field type is `None`; implicit conversion) | `electricity_generation` | Direct pass-through; same name |
| `fossil_electricity` (`$..[*].fossil_electricity`) | JSON value (Pentaho field type is `None`; implicit conversion) | `fossil_electricity` | Direct pass-through; same name |
| `fossil_share_elec` (`$..[*].fossil_share_elec`) | JSON value (Pentaho field type is `None`; implicit conversion) | `fossil_share_elec` | Direct pass-through; same name |
| `gas_electricity` (`$..[*].gas_electricity`) | JSON value (Pentaho field type is `None`; implicit conversion) | `gas_electricity` | Direct pass-through; same name |
| `gas_share_elec` (`$..[*].gas_share_elec`) | JSON value (Pentaho field type is `None`; implicit conversion) | `gas_share_elec` | Direct pass-through; same name |
| `greenhouse_gas_emissions` (`$..[*].greenhouse_gas_emissions`) | JSON value (Pentaho field type is `None`; implicit conversion) | `greenhouse_gas_emissions` | Direct pass-through; same name |
| `hydro_electricity` (`$..[*].hydro_electricity`) | JSON value (Pentaho field type is `None`; implicit conversion) | `hydro_electricity` | Direct pass-through; same name |
| `hydro_share_elec` (`$..[*].hydro_share_elec`) | JSON value (Pentaho field type is `None`; implicit conversion) | `hydro_share_elec` | Direct pass-through; same name |
| `low_carbon_electricity` (`$..[*].low_carbon_electricity`) | JSON value (Pentaho field type is `None`; implicit conversion) | `low_carbon_electricity` | Direct pass-through; same name |
| `low_carbon_share_elec` (`$..[*].low_carbon_share_elec`) | JSON value (Pentaho field type is `None`; implicit conversion) | `low_carbon_share_elec` | Direct pass-through; same name |
| `nuclear_electricity` (`$..[*].nuclear_electricity`) | JSON value (Pentaho field type is `None`; implicit conversion) | `nuclear_electricity` | Direct pass-through; same name |
| `nuclear_share_elec` (`$..[*].nuclear_share_elec`) | JSON value (Pentaho field type is `None`; implicit conversion) | `nuclear_share_elec` | Direct pass-through; same name |
| `oil_electricity` (`$..[*].oil_electricity`) | JSON value (Pentaho field type is `None`; implicit conversion) | `oil_electricity` | Direct pass-through; same name |
| `oil_share_elec` (`$..[*].oil_share_elec`) | JSON value (Pentaho field type is `None`; implicit conversion) | `oil_share_elec` | Direct pass-through; same name |
| `other_renewable_electricity` (`$..[*].other_renewable_electricity`) | JSON value (Pentaho field type is `None`; implicit conversion) | `other_renewable_electricity` | Direct pass-through; same name |
| `other_renewable_exc_biofuel_electricity` (`$..[*].other_renewable_exc_biofuel_electricity`) | JSON value (Pentaho field type is `None`; implicit conversion) | `other_renewable_exc_biofuel_electricity` | Direct pass-through; same name |
| `other_renewables_share_elec` (`$..[*].other_renewables_share_elec`) | JSON value (Pentaho field type is `None`; implicit conversion) | `other_renewables_share_elec` | Direct pass-through; same name |
| `other_renewables_share_elec_exc_biofuel` (`$..[*].other_renewables_share_elec_exc_biofuel`) | JSON value (Pentaho field type is `None`; implicit conversion) | `other_renewables_share_elec_exc_biofuel` | Direct pass-through; same name |
| `renewables_electricity` (`$..[*].renewables_electricity`) | JSON value (Pentaho field type is `None`; implicit conversion) | `renewables_electricity` | Direct pass-through; same name |
| `renewables_share_elec` (`$..[*].renewables_share_elec`) | JSON value (Pentaho field type is `None`; implicit conversion) | `renewables_share_elec` | Direct pass-through; same name |
| `solar_electricity` (`$..[*].solar_electricity`) | JSON value (Pentaho field type is `None`; implicit conversion) | `solar_electricity` | Direct pass-through; same name |
| `solar_share_elec` (`$..[*].solar_share_elec`) | JSON value (Pentaho field type is `None`; implicit conversion) | `solar_share_elec` | Direct pass-through; same name |
| `wind_electricity` (`$..[*].wind_electricity`) | JSON value (Pentaho field type is `None`; implicit conversion) | `wind_electricity` | Direct pass-through; same name |
| `wind_share_elec` (`$..[*].wind_share_elec`) | JSON value (Pentaho field type is `None`; implicit conversion) | `wind_share_elec` | Direct pass-through; same name |
| `year_1` | JSON value (Pentaho field type is `None`; implicit conversion) | `year_1` | Direct pass-through; same name |
| `population` (`$..[*].population`) | JSON value (Pentaho field type is `None`; implicit conversion) | `population` | Direct pass-through; same name |
| `coal_prod_per_capita` (`$..[*].coal_prod_per_capita`) | JSON value (Pentaho field type is `None`; implicit conversion) | `coal_prod_per_capita` | Direct pass-through; same name |
| `coal_production` (`$..[*].coal_production`) | JSON value (Pentaho field type is `None`; implicit conversion) | `coal_production` | Direct pass-through; same name |
| `gas_prod_per_capita` (`$..[*].gas_prod_per_capita`) | JSON value (Pentaho field type is `None`; implicit conversion) | `gas_prod_per_capita` | Direct pass-through; same name |
| `gas_production` (`$..[*].gas_production`) | JSON value (Pentaho field type is `None`; implicit conversion) | `gas_production` | Direct pass-through; same name |
| `coal_prod_change_twh` (`$..[*].coal_prod_change_twh`) | JSON value (Pentaho field type is `None`; implicit conversion) | `coal_prod_change_twh` | Direct pass-through; same name |
| `gas_prod_change_twh` (`$..[*].gas_prod_change_twh`) | JSON value (Pentaho field type is `None`; implicit conversion) | `gas_prod_change_twh` | Direct pass-through; same name |
| `gdp` (`$..[*].gdp`) | JSON value (Pentaho field type is `None`; implicit conversion) | `gdp` | Direct pass-through; same name |
| `coal_prod_change_pct` (`$..[*].coal_prod_change_pct`) | JSON value (Pentaho field type is `None`; implicit conversion) | `coal_prod_change_pct` | Direct pass-through; same name |
| `gas_prod_change_pct` (`$..[*].gas_prod_change_pct`) | JSON value (Pentaho field type is `None`; implicit conversion) | `gas_prod_change_pct` | Direct pass-through; same name |

### 4.5 iiot_smart_grid_dataset.csv → `public.iotsmartgrid`

- **Transformation:** `pentaho/transformations/IoT Smart Grid.ktr`
- **Input step:** `CsvInput`
- **Load mode:** full refresh (`truncate=Y`)
- **Configured non-logging transformation steps:** none; direct field pass-through

| Source field / JSONPath | Source type or interpretation | Target column | Mapping rule |
|---|---|---|---|
| `Timestamp` | object | `Timestamp` | Direct pass-through; same name |
| `Power_Consumption_kWh` | float64 | `Power_Consumption_kWh` | Direct pass-through; same name |
| `Voltage_V` | float64 | `Voltage_V` | Direct pass-through; same name |
| `Current_A` | float64 | `Current_A` | Direct pass-through; same name |
| `Power_Factor` | float64 | `Power_Factor` | Direct pass-through; same name |
| `Grid_Frequency_Hz` | float64 | `Grid_Frequency_Hz` | Direct pass-through; same name |
| `Reactive_Power_kVAR` | float64 | `Reactive_Power_kVAR` | Direct pass-through; same name |
| `Active_Power_kW` | float64 | `Active_Power_kW` | Direct pass-through; same name |
| `Demand_Response_Event` | int64 | `Demand_Response_Event` | Direct pass-through; same name |
| `Temperature_C` | float64 | `Temperature_C` | Direct pass-through; same name |
| `Humidity_%` | float64 | `Humidity_%` | Direct pass-through; same name |
| `Weather_Condition` | object | `Weather_Condition` | Direct pass-through; same name |
| `Solar_Power_Generation_kW` | float64 | `Solar_Power_Generation_kW` | Direct pass-through; same name |
| `Wind_Power_Generation_kW` | float64 | `Wind_Power_Generation_kW` | Direct pass-through; same name |
| `Previous_Day_Consumption_kWh` | float64 | `Previous_Day_Consumption_kWh` | Direct pass-through; same name |
| `Peak_Load_Hour` | int64 | `Peak_Load_Hour` | Direct pass-through; same name |
| `Energy_Source_Type` | int64 | `Energy_Source_Type` | Direct pass-through; same name |
| `User_Type` | int64 | `User_Type` | Direct pass-through; same name |
| `Normalized_Consumption` | float64 | `Normalized_Consumption` | Direct pass-through; same name |
| `Energy_Efficiency_Score` | float64 | `Energy_Efficiency_Score` | Direct pass-through; same name |

### 4.6 OMS_data.csv → `public.omsdata`

- **Transformation:** `pentaho/transformations/OMS Data.ktr`
- **Input step:** `CsvInput`
- **Load mode:** full refresh (`truncate=Y`)
- **Configured non-logging transformation steps:** `Null if` (NullIf), `Select values` (SelectValues)

| Source field / JSONPath | Source type or interpretation | Target column | Mapping rule |
|---|---|---|---|
| `Event Description` | object | `Event Description` | Direct pass-through; same name |
| `Year` | int64 | `Year` | Direct pass-through; same name |
| `Date Event Began` | object | `Date Event Began` | Direct pass-through; same name |
| `Date of Restoration` | object | `Date of Restoration` | Direct pass-through; same name |
| `Time of Restoration` | object | `Time of Restoration` | Direct pass-through; same name |
| `Respondent` | object | `Respondent` | Direct pass-through; same name |
| `Geographic Areas` | object | `Geographic Areas` | Direct pass-through; same name |
| `NERC Region` | object | `NERC Region` | Direct pass-through; same name |
| `Number of Customers Affected` | object | `Number of Customers Affected` | Direct pass-through; same name |
| `Tags` | object | `Tags` | Direct pass-through; same name |

### 4.7 Renewable Energy monitoring.xlsx → `public.renewableenergydata`

- **Transformation:** `pentaho/transformations/Renewable Energy Monitoring.ktr`
- **Input step:** `ExcelInput`
- **Load mode:** full refresh (`truncate=Y`)
- **Configured non-logging transformation steps:** none; direct field pass-through

| Source field / JSONPath | Source type or interpretation | Target column | Mapping rule |
|---|---|---|---|
| `country` | object | `country` | Direct pass-through; same name |
| `year` | int64 | `year` | Direct pass-through; same name |
| `iso_code` | object | `iso_code` | Direct pass-through; same name |
| `population` | float64 | `population` | Direct pass-through; same name |
| `gdp` | float64 | `gdp` | Direct pass-through; same name |
| `biofuel_cons_change_pct` | float64 | `biofuel_cons_change_pct` | Direct pass-through; same name |
| `biofuel_cons_change_twh` | float64 | `biofuel_cons_change_twh` | Direct pass-through; same name |
| `biofuel_cons_per_capita` | float64 | `biofuel_cons_per_capita` | Direct pass-through; same name |
| `biofuel_consumption` | float64 | `biofuel_consumption` | Direct pass-through; same name |
| `biofuel_elec_per_capita` | float64 | `biofuel_elec_per_capita` | Direct pass-through; same name |
| `biofuel_electricity` | float64 | `biofuel_electricity` | Direct pass-through; same name |
| `biofuel_share_elec` | float64 | `biofuel_share_elec` | Direct pass-through; same name |
| `biofuel_share_energy` | float64 | `biofuel_share_energy` | Direct pass-through; same name |
| `carbon_intensity_elec` | float64 | `carbon_intensity_elec` | Direct pass-through; same name |
| `coal_cons_change_pct` | float64 | `coal_cons_change_pct` | Direct pass-through; same name |
| `coal_cons_change_twh` | float64 | `coal_cons_change_twh` | Direct pass-through; same name |
| `coal_cons_per_capita` | float64 | `coal_cons_per_capita` | Direct pass-through; same name |
| `coal_consumption` | float64 | `coal_consumption` | Direct pass-through; same name |
| `coal_elec_per_capita` | float64 | `coal_elec_per_capita` | Direct pass-through; same name |
| `coal_electricity` | float64 | `coal_electricity` | Direct pass-through; same name |
| `coal_prod_change_pct` | float64 | `coal_prod_change_pct` | Direct pass-through; same name |
| `coal_prod_change_twh` | float64 | `coal_prod_change_twh` | Direct pass-through; same name |
| `coal_prod_per_capita` | float64 | `coal_prod_per_capita` | Direct pass-through; same name |
| `coal_production` | float64 | `coal_production` | Direct pass-through; same name |
| `coal_share_elec` | float64 | `coal_share_elec` | Direct pass-through; same name |
| `coal_share_energy` | float64 | `coal_share_energy` | Direct pass-through; same name |
| `electricity_demand` | float64 | `electricity_demand` | Direct pass-through; same name |
| `electricity_demand_per_capita` | float64 | `electricity_demand_per_capita` | Direct pass-through; same name |
| `electricity_generation` | float64 | `electricity_generation` | Direct pass-through; same name |
| `electricity_share_energy` | float64 | `electricity_share_energy` | Direct pass-through; same name |
| `energy_cons_change_pct` | float64 | `energy_cons_change_pct` | Direct pass-through; same name |
| `energy_cons_change_twh` | float64 | `energy_cons_change_twh` | Direct pass-through; same name |
| `energy_per_capita` | float64 | `energy_per_capita` | Direct pass-through; same name |
| `energy_per_gdp` | float64 | `energy_per_gdp` | Direct pass-through; same name |
| `fossil_cons_change_pct` | float64 | `fossil_cons_change_pct` | Direct pass-through; same name |
| `fossil_cons_change_twh` | float64 | `fossil_cons_change_twh` | Direct pass-through; same name |
| `fossil_elec_per_capita` | float64 | `fossil_elec_per_capita` | Direct pass-through; same name |
| `fossil_electricity` | float64 | `fossil_electricity` | Direct pass-through; same name |
| `fossil_energy_per_capita` | float64 | `fossil_energy_per_capita` | Direct pass-through; same name |
| `fossil_fuel_consumption` | float64 | `fossil_fuel_consumption` | Direct pass-through; same name |
| `fossil_share_elec` | float64 | `fossil_share_elec` | Direct pass-through; same name |
| `fossil_share_energy` | float64 | `fossil_share_energy` | Direct pass-through; same name |
| `gas_cons_change_pct` | float64 | `gas_cons_change_pct` | Direct pass-through; same name |
| `gas_cons_change_twh` | float64 | `gas_cons_change_twh` | Direct pass-through; same name |
| `gas_consumption` | float64 | `gas_consumption` | Direct pass-through; same name |
| `gas_elec_per_capita` | float64 | `gas_elec_per_capita` | Direct pass-through; same name |
| `gas_electricity` | float64 | `gas_electricity` | Direct pass-through; same name |
| `gas_energy_per_capita` | float64 | `gas_energy_per_capita` | Direct pass-through; same name |
| `gas_prod_change_pct` | float64 | `gas_prod_change_pct` | Direct pass-through; same name |
| `gas_prod_change_twh` | float64 | `gas_prod_change_twh` | Direct pass-through; same name |
| `gas_prod_per_capita` | float64 | `gas_prod_per_capita` | Direct pass-through; same name |
| `gas_production` | float64 | `gas_production` | Direct pass-through; same name |
| `gas_share_elec` | float64 | `gas_share_elec` | Direct pass-through; same name |
| `gas_share_energy` | float64 | `gas_share_energy` | Direct pass-through; same name |
| `greenhouse_gas_emissions` | float64 | `greenhouse_gas_emissions` | Direct pass-through; same name |
| `hydro_cons_change_pct` | float64 | `hydro_cons_change_pct` | Direct pass-through; same name |
| `hydro_cons_change_twh` | float64 | `hydro_cons_change_twh` | Direct pass-through; same name |
| `hydro_consumption` | float64 | `hydro_consumption` | Direct pass-through; same name |
| `hydro_elec_per_capita` | float64 | `hydro_elec_per_capita` | Direct pass-through; same name |
| `hydro_electricity` | float64 | `hydro_electricity` | Direct pass-through; same name |
| `hydro_energy_per_capita` | float64 | `hydro_energy_per_capita` | Direct pass-through; same name |
| `hydro_share_elec` | float64 | `hydro_share_elec` | Direct pass-through; same name |
| `hydro_share_energy` | float64 | `hydro_share_energy` | Direct pass-through; same name |
| `low_carbon_cons_change_pct` | float64 | `low_carbon_cons_change_pct` | Direct pass-through; same name |
| `low_carbon_cons_change_twh` | float64 | `low_carbon_cons_change_twh` | Direct pass-through; same name |
| `low_carbon_consumption` | float64 | `low_carbon_consumption` | Direct pass-through; same name |
| `low_carbon_elec_per_capita` | float64 | `low_carbon_elec_per_capita` | Direct pass-through; same name |
| `low_carbon_electricity` | float64 | `low_carbon_electricity` | Direct pass-through; same name |
| `low_carbon_energy_per_capita` | float64 | `low_carbon_energy_per_capita` | Direct pass-through; same name |
| `low_carbon_share_elec` | float64 | `low_carbon_share_elec` | Direct pass-through; same name |
| `low_carbon_share_energy` | float64 | `low_carbon_share_energy` | Direct pass-through; same name |
| `net_elec_imports` | float64 | `net_elec_imports` | Direct pass-through; same name |
| `net_elec_imports_share_demand` | float64 | `net_elec_imports_share_demand` | Direct pass-through; same name |
| `nuclear_cons_change_pct` | float64 | `nuclear_cons_change_pct` | Direct pass-through; same name |
| `nuclear_cons_change_twh` | float64 | `nuclear_cons_change_twh` | Direct pass-through; same name |
| `nuclear_consumption` | float64 | `nuclear_consumption` | Direct pass-through; same name |
| `nuclear_elec_per_capita` | float64 | `nuclear_elec_per_capita` | Direct pass-through; same name |
| `nuclear_electricity` | float64 | `nuclear_electricity` | Direct pass-through; same name |
| `nuclear_energy_per_capita` | float64 | `nuclear_energy_per_capita` | Direct pass-through; same name |
| `nuclear_share_elec` | float64 | `nuclear_share_elec` | Direct pass-through; same name |
| `nuclear_share_energy` | float64 | `nuclear_share_energy` | Direct pass-through; same name |
| `oil_cons_change_pct` | float64 | `oil_cons_change_pct` | Direct pass-through; same name |
| `oil_cons_change_twh` | float64 | `oil_cons_change_twh` | Direct pass-through; same name |
| `oil_consumption` | float64 | `oil_consumption` | Direct pass-through; same name |
| `oil_elec_per_capita` | float64 | `oil_elec_per_capita` | Direct pass-through; same name |
| `oil_electricity` | float64 | `oil_electricity` | Direct pass-through; same name |
| `oil_energy_per_capita` | float64 | `oil_energy_per_capita` | Direct pass-through; same name |
| `oil_prod_change_pct` | float64 | `oil_prod_change_pct` | Direct pass-through; same name |
| `oil_prod_change_twh` | float64 | `oil_prod_change_twh` | Direct pass-through; same name |
| `oil_prod_per_capita` | float64 | `oil_prod_per_capita` | Direct pass-through; same name |
| `oil_production` | float64 | `oil_production` | Direct pass-through; same name |
| `oil_share_elec` | float64 | `oil_share_elec` | Direct pass-through; same name |
| `oil_share_energy` | float64 | `oil_share_energy` | Direct pass-through; same name |
| `other_renewable_consumption` | float64 | `other_renewable_consumption` | Direct pass-through; same name |
| `other_renewable_electricity` | float64 | `other_renewable_electricity` | Direct pass-through; same name |
| `other_renewable_exc_biofuel_electricity` | float64 | `other_renewable_exc_biofuel_electricity` | Direct pass-through; same name |
| `other_renewables_cons_change_pct` | float64 | `other_renewables_cons_change_pct` | Direct pass-through; same name |
| `other_renewables_cons_change_twh` | float64 | `other_renewables_cons_change_twh` | Direct pass-through; same name |
| `other_renewables_elec_per_capita` | float64 | `other_renewables_elec_per_capita` | Direct pass-through; same name |
| `other_renewables_elec_per_capita_exc_biofuel` | float64 | `other_renewables_elec_per_capita_exc_biofuel` | Direct pass-through; same name |
| `other_renewables_energy_per_capita` | float64 | `other_renewables_energy_per_capita` | Direct pass-through; same name |
| `other_renewables_share_elec` | float64 | `other_renewables_share_elec` | Direct pass-through; same name |
| `other_renewables_share_elec_exc_biofuel` | float64 | `other_renewables_share_elec_exc_biofuel` | Direct pass-through; same name |
| `other_renewables_share_energy` | float64 | `other_renewables_share_energy` | Direct pass-through; same name |
| `per_capita_electricity` | float64 | `per_capita_electricity` | Direct pass-through; same name |
| `primary_energy_consumption` | float64 | `primary_energy_consumption` | Direct pass-through; same name |
| `renewables_cons_change_pct` | float64 | `renewables_cons_change_pct` | Direct pass-through; same name |
| `renewables_cons_change_twh` | float64 | `renewables_cons_change_twh` | Direct pass-through; same name |
| `renewables_consumption` | float64 | `renewables_consumption` | Direct pass-through; same name |
| `renewables_elec_per_capita` | float64 | `renewables_elec_per_capita` | Direct pass-through; same name |
| `renewables_electricity` | float64 | `renewables_electricity` | Direct pass-through; same name |
| `renewables_energy_per_capita` | float64 | `renewables_energy_per_capita` | Direct pass-through; same name |
| `renewables_share_elec` | float64 | `renewables_share_elec` | Direct pass-through; same name |
| `renewables_share_energy` | float64 | `renewables_share_energy` | Direct pass-through; same name |
| `solar_cons_change_pct` | float64 | `solar_cons_change_pct` | Direct pass-through; same name |
| `solar_cons_change_twh` | float64 | `solar_cons_change_twh` | Direct pass-through; same name |
| `solar_consumption` | float64 | `solar_consumption` | Direct pass-through; same name |
| `solar_elec_per_capita` | float64 | `solar_elec_per_capita` | Direct pass-through; same name |
| `solar_electricity` | float64 | `solar_electricity` | Direct pass-through; same name |
| `solar_energy_per_capita` | float64 | `solar_energy_per_capita` | Direct pass-through; same name |
| `solar_share_elec` | float64 | `solar_share_elec` | Direct pass-through; same name |
| `solar_share_energy` | float64 | `solar_share_energy` | Direct pass-through; same name |
| `wind_cons_change_pct` | float64 | `wind_cons_change_pct` | Direct pass-through; same name |
| `wind_cons_change_twh` | float64 | `wind_cons_change_twh` | Direct pass-through; same name |
| `wind_consumption` | float64 | `wind_consumption` | Direct pass-through; same name |
| `wind_elec_per_capita` | float64 | `wind_elec_per_capita` | Direct pass-through; same name |
| `wind_electricity` | float64 | `wind_electricity` | Direct pass-through; same name |
| `wind_energy_per_capita` | float64 | `wind_energy_per_capita` | Direct pass-through; same name |
| `wind_share_elec` | float64 | `wind_share_elec` | Direct pass-through; same name |
| `wind_share_energy` | float64 | `wind_share_energy` | Direct pass-through; same name |

### 4.8 scada_pipeline.csv → `public.scada_pipeline`

- **Transformation:** `pentaho/transformations/Scada Pipeline.ktr`
- **Input step:** `CsvInput`
- **Load mode:** full refresh (`truncate=Y`)
- **Configured non-logging transformation steps:** none; direct field pass-through

| Source field / JSONPath | Source type or interpretation | Target column | Mapping rule |
|---|---|---|---|
| `timestamp` | object | `timestamp` | Direct pass-through; same name |
| `segment_id` | int64 | `segment_id` | Direct pass-through; same name |
| `pressure` | float64 | `pressure` | Direct pass-through; same name |
| `flow_rate` | float64 | `flow_rate` | Direct pass-through; same name |
| `temperature` | float64 | `temperature` | Direct pass-through; same name |
| `valve_status` | int64 | `valve_status` | Direct pass-through; same name |
| `pump_state` | int64 | `pump_state` | Direct pass-through; same name |
| `pump_speed` | float64 | `pump_speed` | Direct pass-through; same name |
| `compressor_state` | int64 | `compressor_state` | Direct pass-through; same name |
| `energy_consumption` | float64 | `energy_consumption` | Direct pass-through; same name |
| `alarm_triggered` | int64 | `alarm_triggered` | Direct pass-through; same name |
| `event_type` | object | `event_type` | Direct pass-through; same name |
| `target` | int64 | `target` | Direct pass-through; same name |

### 4.9 smart_meter_data.csv → `public.Smart_meter`

- **Transformation:** `pentaho/transformations/Smart Meter.ktr`
- **Input step:** `CsvInput`
- **Load mode:** full refresh (`truncate=Y`)
- **Configured non-logging transformation steps:** none; direct field pass-through

| Source field / JSONPath | Source type or interpretation | Target column | Mapping rule |
|---|---|---|---|
| `Timestamp` | object | `Timestamp` | Direct pass-through; same name |
| `Electricity_Consumed` | float64 | `Electricity_Consumed` | Direct pass-through; same name |
| `Temperature` | float64 | `Temperature` | Direct pass-through; same name |
| `Humidity` | float64 | `Humidity` | Direct pass-through; same name |
| `Wind_Speed` | float64 | `Wind_Speed` | Direct pass-through; same name |
| `Avg_Past_Consumption` | float64 | `Avg_Past_Consumption` | Direct pass-through; same name |
| `Anomaly_Label` | object | `Anomaly_Label` | Direct pass-through; same name |

## 5. Detailed notes for special mappings

### 5.1 `OMS_data.csv` → `public.omsdata`

The `OMS Data.ktr` transformation includes two explicit processing steps before the table output:

1. **`Null if`**: configured to convert the literal values `Unknown`, `Ongoing`, `NA`, and `N/A` to null for restoration date/time fields (the exact configured fields are visible in the `.ktr`).
2. **`Select values`**: field metadata is selected/configured before the target output. The mapping still sends 10 fields to `public.omsdata`.

Important mismatch: the CSV has 12 fields, including `Time Event Began`, but the Pentaho output mapping has 10 fields and does not map `Time Event Began`. The SQL DDL also does not define `Time Event Began`. This field is therefore currently dropped from the PostgreSQL target.

### 5.2 `CIS.xml` → `public.CISData`

`Customer.ktr` uses `XMLInputStream` and maps eight stream fields to the same-named columns: `xml_data_type_description`, `xml_element_id`, `xml_parent_element_id`, `xml_element_level`, `xml_path`, `xml_parent_path`, `xml_data_name`, and `xml_data_value`. This is a generic XML-tree/element representation. It is not currently a normalized customer dimension (for example, it does not explicitly map a customer ID, name, service address, or account status).

**DDL gap:** `Customer.ktr` writes to `public.CISData`, but `sql/Table Schema's.sql` does not create a `CISData` table in the uploaded version. The target table must be created or the DDL updated before this load can be considered reproducible from the schema script alone.

### 5.3 `owid-energy-data.json` → `public.energymanagementdata`

The Pentaho JSON Input step extracts 42 fields with JSONPath expressions of the form `$..[*].field_name`. The table output mapping is a subset of the broader OWID energy data. It includes `year`, electricity-generation mix/share fields, demand/generation, emissions, and other energy indicators configured in the `.ktr`. Unlike the workbook target, this target is not a complete copy of every OWID field.

**Conversion risk:** JSON Input field types are configured as `None` in the `.ktr`, while the PostgreSQL DDL declares a mix of numeric and text types. Verify numeric/date conversion and null handling in an actual Pentaho run; do not assume implicit conversion has been validated.

### 5.4 `asset_maintenance.csv` → `public.assetmaintainence`

The CSV field is `UDI`, but the Pentaho mapping and DDL use `ï»¿UDI`, which appears to be a UTF-8 byte-order-mark (BOM) artifact in the column name. Confirm the actual header bytes and normalize the name to `UDI` consistently in the input step, table DDL, and target mapping. The current spelling can make SQL queries and downstream joins awkward or fail if the incoming field is exposed as `UDI` without the BOM characters.

### 5.5 `Renewable Energy monitoring.xlsx` → `public.renewableenergydata`

The `ExcelInput` step reads `Renewable Energy monitoring.xlsx` and maps 130 same-named fields from the `data` dataset into `public.renewableenergydata`. The source workbook also contains a `metadata` sheet; the transformation is configured for the data columns, not a metadata load. The field mapping is direct pass-through, with no explicit cleaning step in this transformation.

## 6. Target table mapping summary

| PostgreSQL target | Source | Mapped columns | Current key/constraint status in supplied DDL |
|---|---|---:|---|
| `public.Smart_meter` | `smart_meter_data.csv` | 7 | No primary key or unique constraint declared |
| `public.scada_pipeline` | `scada_pipeline.csv` | 13 | No primary key or unique constraint declared |
| `public.omsdata` | `OMS_data.csv` | 10 of 12 source columns | No primary key or unique constraint declared |
| `public.iotsmartgrid` | `iiot_smart_grid_dataset.csv` | 20 | No primary key or unique constraint declared |
| `public.billing_payment` | `Billing_payments.csv` | 38 | Utility number is present but not declared as a primary key |
| `public.assetmaintainence` | `asset_maintenance.csv` | 10 | UDI/BOM column naming requires correction; no primary key declared |
| `public.CISData` | `CIS.xml` | 8 XML fields | Target table is referenced by KTR but missing from supplied SQL DDL |
| `public.renewableenergydata` | `Renewable Energy monitoring.xlsx` | 130 | No primary key declared; natural key likely country + year, to validate |
| `public.energymanagementdata` | `owid-energy-data.json` | 42 | No primary key declared; country/entity identifier is not mapped in the configured 42 fields, so grain/key must be reviewed |

## 7. Data-quality and standardization logic found in the repository

- `pentaho/transformations/OMS Data.ktr` contains explicit null replacement for selected placeholder values, plus a `Select values` step.
- The other individual source-to-table transformations are largely direct input-to-table loads with a `Write to log` step; the field mappings themselves do not show explicit cleansing, deduplication, rejection routing, or business-rule validation.
- Python notebooks exist for profiling, data quality, column mapping, and standardization under `python/` and `silver/cleansing/`. They are analysis/processing code, not a demonstrated Pentaho Silver-to-Gold ETL chain. The `Standardization.ipynb` source references paths such as `DATASET_DIR = BASE / "datasets"`, while the notebook is located in a subdirectory in the repository; verify paths before execution.
- `sql/Table Schema's.sql` uses `DROP TABLE` statements before creation. These are destructive if executed against a populated database; use a controlled development database or change to guarded/idempotent DDL before reruns.
- `TableOutput` uses `truncate=Y` across targets. This means every run can erase the previous target contents before reloading, so this is not appropriate for incremental production ingestion without a deliberate full-refresh policy and transaction/recovery plan.

## 8. Current-state gaps and corrections recommended

These are findings/recommendations, not claims that the work is already implemented.

1. **Complete target DDL:** add the `public.CISData` definition or change `Customer.ktr` to an existing target. Make the DDL and KTR agree exactly.
2. **Resolve BOM mismatch:** normalize the maintenance key from `ï»¿UDI` to `UDI` end-to-end.
3. **Retain all OMS fields:** decide whether `Time Event Began` is needed; if yes, add it to `omsdata` DDL and KTR field mapping. If intentionally excluded, document the reason.
4. **Correct data types:** `iotsmartgrid.Normalized_Consumption` is declared as `VARCHAR(60)` although the source CSV field is numeric. Consider `NUMERIC` and add an explicit conversion/invalid-value policy. Validate all wide numeric types against actual source precision rather than relying on very large arbitrary precision declarations.
5. **Define keys and grain:** establish a stable key for each target, such as timestamp plus meter/device/segment identifier where available. `Smart_meter` has no meter identifier in the source, so timestamp alone may not uniquely identify a physical meter record; the dataset should be described as sample/time-series data unless a meter ID is added.
6. **Fix OWID grain:** verify the JSON layout and include the country/entity field in `energymanagementdata`. With year and indicators but no country/entity column in the mapped output, the table cannot reliably identify which geographic entity each row describes.
7. **Add ingestion audit fields:** `batch_id`, `source_file`, `ingested_at`, `record_hash`, and/or reject reason are not currently mapped. Add them if operational traceability is required.
8. **Implement Silver mappings explicitly:** write cleaned/standardized outputs to named Silver tables or files and document every transformation (types, whitespace, nulls, units, duplicates, outliers). The current notebooks do not by themselves prove that those outputs feed the PostgreSQL targets.
9. **Implement the Gold star schema:** no fact/dimension table DDL or corresponding Pentaho mappings are present in the uploaded repository. The fact/dimension source-to-target mapping remains a future Sprint deliverable, not an implemented mapping.
10. **Add reconciliation tests:** after each load, compare source row counts to inserted/rejected counts, validate null/key constraints, and check business totals (for example source generation totals, usage totals, and revenue totals) where the source definitions permit it.

## 9. Recommended next-stage mappings (proposed, not implemented)

The following is a recommended structure for Sprint 2/3. It is deliberately marked as proposed because the uploaded SQL and Pentaho files do not currently define these targets.

| Proposed target | Candidate source(s) | Grain | Candidate measures/attributes |
|---|---|---|---|
| `silver.smart_meter_clean` | `smart_meter_data.csv` | One source reading per timestamp (source has no meter ID) | consumed electricity, temperature, humidity, wind speed, average past consumption, anomaly label |
| `silver.scada_pipeline_clean` | `scada_pipeline.csv` | One row per source event/segment timestamp | pressure, flow, temperature, valve/pump/compressor state, energy consumption, alarm, target |
| `silver.oms_event_clean` | `OMS_data.csv` | One outage/event record | start/restoration date-time, utility/respondent, region, demand loss, customers affected, tags |
| `silver.iiot_reading_clean` | `iiot_smart_grid_dataset.csv` | One reading per timestamp | consumption, voltage/current, power factor, grid frequency, active/reactive power, weather, generation |
| `silver.utility_billing_clean` | `Billing_payments.csv` | One utility summary record per utility identifier and reporting period (period must be confirmed) | demand, generation/purchases, use/losses, revenue and customer counts |
| `silver.asset_maintenance_clean` | `asset_maintenance.csv` | One machine/product observation | temperature, rotational speed, torque, tool wear, failure target/type |
| `silver.renewable_energy_clean` | `Renewable Energy monitoring.xlsx` | One country-year record | energy production/consumption, energy mix, emissions, population/GDP where valid |
| `silver.owid_energy_clean` | `owid-energy-data.json` | One entity-year record | energy indicators; must retain entity/country and year |
| Gold facts/dimensions | Silver datasets after business-key validation | To be confirmed with business requirements | Possible `fact_energy_reading`, `fact_outage_event`, `fact_utility_summary`, and shared `dim_date`, `dim_geography`, `dim_energy_source`; only create where joins/grain are defensible |

Do not join sources solely because their columns have similar names. For example, smart-meter and IIoT timestamps/consumption/temperature are conceptually related, but a reliable record-level join requires matching identifiers, timestamp semantics, units, and compatible granularity.

## 10. Runbook and verification checklist

Before treating these mappings as production-ready:

- [ ] Verify Pentaho connection `DE` points to the intended PostgreSQL database and schema.
- [ ] Run `sql/Table Schema's.sql` only in a safe development database after resolving destructive drops and the missing `CISData` DDL.
- [ ] Open each `.ktr` and verify its input path resolves from the transformation directory on the current OS; paths currently use Windows-style separators.
- [ ] Run each transformation separately and confirm row counts, conversion errors, rejected rows, and table contents.
- [ ] Confirm `asset_maintenance.csv` header/BOM behavior and standardize the UDI column name.
- [ ] Decide whether the OMS `Time Event Began` field must be retained.
- [ ] Inspect `owid-energy-data.json` and verify the JSONPath outputs preserve the entity/country dimension and one row per intended entity-year.
- [ ] Verify the `renewableenergydata` and `energymanagementdata` target DDL types and field counts against their KTR mappings.
- [ ] Add PK/unique constraints only after confirming source grain and duplicates.
- [ ] Implement and document Silver and Gold mappings separately; do not describe them as implemented until the ETL and DDL exist.

## 11. Repository artifacts reviewed

- `datasets/` source data files
- `pentaho/transformations/Asset.ktr`
- `pentaho/transformations/Billing.ktr`
- `pentaho/transformations/Customer.ktr`
- `pentaho/transformations/Energy Management System.ktr`
- `pentaho/transformations/IoT Smart Grid.ktr`
- `pentaho/transformations/OMS Data.ktr`
- `pentaho/transformations/Renewable Energy Monitoring.ktr`
- `pentaho/transformations/Scada Pipeline.ktr`
- `pentaho/transformations/Smart Meter.ktr`
- `pentaho/transformations/Transformations.ktr` (combined transformation definition; individual transformations above were used as the clearer mapping sources)
- `sql/Table Schema's.sql`
- Python notebooks under `python/` and `silver/`
- `docs/report/Data_Dictionary_EnergyEnterprise.xlsx` (present in repository; use as the business-description companion to this technical mapping)

---

**Interpretation rule:** an entry described as “configured” means it was found in the uploaded Pentaho/XML/SQL artifact. A recommendation or proposed Silver/Gold table is not an implemented repository object until the corresponding DDL/ETL exists and has been executed successfully.
# Enterprise Energy Data Platform — Data Lineage Documentation
## Enterprise Energy Data Platform (EEDP)

| Document attribute | Value |
|---|---|
| Project | Enterprise Energy Data Platform |
| Business context | ABC Energy Ltd. — enterprise energy, utility, grid, billing, asset and outage data |
| Primary integration tool | Pentaho Data Integration (PDI / Kettle) |
| Operational/curated database target currently configured | PostgreSQL, schema `public` |
| Analytics consumer | Power BI (planned/target architecture; no implemented Power BI model is included in this repository snapshot) |
| Document purpose | Trace source datasets through configured ingestion, PostgreSQL landing tables, validation/cleansing assets, and future analytics layers |
| Repository evidence reviewed | `datasets/`, `pentaho/transformations/`, `pentaho/jobs/`, `sql/`, `python/`, `silver/`, `bronze/`, `gold/`, and `lineage/` |
| Implementation status | Mixed: source-to-PostgreSQL loads are configured in Pentaho; a complete Silver-to-Gold warehouse lineage is not yet implemented in the supplied repository |

---

## 1. Purpose and scope

This document records where project data originates, how it is read and transformed, where Pentaho is configured to write it, and which downstream stages are implemented versus planned. It is intended to support data governance, troubleshooting, auditability, data-quality reviews, and Sprint deliverables.

The lineage is based on the files contained in the supplied ZIP. A configured `.ktr` mapping is evidence of intended/implemented ETL configuration, not proof that a successful production run has occurred. No execution logs, database extracts, or populated warehouse validation results were supplied with the repository snapshot.

### Status labels used

- **Configured** — a Pentaho transformation contains a source reader and a PostgreSQL table output.
- **Supporting code** — a notebook contains profiling, mapping, quality, or standardization logic, but it is not shown as an automated Pentaho-to-database stage.
- **Planned / not evidenced** — the directory or architecture implies a stage, but the supplied files do not implement a complete executable data flow for it.
- **Needs verification** — a mismatch or risk in the repository must be resolved before lineage can be treated as reliable.

## 2. End-to-end lineage overview

```text
Source files under datasets/
  ├── smart_meter_data.csv
  ├── scada_pipeline.csv
  ├── OMS_data.csv
  ├── iiot_smart_grid_dataset.csv
  ├── Billing_payments.csv
  ├── asset_maintenance.csv
  ├── CIS.xml
  ├── Renewable Energy monitoring.xlsx
  └── owid-energy-data.json
           |
           | Pentaho Data Integration transformations (.ktr)
           | CSV / XML / Excel / JSON readers
           | selected field mapping and limited null handling
           v
PostgreSQL schema public (configured table outputs)
  ├── Smart_meter
  ├── scada_pipeline
  ├── omsdata
  ├── iotsmartgrid
  ├── billing_payment
  ├── assetmaintainence
  ├── CISData
  ├── renewableenergydata
  └── energymanagementdata
           |
           | Python / Pandas notebooks are present for profiling,
           | column mapping, data-quality checks and standardization.
           | They are not wired as a fully orchestrated DB-to-DB ETL.
           v
Silver: cleansing / validation directories
  [supporting notebooks present; persisted Silver datasets/tables
   and a complete automated hand-off are not evidenced]
           |
           v
Gold: warehouse / datamarts / analytics directories
  [placeholder files only in this ZIP; no implemented star schema
   or complete fact/dimension load chain evidenced]
           |
           v
Power BI reporting
  [intended consumer; no report/model artifact supplied]
```

**Important distinction:** the current Pentaho transformations write directly to the tables listed above in PostgreSQL. The folder names `bronze/`, `silver/`, and `gold/` express the intended medallion architecture, but the repository does not yet demonstrate a complete physical Bronze → Silver → Gold pipeline. Do not describe these layers as operational until the corresponding storage objects and jobs exist and have been run.

## 3. Source inventory

The repository has nine source files with dedicated Pentaho paths (including both JSON and Excel energy datasets, which are separate inputs).

| Source ID | Source asset | Format / structure | Configured Pentaho transformation | PostgreSQL target | Status |
|---|---|---|---|---|---|
| SRC-01 | `datasets/smart_meter_data.csv` | CSV; meter consumption, weather/context, anomaly label | `pentaho/transformations/Smart Meter.ktr` | `public.Smart_meter` | Configured |
| SRC-02 | `datasets/scada_pipeline.csv` | CSV; pipeline/SCADA measurements and states | `pentaho/transformations/Scada Pipeline.ktr` | `public.scada_pipeline` | Configured |
| SRC-03 | `datasets/OMS_data.csv` | CSV; outage/event records | `pentaho/transformations/OMS Data.ktr` | `public.omsdata` | Configured; column handling needs review |
| SRC-04 | `datasets/iiot_smart_grid_dataset.csv` | CSV; IIoT electrical, environmental and consumption fields | `pentaho/transformations/IoT Smart Grid.ktr` | `public.iotsmartgrid` | Configured |
| SRC-05 | `datasets/Billing_payments.csv` | CSV; utility-level demand, supply, use, revenue and retail statistics | `pentaho/transformations/Billing.ktr` | `public.billing_payment` | Configured |
| SRC-06 | `datasets/asset_maintenance.csv` | CSV; equipment condition and failure labels | `pentaho/transformations/Asset.ktr` | `public.assetmaintainence` | Configured; BOM/header issue |
| SRC-07 | `datasets/CIS.xml` | XML; hierarchical XML nodes | `pentaho/transformations/Customer.ktr` | `public.CISData` | Configured; target schema mismatch |
| SRC-08 | `datasets/Renewable Energy monitoring.xlsx` | Excel workbook, sheet `data`; country/year energy indicators | `pentaho/transformations/Renewable Energy Monitoring.ktr` | `public.renewableenergydata` | Configured |
| SRC-09 | `datasets/owid-energy-data.json` | JSON object keyed by entity/country, with time-series records | `pentaho/transformations/Energy Management System.ktr` | `public.energymanagementdata` | Configured; entity/key extraction needs review |

The repository also contains `datasets/Transformer_Health_Records.sql`. It is a SQL-formatted source/data artifact, but the supplied Pentaho transformations do not show it as an input to any of the nine target tables. Its downstream lineage is therefore **not established** in this document.

## 4. Detailed source-to-target lineage

### 4.1 Smart meter data

**Lineage ID:** LIN-01  
**Source:** `datasets/smart_meter_data.csv`  
**Transformation:** `pentaho/transformations/Smart Meter.ktr`  
**Target:** `public.Smart_meter`

Flow:

1. Pentaho CSV Input reads the file using a header row, comma delimiter, and double-quote enclosure.
2. The transformation declares `Timestamp` as a date using `yyyy-MM-dd HH:mm:ss`; measurement columns are parsed as numeric values and `Anomaly_Label` as a string.
3. The table-output step maps fields to columns with matching names in `public.Smart_meter`.
4. A Write to Log step is present for operational visibility.
5. No explicit deduplication, range validation, aggregation, or reject-table route is evidenced in this transformation.

| Source field | PostgreSQL target column | Mapping / interpretation |
|---|---|---|
| `Timestamp` | `"Timestamp"` | Parse to timestamp using `yyyy-MM-dd HH:mm:ss` |
| `Electricity_Consumed` | `Electricity_Consumed` | Numeric measurement; direct field mapping |
| `Temperature` | `Temperature` | Numeric measurement; direct field mapping |
| `Humidity` | `Humidity` | Numeric measurement; direct field mapping |
| `Wind_Speed` | `Wind_Speed` | Numeric measurement; direct field mapping |
| `Avg_Past_Consumption` | `Avg_Past_Consumption` | Numeric measurement; direct field mapping |
| `Anomaly_Label` | `Anomaly_Label` | String label; direct field mapping |

**Downstream use:** consumption trends, contextual analysis, anomaly monitoring. These are potential analytical uses, not proof of a built dashboard.

**Controls to add:** reject malformed timestamps; check null timestamps; define uniqueness/grain (for example, timestamp plus meter identifier if such an identifier is added); validate numeric ranges and label domain. The current source field list does not include an explicit meter ID, which limits per-customer/per-meter attribution.

### 4.2 SCADA pipeline data

**Lineage ID:** LIN-02  
**Source:** `datasets/scada_pipeline.csv`  
**Transformation:** `pentaho/transformations/Scada Pipeline.ktr`  
**Target:** `public.scada_pipeline`

Flow: CSV Input → typed field parsing → table output. The timestamp is configured as a string, while numeric readings and states are parsed to numeric/integer types.

| Source field | Target column | Mapping / interpretation |
|---|---|---|
| `timestamp` | `timestamp` | String in source and target (`VARCHAR(16)`); convert to timestamp in a future curated layer |
| `segment_id` | `segment_id` | Integer identifier |
| `pressure` | `pressure` | Numeric pressure reading |
| `flow_rate` | `flow_rate` | Numeric flow measurement |
| `temperature` | `temperature` | Numeric temperature measurement |
| `valve_status` | `valve_status` | Integer/state code |
| `pump_state` | `pump_state` | Integer/state code |
| `pump_speed` | `pump_speed` | Numeric speed |
| `compressor_state` | `compressor_state` | Integer/state code |
| `energy_consumption` | `energy_consumption` | Numeric energy measurement |
| `alarm_triggered` | `alarm_triggered` | Integer/flag code |
| `event_type` | `event_type` | String event category |
| `target` | `target` | Integer target/label field |

**Downstream use:** equipment/pipeline condition monitoring, alarm and energy analysis.

**Controls to add:** parse `timestamp` into a proper timestamp in Silver; standardize units; validate state/flag domains; verify that `target` is a label rather than a business measure; define row grain and duplicate detection.

### 4.3 Outage Management System (OMS)

**Lineage ID:** LIN-03  
**Source:** `datasets/OMS_data.csv`  
**Transformation:** `pentaho/transformations/OMS Data.ktr`  
**Target:** `public.omsdata`

Flow: CSV Input → `Null if` step → `Select values` step → table output. The transformation includes a null-handling step and a field-selection/rename step. The final selection maps the fields below. The source has `Time Event Began` and `Demand Loss (MW)`, but the target DDL/output mapping does not include those two fields.

| Source field | Target column | Mapping / interpretation |
|---|---|---|
| `Event Description` | `"Event Description"` | Text description |
| `Year` | `"Year"` | Integer year |
| `Date Event Began` | `"Date Event Began"` | Text in target; normalize to date/timestamp in Silver |
| `Date of Restoration` | `"Date of Restoration"` | Target is timestamp; validate conversion and formats |
| `Time of Restoration` | `"Time of Restoration"` | Text/time string |
| `Respondent` | `Respondent` | Organization/respondent text |
| `Geographic Areas` | `"Geographic Areas"` | Geographic description |
| `NERC Region` | `"NERC Region"` | Region text/code |
| `Number of Customers Affected` | `"Number of Customers Affected"` | Stored as text; convert to integer in Silver if valid |
| `Tags` | `Tags` | Text tags |

**Fields not propagated to the current target:** `Time Event Began`, `Demand Loss (MW)`. If they are needed for outage duration, impact analysis, or MW-loss reporting, add them to the target schema and mapping.

**Controls to add:** preserve both start and restoration date/time fields; parse timestamps with documented timezone assumptions; convert affected-customer count to numeric; define null tokens handled by `Null if`; record rejected rows instead of silently losing them.

### 4.4 Industrial IoT smart grid data

**Lineage ID:** LIN-04  
**Source:** `datasets/iiot_smart_grid_dataset.csv`  
**Transformation:** `pentaho/transformations/IoT Smart Grid.ktr`  
**Target:** `public.iotsmartgrid`

Flow: CSV Input → parsed fields → table output. The transformation maps 20 source fields to the target table.

| Source field | Target column | Mapping / interpretation |
|---|---|---|
| `Timestamp` | `"Timestamp"` | Parse date/time; target timestamp |
| `Power_Consumption_kWh` | `Power_Consumption_kWh` | Numeric |
| `Voltage_V` | `Voltage_V` | Numeric voltage |
| `Current_A` | `Current_A` | Numeric current |
| `Power_Factor` | `Power_Factor` | Numeric ratio |
| `Grid_Frequency_Hz` | `Grid_Frequency_Hz` | Numeric frequency |
| `Reactive_Power_kVAR` | `Reactive_Power_kVAR` | Numeric reactive power |
| `Active_Power_kW` | `Active_Power_kW` | Numeric active power |
| `Demand_Response_Event` | `Demand_Response_Event` | Integer event flag/code |
| `Temperature_C` | `Temperature_C` | Numeric temperature |
| `Humidity_%` | `"Humidity_%"` | Numeric humidity; quoted identifier in DDL |
| `Weather_Condition` | `Weather_Condition` | Text category |
| `Solar_Power_Generation_kW` | `Solar_Power_Generation_kW` | Numeric |
| `Wind_Power_Generation_kW` | `Wind_Power_Generation_kW` | Numeric |
| `Previous_Day_Consumption_kWh` | `Previous_Day_Consumption_kWh` | Numeric |
| `Peak_Load_Hour` | `Peak_Load_Hour` | Integer hour/code |
| `Energy_Source_Type` | `Energy_Source_Type` | Integer code |
| `User_Type` | `User_Type` | Integer code |
| `Normalized_Consumption` | `Normalized_Consumption` | Target column is text; normalize/type-check before analytics |
| `Energy_Efficiency_Score` | `Energy_Efficiency_Score` | Numeric score |

**Downstream use:** grid operating conditions, consumption patterns, demand-response analysis and generation mix.

**Controls to add:** validate physical ranges and units, define permitted category values, document categorical codes for `Energy_Source_Type` and `User_Type`, and convert `Normalized_Consumption` to a numeric target type if it represents a quantitative measure.

### 4.5 Utility billing and payment/statistical data

**Lineage ID:** LIN-05  
**Source:** `datasets/Billing_payments.csv`  
**Transformation:** `pentaho/transformations/Billing.ktr`  
**Target:** `public.billing_payment`

Flow: CSV Input → numeric/string parsing → table output. The target stores utility-level demand, generation, use, revenue and customer/sales statistics. Despite the source filename containing “payments”, the supplied fields are utility statistics rather than transaction-level payment records.

| Source field group | Target mapping | Mapping / interpretation |
|---|---|---|
| `Utility.Number`, `Utility.Name`, `Utility.State`, `Utility.Type` | Same-named columns | Utility identifier and descriptive attributes |
| `Demand.Summer Peak`, `Demand.Winter Peak` | Same-named columns | Numeric demand measures |
| `Sources.Generation`, `Sources.Purchased`, `Sources.Other`, `Sources.Total` | Same-named columns | Numeric supply/source measures |
| `Uses.Retail`, `Uses.Resale`, `Uses.No Charge`, `Uses.Consumed`, `Uses.Losses`, `Uses.Total` | Same-named columns | Numeric energy-use measures |
| `Revenues.Retail`, `Revenue.Delivery`, `Revenue.Resale`, `Revenue.Adjustments`, `Revenue.Transmission`, `Revenue.Other`, `Revenue.Total` | Same-named columns | Numeric revenue measures |
| `Retail.Residential.*` | Same-named columns | Residential revenue, sales and customer statistics |
| `Retail.Commercial.*` | Same-named columns | Commercial revenue, sales and customer statistics |
| `Retail.Industrial.*` | Same-named columns | Industrial revenue, sales and customer statistics |
| `Retail.Transportation.*` | Same-named columns | Transportation revenue, sales and customer statistics |
| `Retail.Total.*` | Same-named columns | Total retail revenue, sales and customer statistics |

The transformation maps the columns directly; no business aggregation or reconciliation logic is evidenced in the `.ktr`.

**Controls to add:** check utility-number uniqueness at the intended grain; verify totals against their component fields using source-specific rules; standardize currency and energy units; ensure very large `NUMERIC` precisions are intentional; distinguish missing values from zero.

### 4.6 Asset maintenance and failure records

**Lineage ID:** LIN-06  
**Source:** `datasets/asset_maintenance.csv`  
**Transformation:** `pentaho/transformations/Asset.ktr`  
**Target:** `public.assetmaintainence` (table name spelling retained from repository)

| Source field | Target column | Mapping / interpretation |
|---|---|---|
| `UDI` | `ï»¿UDI` in current mapping/DDL | **Needs correction/verification:** source header is `UDI`, while the target mapping shows a BOM-corrupted header |
| `Product ID` | `"Product ID"` | String equipment/product identifier |
| `Type` | `"Type"` | Equipment type/category |
| `Air temperature [K]` | `"Air temperature [K]"` | Numeric temperature in Kelvin |
| `Process temperature [K]` | `"Process temperature [K]"` | Numeric temperature in Kelvin |
| `Rotational speed [rpm]` | `"Rotational speed [rpm]"` | Integer rotational speed |
| `Torque [Nm]` | `"Torque [Nm]"` | Numeric torque |
| `Tool wear [min]` | `"Tool wear [min]"` | Integer wear duration |
| `Target` | `Target` | Integer target/failure indicator |
| `Failure Type` | `"Failure Type"` | Text failure category |

**Critical issue:** the source CSV header is `UDI`, but the SQL DDL and Pentaho mapping show `ï»¿UDI`. This is consistent with an incorrectly decoded UTF-8 byte-order mark. Normalize the source header to `UDI` or configure explicit header cleanup, then use one canonical target name. Also verify whether `Failure Type` is included in the table-output field mapping; it exists in the source and DDL, but must be checked in the exact field list.

**Controls to add:** enforce `UDI` uniqueness if appropriate; validate temperature/speed/torque bounds; reconcile `Target` against `Failure Type`; define whether no-failure records use a specific category or null.

### 4.7 Customer Information System (CIS) XML

**Lineage ID:** LIN-07  
**Source:** `datasets/CIS.xml`  
**Transformation:** `pentaho/transformations/Customer.ktr`  
**Configured target:** `public.CISData`

The XML reader is an XML Input Stream step. It extracts XML structure into node-level metadata rather than producing a clearly defined customer business entity.

| XML-derived field | Configured target column | Meaning |
|---|---|---|
| `xml_data_type_description` | `xml_data_type_description` | Description/type of the XML node data |
| `xml_element_id` | `xml_element_id` | Identifier for the XML element |
| `xml_parent_element_id` | `xml_parent_element_id` | Parent element identifier |
| `xml_element_level` | `xml_element_level` | Hierarchy depth |
| `xml_path` | `xml_path` | Path of the element in the XML |
| `xml_parent_path` | `xml_parent_path` | Parent path |
| `xml_data_name` | `xml_data_name` | XML element/attribute name |
| `xml_data_value` | `xml_data_value` | Extracted scalar value |

**Critical schema mismatch:** the supplied `sql/Table Schema's.sql` creates `CISData` with none of these XML metadata columns. Therefore, the transformation target and DDL are not aligned. The target table must be created/altered to match the output fields, or the transformation must be redesigned to map XML content to a documented customer schema.

Do not describe this table as a usable customer dimension yet. The sample XML contains generic nested nodes and test values; no validated customer key or customer attribute mapping is established in the supplied files.

### 4.8 Renewable energy monitoring workbook

**Lineage ID:** LIN-08  
**Source:** `datasets/Renewable Energy monitoring.xlsx`, worksheet `data`  
**Transformation:** `pentaho/transformations/Renewable Energy Monitoring.ktr`  
**Target:** `public.renewableenergydata`

Flow: Excel Input → table output. The workbook contains country/year energy indicators; the SQL DDL defines a wide table with country, year, ISO code, population, GDP, electricity, fossil-fuel, renewable and other energy attributes.

| Source field family | Target mapping | Mapping / interpretation |
|---|---|---|
| `country`, `year`, `iso_code` | Same-named columns | Entity, year and geographic code |
| `population`, `gdp` | Same-named columns | Source values are declared as text in DDL; parse/validate before numeric analysis |
| `biofuel_*` | Matching `biofuel_*` columns | Biofuel consumption, electricity, per-capita, change and share indicators |
| `coal_*` | Matching `coal_*` columns | Coal consumption, production, electricity, per-capita, change and share indicators |
| `gas_*` | Matching `gas_*` columns | Gas consumption, production, electricity and share indicators |
| `oil_*` | Matching `oil_*` columns | Oil consumption, production, electricity and share indicators |
| `fossil_*` | Matching `fossil_*` columns | Fossil energy/electricity measures |
| `hydro_*`, `solar_*`, `wind_*` | Matching columns where defined | Renewable technology indicators |
| `renewables_*`, `low_carbon_*`, `other_renewable_*` | Matching columns where defined | Renewable and low-carbon aggregates |
| `electricity_*`, `energy_*`, `carbon_intensity_elec`, `greenhouse_gas_emissions` | Matching columns | Overall electricity/energy/emissions indicators |

The source is very wide (the workbook's `data` sheet has 130 columns in the inspected snapshot). The detailed field-to-field mapping should be maintained against the exact Excel header and Pentaho output field list; this summary records the field families without asserting that every workbook field is currently mapped. The `.ktr` and DDL must be checked for column count/name alignment before treating the load as validated.

**Important lineage risk:** `year` is configured as a numeric/double value in the target schema rather than an integer/date dimension key. Most energy quantities in the DDL are text, even when numeric analysis would be expected. Type normalization belongs in the Silver layer and should not alter the source files.

### 4.9 OWID energy JSON

**Lineage ID:** LIN-09  
**Source:** `datasets/owid-energy-data.json`  
**Transformation:** `pentaho/transformations/Energy Management System.ktr`  
**Target:** `public.energymanagementdata`

The JSON file is structured as an object keyed by country/entity, with time-series records beneath each key. The Pentaho JSON Input step uses JSONPath expressions for fields including `year`, `biofuel_electricity`, `biofuel_share_elec`, `carbon_intensity_elec`, coal/electricity measures and other energy metrics. The output step writes selected fields to `energymanagementdata`.

| JSON attribute / extracted field | Intended target | Lineage note |
|---|---|---|
| `year` | `year` | Year value extracted using JSONPath |
| `biofuel_electricity` | `biofuel_electricity` | Numeric energy indicator |
| `biofuel_share_elec` | `biofuel_share_elec` | Share indicator |
| `carbon_intensity_elec` | `carbon_intensity_elec` | Carbon intensity indicator |
| `coal_electricity`, `coal_share_elec` | Matching columns where mapped | Coal electricity and share |
| `electricity_demand`, `electricity_generation` | Matching columns | Demand/generation indicators |
| Other explicitly selected JSON fields | Matching output columns | Must be reconciled to the full target DDL and JSONPath list |

**Critical issue:** the source's top-level entity/country key must be retained as a column. A mapping that extracts only `year` and measures without country/entity cannot reliably distinguish one country's record from another. Confirm that the JSONPath expressions preserve the parent entity; if not, change the JSON parsing strategy to emit `country`/`entity` with each observation. The target schema should include this entity field and a defined row grain such as `(country, year)`.

This JSON source overlaps conceptually with the Excel renewable energy dataset but is a separate physical source and transformation. Avoid loading both into the same analytical measure set without defining which source is authoritative and how differences are reconciled.

## 5. Target database lineage and schema control

The supplied SQL file `sql/Table Schema's.sql` defines these PostgreSQL tables in schema `public`:

| Target table | Source lineage | Main concerns |
|---|---|---|
| `Smart_meter` | Smart meter CSV | No explicit meter key or uniqueness rule |
| `scada_pipeline` | SCADA CSV | Timestamp stored as `VARCHAR(16)` |
| `omsdata` | OMS CSV | Start time and demand-loss fields excluded from current target |
| `iotsmartgrid` | IIoT CSV | `Normalized_Consumption` stored as text; quoted `%` column |
| `billing_payment` | Billing CSV | Utility-grain and totals need validation |
| `assetmaintainence` | Asset maintenance CSV | BOM-corrupted `UDI` name; table spelling |
| `CISData` | CIS XML | DDL does not match XML metadata output |
| `renewableenergydata` | Renewable Energy workbook | Wide schema; many quantitative values stored as text |
| `energymanagementdata` | OWID energy JSON | Entity/country key and output schema alignment need verification |

The SQL file starts with unqualified `DROP TABLE` statements. Running it will delete existing tables with those names in the active schema/database, subject to privileges and dependencies. Treat it as destructive setup SQL: back up data and use a controlled migration approach before executing it against a populated environment.

## 6. Profiling, quality, mapping and standardization lineage

The repository contains supporting notebooks at both the project root and in `silver/`:

| Asset | Location | Intended role | Current lineage status |
|---|---|---|---|
| Column mapping | `python/Columnmapping.ipynb`; `silver/cleansing/Columnmapping.ipynb` | Load source datasets and inspect/map column names | Supporting code; no persisted target or orchestration connection evidenced |
| Data profiling | `python/dataprofiling.ipynb`; `silver/cleansing/dataprofiling.ipynb`; `silver/validation/dataprofiling.ipynb` | Inspect dataset structure, missing values, types and distributions | Supporting code; validate outputs and execution status separately |
| Data quality | `python/DataQuality.ipynb`; `silver/cleansing/DataQuality.ipynb`; `silver/validation/DataQuality.ipynb` | Run data quality checks | Supporting code; not shown as a blocking gate in Pentaho |
| Standardization | `python/Standardization.ipynb`; `silver/cleansing/Standardization.ipynb` | Standardize selected CSV datasets and prepare output/report directories | Supporting code; output path and downstream consumption need verification |

The notebook code uses Pandas to read source files. The standardization notebook defines output/report directories relative to the notebook/script location and selects the billing, IIoT, OMS, maintenance, and SCADA CSVs. This does not by itself prove that the resulting files are consumed by Pentaho or loaded to PostgreSQL. To establish end-to-end lineage, outputs should have a consistent Silver directory, run metadata, a documented schema, and an automated dependency from the validation step to the next load.

## 7. Orchestration and execution lineage

`pentaho/jobs/transformerJobRecords.kjb` defines a PostgreSQL connection named `DE` using environment variables:

- `${DB_HOST}`
- `${DB_NAME}`
- `${DB_PORT}`
- `${DB_USER}`
- `${DB_PASS}`

This is the connection configuration evidence present in the job file. The repository contains individual `.ktr` files as well as `pentaho/transformations/Transformations.ktr`, which contains a combined set of source reader/output steps. The supplied job file should be inspected in Spoon to confirm which transformation entry it actually executes and whether all source pipelines are sequenced. A file existing in the folder does not prove it is invoked by the job.

**Operational lineage fields to capture on each run (recommended):**

- pipeline/transformation name and version/commit;
- source filename or API endpoint and extraction timestamp;
- run ID / Pentaho batch ID;
- input, output, rejected, updated and error row counts;
- start/end timestamp and status;
- target table and load mode (append, truncate/reload, upsert);
- checksum or source snapshot identifier where feasible;
- validation results and reject reason.

Pentaho has log steps in the transformations, but a dedicated, populated audit table and persisted run-level metrics are not evidenced in the SQL supplied.

## 8. Proposed future lineage: Silver, Gold and Power BI

This section is a target-state recommendation, not a claim about current implementation.

```text
Source files
  -> Raw/landing PostgreSQL tables (current configured targets)
  -> Silver standardized tables/files
       - canonical names and types
       - parsed timestamps and units
       - duplicate and null rules
       - rejected-row quarantine
       - source/run metadata
  -> Gold dimensional model
       - DimDate
       - DimUtility / DimGeography / DimAsset (where keys exist)
       - FactSmartMeterReading
       - FactGridTelemetry
       - FactOutageEvent
       - FactUtilityEnergyStatistics
       - FactAssetMaintenance
       - FactRenewableEnergyByCountryYear
  -> Power BI semantic model and reports
```

Do not create joins merely because datasets share the general energy domain. For example, the smart-meter source has no explicit customer/meter key in its current column list; the XML CIS sample does not yet establish a validated customer key; and country/year energy data has a different grain from operational telemetry. Cross-source relationships should be implemented only when stable business keys and compatible time/geographic grains are identified.

### Suggested target grain (subject to source validation)

| Proposed Gold table | Proposed grain | Primary source |
|---|---|---|
| `FactSmartMeterReading` | One observation per meter and timestamp; requires meter key | Smart meter CSV |
| `FactGridTelemetry` | One telemetry observation per source timestamp/segment/device key | IIoT and/or SCADA; keep sources distinct until grain and units are aligned |
| `FactOutageEvent` | One outage/event | OMS CSV |
| `FactUtilityEnergyStatistics` | One utility per reporting period, if period is available | Billing/utility statistics CSV |
| `FactAssetMaintenance` | One equipment observation/record | Asset maintenance CSV |
| `FactRenewableEnergyByCountryYear` | One country/entity per year | Renewable workbook or OWID JSON, with source authority defined |
| `DimDate` | One calendar date | Derived from validated timestamps/years |
| `DimUtility`, `DimAsset`, `DimGeography` | One stable business entity per key | Only after reliable keys and attributes are identified |

## 9. Data lineage controls and acceptance criteria

Before calling lineage complete, implement and record the following:

1. **Source registration:** every source has a stable ID, owner/source description, format, refresh frequency, encoding, schema version and expected grain.
2. **Schema contracts:** source headers, Pentaho input fields, table-output fields and SQL DDL agree exactly, including case-sensitive/quoted identifiers.
3. **Type conversion:** timestamps and numeric measures are stored in analytical types; failed conversions are counted and quarantined.
4. **Row reconciliation:** for each run, record source rows, rows read, rows written, rows rejected and row-count difference. Explain legitimate filtering.
5. **Key/duplicate rules:** document the natural key and uniqueness test for every target. Do not invent a key where the source lacks one.
6. **Null handling:** list accepted null tokens and distinguish unknown/not supplied from zero.
7. **Referential integrity:** validate foreign keys only after the dimensions and their business keys exist.
8. **Metric reconciliation:** validate totals against component measures where source definitions make the calculation valid.
9. **Lineage metadata:** retain run ID, source file, transformation, target, timestamps, status and code version.
10. **Downstream certification:** certify Gold and Power BI lineage only after actual warehouse tables, ETL jobs, semantic models and report artifacts exist.

### Initial issue register

| ID | Issue | Impact | Recommended action | Priority |
|---|---|---|---|---|
| DL-01 | `Customer.ktr` outputs XML metadata fields, but SQL DDL for `CISData` does not define them | Customer load may fail or target contract is wrong | Align DDL and transformation, then test an end-to-end load | Critical |
| DL-02 | Asset source header `UDI` differs from target/mapping `ï»¿UDI` | Header/column mapping may fail | Normalize BOM/header and rename target consistently | High |
| DL-03 | OWID JSON top-level entity key may be omitted from selected output | Country/entity observations may become indistinguishable | Include entity/country in each emitted row and target schema | Critical |
| DL-04 | OMS `Time Event Began` and `Demand Loss (MW)` are omitted | Outage start time and impact analysis incomplete | Add fields to target and mapping if required by scope | High |
| DL-05 | SCADA timestamp stored as text | Time filtering and joins become unreliable | Parse to timestamp in Silver and reject invalid formats | High |
| DL-06 | `Normalized_Consumption` stored as text | Numeric aggregations may be incorrect or require implicit casts | Profile values and choose a numeric type or document categorical meaning | Medium |
| DL-07 | Renewable/OWID values have mixed text and numeric target types | Aggregations and null checks become inconsistent | Create typed Silver schema and conversion/rejection rules | High |
| DL-08 | Notebook outputs are not linked to Pentaho/database loads | Cleansing may not be reflected in database targets | Define one canonical output location and orchestrate the dependency | High |
| DL-09 | Gold and lineage directories contain placeholders, not full implementations | No evidence of end-to-end warehouse/Power BI lineage | Build Gold ETL, audit records and semantic model before claiming completion | High |
| DL-10 | SQL setup drops tables before recreating them | Potential loss of loaded data | Separate development reset scripts from production migrations | Critical |

## 10. Evidence and limitations

This document was prepared from the supplied repository snapshot, specifically:

- `datasets/*` source assets;
- `pentaho/transformations/*.ktr`;
- `pentaho/jobs/transformerJobRecords.kjb`;
- `sql/Table Schema's.sql`;
- Python and Silver notebooks;
- folder placeholders under `bronze/`, `silver/`, `gold/`, `metadata/`, `lineage/`, and `dashboards/`.

The document does not assert that any ETL run succeeded. Runtime status, actual database row counts, rejection counts, credentials/connection availability, and Power BI refresh lineage must be verified in the running environment. Where the transformation, source schema and SQL DDL disagree, the discrepancy is explicitly recorded rather than inferred away.

---

## 11. Recommended repository placement

Save this document as:

`docs/report/Data_Lineage_Documentation.md`

A companion machine-readable lineage register can later be added as `lineage/lineage_register.csv` with columns such as `lineage_id,source_asset,source_format,transformation,target_schema,target_table,load_mode,status,quality_gate,owner,last_verified`.

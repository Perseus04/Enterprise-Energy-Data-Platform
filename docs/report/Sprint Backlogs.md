# Sprint Backlog — Enterprise Energy Data Platform (EEDP)

## 1. Purpose

This document organizes the planned work across **Sprint 0 through Sprint 3**, following the UC6 Enterprise Energy Data Platform roadmap. Statuses are planning defaults and must be updated to reflect actual implementation; an item should only be marked **Done** after its acceptance criteria have been verified.

## 2. Status Legend

- **To Do** — not started
- **In Progress** — currently being worked on
- **Blocked** — cannot proceed until a dependency or issue is resolved
- **Done** — acceptance criteria verified

## 3. Sprint Overview

| Sprint | Focus | Main Outcome |
|---|---|---|
| Sprint 0 | Project Initiation & Architecture | Agreed project foundation, scope, requirements, architecture, and repository |
| Sprint 1 | Data Discovery & Ingestion | Documented selected sources and working raw-data ingestion into PostgreSQL staging |
| Sprint 2 | Data Profiling & DB / Data Warehouse | Profiled and quality-checked data, dimensional model, and populated warehouse |
| Sprint 3 | Data Governance, Lineage & Analytics | Traceable ETL, reconciliation evidence, analytics dashboards, and final documentation |

---

## 4. Sprint 0 — Project Initiation & Architecture

**Objective:** Understand the business problem and establish the requirements, scope, architecture, and development repository before implementation.

| ID | Backlog Item | Acceptance Criteria / Definition of Done | Priority |
|---|---|---|---|
| S0-01 | Review UC6 business problem and objectives | Problem, business context, and objectives are summarized in project documentation | High |
| S0-02 | Identify stakeholders | Required stakeholder groups and their interests are documented | High |
| S0-03 | Prepare Business Requirement Document (BRD) | Business needs, objectives, requirements, and expected outcomes are documented | High |
| S0-04 | Define project scope | Scope clearly describes the platform capabilities and boundaries | High |
| S0-05 | Identify enterprise source landscape | Candidate source systems and their likely data domains are listed | High |
| S0-06 | Draft high-level solution architecture | Architecture shows source systems, Pentaho, processing, PostgreSQL, and Power BI | High |
| S0-07 | Prepare Project Charter | Charter includes background, problem, objectives, scope, stakeholders, technology, milestones, and success criteria | High |
| S0-08 | Create GitHub repository | Repository exists and project files can be version-controlled | High |
| S0-09 | Create project directory structure | Directories for data layers, Pentaho, Python, SQL, metadata/lineage, dashboards, documentation, and tests are established as needed | High |
| S0-10 | Establish Git workflow | Initial commit is created and meaningful commit conventions are defined | Medium |
| S0-11 | Prepare Product Backlog | Project work is listed, prioritized, and assigned to planned sprints | High |
| S0-12 | Prepare Sprint Backlogs | Sprint 0–3 work is organized with IDs, priorities, dependencies, and acceptance criteria | High |
| S0-13 | Record technology stack and setup requirements | Pentaho, PostgreSQL, Python/Pandas, Power BI, Git/GitHub, and documentation tools are recorded | Medium |
| S0-14 | Review Sprint 0 deliverables | Charter, BRD, architecture, repository, and backlog are reviewed for consistency | High |
| S0-15 | Prepare Sprint 0 review material | A concise summary of completed work, decisions, and outstanding issues is available | Medium |

**Sprint 0 deliverables:** Project Charter, BRD, stakeholder analysis, solution architecture, Git repository and structure, Product Backlog, Sprint Backlog.

---

## 5. Sprint 1 — Data Discovery & Ingestion

**Objective:** Analyze selected data sources and build the raw-data landing/staging layer.

| ID | Backlog Item | Acceptance Criteria / Definition of Done | Priority |
|---|---|---|---|
| S1-01 | Finalize datasets for implementation | Selected datasets, sources, formats, and intended use are recorded; selection is based on actual availability | High |
| S1-02 | Prepare Source Inventory | Inventory records source name, domain, file/table, format, key fields, and implementation status | High |
| S1-03 | Analyze source schemas | Column names, data types, keys, and known limitations are recorded for selected datasets | High |
| S1-04 | Prepare Data Dictionary | Selected source fields, definitions, types, and relevant constraints are documented | High |
| S1-05 | Inspect data types and formats | Formats present in the chosen data are identified; unsupported formats are not claimed as implemented | Medium |
| S1-06 | Configure PostgreSQL staging database | Database and staging schema/tables are created and connection is verified | High |
| S1-07 | Design raw/staging table structures | Table definitions reflect selected source fields and preserve traceability to source data | High |
| S1-08 | Build Pentaho CSV ingestion | A selected CSV source loads successfully and row counts are checked | High |
| S1-09 | Build Pentaho Excel ingestion, if selected | An Excel source loads successfully and output is validated; otherwise document as not applicable | Medium |
| S1-10 | Build Pentaho JSON ingestion, if selected | A JSON source loads successfully and output is validated; otherwise document as not applicable | Medium |
| S1-11 | Build Pentaho XML ingestion, if selected | An XML source loads successfully and output is validated; otherwise document as not applicable | Medium |
| S1-12 | Build SQL-source ingestion, if selected | Data is extracted from a database source and loaded to staging; otherwise document as not applicable | Medium |
| S1-13 | Add ingestion logging | Run details such as source, time, status, and processed row counts are recorded where supported | High |
| S1-14 | Add exception handling | Invalid inputs or failed loads produce visible errors and do not silently appear successful | High |
| S1-15 | Validate staging loads | Row counts, column mapping, sample records, and required fields are checked against the source | High |
| S1-16 | Document ingestion configuration | Pentaho transformations, connections, parameters, and execution steps are documented without exposing credentials | Medium |
| S1-17 | Organize source and configuration files | Files are stored in the agreed repository locations; secrets and local-only paths are excluded | Medium |
| S1-18 | Commit ingestion implementation to Git | Working transformations, SQL, and documentation are committed with meaningful messages | High |
| S1-19 | Prepare Sprint 1 evidence | Logs, row counts, screenshots or output samples, and known limitations are recorded | Medium |
| S1-20 | Conduct Sprint 1 review | Source Inventory, Data Dictionary, staging loads, and unresolved issues are reviewed | High |

**Sprint 1 deliverables:** Source Inventory, Data Dictionary, Pentaho ingestion transformations for selected formats, PostgreSQL staging database, ingestion logging and exception handling, Git commit history.

---

## 6. Sprint 2 — Data Profiling & DB / Data Warehouse

**Objective:** Understand data quality, prepare trusted datasets, design the analytical model, and populate the PostgreSQL data warehouse.

| ID | Backlog Item | Acceptance Criteria / Definition of Done | Priority |
|---|---|---|---|
| S2-01 | Confirm profiling dataset and baseline | Source tables/files and record counts to be profiled are identified | High |
| S2-02 | Profile dataset structure with Python/Pandas | Data types, row/column counts, distributions, and summary statistics are reported | High |
| S2-03 | Analyze missing values | Missing-value counts and percentages are calculated and documented | High |
| S2-04 | Detect duplicate records | Duplicate checks are run using appropriate keys or business rules and results recorded | High |
| S2-05 | Check invalid values and ranges | Relevant date, numeric, meter, sensor, customer, and billing rules are tested where fields exist | High |
| S2-06 | Check cross-field and referential consistency | Related fields and keys are checked for logical consistency where applicable | Medium |
| S2-07 | Prepare Data Profiling Report | Methods, counts, findings, and limitations are documented | High |
| S2-08 | Prepare Data Quality Report | Issues are categorized by type, severity, affected records, and proposed treatment | High |
| S2-09 | Define cleansing and standardization rules | Rules are documented before being applied to the selected datasets | High |
| S2-10 | Implement data cleaning | Cleaning is reproducible and preserves raw data or a clear raw-to-cleaned trace | High |
| S2-11 | Validate cleaned data | Quality checks are rerun and before/after results are compared | High |
| S2-12 | Design dimensional/star schema | Fact and dimension tables, keys, grain, and relationships are documented | High |
| S2-13 | Create PostgreSQL warehouse tables | DDL scripts create fact and dimension tables with appropriate keys and types | High |
| S2-14 | Develop Pentaho warehouse transformations | Cleaned/staged data is transformed and loaded into warehouse tables | High |
| S2-15 | Validate warehouse loads | Row counts, key integrity, duplicates, and representative values are checked | High |
| S2-16 | Develop SQL analytical queries | Queries answer agreed operational questions using the warehouse schema | Medium |
| S2-17 | Version-control Sprint 2 assets | Python scripts, SQL, Pentaho transformations, reports, and model documentation are committed | High |
| S2-18 | Prepare Sprint 2 review evidence | Profiling findings, quality improvements, schema, load results, and issues are demonstrable | Medium |

**Sprint 2 deliverables:** Data Profiling Report, Data Quality Report, documented cleaning rules and results, Star Schema, PostgreSQL Data Warehouse, SQL scripts, Git updates.

---

## 7. Sprint 3 — Data Governance, Lineage & Analytics

**Objective:** Improve traceability and governance, validate related data, orchestrate ETL workflows, and provide business-facing analytics.

| ID | Backlog Item | Acceptance Criteria / Definition of Done | Priority |
|---|---|---|---|
| S3-01 | Document Source-to-Target Mapping | Each implemented flow maps source fields to target fields with transformation rules and key handling | High |
| S3-02 | Prepare Data Lineage Documentation | Lineage traces selected source data through ingestion, cleaning, transformation, and target tables | High |
| S3-03 | Prepare Energy Business Glossary | Business terms, definitions, and relevant fields are documented consistently | Medium |
| S3-04 | Review metadata documentation | Dataset and table descriptions, owners/stewards where known, update frequency where known, and technical details are recorded | Medium |
| S3-05 | Build Pentaho orchestration jobs | Related transformations can be executed in a controlled sequence with visible success/failure outcomes | High |
| S3-06 | Validate meter data, where selected | Reconciliation checks compare relevant meter records, counts, dates, or readings and document exceptions | High |
| S3-07 | Validate billing data, where selected | Relevant billing totals, record counts, keys, and consistency checks are documented | High |
| S3-08 | Validate asset data, where selected | Asset identifiers, record counts, and related consistency checks are documented | Medium |
| S3-09 | Produce reconciliation summary | Checks performed, expected results, actual results, exceptions, and limitations are recorded | High |
| S3-10 | Define Power BI analytical questions and KPIs | Dashboard measures are tied to available fields and documented business questions | High |
| S3-11 | Connect Power BI to curated data | Power BI connects to the selected PostgreSQL tables or approved extracts and refresh is tested | High |
| S3-12 | Develop energy and operational dashboards | Visuals use validated data and display meaningful trends, comparisons, or summaries | High |
| S3-13 | Validate dashboard figures | Selected dashboard values reconcile with SQL queries or known source totals | High |
| S3-14 | Consolidate technical documentation | Architecture, setup, data sources, ETL, quality, warehouse, lineage, and analytics documentation are consistent | High |
| S3-15 | Prepare final project presentation | Presentation summarizes the problem, architecture, data, methods, implementation, validation, results, and limitations | High |
| S3-16 | Run final end-to-end demonstration | Selected data can be traced from source through ingestion and warehouse to validated analytics | High |
| S3-17 | Final Git review and release tag | Repository is reviewed, important assets are committed, and a release tag is created if required by the project | Medium |
| S3-18 | Conduct Sprint 3 / final review | Deliverables, outstanding limitations, and final demonstration are reviewed and recorded | High |

**Sprint 3 deliverables:** Source-to-Target Mapping, Data Lineage Documentation, Energy Business Glossary, Pentaho orchestration jobs, reconciliation evidence, Power BI dashboards, final technical documentation, presentation, and Git release.

---

## 8. Cross-Sprint Dependencies

```text
Sprint 0: Requirements, Scope, Architecture, Repository
                         |
                         v
Sprint 1: Source Inventory, Data Dictionary, Ingestion, Staging
                         |
                         v
Sprint 2: Profiling, Quality, Cleaning, Star Schema, Warehouse
                         |
                         v
Sprint 3: Mapping, Lineage, Reconciliation, Orchestration, Power BI
                         |
                         v
               Final Demonstration
```

## 9. Sprint Review Checklist

Use this checklist at the end of each sprint:

- [ ] Sprint goal has been addressed.
- [ ] Acceptance criteria for completed items have been verified.
- [ ] Working outputs or evidence are available.
- [ ] Known defects, blockers, and limitations are documented.
- [ ] Relevant documentation is updated.
- [ ] Changes are committed to Git.
- [ ] Completed items are marked **Done**; unfinished items remain open or are replanned.
- [ ] Sprint review/demo is prepared.


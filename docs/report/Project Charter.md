# Project Charter — Enterprise Energy Data Platform (EEDP)

## 1. Project Title

**Enterprise Energy Data Platform (EEDP): Building a Unified Smart Grid & Energy Analytics Platform**

## 2. Project Background

ABC Energy Ltd. serves more than 10 million residential, commercial, and industrial consumers. Its operational and business data is generated across multiple independent systems, including smart meters, SCADA, Energy Management Systems (EMS), Customer Information Systems (CIS), billing systems, renewable energy monitoring, asset management, outage management, and IoT-enabled grid sensors.

The **Enterprise Energy Data Platform (EEDP)** will integrate data from these heterogeneous sources, improve data reliability, store curated datasets in PostgreSQL, and provide a foundation for energy analytics and reporting.

## 3. Business Problem

Energy, customer, asset, and grid data is distributed across independent systems. This makes it difficult to obtain a consistent enterprise view, identify data-quality issues, analyze operational performance, reconcile related records, and produce reliable reports.

ABC Energy requires a unified data platform that consolidates data from selected sources and makes trusted datasets available for operational and management analytics.

## 4. Project Objectives

The project aims to:

1. Ingest data from selected heterogeneous enterprise sources.
2. Profile, clean, validate, and standardize data.
3. Store raw and curated data in PostgreSQL staging and warehouse structures.
4. Design a dimensional data model for analytical queries.
5. Document metadata, source-to-target mappings, and data lineage.
6. Use Pentaho Data Integration for ingestion and ETL workflows.
7. Use Python/Pandas and SQL for data profiling, quality checks, and validation.
8. Provide analytics and dashboards using Power BI.
9. Maintain project code and documentation in Git/GitHub.

## 5. Project Scope

The project covers requirements analysis, source discovery, data dictionary preparation, ingestion, data profiling, data cleansing and validation, PostgreSQL staging and warehouse development, dimensional modelling, ETL workflows, metadata and lineage documentation, data reconciliation, Power BI analytics, version control, and technical documentation.

The project is a student implementation of an enterprise-style data platform. The source landscape may include smart meter readings, SCADA logs, EMS, CIS, billing and payment records, renewable-energy monitoring, asset maintenance records, OMS data, IoT grid-sensor data, and transformer-health reports. The specific datasets used will be recorded in the Source Inventory.

## 6. Stakeholders

| Stakeholder | Primary Interest |
|---|---|
| Grid Operations Team | Grid monitoring and operational performance |
| Distribution Team | Distribution performance and energy data |
| Customer Service Team | Customer and consumption information |
| Asset Management Team | Asset and transformer information |
| Regulatory Compliance Team | Reliable reporting and traceability |
| Executive Management | Business insights and decision-making |
| Data Engineering Team | Development and maintenance of EEDP |

## 7. Technology Stack

| Category | Technology | Purpose |
|---|---|---|
| ETL and ingestion | Pentaho Data Integration (Spoon) | Ingestion, transformation, and workflow orchestration |
| Database | PostgreSQL | Staging and data warehouse |
| Data processing | Python / Pandas | Profiling, quality analysis, and data processing |
| Querying and validation | SQL | Data validation, reconciliation, and analytical queries |
| Version control | Git / GitHub | Versioning and collaboration |
| Reporting | Power BI | Dashboards and analytics |
| Documentation | Markdown / MS Word | Project and technical documentation |
| Project management | Agile Scrum | Sprint-based delivery |

## 8. High-Level Solution Architecture

```text
Selected Enterprise Data Sources
              |
              v
   Pentaho Data Integration
              |
              v
      Raw / Staging Data
              |
              v
 Python / Pandas + SQL Checks
              |
              v
     Cleaned / Validated Data
              |
              v
   PostgreSQL Data Warehouse
              |
              v
       Curated Data for BI
              |
              v
      Power BI Dashboards
```

Cross-cutting project practices include Git/GitHub version control, documentation, data-quality evidence, metadata, lineage, and testing. The exact implementation sequence and dataset coverage will be refined through the sprint backlogs.

## 9. Sprint Roadmap and Milestones

| Sprint | Name | Main Focus | Expected Deliverables |
|---|---|---|---|
| Sprint 0 | Project Initiation & Architecture | Understand the business problem, define requirements and scope, identify stakeholders and sources, plan architecture, and establish the repository | Project Charter, BRD, stakeholder analysis, solution architecture, Git repository and structure, Product Backlog, Sprint Backlog |
| Sprint 1 | Data Discovery & Ingestion | Analyze selected sources, prepare the data dictionary, ingest supported file/database formats, and land raw data in PostgreSQL staging | Source Inventory, Data Dictionary, Pentaho ingestion transformations, staging tables, ingestion logs and exception handling, Git history |
| Sprint 2 | Data Profiling & Database / Data Warehouse | Profile data, identify quality issues, standardize records, design the star schema, and populate warehouse tables | Data Profiling Report, Data Quality Report, Star Schema, PostgreSQL Data Warehouse, SQL scripts, Git updates |
| Sprint 3 | Data Governance, Lineage & Analytics | Document mappings and lineage, prepare a business glossary, orchestrate ETL jobs, reconcile data, and develop dashboards | Source-to-Target Mapping, Data Lineage Documentation, Business Glossary, Pentaho Jobs, reconciliation evidence, Power BI dashboards, final technical documentation and presentation, tagged Git release |

## 10. Major Deliverables Across the Project

- Business Requirement Document and Project Charter
- Stakeholder analysis and solution architecture
- GitHub repository and project directory structure
- Source Inventory and Data Dictionary
- Pentaho ingestion and transformation workflows
- PostgreSQL staging database and data warehouse
- Data Profiling and Data Quality Reports
- Star-schema design and SQL validation scripts
- Source-to-Target Mapping and Data Lineage documentation
- Business Glossary and reconciliation evidence
- Power BI dashboards
- Technical documentation, sprint presentations, and final Git release

## 11. Success Criteria

The project will be considered successful when:

- Selected data sources are documented and ingested successfully.
- Required Pentaho workflows execute and handle failures visibly.
- PostgreSQL staging and warehouse tables contain the expected data.
- Data profiling and quality checks are performed and documented.
- Dimensional tables support the intended analytical queries.
- Source-to-target mappings and lineage are documented.
- Meter, billing, and asset reconciliation checks are performed where applicable to the selected datasets.
- Power BI dashboards present useful energy and operational insights.
- Code, transformations, SQL, and documentation are version-controlled.
- Each sprint produces its agreed deliverables and a demonstrable increment.

## 12. Project Constraints and Assumptions

- Delivery follows the project’s defined Agile sprint roadmap.
- The implementation uses Pentaho Data Integration, Python/Pandas, PostgreSQL, Power BI, and Git/GitHub.
- Dataset selection and availability determine which source formats and business scenarios can be demonstrated.
- The solution is an enterprise-style student implementation, not a live production utility control system.
- Deliverables and completion status reflect work actually implemented.

## 13. Definition of Done

A sprint is complete when its agreed backlog items meet their acceptance criteria, relevant pipelines or scripts have been tested, data-quality and validation results are recorded where applicable, code and project files are committed to Git, documentation is updated, and the sprint increment is ready to demonstrate.

## 14. Project Governance

The Project Charter establishes the overall direction and boundaries of EEDP. The Product Backlog contains the full prioritized project work, while each Sprint Backlog identifies the work planned for that sprint. Sprint progress and completion status should be updated as implementation proceeds.

# Enterprise Energy Data Platform (EEDP)

## 1. Project Overview

The **Enterprise Energy Data Platform (EEDP)** is a data-engineering project for **ABC Energy Ltd.** that demonstrates how data from heterogeneous energy, utility, and external sources can be collected, validated, standardized, and prepared for analytics.

The platform follows a layered data flow:

**Data Sources → Raw/Bronze Layer → Data Profiling and Quality Checks → Cleaned/Silver Layer → PostgreSQL → Curated/Gold Data and Reporting**

The project uses Pentaho Data Integration (PDI) for ETL workflows, Python and Pandas for data inspection and transformation, and PostgreSQL for structured storage. Power BI can be used to build reports from the curated data.

### Main objectives

- Ingest data from supported file-based and external sources.
- Inspect datasets and identify missing, duplicate, inconsistent, or invalid values.
- Apply documented data-quality and standardization rules.
- Store staging and curated data in PostgreSQL.
- Maintain useful ETL logs, metadata, and source-to-target mapping information where implemented.
- Prepare clean, structured data for downstream analysis and dashboards.

> **Implementation note:** The repository is developed incrementally across project sprints. The components and datasets actually present in the checked-out branch determine which workflows can currently be executed end to end. Do not assume every source or reporting component listed in the project scope is already integrated.

## 2. Technology Stack

| Component | Purpose |
|---|---|
| Python 3 | Data processing, validation, and notebook execution |
| Pandas | Tabular data profiling and transformation |
| Jupyter Notebook | Interactive data exploration and implementation |
| Pentaho Data Integration (PDI / Spoon) | ETL transformations and data movement |
| PostgreSQL | Staging and structured/curated data storage |
| SQL | Schema creation, querying, and data validation |
| Git and GitHub | Source control and collaboration |
| Power BI (optional) | Dashboarding and reporting from curated data |

## 3. Software Requirements

Install the following software before running the project.

1. **Git** — to clone the repository.
2. **Python 3.10 or later** — Python 3.11 or 3.12 is a practical choice for compatibility with common data-science packages.
3. **PostgreSQL** — install the database server and ensure it is running.
4. **Pentaho Data Integration (PDI / Spoon)** — required to open and run the repository's `.ktr` transformations and `.kjb` jobs, if present.
5. **Jupyter Notebook** — installed through Python dependencies below.
6. **Power BI Desktop (optional)** — needed only if you intend to open or build Power BI reports.

Use a terminal appropriate to your operating system. The commands below show Windows PowerShell first; equivalent commands can be used on Linux/macOS.

## 4. Download the Project

Clone the repository and enter the project directory:

```bash
git clone https://github.com/Perseus04/Enterprise-Energy-Data-Platform.git
cd Enterprise-Energy-Data-Platform
```

If the required work is on the `subBranch` branch, switch to it:

```bash
git switch subBranch
```

If you downloaded the project as a ZIP file instead, extract it and open a terminal in the extracted repository folder.

Before proceeding, inspect the available files and folders. Notebook names, SQL scripts, datasets, and Pentaho transformation paths can vary by branch.

## 5. Set Up the Python Environment

### Windows PowerShell

Create a virtual environment:

```powershell
py -3 -m venv .venv
```

Activate it:

```powershell
.\.venv\Scripts\Activate.ps1
```

If PowerShell blocks activation due to execution policy, use Command Prompt instead:

```bat
.venv\Scripts\activate.bat
```

Alternatively, run the environment's Python executable directly without activating it.

### Linux/macOS

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Upgrade pip:

```bash
python -m pip install --upgrade pip
```

## 6. Install Python Dependencies

If the repository contains a `requirements.txt`, install its pinned dependencies from the repository root:

```bash
python -m pip install -r requirements.txt
```

If no dependency file is present, install the core packages explicitly:

```bash
python -m pip install pandas numpy openpyxl jupyter ipykernel sqlalchemy "psycopg[binary]" requests pytest
```

These packages provide common functionality for CSV/Excel processing, notebooks, PostgreSQL connectivity, HTTP API requests, and automated tests. Some workflows may require additional packages depending on the imports used in the specific notebook or script. Install those packages into the same virtual environment.

Register the environment as a Jupyter kernel:

```bash
python -m ipykernel install --user --name eedp --display-name "Python (EEDP)"
```

Launch Jupyter:

```bash
jupyter notebook
```

Open the relevant notebook from the repository in the browser and select the **Python (EEDP)** kernel.

### Dependency installation troubleshooting

- Use `python -m pip` rather than a standalone `pip` command so packages are installed for the selected Python interpreter.
- If your organization blocks package installation, follow its approved software-installation process or use an approved Python environment. Do not attempt to bypass device-management policies.
- If a package is already installed, pip may report that its requirement is satisfied.
- If a dependency file is missing, do not point pip at a nonexistent `requirements.txt`; use the explicit installation command above or create a dependency file based on the imports actually used by the project.

## 7. Configure PostgreSQL

1. Install PostgreSQL and start the database service.
2. Open `psql` or pgAdmin.
3. Create a dedicated database and a database user for this project. Example SQL:

```sql
CREATE DATABASE eedp;
CREATE USER eedp_user WITH PASSWORD 'change_this_password';
GRANT ALL PRIVILEGES ON DATABASE eedp TO eedp_user;
```

4. Connect to the new database and grant schema permissions if required by your PostgreSQL version and configuration:

```sql
\connect eedp
GRANT USAGE, CREATE ON SCHEMA public TO eedp_user;
```

5. Locate the SQL schema or setup scripts in the checked-out repository and execute the relevant scripts in the documented order. If no schema script is provided, create only the tables required by the workflow you are running.

### Database connection settings

Use environment variables for credentials rather than committing passwords to Git. Set the values to match your local PostgreSQL configuration.

Windows PowerShell example:

```powershell
$env:PGHOST = "localhost"
$env:PGPORT = "5432"
$env:PGDATABASE = "eedp"
$env:PGUSER = "eedp_user"
$env:PGPASSWORD = "your_local_password"
```

Linux/macOS example:

```bash
export PGHOST=localhost
export PGPORT=5432
export PGDATABASE=eedp
export PGUSER=eedp_user
export PGPASSWORD='your_local_password'
```

These are standard PostgreSQL environment variables. A notebook or script will use them only if it is written to read them. If the current implementation defines connection settings in a configuration file or connection dialog, update that configuration instead and avoid committing secrets.

Verify that PostgreSQL is reachable:

```bash
psql -h localhost -p 5432 -U eedp_user -d eedp
```

At the `psql` prompt, run:

```sql
SELECT version();
```

## 8. Configure Pentaho Data Integration

Pentaho Data Integration is required for workflows implemented as Spoon transformations (`.ktr`) or jobs (`.kjb`).

1. Install a PDI version compatible with the Java version required by that PDI release.
2. Start **Spoon** using the launcher supplied with your installation.
3. Open the relevant `.ktr` or `.kjb` file from the repository.
4. Configure database connections using your local PostgreSQL host, port, database, username, and password.
5. Check input-file steps and confirm that their paths point to files that exist on your machine.
6. Run a small test execution first and inspect the step-level output, row counts, and error details.
7. Confirm that expected records reached the intended PostgreSQL staging tables before running a larger workflow.

### File paths

Prefer repository-relative paths or PDI variables where the transformation supports them. Do not assume a path from another developer's computer exists on yours. If a transformation uses an absolute path, update it to the correct local path before execution.

## 9. Data and Execution Workflow

Follow the order below, adapting it to the actual scripts and transformations present in your branch.

1. **Inspect the repository.** Identify source datasets, notebooks, SQL files, PDI transformations/jobs, and any configuration files.
2. **Prepare the source data.** Keep input files in their expected directories and preserve original files when possible.
3. **Set up the database.** Create the database and run the provided schema/setup SQL scripts.
4. **Configure source connections.** Update local file paths, API settings, and database connection details.
5. **Run ingestion.** Execute the relevant PDI workflow or ingestion script to load available source data into staging/raw tables or the raw-data layer.
6. **Profile the data.** Run the applicable notebook/script to inspect column types, missing values, duplicates, value ranges, and inconsistencies.
7. **Apply data-quality rules.** Run the implemented validation, cleaning, and standardization steps. Review the outputs and quality reports rather than assuming all records are valid.
8. **Load curated data.** Run the relevant SQL or ETL steps to populate the cleaned/curated tables and dimensional model, if implemented.
9. **Validate database results.** Check row counts, nulls, duplicates, keys, and other constraints defined by the project.
10. **Build reports (optional).** Connect Power BI to the curated PostgreSQL tables or views and refresh the report.

**Important:** There is no universal command that runs every stage unless an end-to-end orchestration script has been implemented. Execute the repository's actual notebooks, SQL scripts, and PDI jobs in dependency order.

## 10. Testing

If the repository includes automated tests, install the test dependency and run them from the repository root:

```bash
python -m pytest -v
```

If tests are located in a specific directory, use the appropriate path, for example:

```bash
python -m pytest tests/ -v
```

A passing unit or repository-integrity test suite does not necessarily prove that the full ETL pipeline works against a live PostgreSQL instance or external API. Verify the relevant database, file-ingestion, and transformation steps separately.

## 11. Common Problems

| Problem | What to check |
|---|---|
| `requirements.txt` not found | Confirm the current working directory and whether the file exists in the checked-out branch. Use the explicit dependency installation command in Section 6 if it does not exist. |
| `ModuleNotFoundError` | Activate the project's virtual environment and install the missing package using `python -m pip`. |
| PostgreSQL connection refused | Confirm the PostgreSQL service is running and that host/port are correct. |
| Password authentication failed | Check the database username/password and PostgreSQL authentication configuration. |
| Database or table does not exist | Create the database and execute the relevant schema scripts before running the ETL step. |
| PDI input file not found | Check the transformation's file path, working directory, and file name. |
| PDI database connection fails | Test the connection in Spoon and confirm PostgreSQL JDBC driver/configuration and credentials. |
| API request fails | Check connectivity, endpoint availability, rate limits, and any required API key. Keep API keys out of source control. |
| Notebook uses the wrong Python | Select the `Python (EEDP)` kernel or launch Jupyter from the activated virtual environment. |
| CI cannot install dependencies | Check whether the workflow expects `requirements.txt` or `pyproject.toml`; ensure the workflow and dependency-management approach match the repository. |

## 12. Project Status and Scope

This README describes the intended setup and general operating procedure for EEDP. The exact runnable stages depend on the files and integrations available in the selected branch. Before treating the platform as end-to-end complete, verify that ingestion, profiling, cleaning, PostgreSQL loading, and reporting all execute successfully using the project's actual inputs and configuration.


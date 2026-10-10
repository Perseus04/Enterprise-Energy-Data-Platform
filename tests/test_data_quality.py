from pathlib import Path
import json
import re
import xml.etree.ElementTree as ET

import pandas as pd
import pytest

ROOT = Path(__file__).resolve().parents[1]
DATASETS = ROOT / "datasets"


@pytest.mark.parametrize(
    ("filename", "required_columns"),
    [
        (
            "asset_maintenance.csv",
            ["UDI", "Product ID", "Type", "Target", "Failure Type"],
        ),
        (
            "Billing_payments.csv",
            ["Utility.Number", "Utility.Name", "Utility.State", "Utility.Type"],
        ),
        (
            "iiot_smart_grid_dataset.csv",
            ["Timestamp", "Power_Consumption_kWh", "Voltage_V", "Current_A"],
        ),
        (
            "OMS_data.csv",
            ["Event Description", "Year", "Date Event Began", "Geographic Areas"],
        ),
        (
            "scada_pipeline.csv",
            ["timestamp", "segment_id", "pressure", "flow_rate", "energy_consumption"],
        ),
        (
            "smart_meter_data.csv",
            ["Timestamp", "Electricity_Consumed", "Temperature", "Humidity"],
        ),
    ],
)
def test_csv_sources_exist_load_and_have_expected_fields(filename, required_columns):
    """Check the real CSV inputs used by the EEDP project."""
    path = DATASETS / filename
    assert path.is_file(), f"Missing project dataset: {path}"

    df = pd.read_csv(path)
    assert not df.empty, f"{filename} contains no data rows"
    assert len(df.columns) == len(set(df.columns)), f"{filename} has duplicate column names"

    missing = set(required_columns) - set(df.columns)
    assert not missing, f"{filename} is missing expected columns: {sorted(missing)}"


def test_renewable_energy_workbook_has_data_sheet_and_expected_fields():
    path = DATASETS / "Renewable Energy monitoring.xlsx"
    assert path.is_file()

    df = pd.read_excel(path, sheet_name="data")
    assert not df.empty
    assert {"country", "year", "iso_code"}.issubset(df.columns)


def test_owid_json_contains_country_records():
    path = DATASETS / "owid-energy-data.json"
    assert path.is_file()

    with path.open(encoding="utf-8") as handle:
        data = json.load(handle)

    assert isinstance(data, dict)
    assert data, "OWID JSON has no top-level records"
    assert "Afghanistan" in data, "Expected OWID country record is absent"


def test_standardization_notebook_is_valid_and_contains_project_transformations():
    """Verify the existing Standardization notebook, not a demo implementation."""
    path = ROOT / "python" / "Standardization.ipynb"
    assert path.is_file()

    notebook = json.loads(path.read_text(encoding="utf-8"))
    source = "\n".join(
        "".join(cell.get("source", []))
        for cell in notebook.get("cells", [])
        if cell.get("cell_type") == "code"
    )

    assert "def clean_text(" in source
    assert "def clean_column_names(" in source
    assert "customer_records" in source
    assert "Billing_payments.csv" in source
    assert "asset_maintenance.csv" in source
    assert "scada_pipeline.csv" in source


@pytest.mark.parametrize(
    "relative_path",
    [
        "pentaho/transformations/Asset.ktr",
        "pentaho/transformations/Billing.ktr",
        "pentaho/transformations/Customer.ktr",
        "pentaho/transformations/Energy Management System.ktr",
        "pentaho/transformations/IoT Smart Grid.ktr",
        "pentaho/transformations/OMS Data.ktr",
        "pentaho/transformations/Renewable Energy Monitoring.ktr",
        "pentaho/transformations/Scada Pipeline.ktr",
        "pentaho/transformations/Smart Meter.ktr",
        "pentaho/transformations/Transformations.ktr",
        "pentaho/jobs/transformerJobRecords.kjb",
    ],
)
def test_pentaho_job_and_transformation_files_are_well_formed_xml(relative_path):
    path = ROOT / relative_path
    assert path.is_file(), f"Missing Pentaho file: {relative_path}"
    ET.parse(path)


def test_sql_schema_declares_expected_project_source_tables():
    path = ROOT / "sql" / "Table Schema's.sql"
    assert path.is_file()
    sql = path.read_text(encoding="utf-8", errors="replace")

    # These are the source tables explicitly declared by the current schema.
    expected_tables = [
        "Smart_meter",
        "scada_pipeline",
        "omsdata",
        "iotsmartgrid",
        "billing_payment",
        "assetmaintainence",
        "renewableenergydata",
        "energymanagementdata",
        "CISData",
    ]
    declared_tables = re.findall(
        r'CREATE\s+TABLE\s+"?public"?\s*\.\s*"?([A-Za-z_][A-Za-z0-9_]*)"?',
        sql,
        flags=re.IGNORECASE,
    )
    assert set(expected_tables).issubset(set(declared_tables))


def test_required_project_dataset_files_are_present():
    expected = [
        "asset_maintenance.csv",
        "Billing_payments.csv",
        "iiot_smart_grid_dataset.csv",
        "OMS_data.csv",
        "Renewable Energy monitoring.xlsx",
        "owid-energy-data.json",
        "scada_pipeline.csv",
        "smart_meter_data.csv",
    ]
    missing = [name for name in expected if not (DATASETS / name).is_file()]
    assert not missing, f"Missing expected EEDP datasets: {missing}"

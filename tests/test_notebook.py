import json
from pathlib import Path


def test_public_notebook_has_no_saved_outputs():
    notebook = json.loads(Path("notebooks/public_demo.ipynb").read_text(encoding="utf-8"))
    assert notebook["nbformat"] == 4
    assert all(not cell.get("outputs") for cell in notebook["cells"])
    assert all(cell.get("execution_count") is None for cell in notebook["cells"] if cell["cell_type"] == "code")


def test_public_notebook_uses_public_catalog_data_only():
    text = Path("notebooks/public_demo.ipynb").read_text(encoding="utf-8")
    assert "USGS/SRTMGL1_003" in text
    assert "JRC/GSW1_4/GlobalSurfaceWater" in text
    assert "projects/your-project/assets" not in text

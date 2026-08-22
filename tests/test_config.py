from pathlib import Path

import pytest

from gee_workbench.config import load_config


def test_environment_overrides_config(monkeypatch, tmp_path: Path):
    config_path = tmp_path / "config.toml"
    config_path.write_text('project = "file-project"\nasset_root = "projects/file-project/assets"\n')
    monkeypatch.setenv("EE_PROJECT", "environment-project")
    monkeypatch.setenv("EE_ASSET_ROOT", "projects/environment-project/assets/custom")

    config = load_config(config_path)
    assert config.project == "environment-project"
    assert config.asset_root == "projects/environment-project/assets/custom"


def test_default_asset_root(monkeypatch, tmp_path: Path):
    config_path = tmp_path / "config.toml"
    config_path.write_text('project = "demo-project"\n')
    monkeypatch.delenv("EE_PROJECT", raising=False)
    monkeypatch.delenv("EE_ASSET_ROOT", raising=False)

    config = load_config(config_path)
    assert config.asset_root == "projects/demo-project/assets"


def test_placeholder_project_is_rejected(monkeypatch, tmp_path: Path):
    config_path = tmp_path / "config.toml"
    config_path.write_text('project = "your-google-cloud-project"\n')
    monkeypatch.delenv("EE_PROJECT", raising=False)
    monkeypatch.delenv("EE_ASSET_ROOT", raising=False)

    with pytest.raises(ValueError):
        load_config(config_path)

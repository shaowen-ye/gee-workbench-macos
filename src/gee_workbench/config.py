"""Configuration loading with environment-variable overrides."""

from __future__ import annotations

import os
import tomllib
from dataclasses import dataclass
from pathlib import Path


def default_config_path() -> Path:
    base = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
    return base / "gee-workbench" / "config.toml"


@dataclass(frozen=True)
class WorkbenchConfig:
    project: str
    asset_root: str


def load_config(path: Path | None = None) -> WorkbenchConfig:
    path = path or default_config_path()
    data: dict = {}
    if path.exists():
        data = tomllib.loads(path.read_text(encoding="utf-8"))

    project = os.environ.get("EE_PROJECT") or str(data.get("project", "")).strip()
    if not project or project == "your-google-cloud-project":
        raise ValueError(
            "Set EE_PROJECT or copy config/config.example.toml to "
            f"{default_config_path()} and set your Google Cloud project ID."
        )

    asset_root = os.environ.get("EE_ASSET_ROOT") or str(data.get("asset_root", "")).strip()
    if not asset_root:
        asset_root = f"projects/{project}/assets"
    return WorkbenchConfig(project=project, asset_root=asset_root.rstrip("/"))

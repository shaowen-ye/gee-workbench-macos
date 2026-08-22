"""Read-only Earth Engine project, asset, task and quota inspection."""

from __future__ import annotations

import time
from collections import Counter
from datetime import UTC, datetime
from typing import Any

import ee

from .config import WorkbenchConfig


def initialize(config: WorkbenchConfig, attempts: int = 4) -> None:
    last_error: Exception | None = None
    for attempt in range(1, attempts + 1):
        try:
            ee.Initialize(project=config.project)
            return
        except ee.EEException as exc:
            last_error = exc
            if attempt < attempts:
                time.sleep(attempt * 2)
    raise RuntimeError("Earth Engine initialization failed") from last_error


def list_assets(config: WorkbenchConfig, recursive: bool = True) -> list[dict[str, Any]]:
    assets: list[dict[str, Any]] = []
    pending = [config.asset_root]
    visited: set[str] = set()
    while pending:
        parent = pending.pop(0)
        if parent in visited:
            continue
        visited.add(parent)
        response = ee.data.listAssets({"parent": parent, "pageSize": 1000})
        children = response.get("assets", []) if isinstance(response, dict) else []
        assets.extend(children)
        if recursive:
            pending.extend(
                asset["name"]
                for asset in children
                if asset.get("type") in {"FOLDER", "IMAGE_COLLECTION"}
            )
    return assets


def list_tasks() -> list[dict[str, Any]]:
    return ee.data.getTaskList()


def concise_assets(assets: list[dict[str, Any]]) -> list[dict[str, Any]]:
    return [
        {
            "name": asset.get("name"),
            "type": asset.get("type"),
            "update_time": asset.get("updateTime"),
            "size_bytes": asset.get("sizeBytes"),
        }
        for asset in assets
    ]


def concise_tasks(tasks: list[dict[str, Any]]) -> list[dict[str, Any]]:
    return [
        {
            "id": task.get("id"),
            "state": task.get("state"),
            "description": task.get("description"),
            "task_type": task.get("task_type"),
            "error_message": task.get("error_message"),
        }
        for task in tasks
    ]


def doctor(config: WorkbenchConfig) -> dict[str, Any]:
    initialize(config)
    assets = list_assets(config)
    tasks = list_tasks()
    quota = ee.data.getAssetRootQuota(config.asset_root)
    return {
        "checked_at": datetime.now(UTC).isoformat(),
        "project": config.project,
        "asset_root": config.asset_root,
        "earthengine_api": ee.__version__,
        "assets": {
            "total": len(assets),
            "by_type": dict(sorted(Counter(a.get("type", "UNKNOWN") for a in assets).items())),
        },
        "tasks": {
            "total": len(tasks),
            "by_state": dict(sorted(Counter(t.get("state", "UNKNOWN") for t in tasks).items())),
        },
        "quota": quota,
    }

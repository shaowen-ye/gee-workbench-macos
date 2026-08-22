"""Command-line interface for read-only Earth Engine management."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from .config import load_config
from .manager import concise_assets, concise_tasks, doctor, initialize, list_assets, list_tasks


def main() -> int:
    parser = argparse.ArgumentParser(prog="gee-workbench")
    parser.add_argument("command", choices=["doctor", "assets", "tasks"])
    parser.add_argument("--config", type=Path)
    parser.add_argument("--output", type=Path, help="optional JSON output path")
    args = parser.parse_args()

    config = load_config(args.config)
    initialize(config)
    if args.command == "doctor":
        payload = doctor(config)
    elif args.command == "assets":
        payload = {"project": config.project, "assets": concise_assets(list_assets(config))}
    else:
        payload = {"project": config.project, "tasks": concise_tasks(list_tasks())}

    rendered = json.dumps(payload, ensure_ascii=False, indent=2, default=str) + "\n"
    print(rendered, end="")
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

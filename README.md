# GEE Workbench for macOS

![GEE Workbench icon](launcher/macos/assets/gee-workbench-icon.png)

[![macOS CI](https://github.com/Shaowen-Ye/gee-workbench-macos/actions/workflows/macos-ci.yml/badge.svg)](https://github.com/Shaowen-Ye/gee-workbench-macos/actions/workflows/macos-ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> **Unofficial community project.** This project is not affiliated with,
> endorsed by, or sponsored by Google.

A privacy-conscious macOS research workbench that connects the Google Earth
Engine Python API, geemap, JupyterLab Desktop, QGIS and read-only asset/task
management in one reproducible workflow.

面向生态环境、遥感和地学研究者的macOS桌面工作台：统一启动Earth Engine
Python环境、geemap交互地图、Jupyter Notebook、QGIS专业制图以及只读资产与任务盘点。

## Why this project?

Earth Engine's official Code Editor is browser-based, JupyterLab is a general
notebook environment, and QGIS is a desktop GIS. GEE Workbench does not replace
them. It provides a reproducible macOS integration layer:

- one-click desktop launcher;
- explicit Python environment selection;
- Google Cloud project health checks;
- read-only asset, task and quota inventory;
- geemap interactive maps and public-data demo;
- optional QGIS Earth Engine plugin workflow;
- privacy-first configuration outside the repository.

## Scope and safety

- The CLI is read-only: it does not delete, move, rename or share assets.
- Credentials stay in Earth Engine's standard user credential store.
- Project IDs are read from environment variables or a user configuration file.
- No private assets, coordinates, task IDs, credentials or research data ship
  with this repository.

## Requirements

- macOS 12 or newer;
- Python 3.11+;
- a registered Google Earth Engine Cloud project;
- Earth Engine authentication completed on the local machine;
- optional: JupyterLab Desktop and QGIS 3.44+.

## Quick start

```bash
git clone https://github.com/Shaowen-Ye/gee-workbench-macos.git
cd gee-workbench-macos
./scripts/install.sh
```

Edit the configuration created at:

```text
~/.config/gee-workbench/config.toml
```

Then launch from Finder, Spotlight or Alfred:

```text
GEE Workbench.app
```

Or use the read-only CLI:

```bash
source ~/.local/share/gee-workbench/.venv/bin/activate
gee-workbench doctor
gee-workbench assets
gee-workbench tasks
```

## Notebook

The public demo notebook uses only public Earth Engine datasets. It contains:

1. authentication and initialization;
2. project health summary;
3. asset inventory;
4. task monitor;
5. interactive public-data map;
6. links to the official Code Editor and Data Catalog.

## QGIS integration

Install the **Google Earth Engine** plugin from the official QGIS Plugin
Repository. The plugin can display Earth Engine layers, search the Data Catalog,
run Processing algorithms and export images. QGIS and its plugin are external
dependencies and are not redistributed here.

## Privacy-first release

Before every release, the project runs:

- Python unit tests;
- shell syntax and ShellCheck;
- notebook structure checks;
- temporary-home installation smoke test;
- repository privacy scan;
- gitleaks history scan;
- clean-clone verification.

## Documentation

- [Architecture](docs/architecture.md)
- [Privacy and data governance](docs/privacy.md)
- [Security policy](SECURITY.md)
- [Third-party notices](THIRD_PARTY_NOTICES.md)

## Trademark notice

Google Earth Engine and Google are trademarks of Google LLC. They are used in
plain text only to describe API compatibility. No Google logo, product icon or
official visual identity is included.

## License

The original source code in this repository is released under the [MIT License](LICENSE).
Use of Google Earth Engine remains subject to Google's applicable terms and
the licenses of individual datasets.

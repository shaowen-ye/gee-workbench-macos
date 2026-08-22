<p align="center">
  <img src="launcher/macos/assets/gee-workbench-icon.png" alt="GEE Workbench icon" width="96">
</p>

# GEE Workbench for macOS

<p align="center">
  <strong>English</strong> | <a href="README.zh-CN.md">简体中文</a>
</p>

[![macOS CI](https://github.com/Shaowen-Ye/gee-workbench-macos/actions/workflows/macos-ci.yml/badge.svg)](https://github.com/Shaowen-Ye/gee-workbench-macos/actions/workflows/macos-ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> **Unofficial community project.** This project is not affiliated with,
> endorsed by, or sponsored by Google.

GEE Workbench for macOS is a privacy-conscious research workspace that connects
the Google Earth Engine Python API, geemap, JupyterLab Desktop, and QGIS in one
reproducible local workflow. It is designed for environmental science, ecology,
remote sensing, fisheries, conservation, and other spatial research.

## What it does

GEE Workbench does not replace Earth Engine, JupyterLab, or QGIS. It provides a
small integration and management layer around them:

- creates an isolated Python environment for Earth Engine and geemap;
- installs a one-click macOS launcher with a custom, non-Google icon;
- opens a prepared Jupyter notebook with the correct Python environment;
- reads the Google Cloud project ID from a local configuration file or
  environment variable;
- provides read-only project health, asset, task, and quota inspection;
- supplies an output-free notebook that uses public Earth Engine datasets;
- documents an optional workflow for continuing analysis and cartography in
  QGIS;
- keeps credentials, private asset identifiers, and research data outside the
  repository.

## Scope and safety

- The command-line interface is read-only. It does not delete, move, rename, or
  share Earth Engine assets.
- Authentication remains in Earth Engine's standard user credential store.
- Configuration is stored in `~/.config/gee-workbench/config.toml`, outside the
  Git repository.
- The public demo contains no private coordinates, project IDs, asset IDs, task
  IDs, or research data.
- JSON reports created with `--output` may contain your project, asset, or task
  identifiers. Treat those reports as private research records.

## Requirements

- macOS 12 or newer;
- Python 3.11 or newer (the installer prefers Homebrew Python 3.12);
- a registered Google Earth Engine account and Google Cloud project;
- Earth Engine authentication completed on the local Mac;
- JupyterLab Desktop for the one-click desktop launcher;
- optional: QGIS for desktop GIS inspection and publication cartography.

## Installation

Clone the repository and run the installer:

```bash
git clone https://github.com/Shaowen-Ye/gee-workbench-macos.git
cd gee-workbench-macos
./scripts/install.sh
```

The installer creates:

- the application environment at `~/.local/share/gee-workbench`;
- the local configuration at `~/.config/gee-workbench/config.toml`;
- `GEE Workbench.app` in `~/Applications`.

The application is generated and ad-hoc signed locally. The current release
does not distribute a notarized `.app` or `.dmg` binary.

## Configuration and authentication

Edit the configuration file and replace the placeholder with your Google Cloud
project ID:

```toml
project = "your-google-cloud-project"
asset_root = "projects/your-google-cloud-project/assets"
```

You can override these settings for a terminal session:

```bash
export EE_PROJECT="your-google-cloud-project"
export EE_ASSET_ROOT="projects/your-google-cloud-project/assets"
```

If Earth Engine authentication has not been completed, activate the installed
environment and run the authentication command:

```bash
source ~/.local/share/gee-workbench/.venv/bin/activate
earthengine authenticate
```

Authentication opens Google's authorization flow. Credentials are not copied
into this repository.

## Launching the desktop workspace

Open `GEE Workbench.app` from Finder, Spotlight, or Alfred. The launcher:

1. locates the isolated Python environment;
2. locates the JupyterLab Desktop command-line interface;
3. opens `notebooks/public_demo.ipynb` in the repository workspace.

If JupyterLab Desktop cannot be found, install it first and run
`./scripts/install.sh` again.

## Read-only command-line tools

Activate the installed environment:

```bash
source ~/.local/share/gee-workbench/.venv/bin/activate
```

Then use:

```bash
gee-workbench doctor
gee-workbench assets
gee-workbench tasks
```

Save a report only when needed:

```bash
gee-workbench doctor --output reports/doctor.json
```

The `reports/` directory is ignored by Git by default.

## Public demonstration notebook

`notebooks/public_demo.ipynb` includes:

1. authentication and project initialization;
2. a project health summary;
3. read-only asset inventory;
4. task monitoring;
5. an interactive geemap view using public elevation and surface-water data;
6. links to the Earth Engine Code Editor and Data Catalog.

The committed notebook has no execution counts or saved outputs. Run it only
after setting your own project ID.

## Working with QGIS

QGIS remains a separate desktop GIS application. A typical workflow is:

1. compute or extract remote-sensing variables in Earth Engine;
2. export approved results to GeoTIFF, GeoPackage, GeoJSON, or CSV;
3. inspect CRS, geometry, raster alignment, and NoData handling in QGIS;
4. create final maps, layouts, legends, labels, and print-ready outputs in QGIS.

This repository does not redistribute QGIS or third-party QGIS plugins.

## Project structure

```text
config/                  example local configuration
docs/                    architecture and privacy guidance
launcher/macos/          launcher source and icon assets
notebooks/               output-free public demonstration
scripts/                 installer, uninstaller, and privacy scan
src/gee_workbench/       read-only Python management CLI
tests/                   unit and macOS installation smoke tests
```

## Uninstallation

Remove the application while preserving your configuration:

```bash
./scripts/uninstall.sh
```

Also remove the local configuration:

```bash
./scripts/uninstall.sh --purge-config
```

## Development and verification

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -e '.[dev]'
ruff check src tests
pytest -q
bash scripts/privacy_scan.sh
bash tests/smoke.sh
```

Every public release is checked with macOS CI, Python tests, ShellCheck,
notebook structure tests, a repository privacy scan, gitleaks, CodeQL, and a
temporary-home installation test.

## Data governance

Keep authoritative raw data read-only. Separate raw, standardized,
analysis-ready, code, output, and release layers. Verify coordinate reference
systems, units, time ranges, missing values, raster alignment, and sampling
station identity before treating any AI- or GEE-generated result as suitable
for scientific publication or management decisions.

## Documentation

- [Architecture](docs/architecture.md)
- [Privacy and data governance](docs/privacy.md)
- [Security policy](SECURITY.md)
- [Third-party notices](THIRD_PARTY_NOTICES.md)
- [Contributing](CONTRIBUTING.md)

## Trademark notice

Google Earth Engine and Google are trademarks of Google LLC. Their names are
used in plain text only to describe API compatibility. No Google logo, product
icon, or official visual identity is included.

## License and citation

Original source code in this repository is released under the [MIT License](LICENSE).
Use of Earth Engine and individual datasets remains subject to their applicable
terms and licenses. Citation metadata is provided in [CITATION.cff](CITATION.cff).

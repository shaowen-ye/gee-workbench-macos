# Architecture

```text
macOS launcher
      |
      v
JupyterLab Desktop ---- public demo notebook
      |                         |
      v                         v
configured Python env ---> Earth Engine Python API
      |                         |
      +---- read-only CLI ------+
      |
      +---- optional QGIS integration
```

The launcher selects an explicit Python environment and opens the public
notebook. The CLI uses the same configuration and provides read-only project,
asset, task and quota inspection. Computation remains on Earth Engine servers.

The application does not proxy OAuth credentials and does not provide its own
cloud backend.

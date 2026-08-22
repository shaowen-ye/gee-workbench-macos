# Contributing

Contributions are welcome through issues and pull requests.

## Development setup

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -e '.[dev]'
pytest
bash tests/smoke.sh
bash scripts/privacy_scan.sh
```

Do not include credentials, private asset IDs, task IDs, exact research
locations, executed private notebooks, local paths or personal configuration.

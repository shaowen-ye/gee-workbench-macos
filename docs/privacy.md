# Privacy and data governance

## Public repository boundary

The repository contains reusable methods, launcher source, generic examples and
tests. It must not contain:

- `.env` or credential files;
- OAuth tokens, API keys or passwords;
- private Cloud project or asset identifiers;
- task IDs or quota reports;
- exact sampling coordinates or non-public research data;
- user-specific absolute paths;
- executed private notebook outputs;
- QGIS projects containing local paths or private remote layers.

## Research data

Keep authoritative raw data read-only and outside the repository. Use separate
standardized, analysis-ready and public-demo layers. A public demonstration
must use public datasets and generic locations.

## Release verification

Run the privacy scan and gitleaks against both the working tree and complete Git
history. Then clone the remote repository into a new temporary directory and
repeat all checks before declaring a release complete.

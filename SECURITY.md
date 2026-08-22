# Security policy

## Supported versions

Only the latest release is supported during the alpha stage.

## Reporting a vulnerability

Please open a private security advisory through GitHub Security Advisories.
Do not place credentials, private asset IDs, task IDs, exact research locations
or other sensitive information in public issues.

## Credential handling

GEE Workbench does not store Google OAuth tokens in the repository or its own
configuration. Authentication is delegated to the Earth Engine Python API,
which uses the standard credential location on the user's machine.

If a credential is accidentally committed, revoke or rotate it immediately and
remove it from the complete Git history; deleting only the latest file is not sufficient.

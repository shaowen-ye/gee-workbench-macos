import tomllib
from pathlib import Path

from gee_workbench import __version__

ROOT = Path(__file__).resolve().parents[1]


def test_release_versions_are_aligned() -> None:
    pyproject = tomllib.loads((ROOT / "pyproject.toml").read_text(encoding="utf-8"))
    version = pyproject["project"]["version"]
    citation = (ROOT / "CITATION.cff").read_text(encoding="utf-8")
    installer = (ROOT / "scripts/install.sh").read_text(encoding="utf-8")

    assert version == __version__
    assert f"version: {version}" in citation
    assert f"CFBundleShortVersionString -string '{version}'" in installer


def test_complete_readmes_link_to_each_other_and_use_small_logo() -> None:
    english = (ROOT / "README.md").read_text(encoding="utf-8")
    chinese = (ROOT / "README.zh-CN.md").read_text(encoding="utf-8")

    assert 'href="README.zh-CN.md"' in english
    assert 'href="README.md"' in chinese
    assert 'width="96"' in english
    assert 'width="96"' in chinese
    assert english.count("\n## ") == chinese.count("\n## ") == 16

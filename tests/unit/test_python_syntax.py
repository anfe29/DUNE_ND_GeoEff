import py_compile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]


def test_python_sources_compile():
    for path in (REPO_ROOT / "python").rglob("*.py"):
        py_compile.compile(str(path), doraise=True)

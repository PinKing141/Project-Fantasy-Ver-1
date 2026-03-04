"""Launcher shim so `python -m rpg` works from a source checkout without install."""

from pathlib import Path
from pkgutil import extend_path

__path__ = extend_path(__path__, __name__)
_src_pkg = Path(__file__).resolve().parent.parent / "src" / "rpg"
if _src_pkg.is_dir():
    __path__.append(str(_src_pkg))

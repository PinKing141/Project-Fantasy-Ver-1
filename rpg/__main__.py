"""Execute the real runtime entrypoint from src/rpg/__main__.py."""

from pathlib import Path
import runpy

_SRC_MAIN = Path(__file__).resolve().parent.parent / "src" / "rpg" / "__main__.py"
runpy.run_path(str(_SRC_MAIN), run_name="__main__")

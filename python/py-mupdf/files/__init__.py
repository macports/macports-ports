"""
Shim so that `import mupdf` works with mupdf.py/_mupdf.so installed
inside a real `mupdf` package directory (site-packages/mupdf/), rather
than upstream's own flat, package-less layout at the root of
site-packages.

The generated mupdf.py (SWIG output) does a bare `import _mupdf`. That
resolves on its own only when both files sit directly on sys.path
(upstream's flat layout). Nested one level down in a package, whether
that bare import still resolves depends on the SWIG version that
generated mupdf.py. To avoid depending on that, we pre-load _mupdf.so
under the plain name '_mupdf' in sys.modules, by absolute path, before
executing mupdf.py -- so mupdf.py's own import of _mupdf finds the
already-loaded module no matter how it's spelled.
"""
import importlib.util
import os
import sys

_dir = os.path.dirname(os.path.abspath(__file__))


def _load(mod_name, file_path):
    spec = importlib.util.spec_from_file_location(mod_name, file_path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[mod_name] = module
    spec.loader.exec_module(module)
    return module


_load("_mupdf", os.path.join(_dir, "_mupdf.so"))
_impl = _load("mupdf._impl", os.path.join(_dir, "mupdf.py"))

# Re-export everything from the real implementation module as this
# package's own top-level namespace, so `mupdf.Document(...)` etc. keep
# working exactly as with upstream's flat install.
globals().update(
    {k: v for k, v in vars(_impl).items() if not k.startswith("_")}
)

del _impl, _load, _dir, importlib, os, sys

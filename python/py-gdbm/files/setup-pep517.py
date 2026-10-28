from setuptools import Extension, setup

extensions = [
        Extension(
            name="_gdbm",
            sources=["_gdbmmodule.c"],
            include_dirs = ["__PYTHON_INCDIR__/internal", "__PREFIX__/include"],
            libraries = ["gdbm"],
            library_dirs = ["__PREFIX__/lib"]
        )
    ]
if __ADD_FREETHREADED__:
    extensions.append(
        Extension(
            name="_gdbmt",
            sources=["_gdbmmodule.c"],
            define_macros=[("Py_GIL_DISABLED", 1)],
            include_dirs = ["__PYTHON_INCDIR__/internal", "__PREFIX__/include"],
            libraries = ["gdbm"],
            library_dirs = ["__PREFIX__/lib"]
        )
    )

setup(
    ext_modules = extensions
)

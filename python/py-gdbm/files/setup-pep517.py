from setuptools import Extension, setup

setup(
    ext_modules = [
        Extension(
            name="_gdbm",
            sources=["_gdbmmodule.c"],
            include_dirs = ["__PREFIX__/include"],
            libraries = ["gdbm"],
            library_dirs = ["__PREFIX__/lib"]
        )
    ]
)

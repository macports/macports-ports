from setuptools import Extension, setup

tkversion = "__TK-VERSION__"

setup(
    ext_modules = [
        Extension(
            name="_tkinter",
            sources=["_tkinter.c", "tkappinit.c"],
            define_macros=[("WITH_APPINIT", 1)],
            include_dirs = ["__PREFIX__/include"],
            libraries = ["tcl" + tkversion, "tk" + tkversion],
            library_dirs = ["__PREFIX__/lib"]
        )
    ]
)

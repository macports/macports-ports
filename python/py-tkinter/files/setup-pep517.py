from setuptools import Extension, setup

defines=[("WITH_APPINIT", 1)]
incdirs=["__PYTHON_INCDIR__/internal", "__TK_INCDIR__", "__TCL_INCDIR__"]
if __EXTERNAL_TOMMATH__:
    defines.append(("TCL_WITH_EXTERNAL_TOMMATH", 1))
    incdirs.append("__PREFIX__/include/libtommath")

setup(
    ext_modules = [
        Extension(
            name="_tkinter",
            sources=["_tkinter.c", "tkappinit.c"],
            extra_compile_args=[__EXTRA_CFLAGS__],
            define_macros=defines,
            include_dirs=incdirs,
            libraries = ["__TCL_LIBNAME__", "__TK_LIBNAME__"],
            library_dirs = ["__TK_LIBDIR__", "__TCL_LIBDIR__", "__PREFIX__/lib"]
        )
    ]
)

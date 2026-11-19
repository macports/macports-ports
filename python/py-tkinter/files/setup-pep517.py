from setuptools import Extension, setup

defines=[("WITH_APPINIT", 1)]
incdirs=["__PYTHON_INCDIR__/internal", "__TK_INCDIR__", "__TCL_INCDIR__"]
if __EXTERNAL_TOMMATH__:
    defines.append(("TCL_WITH_EXTERNAL_TOMMATH", 1))
    incdirs.append("__PREFIX__/include/libtommath")

extensions = [
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
if __ADD_FREETHREADED__:
        extensions.append(
            Extension(
                name="_tkintert",
                sources=["_tkinter.c", "tkappinit.c"],
                extra_compile_args=[__EXTRA_CFLAGS__],
                define_macros=defines+[("Py_GIL_DISABLED", 1)],
                include_dirs=incdirs,
                libraries = ["__TCL_LIBNAME__", "__TK_LIBNAME__"],
                library_dirs = ["__TK_LIBDIR__", "__TCL_LIBDIR__", "__PREFIX__/lib"]
            )
        )

setup(
    ext_modules = extensions
)

import os, string

try:
    import distutils
    from distutils import sysconfig
    from distutils.command.install import install
    from distutils.core import setup, Extension
except:
    raise SystemExit("Distutils problem")

inc_dirs = ["__TK_INCDIR__", "__TCL_INCDIR__"]
lib_dirs = ["__TK_LIBDIR__", "__TCL_LIBDIR__"]
libs = ["__TCL_LIBNAME__", "__TK_LIBNAME__"]

setup(name = "__MODULE_NAME__",
      description = "Tk Extension to Python",
      
      ext_modules = [Extension('_tkinter', ['_tkinter.c', 'tkappinit.c'],
                               define_macros=[('WITH_APPINIT', 1)],
                               include_dirs = inc_dirs,
                               libraries = libs,
                               library_dirs = lib_dirs)]
      )

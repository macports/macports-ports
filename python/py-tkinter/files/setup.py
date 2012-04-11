import os, string

try:
    import distutils
    from distutils import sysconfig
    from distutils.command.install import install
    from distutils.core import setup, Extension
except:
    raise SystemExit("Distutils problem")

tkversion = "__TK-VERSION__"
prefix = "__PREFIX__"
inc_dirs = [prefix + "/include"]
lib_dirs = [prefix + "/lib"]
libs = ["tcl" + tkversion, "tk" + tkversion]

setup(name = "__MODULE_NAME__",
      description = "Tk Extension to Python",
      
      ext_modules = [Extension('_tkinter', ['_tkinter.c', 'tkappinit.c'],
                               define_macros=[('WITH_APPINIT', 1)],
                               include_dirs = inc_dirs,
                               libraries = libs,
                               library_dirs = lib_dirs)]
      )

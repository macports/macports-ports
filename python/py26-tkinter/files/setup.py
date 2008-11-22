try:
    import distutils
    from distutils import sysconfig
    from distutils.command.install import install
    from distutils.core import setup, Extension
except:
    raise SystemExit, "Distutils problem"

prefix = "__PREFIX__"
inc_dirs = [prefix + "/include"]
lib_dirs = [prefix + "/lib"]

setup(name = "Tkinter",
      version = "__VERSION__",
      description = "Tk Extension to Python",
      
      ext_modules = [Extension('_tkinter', ['_tkinter.c', 'tkappinit.c'],
                               define_macros=[('WITH_APPINIT', 1)],
                               include_dirs = inc_dirs,
                               libraries = ["tcl", "tk"],
                               library_dirs = lib_dirs)]
      )

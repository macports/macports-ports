try:
    import distutils
    from distutils import sysconfig
    from distutils.command.install import install
    from distutils.core import setup, Extension
except:
    raise SystemExit("Distutils problem")

prefix = "__PREFIX__"
inc_dirs = [prefix + "/include"]
lib_dirs = [prefix + "/lib"]
libs = ["gdbm"]

setup(name = "gdbm",
      version = "__VERSION__",
      description = "GDBM Extension to Python",
      
      ext_modules = [Extension('_gdbm', ['_gdbmmodule.c'],
                               include_dirs = inc_dirs,
                               libraries = libs,
                               library_dirs = lib_dirs)]
      )

try:
    import distutils
    from distutils import sysconfig
    from distutils.command.install import install
    from distutils.core import setup, Extension
except:
    raise SystemExit, "Distutils problem"

inc_dirs = ["__INCDIR__"]
lib_dirs = ["__LIBDIR__"]
libs = ["db"]

setup(name = "_bsddb",
      version = "__VERSION__",
      description = "BSDDB Extension to Python",
      
      ext_modules = [Extension('_bsddb', ['_bsddb.c'],
                               include_dirs = inc_dirs,
                               libraries = libs,
                               library_dirs = lib_dirs)]
      )

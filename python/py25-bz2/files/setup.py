try:
    import distutils
    from distutils import sysconfig
    from distutils.command.install import install
    from distutils.core import setup, Extension
except:
    raise SystemExit, "Distutils problem"

inc_dirs = ["__INCDIR__"]
lib_dirs = ["__LIBDIR__"]
libs = ["bz2"]

setup(name = "bz2",
      version = "__VERSION__",
      description = "bz2 Extension to Python",
      
      ext_modules = [Extension('bz2', ['bz2module.c'],
                               include_dirs = inc_dirs,
                               libraries = libs,
                               library_dirs = lib_dirs)]
      )

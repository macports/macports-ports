try:
    import distutils
    from distutils import sysconfig
    from distutils.command.install import install
    from distutils.core import setup, Extension
except:
    raise SystemExit, "Distutils problem"

inc_dirs = ["__INCDIR__"]
lib_dirs = ["__LIBDIR__"]

sqlite_defines = []
sqlite_defines.append(('MODULE_NAME', '"sqlite3"'))
sqlite_srcs = ['_sqlite/cache.c', \
    '_sqlite/connection.c', \
    '_sqlite/cursor.c', \
    '_sqlite/microprotocols.c', \
    '_sqlite/module.c', \
    '_sqlite/prepare_protocol.c', \
    '_sqlite/row.c', \
    '_sqlite/statement.c', \
    '_sqlite/util.c']

setup(name = "_sqlite3",
      version = "__VERSION__",
      description = "sqlite3 Extension to Python",
      
      ext_modules = [Extension('_sqlite3', sqlite_srcs,
                               define_macros=sqlite_defines,
                               include_dirs = ["_sqlite", inc_dirs],
                               libraries = ["sqlite3"],
                               library_dirs = lib_dirs)]
      )


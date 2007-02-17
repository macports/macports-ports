try:
    import distutils
    from distutils import sysconfig
    from distutils.command.install import install
    from distutils.core import setup, Extension
except:
    raise SystemExit, "Distutils problem"

inc_dirs = ["__INCDIR__"]
lib_dirs = ["__LIBDIR__"]
libs = ["ncursesw"]

setup(name = "_curses",
      version = "__VERSION__",
      description = "curses Extension to Python",
      
      ext_modules = [Extension('_curses', ['_cursesmodule.c'],
                               include_dirs = inc_dirs,
                               libraries = libs,
                               library_dirs = lib_dirs)]
      )
setup(name = "_curses_panel",
      version = "__VERSION__",
      description = "curses panel Extension to Python",
      
      ext_modules = [Extension('_curses_panel', ['_curses_panel.c'],
                               include_dirs = inc_dirs,
                               libraries = libs,
                               library_dirs = lib_dirs)]
      )

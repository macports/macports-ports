try:
    import distutils
    from distutils import sysconfig
    from distutils.command.install import install
    from distutils.core import setup, Extension
except:
    raise SystemExit, "Distutils problem"

setup(name = "aspects",
      version = "VERSION",
      description = "aspect oriented programming for python",
      py_modules=['aspects']
      )

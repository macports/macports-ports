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
libs = ["crypto","ssl"]

setup(name = "_ssl",
      version = "__VERSION__",
      description = "OpenSSL secure socket Extension to Python",
      
      ext_modules = [Extension('_ssl', ['_ssl.c'],
                               include_dirs = inc_dirs,
                               libraries = libs,
                               library_dirs = lib_dirs)]
      )

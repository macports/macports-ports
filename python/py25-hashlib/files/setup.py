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

setup(name = "_hashlib",
      version = "__VERSION__",
      description = "OpenSSL HashLib Extension to Python",
      
      ext_modules = [Extension('_hashlib', ['_hashopenssl.c'],
                               include_dirs = inc_dirs,
                               libraries = libs,
                               library_dirs = lib_dirs)]
      )

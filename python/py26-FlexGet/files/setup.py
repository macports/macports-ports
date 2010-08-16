from distutils.core import setup

setup(name = 'FlexGet',
      version = '@VERSION@',
      packages = ['flexget', 'flexget.plugins', 'flexget.utils'],
      scripts = ['scripts/flexget'])

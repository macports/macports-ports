from distutils.core import setup

with open("README.rst", "r") as f:
    readme = f.read()

setup(name='testpath',
      version='@VERSION@',
      description='Test utilities for code working with files and commands',
      long_description = readme,
      author='Thomas Kluyver',
      author_email='thomas@kluyver.me.uk',
      url='https://github.com/takluyver/testpath',
      packages=['testpath'],
      classifiers=[
          'Intended Audience :: Developers',
          'License :: OSI Approved :: MIT License',
          'Programming Language :: Python',
          'Programming Language :: Python :: 2',
          'Programming Language :: Python :: 3',
          'Topic :: Software Development :: Testing',
      ]
)

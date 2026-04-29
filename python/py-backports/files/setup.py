# -*- coding: utf-8 -*-
from distutils.core import setup
setup(name='backports',
      version='1.0',
      description='Namespace for backported Python features',
      long_description=u"""\
A few minutes ago,
my fingers were poised for a moment above the keyboard
as I prepared to backport the essential ``match_hostname()`` function
(without which the Secure Sockets Layer is not actually *secure!*)
from the Python 3.2 version of the ``ssl`` Standard Library
to earlier versions of Python.
Suddenly, I paused: what would I call the new distribution
that I created in the Package Index to hold this small function?

It seemed a shame to consume an entire top-level name
in the Package Index for what is, after all, a stopgap measure
until older versions of Python are one day retired.

And so I conceived this ``backports`` namespace package.
It reserves a namespace beneath which we can happy place
all of the various features that we want to cut-and-paste
from later Python versions.
I hope that this will provide two benefits:

1. It should provide greater sanity, and a bit more organization,
   in the Package Index.

2. When you are ready to port a Python application
   to a new version of Python,
   you can search the code for any ``import`` statements
   that name a ``backports`` package,
   and remove the backports for features that have now “arrived”
   in the version of Python to which you are upgrading.

I have considered calling for all ``backports`` packages
to issue a warning upon import if they detect that they are
running under a version of Python that has now gained the feature
they offer, but I think that will be unkind to actual users,
since the most widespread versions of Python today still
display warnings by default.

Building your own backports module
----------------------------------

Placing a module of your own inside of the ``backports`` namespace
requires only a few simple steps. First, set your project up like::

    project/
    project/setup.py
    project/backports/
    project/backports/__init__.py   <--- SPECIAL - see below!
    project/backports/yourpkg/
    project/backports/yourpkg/__init__.py
    project/backports/yourpkg/foo.py
    project/backports/yourpkg/bar.py

This places your own package inside of the ``backports`` namespace,
so your package and its modules can be imported like this::

    import backports.yourpkg
    import backports.yourpkg.foo

The one **absolutely essential rule** is that the ``__init__.py`` inside
of the ``backports`` directory itself **must** have the following code
as its content::

    # A Python "namespace package" http://www.python.org/dev/peps/pep-0382/
    # This always goes inside of a namespace package's __init__.py

    from pkgutil import extend_path
    __path__ = extend_path(__path__, __name__)

If you fail to include this code, then the namespace package might fail
to see all of the packages beneath it, and ``import`` statements might
return errors.

A live example of a package that implements all of this can be
downloaded from the Python Package Index:

http://pypi.python.org/pypi/backports.ssl_match_hostname/3.2a3

What if the feature is present?
-------------------------------

An issue on which I am undecided is whether a ``backports`` package,
if it finds itself on a modern enough version of Python,
should simply import the “real” version of its feature
from the Standard Library instead of offering the replacement.
My guess is that this is *not* a good idea,
because if — for some reason — an incompatibility crops up
bewteen the tweaked code in a backport
and the official code in the modern Standard Library,
then it would be nice for developers using the backport
to be faced with that breakage when they themselves
try removing the backport,
instead of being faced with it simply because a user
tries running their program on more modern version of Python.

""",
      author='Brandon Craig Rhodes',
      author_email='brandon@rhodesmill.org',
      url='http://bitbucket.org/brandon/backports',
      packages=['backports'],
      )

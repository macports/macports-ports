#!/usr/bin/env python

import glob, os, sys
from distutils.core import setup, Extension

dnet_srcs = [ './dnet.c' ]
dnet_incdirs = [ '../include' ]
dnet_libdirs = []
dnet_libs = []
dnet_extargs = []
dnet_extobj = []

if sys.platform == 'win32':
    winpcap_dir = '../../WPdpack'
    dnet_srcs.extend(['../src/addr-util.c', '../src/addr.c', '../src/blob.c', '../src/ip-util.c', '../src/ip6.c', '../src/rand.c', '../src/err.c', '../src/strlcat.c', '../src/strlcpy.c', '../src/err.c', '../src/strlcat.c', '../src/strlcpy.c', '../src/strsep.c', '../src/arp-win32.c', '../src/eth-win32.c', '../src/fw-pktfilter.c', '../src/intf-win32.c', '../src/ip-win32.c', '../src/route-win32.c', '../src/tun-none.c'])
    dnet_incdirs.append(winpcap_dir + '/Include')
    dnet_libdirs.append(winpcap_dir + '/Lib')
    dnet_libs.extend([ 'advapi32', 'iphlpapi', 'ws2_32', 'packet' ])
else:
    # XXX - can't build on Cygwin+MinGW yet.
    #if sys.platform == 'cygwin':
    #    dnet_extargs.append('-mno-cygwin')
    dnet_extobj.extend(glob.glob('../src/.libs/*.o'))

dnet = Extension('dnet',
                 map(os.path.realpath, dnet_srcs),
                 include_dirs=map(os.path.realpath, dnet_incdirs),
                 library_dirs=map(os.path.realpath, dnet_libdirs),
                 libraries=dnet_libs,
                 extra_compile_args=dnet_extargs,
                 extra_objects=map(os.path.realpath, dnet_extobj))

setup(name='dnet',
      version='1.10',
      description='low-level networking library',
      author='Dug Song',
      author_email='dugsong@monkey.org',
      url='http://libdnet.sourceforge.net/',
      ext_modules = [ dnet ])

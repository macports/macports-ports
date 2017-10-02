PortSystem      1.0
PortGroup       github 1.0

github.setup    signal11 hidapi 0.8.0-rc1 hidapi-
name            libhidapi

categories      devel
maintainers     nomaintainer
description     library for HID device access
long_description \
    library for use by user level applications to \
    access HID-class devices regardless of OS. \
    On OS X, access to HID devices is provided through \
    IOHidManager.
license         {GPL-3 BSD HIDAPI}
homepage        http://www.signal11.us/oss/hidapi/
platforms       darwin

# Github project archive files conform to neither the 'downloads' nor the
# 'releases' scheme supported by the github 1.0 portgroup.
github.master_sites https://github.com/${github.author}/${github.project}/archive/

# Override non-standard tag names for github livecheck
distname        hidapi-${version}

checksums       rmd160  546c7df938595fa7c731c5f44477158626728fa3 \
                sha256  3c147200bf48a04c1e927cd81589c5ddceff61e6dac137a605f6ac9793f4af61

worksrcdir      hidapi-hidapi-${version}

use_autoreconf  yes

variant testgui description {Test GUI for libhidapi} {
   configure.args-append  --enable-testgui
       depends_lib-append    port:fox
}

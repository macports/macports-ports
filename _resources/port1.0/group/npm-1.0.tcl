# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# This PortGroup supports npm modules.
#
# It essentially imitates what npm install -g does.

options npm.rootname
default npm.rootname    {[option name]}

default master_sites    {https://registry.npmjs.org/${npm.rootname}/-/}
default distname        {${npm.rootname}-${version}}

extract.suffix .tgz

options npm.nodejs_version
default npm.nodejs_version 16

options npm.version
default npm.version 8

default livecheck.type  regex
default livecheck.url   {https://registry.npmjs.org/${npm.rootname}/latest}
default livecheck.regex {\\"version\\":\\"(\[^\\"\]+)\\"}

depends_build-append    path:bin/npm:npm${npm.version}

depends_lib-append      path:bin/node:nodejs${npm.nodejs_version}

# Pass the tarball distfile to 'npm install' directly, since running 'npm
# install' from the extracted directory creates a symlink to the directory
# (which gets removed). Since there's no need to extract the tarball, disable
# the extraction step.
extract {}

use_configure no

build   {}

destroot {
    system "npm install -ddd --global --prefix=${destroot}${prefix} ${distpath}/${distfiles}"
}

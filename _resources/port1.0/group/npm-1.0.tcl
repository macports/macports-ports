# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# This PortGroup supports npm modules.
#
# It essentially imitates what npm install -g does.

options npm.rootname
default npm.rootname    {${name}}

default master_sites    {https://registry.npmjs.org/${npm.rootname}/-/}
default distname        {${npm.rootname}-${version}}

extract.suffix .tgz

options npm.nodejs_version npm.version npm.add_dependencies
default npm.nodejs_version 22
default npm.version 10
default npm.add_dependencies yes

default livecheck.type  regex
default livecheck.url   {https://registry.npmjs.org/${npm.rootname}/latest}
default livecheck.regex {\\"version\\":\\"(\[^\\"\]+)\\"}

proc npm_add_dependencies {} {
    global npm.version npm.nodejs_version
    depends_build-delete    path:bin/npm:npm${npm.version}
    depends_lib-delete      path:bin/node:nodejs${npm.nodejs_version}
    depends_build-append    path:bin/npm:npm${npm.version}
    depends_lib-append      path:bin/node:nodejs${npm.nodejs_version}
}
port::register_callback npm_add_dependencies

# Pass the tarball distfile to 'npm install' directly, since running 'npm
# install' from the extracted directory creates a symlink to the directory
# (which gets removed). Since there's no need to extract the tarball, disable
# the extraction step.
extract.only

use_configure no

build   {}

destroot {
    system -W ${workpath} "npm install -ddd --global --prefix=${destroot}${prefix} ${distpath}/${distfiles}"
}

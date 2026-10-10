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

# A path: dependency is satisfied by ANY ${prefix}/bin/node, and the ten nodejs
# ports all provide one while conflicting with each other. So a user holding
# nodejs8 satisfies path:bin/node:nodejs22, no newer nodejs is pulled in, and the
# port installs against a node it was never meant to run on -- silently, because
# path: cannot express a minimum version. Fail early and say which port to
# install instead.
pre-fetch {
    global npm.nodejs_version prefix name
    set node ${prefix}/bin/node
    # Not installed yet: the dependency will bring in the right one.
    if {![file executable ${node}]} {
        return
    }
    if {[catch {exec ${node} --version 2>@1} v]} {
        ui_warn "could not determine the node version: ${v}"
        return
    }
    if {![regexp {^v(\d+)\.} ${v} -> major]} {
        ui_warn "could not parse the node version: ${v}"
        return
    }
    if {${major} < ${npm.nodejs_version}} {
        return -code error \
            "${name} needs node ${npm.nodejs_version} or newer, but\
             ${node} is ${v}. Install nodejs${npm.nodejs_version} first;\
             the nodejs ports conflict, so the older one has to go."
    }
}

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

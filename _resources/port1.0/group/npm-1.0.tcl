# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup is mainly used for npm ports (e.g. npm7). It helps setting up conflicts/dependencies/etc.
#
# Usage:
#
#     PortGroup            npm 1.0
#     npm.setup            version
#
# It also makes publically accessible which node version each NPM/yarn depends on.
# This can be accessed via [node_version NPM_VERSION]
# e.g. npm7: [node_version 7] returns 16 for nodejs16
#      yarn: [node_version yarn]


# Set the minimum and maximum versions of npm
# Required for livecheck and for setting conflicts
# Also used by javascript portgroup
options npm.maximum_version npm.minimum_version
default npm.maximum_version 7
default npm.minimum_version 3


# This publically makes accessible which node version goes with which npm/yarn.
# N.B. the npm.major of yarn is "yarn"
proc node_version {npm.major} {
    global os.major

    # The platform is already darwin, so no need to double check
    if {${npm.major} <= 5 || ${os.major} < 13} {
        return 8
    } else {
        return 16
    }
}

use_configure       no

# Set all npm-specific attributes in npm.setup
# This is only used by npm-based ports
options npm.major npm.version
proc npm.setup {npm_version} {
    global prefix destroot distname conflicts
    global npm.major npm.version npm.maximum_version npm.minimum_version
    global PortInfo

    npm.version         ${npm_version}

    # This returns the first number of the npm version
    # e.g. 7 for npm7
    npm.major           [lindex [split ${npm.version} .] 0]

    if {!([info exists PortInfo(name)] && (${PortInfo(name)} ne "npm${npm.major}"))} {
        name            npm${npm.major}
    }

    categories          devel
    platforms           darwin
    license             MIT

    supported_archs     noarch

    homepage            https://www.npmjs.com/

    description         node package manager
    long_description    npm is a package manager for node. \
                        You can use it to install and publish your node programs. \
                        It manages dependencies and does other cool stuff.

    worksrcdir          "package"

    version             ${npm.version}

    master_sites        https://registry.npmjs.org/npm/-/
    distname            npm-${npm.version}
    extract.suffix      .tgz

    # Add all the conflicts
    for {set index ${npm.minimum_version}} { $index <= ${npm.maximum_version} } { incr index } {
        if {${index} ne ${npm.major}} {
            lappend conflicts npm${index}
        }
    }

    depends_lib         port:nodejs[node_version ${npm.major}]
    
    destroot.destdir    --prefix=${destroot}${prefix}
    
    # As of npm5 installing from a directory will result in a symlink being used. 
    # Change the install to use the built in pack functionality instead.
    if {${npm.major} >= 5} {
        build {
            system -W ${worksrcpath} "NPM_CONFIG_UNSAFE_PERM=false ${prefix}/bin/node bin/npm-cli.js pack"
        }
    
        destroot.cmd        ${prefix}/bin/node ./bin/npm-cli.js
        destroot.args       --global ${distname}.tgz
    } else {
        build               {}
        
        destroot.cmd        ${prefix}/bin/node ./cli.js
        destroot.args       --global .
    }

    post-destroot {
        set completions_path ${destroot}${prefix}/share/bash-completion/completions/
        xinstall -d ${completions_path}
        xinstall -m 644 ${worksrcpath}/lib/utils/completion.sh ${completions_path}/npm
    }

    notes "
    It is not recommended to install packages globally. But if you do so\
    please be aware that they won't get cleaned up when you deactivate\
    or uninstall npm${npm.major}. Globally installed packages will remain in\
    ${prefix}/lib/node_modules/ until you manually delete them.
    "
    
    livecheck.type      regex
    livecheck.url       https://registry.npmjs.org/npm

    # The latest version of npm has a slightly different livecheck
    if {${npm.maximum_version} eq ${npm.major}} {
        livecheck.regex \"latest\":"(.*?)"
    } else {
        livecheck.regex \"latest-${npm.major}\":"(.*?)"
    }
}

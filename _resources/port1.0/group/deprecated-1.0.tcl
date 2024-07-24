# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# This PortGroup is used to indicate that a port is deprecated.
# Ports using this PortGroup are not necessarily about to be removed, but usage of those ports is discouraged.
# Some possible reasons for deprecation:
#     * the port no longer builds on recent versions of macOS and/or Xcode
#     * the project is no longer maintained upstream
#     * the port is severely out of date, and maintaining it has become a burden no-one wants to take on

# deprecated.maximum_xcodeversion: maximum version of Xcode supported
# deprecated.maximum_osmajor:      maximum OS version supported
# deprecated.upstream_support:     is the project supported upstream?
# deprecated.macports_support:     does the project have proper support from the MacPorts maintainers?

options deprecated.maximum_xcodeversion \
        deprecated.maximum_osmajor      \
        deprecated.upstream_support     \
        deprecated.macports_support     \
        deprecated.eol_version
default deprecated.maximum_xcodeversion  {}
default deprecated.maximum_osmajor       {}
default deprecated.upstream_support      yes
default deprecated.macports_support      yes
default deprecated.eol_version           no


proc deprecated.deprecate_port {} {
    global deprecated.maximum_xcodeversion \
           deprecated.maximum_osmajor \
           deprecated.upstream_support \
           deprecated.macports_support \
           deprecated.eol_version \
           os.platform \
           os.major \
           xcodeversion
    if {${os.platform} eq "darwin" && (${deprecated.maximum_osmajor} ne {}) && ([vercmp ${os.major} > ${deprecated.maximum_osmajor}])} {
        depends_lib
        depends_run
        archive_sites
        known_fail yes
        pre-fetch {
            ui_error "building ${name} is not supported on OS version greater than ${deprecated.maximum_osmajor}"
            return -code error {unsupported platform}
        }
    } elseif {${os.platform} eq "darwin" && (${deprecated.maximum_xcodeversion} ne {}) && ([vercmp ${xcodeversion} > ${deprecated.maximum_xcodeversion}])} {
        depends_lib
        depends_run
        archive_sites
        known_fail yes
        pre-fetch {
            ui_error "building ${name} is not supported with Xcode greater than ${deprecated.maximum_xcodeversion}"
            return -code error {unsupported platform}
        }
    } elseif {!${deprecated.upstream_support}} {
        notes-prepend "
This port is deprecated since the project is no longer maintained upstream.\
It is likely to be removed from MacPorts at some point in the future.\
If you find this port useful and would like to see it continue, please consider posting to the macports-users mailing list.\
See https://trac.macports.org/wiki/MailingLists for more details.
" ""
    } elseif {!${deprecated.macports_support}} {
        notes-prepend "
This port is deprecated due to the difficulty of maintaining it.\
It is possible it will be removed from MacPorts at some point in the future.\
If you find this port useful and would like to see it continue, please consider contributing to the MacPort project.\
See https://guide.macports.org/chunked/project.contributing.html for more details.
" ""
    } elseif {${deprecated.eol_version}} {
        notes-prepend "
This port is for a software version that is no longer receiving upstream updates. It may have security vulnerabilities\
or other issues that will not be fixed. Newer versions are provided as separate ports.
" ""
    }
}

port::register_callback deprecated.deprecate_port

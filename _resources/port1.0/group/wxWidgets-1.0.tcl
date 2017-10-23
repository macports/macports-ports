# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup is to be used with all projects that depend on wxWidgets
# (including some that need wxPython).
#
# Usage:
#
# After the PortSystem 1.0 line, put:
#
#   PortGroup           wxWidgets 1.0
#
# Then, assuming that the port needs wxWidgets 3.0, use
#
#   wxWidgets.use       wxWidgets-3.0
#
# to specify the version/variant of wxWidgets.
#
# Valid options for wxWidgets.use are as follows:
#
# * 'wxWidgets-3.0'
#   You should generally use this one unless there are valid reasons for
#   a different choice.
#
# * 'wxPython-3.0'
#   This is almost the same as 'wxWidgets-3.0' except that a separate
#   instance of wxWidgets was made available for cases when wxPython
#   releases lag behind the wxWidgets releases.
#   You should only use this option for ports that need both wxPython
#   (usually py27-wxpython) as well as require linking of C++ code against
#   wxWidgets via the usual ./configure && make. Using 'wxPython-3.0'
#   avoids any version mismatches between wxPython and wxWidgets.
#
# * 'wxWidgets-2.8' or 'wxGTK-2.8'
#   For projects that are still not fully compatible with wxWidgets 3.0
#   (even though we strongly encourage you to try to make the package work
#   with wxWidgets 3.0 instead).
#   'wxWidgets-2.8' requires Carbon and can only be compiled as 32-bit app
#   against MacOSX10.6.sdk or earlier. It gives a native look and feel and
#   might be preferred to wxGTK on systems where it works.
#   'wxGTK-2.8' should work on modern systems as well, but depends on X11.
#
# * 'wxGTK-3.0'
#   Mainly for testing purposes. wxGTK 3.0 currently uses GTK 3 (and could
#   be compiled against quartz if desired). Many programs make assumptions
#   that GTK != Mac, some programs work with wxGTK, but not with wxOSX.
#   This could help you write proper patches and submit them upstream.
#
# * 'wxWidgets-3.0-libcxx'
#   A workaround to make software written in C++11 (but without other C++
#   dependencies) work on macOS < 10.9. This is just wxWidgets 3.0
#   compiled against libc++ even where libstdc++ is default. See also
#   https://trac.macports.org/wiki/LibcxxOnOlderSystems
#
# * 'wxWidgets-3.0-devel'
#   Tracking latest commits from the 3.0 branch for development purposes.
#   (This variant will be removed at some point, so try not to rely on its
#   existence.)
#
# * 'wxWidgets-3.2'
#   At the moment still mainly for development purposes, for testing ports
#   for compatibility with wxWidgets 3.1/3.2.
#   It uses wxWidgets 3.1 at the moment, but will switch to wxWidgets 3.2
#   after the first release of version 3.2 becomes available.
#   If you already want to provide a special variant for your port with
#   'wxWidgtes-3.2', you might only need a revbump after the switch to 3.2
#
#
# You should note an important aspect of 'wxWidgets.use' though:
# it does not actually do anything useful yet other than failing during
# the 'pre-fetch' phase in case your OS is not compatible with the choice.
#
# To actually use wxWidgets, you need at least two additional steps:
#
# * add a dependency with
#   depends_lib[-append] port:${wxWidgets.port}
#
# * add the appropriate configure flags
#   (depending on the project configuration/requirements)
#
# For adding appropirate configure flags you can you use any of the
# following variables:
#
# * wxWidgets.prefix
# * wxWidgets.wxdir
# * wxWidgets.wxconfig
# * wxWidgets.wxrc
#
# Examples of their typical values are:
#
# * wxWidgets.prefix (PATH)
#   /opt/local/Library/Frameworks/wxWidgets.framework/Versions/wxWidgets/3.0
#
# * wxWidgets.wxdir (PATH)
#   /opt/local/Library/Frameworks/wxWidgets.framework/Versions/wxWidgets/3.0/bin
#
# * wxWidgets.wxconfig (SHELL SCRIPT)
#   /opt/local/Library/Frameworks/wxWidgets.framework/Versions/wxWidgets/3.0/bin/wx-config
#
# * wxWidgets.wxrc (BINARY)
#   /opt/local/Library/Frameworks/wxWidgets.framework/Versions/wxWidgets/3.0/bin/wxrc
#
#
# You should study your port's build scripts to figure out the proper
# configuration flag. A typical configure-based build would work with:
#
#   configure.args[-append] \
#       --with-wxdir=${wxWidgets.wxdir}
#
# and equally well with either one of the following:
#
#       --with-wx-config=${wxWidgets.wxconfig}
#       --with-wx-prefix=${wxWidgets.prefix}
#
# A CMake-based installation could require
#
#   configure.args-append \
#       -DwxWidgets_CONFIG_EXECUTABLE=${wxWidgets.wxconfig}
#
# and/or:
#
#       -DwxWidgets_wxrc_EXECUTABLE=${wxWidgets.wxrc}
#
# Sometimes enviromental variables are required, like:
#
#   configure.env[-append] \
#       WX_CONFIG=${wxWidgets.wxconfig}
#
# and/or:
#
#       WXRC=${wxWidgets.wxrc}
#
# But you should always check the build documentation.
#
#
# You are strongly encouraged not to use any hardcoded values
# (not even for the port name)
# to minimize problems in case the layout changes in the future.
# If you switch to a different version of wxWidgets it would also be
# sufficient to change one single line line with 'wxWidgets.use <name>'.

options     wxWidgets.name
options     wxWidgets.port
options     wxWidgets.version
options     wxWidgets.prefix

options     wxWidgets.wxdir
options     wxWidgets.wxconfig
options     wxWidgets.wxrc

options     wxWidgets.sdk
options     wxWidgets.macosx_version_min

# set to empty
wxWidgets.name
wxWidgets.port
wxWidgets.version
wxWidgets.prefix
wxWidgets.wxdir
wxWidgets.wxconfig
wxWidgets.wxrc
wxWidgets.sdk
wxWidgets.macosx_version_min

options     wxWidgets.use
option_proc wxWidgets.use wxWidgets._set

PortGroup   compiler_blacklist_versions 1.0

## TODO: it would be nice to make the changes reversible
##
## parameters:
## - wxWidgets-2.8
## - wxGTK-2.8
## - wxWidgets-3.0
## - wxGTK-3.0
## - wxPython-3.0
## - wxWidgets-3.0-libcxx
## - wxWidgets-3.0-devel
## - wxWidgets-3.2
proc wxWidgets._set {option action args} {
    global prefix frameworks_dir os.major
    global wxWidgets.name wxWidgets.version wxWidgets.prefix wxWidgets.wxdir
    if {"set" ne ${action}} {
        return
    }

    if {${args} eq "wxWidgets-2.8"} {
        wxWidgets.name      "wxWidgets"
        wxWidgets.version   "2.8"
        wxWidgets.port      "wxWidgets-2.8"

        # wxWidgets is not universal and is 32-bit only
        universal_variant   no
        supported_archs     i386 ppc

        # wxWidgets-2.8 fails to build with clang
        compiler.blacklist  *clang*

        pre-fetch {
            # 10.8 (or later) -or- 10.7 with Xcode 4.4 (or later)
            if {${os.major} >= 12 || [vercmp $xcodeversion 4.4] >= 0} {
                ui_error "${wxWidgets.port} cannot be built on macOS >= 10.7 with Xcode >= 4.4; please use port wxWidgets-3.0 or wxgtk-2.8 instead"
                return -code return "wxWidgets-2.8 cannot be built on macOS >= 10.7 with Xcode >= 4.4; please use port wxWidgets-3.0 or wxgtk-2.8 instead"
            } else {
                # 10.7
                if {${os.major} == 11} {
                    if {[vercmp $xcodeversion 4.3] < 0} {
                        set sdks_dir "${developer_dir}/SDKs"
                    } else {
                        set sdks_dir "${developer_dir}/Platforms/MacOSX.platform/Developer/SDKs"
                    }
                    wxWidgets.sdk "${sdks_dir}/MacOSX10.6.sdk"
                    wxWidgets.macosx_version_min "10.6"
                }
            }
        }
    } elseif {${args} eq "wxGTK-2.8"} {
        wxWidgets.name      "wxGTK"
        wxWidgets.version   "2.8"
        wxWidgets.port      "wxgtk-2.8"
    } elseif {${args} eq "wxGTK-3.0"} {
        wxWidgets.name      "wxGTK"
        wxWidgets.version   "3.0"
        wxWidgets.port      "wxgtk-3.0"
    } elseif {${args} eq "wxWidgets-3.0"} {
        wxWidgets.name      "wxWidgets"
        wxWidgets.version   "3.0"
        wxWidgets.port      "wxWidgets-3.0"
        if {${os.major} < 9} {
            pre-fetch {
                ui_error "${wxWidgets.port} requires macOS 10.5 or later."
                return -code error "incompatible macOS version"
            }
        }
    } elseif {${args} eq "wxPython-3.0"} {
        wxWidgets.name      "wxPython"
        wxWidgets.version   "3.0"
        wxWidgets.port      "wxPython-3.0"
        if {${os.major} < 9} {
            pre-fetch {
                ui_error "${wxWidgets.port} requires macOS 10.5 or later."
                return -code error "incompatible macOS version"
            }
        }
    # ugly workaround to allow some C++11-only applications to be built on < 10.9
    } elseif {${args} eq "wxWidgets-3.0-libcxx"} {
        wxWidgets.name      "wxWidgets"
        wxWidgets.version   "3.0-libcxx"
        wxWidgets.port      "wxWidgets-3.0-libcxx"
        if {${os.major} < 9} {
            pre-fetch {
                ui_error "${wxWidgets.port} requires macOS 10.5 or later."
                return -code error "incompatible macOS version"
            }
        }
    # ugly workaround to allow some C++11-only applications to be built on < 10.9
    } elseif {${args} eq "wxWidgets-3.0-cxx11"} {
        global cxx_stdlib
        wxWidgets.name      "wxWidgets"
        if {${cxx_stdlib} eq "libstdc++"} {
            wxWidgets.version   "3.0-cxx11"
            wxWidgets.port      "wxWidgets-3.0-cxx11"
        } else {
            wxWidgets.version   "3.0"
            wxWidgets.port      "wxWidgets-3.0"
        }
        if {${os.major} < 9} {
            pre-fetch {
                ui_error "${wxWidgets.port} requires macOS 10.5 or later."
                return -code error "incompatible macOS version"
            }
        }
    # temporary development version of wxWidgets 3.0.x
    } elseif {${args} eq "wxWidgets-3.0-devel"} {
        wxWidgets.name      "wxWidgets"
        wxWidgets.version   "3.0-devel"
        wxWidgets.port      "wxWidgets-3.0-devel"
        if {${os.major} < 9} {
            pre-fetch {
                ui_error "${wxWidgets.port} requires macOS 10.5 or later."
                return -code error "incompatible macOS version"
            }
        }
    # preliminary support for wxWidgets 3.1/3.2
    } elseif {${args} eq "wxWidgets-3.2"} {
        wxWidgets.name      "wxWidgets"
        wxWidgets.version   "3.1"
        wxWidgets.port      "wxWidgets-3.1"
        if {${os.major} < 11} {
            pre-fetch {
                ui_error "${wxWidgets.port} requires macOS 10.7 or later."
                return -code error "incompatible macOS version"
            }
        }
    } else {
        # throw an error
        ui_error "invalid parameter for wxWidgets.use; use one of:\n\twxWidgets-2.8/wxGTK-2.8/wxWidgets-3.0/wxGTK-3.0/wxPython-3.0/wxWidgets-3.2"
        # wxWidgets-3.0-libcxx, wxWidgets-3.0-devel
        return -code return "invalid parameter for wxWidgets.use"
    }
    wxWidgets.prefix    ${frameworks_dir}/wxWidgets.framework/Versions/${wxWidgets.name}/${wxWidgets.version}

    wxWidgets.wxdir     ${wxWidgets.prefix}/bin
    wxWidgets.wxconfig  ${wxWidgets.wxdir}/wx-config
    wxWidgets.wxrc      ${wxWidgets.wxdir}/wxrc

    if {[string match "wxWidgets-3.0*" ${args}]} {
        # the following causes a crash on older versions of clang:
        #    #define wx_has_cpp11_include(h) __has_include(h)
        #    #if wx_has_cpp11_include(<unordered_map>)
        # see https://trac.macports.org/ticket/54296
        compiler.blacklist-append {clang < 500}
    }
}

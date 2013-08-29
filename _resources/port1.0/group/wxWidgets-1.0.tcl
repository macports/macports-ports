# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# $Id$

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

## TODO:
## If the need for this ever arises ...
##
## This parameter could be set for every port and could be useful on Tiger
## to switch to 2.8 automatically even when 3.0 is the default elsewhere
## or to provent using 3.0 for ports that don't support this
##
## With proper implementation wxWidgets.use should only be needed in Portfile
## in special cases (when a specific port wants to support multiple wxWidgets versions)
#
# options     wxWidgets.supported_versions
# option_proc wxWidgets.supported_versions wxWidgets._set_supported_versions
# proc wxWidgets._set_supported_versions {option action args} {}

## TODO: it would be nice to make the changes reversible
##
## parameters: "wxWidgets-2.8" "wxGTK-2.8" "wxWidgets-3.0" "wxGTK-3.0" "wxPython-3.0"
proc wxWidgets._set {option action args} {
    global prefix frameworks_dir os.major
    global wxWidgets.name wxWidgets.version wxWidgets.prefix wxWidgets.wxdir
    if {"set" != ${action}} {
        return
    }

    if {${args} == "wxWidgets-2.8"} {
        wxWidgets.name      "wxWidgets"
        wxWidgets.version   "2.8"
        wxWidgets.port      "wxWidgets-2.8"

        # wxWidgets is not universal and is 32-bit only
        universal_variant   no
        supported_archs     i386 ppc
        compiler.blacklist  clang

        pre-fetch {
            # 10.8 (or later) -or- 10.7 with Xcode 4.4 (or later)
            if {${os.major} >= 12 || [vercmp $xcodeversion 4.4] >= 0} {
                ui_error "${wxWidgets.port} cannot be built on Moc OS X >= 10.7 with Xcode >= 4.4, please use port wxWidgets-3.0 or wxgtk-2.8 instead"
                return -code return "wxWidgets-2.8 cannot be built on Moc OS X >= 10.7 with Xcode >= 4.4, please use port wxWidgets-3.0 or wxgtk-2.8 instead"
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
    } elseif {${args} == "wxGTK-2.8"} {
        wxWidgets.name      "wxGTK"
        wxWidgets.version   "2.8"
        wxWidgets.port      "wxgtk-2.8"
    } elseif {${args} == "wxGTK-3.0"} {
        wxWidgets.name      "wxGTK"
        wxWidgets.version   "2.9"
        wxWidgets.port      "wxgtk-3.0"
    } elseif {${args} == "wxWidgets-3.0"} {
        wxWidgets.name      "wxWidgets"
        wxWidgets.version   "2.9"
        wxWidgets.port      "wxWidgets-3.0"
        if {${os.major} < 9} {
            pre-fetch {
                ui_error "${wxWidgets.port} requires Mac OS X 10.5 or later."
                return -code error "incompatible Mac OS X version"
            }
        }
    } elseif {${args} == "wxPython-3.0"} {
        wxWidgets.name      "wxPython"
        wxWidgets.version   "2.9"
        wxWidgets.port      "wxPython-3.0"
        if {${os.major} < 9} {
            pre-fetch {
                ui_error "${wxWidgets.port} requires Mac OS X 10.5 or later."
                return -code error "incompatible Mac OS X version"
            }
        }
    } else {
        # throw an error
        ui_error "invalid parameter for wxWidgets.use; use one of: wxWidgets-2.8/wxGTK-2.8/wxWidgets-3.0/wxGTK-3.0/wxPython-3.0"
        return -code return "invalid parameter for wxWidgets.use"
    }
    wxWidgets.prefix    ${frameworks_dir}/wxWidgets.framework/Versions/${wxWidgets.name}/${wxWidgets.version}

    wxWidgets.wxdir     ${wxWidgets.prefix}/bin
    wxWidgets.wxconfig  ${wxWidgets.wxdir}/wx-config
    wxWidgets.wxrc      ${wxWidgets.wxdir}/wxrc
}

# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup lets a port know the version of the Command Line Tool (CLT) package installed.
#
# Usage:
#
#   PortGroup        cltversion 1.0
#   cltversion       is the version of CLT package installed
#   developerversion is the version of Apple provided developer tools to be used by MacPorts (CLTs or Xcode)
#

namespace eval cltversion {
}

options cltversion \
        developerversion

default cltversion       {[cltversion::get_default_cltversion]}
default developerversion {[cltversion::get_default_developerversion]}

proc cltversion::get_default_cltversion {} {
    global cltversion._cltversion_version_cache os.major

    if {[info exists cltversion._cltversion_version_cache]} {
        return [set cltversion._cltversion_version_cache]
    }

    if       {![catch {exec /usr/sbin/pkgutil --pkg-info=com.apple.pkg.CLTools_Executables  | /usr/bin/grep version: | /usr/bin/cut -d: -f2} result]} {
    } elseif {![catch {exec /usr/sbin/pkgutil --pkg-info=com.apple.pkg.CLTools_Base         | /usr/bin/grep version: | /usr/bin/cut -d: -f2} result]} {
    } elseif {![catch {exec /usr/sbin/pkgutil --pkg-info=com.apple.pkg.DeveloperToolsCLI    | /usr/bin/grep version: | /usr/bin/cut -d: -f2} result]} {
    } elseif {![catch {exec /usr/sbin/pkgutil --pkg-info=com.apple.pkg.DeveloperToolsCLILeo | /usr/bin/grep version: | /usr/bin/cut -d: -f2} result]} {
    } else {
        set result ""
    }

    set result [string trim ${result}]

    # There are reports of pkgutil returning (null) for version.
    # It is unclear why this is or how common it is.
    # Ensure $result is a valid version number.
    if {[vercmp ${result} 0] >= 0} {
        ui_debug "cltversion: Found Command Line Tools Version ${result}"
    } else {
        ui_debug "cltversion: Unable to Find Command Line Tools using pkgutil"

        # This should be the end of the story.
        # However, it would seem that receipts for command line tools are easily lost when upgrading Xcode.
        # So it is possible that command line tools are installed (the files exist), but `pkgutil` does not recognize them.

        # On OS X 10.9, running `xcode-select --install` seems to reinstall the command line tools.
        # For later OS versions, however, if `/Library/Developer/CommandLineTools/usr/lib/libxcrun.dylib` exists, then `xcode-select --install` refuses to reinstall.
        #
        # /usr/lib/libxcselect.dylib will not exist as a file on disk on macOS
        # 11 or later (Darwin 20 or later) because individual system dylibs are
        # only shipped in the dyld shared cache. Rest assured that if the OS is
        # that new, it's always appropriate to look for a Command Line Tools
        # installation at the path given here.

        if {[file exists /usr/lib/libxcselect.dylib] || ${os.major} >= 20} {
            set test_file /Library/Developer/CommandLineTools/usr/lib/libxcrun.dylib
        } else {
            set test_file /usr/bin/make
        }

        if {![file exists ${test_file}]} {
            # Command line tools do not seem to be installed.
            set result none
        } else {
            ui_warn "cltversion: The Command Line Tools are installed, but MacPorts cannot determine the version."
            ui_warn "cltversion: For a possible fix, please see: https://trac.macports.org/wiki/ProblemHotlist#reinstall-clt"
            set result ""
        }
    }
    set cltversion._cltversion_version_cache ${result}
    return ${result}
}

proc cltversion::get_default_developerversion {} {
    global use_xcode xcodeversion cltversion
    if {${use_xcode}} {
        return ${xcodeversion}
    } else {
        return ${cltversion}
    }
}

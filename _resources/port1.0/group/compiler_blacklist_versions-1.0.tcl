# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Including this PortGroup in a Portfile enhances the compiler.blacklist option
# to support blacklisting only specific build numbers of the given compiler.
# This PortGroup only knows about the build numbering scheme used by Apple's
# versions of gcc, llvm-gcc and clang provided with Xcode and the command line
# tools. As such, on platforms other than Darwin, any blacklist entries
# specifying a compiler build number will just be removed without being checked.
#
# Examples:
#
# Blacklist only clang build numbers less than 318.0.61:
# compiler.blacklist-append {clang < 318.0.61}
#
# Blacklist only clang build numbers greater than or equal to 421.11.66:
# compiler.blacklist-append {clang >= 421.11.66}
#
# Blacklist only clang build numbers greater than or equal to 421.11.66 but less than 444:
# compiler.blacklist-append {clang >= 421.11.66 < 444}
#
# Blacklist all versions of clang (same as without this PortGroup):
# compiler.blacklist-append clang
#
# Known limitations:
#
# Trying to remove an enhanced compiler.blacklist specification will not work
# (it will silently do nothing):
# compiler.blacklist-delete {clang >= 421.11.66}
# Workaround:
# compiler.blacklist-delete clang
#
# This PortGroup was created following this discussion:
# https://lists.macosforge.org/pipermail/macports-dev/2012-November/021103.html

option_proc compiler.blacklist compiler_blacklist_versions._set_compiler_blacklist

proc compiler_blacklist_versions._set_compiler_blacklist {option action args} {
    global os.platform
    if {${action} ne "set"} return
    foreach blacklist [option ${option}] {
        if {[llength ${blacklist}] > 1} {
            compiler.blacklist-delete ${blacklist}
            if {${os.platform} ne "darwin"} {
                continue
            }
            set compiler [lindex ${blacklist} 0]
            set comparisons [lrange ${blacklist} 1 end]
            set compiler_version [compiler_blacklist_versions._get_compiler_version ${compiler}]
            if {[compiler_blacklist_versions._matches_all_versions ${compiler} ${comparisons}]} {
                if {${compiler_version} eq ""} {
                    ui_debug "compiler ${compiler} blacklisted because it's not installed or it doesn't work"
                } else {
                    ui_debug "compiler ${compiler} ${compiler_version} blacklisted because it matches {${blacklist}}"
                }
                compiler.blacklist-append ${compiler}
            } else {
                ui_debug "compiler ${compiler} ${compiler_version} not blacklisted because it doesn't match {${blacklist}}"
            }
        }
    }
}

proc compiler_blacklist_versions._matches_all_versions {compiler comparisons} {
    if {[llength ${comparisons}] % 2} {
        return -code error "invalid/incomplete comparison specification \"${comparisons}\""
    }
    while {[llength ${comparisons}] > 0} {
        set comparison_operator [lindex ${comparisons} 0]
        set test_version [lindex ${comparisons} 1]
        if {![compiler_blacklist_versions._version_matches ${compiler} ${comparison_operator} ${test_version}]} {
            return 0
        }
        set comparisons [lrange ${comparisons} 2 end]
    }
    return 1
}

proc compiler_blacklist_versions._version_matches {compiler comparison_operator test_version} {
    set actual_version [compiler_blacklist_versions._get_compiler_version ${compiler}]
    if {${actual_version} eq ""} {
        return 1
    }
    return [expr [vercmp ${actual_version} ${test_version}] ${comparison_operator} 0]
}

proc compiler_blacklist_versions._get_compiler_version {compiler} {
    global compiler_blacklist_versions._compiler_versions os.major xcodeversion
    if {[info exists compiler_blacklist_versions._compiler_versions(${compiler})]} {
        return [set compiler_blacklist_versions._compiler_versions(${compiler})]
    }
    switch ${compiler} {
        clang {
            set re {clang(?:_.*)?-([0-9.]+)}
        }
        llvm-gcc-4.2 {
            if {${os.major} > 12 || [vercmp $xcodeversion 5.0] >= 0 || [vercmp $xcodeversion 3.1] < 0} {
                return ""
            }
            set re {LLVM build ([0-9.]+)}
        }
        gcc-4.2 {
            if {${os.major} > 11 || [vercmp $xcodeversion 4.2] >= 0} {
                return ""
            }
            set re {build ([0-9.]+)}
        }
        gcc-4.0 -
        apple-gcc-4.2 {
            set re {build ([0-9.]+)}
        }
        default {
            return -code error "don't know how to determine build number of compiler \"${compiler}\""
        }
    }
    set cc [portconfigure::configure_get_compiler cc ${compiler}]
    if {![file exists ${cc}]} return
    if {[catch {regexp ${re} [exec ${cc} -v 2>@1] -> compiler_version}]} return
    if {![info exists compiler_version]} {
        return -code error "couldn't determine build number of compiler \"${compiler}\""
    }
    set compiler_blacklist_versions._compiler_versions(${compiler}) ${compiler_version}
    return ${compiler_version}
}

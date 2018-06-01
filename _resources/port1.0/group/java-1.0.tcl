# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# Search for a good value for JAVA_HOME
proc find_java_home {} {
    set home_value ""

    # Default to any valid value that made it through the environment
    if { [info exists ::env(JAVA_HOME)] } {
        set val $::env(JAVA_HOME)
        if { [file isdirectory $val] } {
            set home_value $val
            ui_debug "Discovered JAVA_HOME via env: $home_value"
        }
    }

    # First, ask the system where java home is
    if { ![file isdirectory $home_value] && ![catch {set val [exec "/usr/libexec/java_home"]}] } {
        set home_value $val
        ui_debug "Discovered JAVA_HOME via /usr/libexec/java_home: $home_value"
    }

    # Fall back to more conventional way to find java home
    if { ![file isdirectory $home_value] } {
        foreach loc { "/System/Library/Frameworks/JavaVM.framework/Home" } {
            if { [file isdirectory $loc] } {
                set home_value $loc
                ui_debug "Discovered JAVA_HOME via search path: $home_value"
                break
            }
        }
    }

    # Warn user if we couldn't find a likely JAVA_HOME
    if { ![file isdirectory $home_value]} {
        ui_warn "No value for java JAVA_HOME was automatically discovered"
    }

    return $home_value
}

# Set the best value we can find for JAVA_HOME
set java_home [find_java_home]
configure.env-append   JAVA_HOME=${java_home}
build.env-append       JAVA_HOME=${java_home}
destroot.env-append    JAVA_HOME=${java_home}

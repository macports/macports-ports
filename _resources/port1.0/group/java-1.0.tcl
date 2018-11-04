# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup accommodates Java projects by setting the JAVA_HOME environment
# variable appropriately for the configure, build, and destroot phases.
#
# Usage:
#
# PortGroup     java 1.0
#
# java.version  1.8
#
# The java.version option allows one to optionally specify a required Java
# version. The syntax is the same as that accepted by /usr/libexec/java_home:
#
# - Java 8 and earlier are "1.8", etc.
# - Java 9 and later are "9", etc.
# - "+" and "*" wilcards are supported
#
# If the required Java cannot be found, an error will be thrown at pre-fetch.

options java.version java.home

default java.version {}
default java.home    {}

# allow PortGroup to be used inside a variant (e.g. octave)
global java_version_not_found
set java_version_not_found no

pre-fetch {
    if { ${java_version_not_found} } {
        # Check again, incase java became available, .e.g openjdk installed as a dependency
        java_set_env
        # If still not present, error out
        if { ${java_version_not_found} } {
            ui_error "${name} requires Java ${java.version} but no such installation could be found."
            return -code error "missing required Java version"
        }
    }
}

# Search for a good value for JAVA_HOME
proc find_java_home {} {
    set home_value ""

    # Default setting to found, until proved otherwise below
    global java_version_not_found
    set java_version_not_found no
    
    global java.version
    if { ${java.version} ne "" } {
        if { [catch {set val [exec "/usr/libexec/java_home" "-f" "-v" ${java.version}]}] } {
            # Don't return an error because that would prevent the port from
            # even being indexed when the required Java is missing. Instead, set
            # a flag to be checked at pre-fetch.
            set java_version_not_found yes
        } else {
            set home_value $val
            ui_debug "Discovered JAVA_HOME via /usr/libexec/java_home: $home_value"
        }
    }

    # Default to any valid value that made it through the environment
    if { ![file isdirectory $home_value] && \
             [info exists ::env(JAVA_HOME)] } {
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

proc java_set_env {} {
    # Set the best value we can find for JAVA_HOME
    set java_home [find_java_home]
    configure.env-append   JAVA_HOME=${java_home}
    build.env-append       JAVA_HOME=${java_home}
    destroot.env-append    JAVA_HOME=${java_home}
    java.home ${java_home}
}
port::register_callback java_set_env

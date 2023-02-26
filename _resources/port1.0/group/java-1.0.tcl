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
# - "+" and "*" wildcards are supported
#
# If the required Java cannot be found, an error will be thrown at pre-fetch.

options java.version java.home java.fallback java.deptypes

default java.version  {}
default java.home     {}
default java.fallback {[java::java_get_default_fallback]}
default java.deptypes lib

# allow PortGroup to be used inside a variant (e.g. octave)
global java_version_not_found
set java_version_not_found no

pre-fetch {
    if { ${java_version_not_found} } {
        # Check again in case java became available e.g. openjdk installed as a dependency
        java::java_set_env
        # If still not present, error out
        if { ${java_version_not_found} } {
            ui_error "${name} requires Java ${java.version} but no such installation could be found."
            return -code error "missing required Java version"
        }
    }
}

port::register_callback java::java_set_env

namespace eval java {
    # Search for a good value for JAVA_HOME
    proc find_java_home {} {
        set home_value ""

        # Default setting to found, until proved otherwise below
        global java_version_not_found
        set java_version_not_found no

        global java.version java.fallback
        if { ${java.version} ne "" } {
            ui_debug "java-portgroup: Trying to find JVM version: ${java.version}"

            # If on arm automatically adjust to the *-zulu fallback versions
            # as required, as currently these are the only ones supporting arm.
            # To be reviewed as support for arm comes for the other versions.
            # Following regex matches openjdk<version> only.
            # Keep in mind that configure.build_arch isn't available here
            global os.arch
            if { ${os.arch} eq "arm" &&
                 [regexp {openjdk(\d{1,2}$)} ${java.fallback}] } {
                set newjdk ${java.fallback}-zulu
                ui_debug "Redefining java fallback ${java.fallback} to ${newjdk} for arm compatibility"
                java.fallback ${newjdk}
            }

            # For macOS >= Big Sur, the JDK discovery was re-implemented because
            # the previous approach relied on '/usr/libexec/java_home -v' whose
            # behaviour changed with Big Sur. The new implementation can
            # handle wildcards on the major version, but not on the minor version:
            # 1.8+, 9* works, 1.7.35+ won't.
            #
            # See https://trac.macports.org/ticket/61445
            global os.platform os.major

            set big_sur_workaround [expr {${os.platform} eq "darwin" && ${os.major} >= 20}]
            if { ${big_sur_workaround} && [catch {set val [get_jvm_bigsur ${java.version}] } ]
            || !${big_sur_workaround} && [catch {set val [exec "/usr/libexec/java_home" "-f" "-v" ${java.version}] } ] } {
                # Don't return an error because that would prevent the port from
                # even being indexed when the required Java is missing. Instead, set
                # a flag to be checked at pre-fetch.
                set java_version_not_found yes
            } else {
                set home_value $val
                ui_debug "java-portgroup: Discovered matching JAVA_HOME: $home_value"
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
            ui_debug "No value for java JAVA_HOME was automatically discovered"
        }

        # Add dependency if required
        if { ${java_version_not_found} && ${java.fallback} ne "" } {
            ui_debug "Adding dependency on JDK fallback ${java.fallback}"
            foreach deptype [option java.deptypes] {
                depends_${deptype}-append port:${java.fallback}
            }
        }

        return $home_value
    }

    proc java_get_default_fallback {} {
        global os.major java.version
        if {[option os.platform] eq "darwin"} {
            if {${os.major} >= 18 && [vercmp ${java.version} < 18]} {
                return openjdk17
            } elseif {${os.major} >= 15 && [vercmp ${java.version} < 12]} {
                return openjdk11
            } elseif {${os.major} >= 11 && [vercmp ${java.version} < 9]} {
                return openjdk8
            }
        }
        return {}
    }

    proc java_set_env {} {
        # Set the best value we can find for JAVA_HOME
        set java_home [find_java_home]
        configure.env-append   JAVA_HOME=${java_home}
        build.env-append       JAVA_HOME=${java_home}
        destroot.env-append    JAVA_HOME=${java_home}
        java.home ${java_home}
    }

    proc get_jvm_bigsur { version_requested } {
        # Normalize version numbers 1.x -> x
        set version_requested [regsub {^1\.} $version_requested ""]
        # Sort the JVMs we found on the system descending
        set versions_found [sort_dict [find_jvm_versions]]
        ui_debug "java-portgroup: Detected JVMs: $versions_found"
        # Match the systems JVMs with the one requested by MacPorts
        # Higher JVM Versions win
        return [match_jvm_version $version_requested $versions_found]
    }

    # Find JVM versions by using /usr/libexec/java_home -V (not -v!)
    # Returns a dict with unique major versions as key and the corresponding
    # java_home as value:
    #  dict[major_version]=java_home
    proc find_jvm_versions {} {
        if {[catch {exec /usr/libexec/java_home -V} result options]} {
            # Extract JVM versions and corresponding JAVA_HOMEs
            set vm_versions [regexp -all -inline -- { +(\d+(?:\.\d+)+)[^/]+(\/[^\0\n]+)} $result]
            # %3=0 -> Regex match, ignored.
            # %3=1 -> Version
            # %3=2 -> JAVA_HOME.
            for {set idx 0} {$idx < [llength $vm_versions]} {incr idx 3} {
                set vers [lindex $vm_versions $idx+1]
                # Normalize version 1.x -> x
                set vers [regsub {^1\.} $vers ""]
                # Extract major version
                set vers [regsub {(\.\d+)+} $vers ""]
                set path [lindex $vm_versions $idx+2]
                dict append version_path_dict $vers $path
            }
        } else {
            set details [dict get $options -errorcode]
            ui_debug "Error executing /usr/libexec/java_home -V"
        }
        set version_path_dict
    }

    # Match a normalized major version string like 7, 8*, 9+
    proc match_jvm_version { version_requested versions_found } {
        if {[string first "+" $version_requested] != -1} {
            set version_requested [regsub {\+} $version_requested ""]
            match_less_equal $version_requested $versions_found
        } else {
            set version_requested [regsub {\*} $version_requested ""]
            match_equal $version_requested $versions_found
        }
    }

    # Returns the value of the first dictionary entry
    # whose key is equal to search_key.
    #
    # @param search_key The key that is to be found in the dictionary
    # @param target_dict The dictionary which should be searched for search_key
    # @return The value of the first entry that matched.
    # Returns an error, if no such entry is found.
    proc match_equal { search_key target_dict } {
        foreach td_key [dict keys $target_dict] {
            if {$search_key == $td_key} {
                set ret_value [dict get $target_dict $td_key]
                return $ret_value
            }
        }
        return -code error
    }

    # Returns the value of the first dictionary entry
    # whose key is less than or equal to search_key.
    #
    # @param search_key The key that is to be found in the dictionary
    # @param target_dict The dictionary which should be searched for search_key
    # @return The value of the first entry that matched.
    # Returns an error, if no such entry is found.
    proc match_less_equal { search_key target_dict } {
        foreach td_key [dict keys $target_dict] {
            if {$search_key <= $td_key} {
                set ret_value [dict get $target_dict $td_key]
                return $ret_value
            }
        }
        return -code error
    }

    # Sorts a dictionary decreasing by its keys
    #
    # @param The dictionary that is to be sorted decreasing by its keys
    # @return A sorted dictionary
    proc sort_dict { unsorted_dict } {
        set keys_unsorted [dict keys $unsorted_dict]
        set keys_sorted [lsort -decreasing $keys_unsorted]

        foreach key $keys_sorted {
            set value [dict get $unsorted_dict $key]
            dict append sorted_dict $key $value
        }
        return $sorted_dict
    }
}

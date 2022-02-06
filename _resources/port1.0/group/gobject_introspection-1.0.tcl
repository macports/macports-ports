# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup adds dependencies and arguments for building with gobject
# introspection. There is just one option to set:
#
# gobject_introspection: whether to use gobject introspection. The default
# is no. Possible values are yes and no.

options gobject_introspection
default gobject_introspection   no

namespace eval gobject_introspection_pg {
}

# utility procedure to map tool name to appropriate variable name
proc gobject_introspection_pg::map_tool_to_environment_variable {tool} {
    switch -- ${tool} {
        cc {
            return CFLAGS
        }
        f77 {
            return FFLAGS
        }
        default {
            return [string toupper $tool]FLAGS
        }
    }
}

proc gobject_introspection_pg::append_env { phase var } {
    ${phase}.env-delete ${var}
    ${phase}.env-append ${var}
}

proc gobject_introspection_pg::gobject_introspection_setup {} {
    if {![option gobject_introspection]} {
        if { [string match *cmake* [option configure.cmd] ] } {
            configure.args-append   -DENABLE_GOBJECT_INTROSPECTION=OFF
        } elseif { [string match *meson* [option configure.cmd] ] } {
            configure.args-append   -Dintrospection=false
        } else {
            configure.args-append   --disable-introspection
        }
    } else {
        depends_lib-append          path:lib/pkgconfig/gobject-introspection-1.0.pc:gobject-introspection
        if {![string match *meson* [option configure.cmd]]} {
            platform darwin 8 {
                global prefix_frozen
                # The rules enabled by gobject-introspection require GNU make 3.81+
                depends_build-append    port:gmake
                configure.env-append    MAKE=${prefix_frozen}/bin/gmake
                build.cmd-replace       [portbuild::build_getmaketype] ${prefix_frozen}/bin/gmake
            }
        }

        if { [string match *cmake* [option configure.cmd] ] } {
            configure.args-append   -DENABLE_GOBJECT_INTROSPECTION=ON            
        } elseif { [string match *meson* [option configure.cmd] ] } {
            configure.args-append   -Dintrospection=true
        } else {
            configure.args-append   --enable-introspection
        }

        #########################################################################################
        # In order to get the GObject Introspection system to respect MacPorts settings,
        #     CC, CFLAGS, and LDFLAGS must be set as build command arguments.
        # This can override other parts of the build system.
        # Some parts of some build systems still respect the values set during configure phase.
        # Attempt to compromise by ensuring that the command arguments are consistent with the
        #     values set during the configure phase.
        #
        # See https://trac.macports.org/ticket/59078
        # See https://trac.macports.org/ticket/62410
        #########################################################################################

        gobject_introspection_pg::append_env build    CC=[option configure.cc]
        gobject_introspection_pg::append_env destroot CC=[option configure.cc]

        # replicate behavior in procedure portconfigure::configure_main
        # see https://github.com/macports/macports-base/blob/master/src/port1.0/portconfigure.tcl
        options gobject_introspection.build.cflags \
                gobject_introspection.build.ldflags

        if {[option configure.pipe]} {
            gobject_introspection.build.cflags-append -pipe
        }

        # this is the major deviation from configure_main
        # -isysroot cannot be empty (see _osx_support.py in python installation)
        if {[option configure.sdkroot] ne ""} {
            set sdk_root "[option configure.sdkroot]"
        } else {
            set sdk_root "/"
        }
        gobject_introspection.build.cflags-append   "-isysroot${sdk_root}"
        gobject_introspection.build.ldflags-append  "-Wl,-syslibroot,${sdk_root}"

        if {![exists universal_archs_supported] || ![variant_exists universal] || ![variant_isset universal]} {
            # muniversal PG is *not* being used
            foreach tool {cc ld} {
                if {[catch {get_canonical_archflags $tool} flags]} {
                    continue
                }
                set env_var [gobject_introspection_pg::map_tool_to_environment_variable $tool]
                gobject_introspection.build.[string tolower ${env_var}]-append {*}${flags}
            }
        } else {
            # muniversal PG is being used
            global merger_build_args
            foreach arch [option configure.universal_archs] {
                foreach tool {cc ld} {
                    set env_var [gobject_introspection_pg::map_tool_to_environment_variable $tool]
                    lappend merger_build_args(${arch}) ${env_var}+="[muniversal_get_arch_flag ${arch}]"
                }
            }
        }

        if {![variant_exists universal] || ![variant_isset universal]} {
            foreach env_var {CFLAGS LDFLAGS} {
                if {[option configure.march] ne ""} {
                    gobject_introspection.build.[string tolower ${env_var}]-append -march=[option configure.march]
                }
                if {[option configure.mtune] ne ""} {
                    gobject_introspection.build.[string tolower ${env_var}]-append -mtune=[option configure.mtune]
                }
            }
        }

        if {![string match *meson* [option configure.cmd]]} {
            build.args-append    CFLAGS="[option configure.cflags]  [option gobject_introspection.build.cflags]" \
                                LDFLAGS="[option configure.ldflags] [option gobject_introspection.build.ldflags]"
        }
    }
}

port::register_callback gobject_introspection_pg::gobject_introspection_setup

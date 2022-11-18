
# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

#===================================================================================================
#
# Portgroup to simplify building a port in sterilize build environment.
# Sterilize build environment prevents port to picks anything up from MacPorts prefix.
#
#---------------------------------------------------------------------------------------------------
#
# Usage:
#   PortGroup           sterile 1.0
#
#===================================================================================================

# sterilize MacPorts build environment; we want nothing picked up from MP prefix
default compiler.cpath                  {}
default compiler.library_path           {}

default configure.cxx_stdlib            {}

default configure.cflags                {}
default configure.cxxflags              {}
default configure.cppflags              {}
default configure.optflags              {}
default configure.ldflags               {}

default configure.universal_cflags      {}
default configure.universal_cxxflags    {}
default configure.universal_cppflags    {}
default configure.universal_ldflags     {}
default configure.universal_args        {}

default configure.ccache                no
default configure.distcc                no

# sterilize PATH
configure.env-append                    PATH=/usr/bin:/bin:/usr/sbin:/sbin
build.env-append                        PATH=/usr/bin:/bin:/usr/sbin:/sbin
destroot.env-append                     PATH=/usr/bin:/bin:/usr/sbin:/sbin

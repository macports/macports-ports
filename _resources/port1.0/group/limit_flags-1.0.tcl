# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup limits compiler flags to avoid conflicts with installed headers
# and libraries.
#
# Usage:
#
#   PortGroup               limit_flags 1.0

compiler.limit_flags    yes
configure.env-append    PKG_CONFIG_SYSTEM_INCLUDE_PATH=${prefix}/include \
                        PKG_CONFIG_SYSTEM_LIBRARY_PATH=${prefix}/lib

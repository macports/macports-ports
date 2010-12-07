# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
# $Id$

# Copyright (c) 2010 The MacPorts Project
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of Apple Computer, Inc. nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
# Usage:
# PortGroup     kde4 1.1

# Use CMake and Qt4 port groups
PortGroup               cmake 1.0
PortGroup               qt4 1.0

# build in a separate directory; have to put these into phases because
# ${distname} and ${workpath} are not necessarily defined at the
# top-level while they are guaranteed to be by the pre-fetch phase.

# setup all KDE4 ports to build in a separate directory from the source;
# this setting must be the full directory path
post-extract            { file mkdir ${workpath}/build }

# Have to set for configure, build, and destroot phases only.
pre-configure {
    # standard post-arg, where to find the primary CMakeLists.txt file.
    configure.post_args ../${distname}
    configure.dir       ${workpath}/build
}
pre-build {
    build.dir           ${workpath}/build
}
pre-destroot {
    build.dir           ${workpath}/build
}

# Automoc added as build dependency here as most, if not all kde
# programs currently need it. The automoc port, which includes this
# PortGroup overrides depends_build, removing "port:automoc" to
# prevent a cyclic dependency
depends_build-append    port:automoc

# Phonon added as library dependency here as most, if not all KDE
# programs current need it.  The phonon port, which includes this
# PortGroup overrides depends_lib, removing "port:phonon" to prevent a
# cyclic dependency
depends_lib-append      port:phonon

# set compiler to Apple's GCC 4.2
switch ${os.platform}_${os.major} {
    darwin_8 {
	    depends_lib-append 	port:apple-gcc42-devel
	    configure.compiler	apple-gcc-4.2
    }
    darwin_9 {
	    configure.compiler  gcc-4.2
    }
}

post-extract {
    # Following the official word: Change #include ["<]Phonon...[">] to
    # ...phonon... in all files that contain that header.
    fs-traverse item ${workpath}/${distname} {
        if {[file isfile ${item}]} {
            reinplace "/#include/s@Phonon@phonon@" ${item}
        }
    }
}

# augment the CMake module lookup path, if necessary depending on
# where Qt4 is installed.
if {${qt_dir} != ${prefix}} {
    set cmake_module_path ${cmake_share_module_dir}\;${qt_cmake_module_dir}
    configure.args-delete -DCMAKE_MODULE_PATH=${cmake_share_module_dir}
    configure.args-append -DCMAKE_MODULE_PATH="${cmake_module_path}"
    unset cmake_module_path
}

# standard configure args; virtuall all KDE ports use CMake and Qt4
configure.args-append   -DBUILD_doc=OFF \
                        -DBUILD_SHARED_LIBS=ON \
                        -DBUNDLE_INSTALL_DIR=${applications_dir}/KDE4 \
                        -DKDE_DISTRIBUTION_TEXT="MacPorts\/Mac OS X" \
                        ${qt_cmake_defines}

# standard variant for building documentation
variant docs description "Build documentation" {
    depends_lib-append      port:doxygen
    configure.args-delete   -DBUILD_doc=OFF
}

post-activate {
    ui_msg "##########################################################"
    ui_msg "# Don't forget that dbus needs to be started as the local "
    ui_msg "# user (not with sudo) before any KDE programs will launch"
    ui_msg "# To start it run the following command:                  "
    ui_msg "# launchctl load /Library/LaunchAgents/org.freedesktop.dbus-session.plist"
    ui_msg "##########################################################"
    ui_msg " "
    ui_msg "######################################################"
    ui_msg "#  Programs will not start until you run the command "
    ui_msg "#  'sudo chown -R \$USER ~/Library/Preferences/KDE'  "
    ui_msg "#  replacing \$USER with your username.              "
    ui_msg "######################################################"
}

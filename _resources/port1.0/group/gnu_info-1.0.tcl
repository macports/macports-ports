# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2015 The MacPorts Project
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
# 3. Neither the name of The MacPorts Project nor the names of its
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
# PortGroup       gnu_info 1.0
#
# In the default case of your package installing a single ${subport}.info file
# in ${prefix}/share/info, you don't need to do anything.
#
# If your package installs a single info file in the standard directory, but
# its name does not equal your port's name (e.g. when the port has been renamed
# due to a naming conflict), set gnu_info.name:
#
# gnu_info.name   ddrescue
#
# If your package installs more than a single info file, set the gnu_info.files
# property:
#
# gnu_info.files  ${gnu_info.path}/${name}.info ${gnu_info.path}/${name}-dev.info
#
# If your package installs info files in a non-standard path, you may want to
# set gnu_info.dir to this alternative path. Note that the dir file will still
# be in the standard location ${prefix}/share/info/dir; you can control this
# property using gnu_info.dirfile.
#
# gnu_info.dir    ${prefix}/share/info/${name}
#
# If you also want to change the location of the GNU info dir file, set
# gnu_info.dirfile. The default should, however, be fine for all use cases.
#
# gnu_info.dirfile ${prefix}/share/info/dir
#
# If your package installs info files in more than one directory, you will have
# to use gnu_info.files with multiple different paths.

# The name of the info file the port installs in in ${gnu_info.dir}. Defaults
# to the name of the port.
options gnu_info.name
default gnu_info.name {${subport}}

# List of GNU info files installed by this port. Use absolute paths only.
# Defaults to ${gnu_info.dir}/${gnu_info.name}.info
options gnu_info.files
default gnu_info.files {[list ${gnu_info.dir}/${gnu_info.name}.info]}

# Directory that contains the installed info file, defaults to
# ${prefix}/share/info. This is only used in the default value of
# gnu_info.files, so if you set that, this property has no effect. Note that
# this property does NOT affect the location of the GNU info dir file. That is
# instead controlled by gnu_info.dirfile.
options gnu_info.dir
default gnu_info.dir {${prefix}/share/info}

# Absolute path of the GNU info dir file. Defaults to ${prefix}/share/info/dir.
# You shouldn't have to change this.
options gnu_info.dirfile
default gnu_info.dirfile {${prefix}/share/info/dir}

# Absolute path to the install-info binary to be used for installation of info
# files. Defaults to ${prefix}/bin/install-info.
options gnu_info.install_info
default gnu_info.install_info {${prefix}/bin/install-info}

# Add the necessary dependency for activation and de-activation
depends_run-delete  port:texinfo
depends_run-append  port:texinfo

post-activate {
    foreach infofile ${gnu_info.files} {
        ui_debug "Registering GNU info file ${infofile} in ${gnu_info.dirfile} using ${gnu_info.install_info}"
        system "${gnu_info.install_info} ${infofile} ${gnu_info.dirfile}"
    }
}

pre-deactivate {
    foreach infofile ${gnu_info.files} {
        ui_debug "Unregistering GNU info file ${infofile} in ${gnu_info.dirfile} using ${gnu_info.install_info}"
        system "${gnu_info.install_info} --delete ${infofile} ${gnu_info.dirfile}"
    }
}

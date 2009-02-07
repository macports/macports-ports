# Copyright (c) 2009 Orville Bennett <illogical1 at gmail.com>
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
# Use CMake Portgroup
PortGroup       cmake   1.0

depends_build-append    port:automoc

use_parallel_build      yes

worksrcdir              build

post-extract            { file mkdir ${worksrcpath} }

depends_lib-append      port:doxygen

configure.compiler      gcc-4.2

configure.args-append   -DBUILD_doc=ON \
                        -DBUILD_SHARED_LIBS=ON \
                        -DBUNDLE_INSTALL_DIR=${applications_dir}/KDE4 \
                        -DPHONON_INCLUDE_DIR=${prefix}/include \
                        -DPHONON_LIBRARY=${prefix}/lib/libphonon.dylib \
                        -DKDE_DISTRIBUTION_TEXT="MacPorts\/Mac OS X"

variant no_docs description "Omit documentation" {
    depends_lib-delete      port:doxygen
    configure.args-delete   -DBUILD_doc=ON
    configure.args-append   -DBUILD_doc=OFF
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
    ui_msg "#  Programs will not start until you run the command #"
    ui_msg "#  'sudo chown -R \$USER ~/Library/Preferences/KDE'  #"
    ui_msg "#  replacing \$USER with your username, followed by  #"
    ui_msg "#  'open ${applications_dir}/KDE4/kdeinit4.app'      #" 
    ui_msg "#  in a Terminal.                                    #"
    ui_msg "######################################################"
}

# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2013-2016 The MacPorts Project
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
# This portgroup defines standard settings when using qmake.
#
# Usage:
# PortGroup                     qmake5 1.0

PortGroup                       qt5 1.0
PortGroup                       active_variants 1.1

options qt5.add_spec qt5.debug_variant qt5.top_level
default qt5.add_spec yes
default qt5.debug_variant yes
default qt5.top_level {${configure.dir}}

# with the -r option, the examples do not install correctly (no source code)
#     the install_sources target is not created in the Makefile(s)
configure.cmd                   ${qt_qmake_cmd}
#configure.cmd                   ${qt_qmake_cmd} -r

configure.pre_args-replace      --prefix=${prefix} "PREFIX=${prefix}"
configure.universal_args-delete --disable-dependency-tracking

pre-configure {
    #
    # set QT_ARCH and QT_TARGET_ARCH manually since they may be
    #     incorrect in ${qt_mkspecs_dir}/qconfig.pri
    #     if qtbase was built universal
    #
    # -spec specifies build configuration (compiler, 32-bit/64-bit, etc.)
    #
    # set -arch x86_64 since macx-clang spec file assumes it is the default
    #
    if { [tbool qt5.add_spec] } {
        if {[variant_exists universal] && [variant_isset universal]} {
            global merger_configure_args
            lappend merger_configure_args(i386)   -spec ${qt_qmake_spec_32}
            lappend merger_configure_args(x86_64) -spec ${qt_qmake_spec_64}
        } else {
            configure.args-append -spec ${qt_qmake_spec}
        }
    }

    if { [vercmp ${xcodeversion} "7.0"] >= 0 } {
        # starting with Xcode 7.0, the SDK for build OS version might not be available
        # see https://trac.macports.org/ticket/53597

        set sdks_dir ${developer_dir}/Platforms/MacOSX.platform/Developer/SDKs
        if { ![file exists ${sdks_dir}/MacOSX${configure.sdk_version}.sdk] } {
            configure.sdk_version
        }
    }

    # set QT and QMAKE values in a cache file
    # previously, they were set using configure.args
    # a cache file is used for two reasons
    #
    # 1) a change in Qt 5.7.1  made it more difficult to override sdk variables
    #    see https://codereview.qt-project.org/#/c/165499/
    #    see https://bugreports.qt.io/browse/QTBUG-56965
    #
    # 2) some ports (e.g. py-pyqt5 py-qscintilla2) call qmake indirectly and
    #    do not pass on the configure.args values
    #
    set cache [open "${qt5.top_level}/.qmake.cache" w 0644]
    puts ${cache} "if(${qt_qmake_spec_64}) {"
    puts ${cache} "  QT_ARCH=x86_64"
    puts ${cache} "  QT_TARGET_ARCH=x86_64"
    puts ${cache} "  QMAKE_CFLAGS+=-arch x86_64"
    puts ${cache} "  QMAKE_CXXFLAGS+=-arch x86_64"
    puts ${cache} "  QMAKE_LFLAGS+=-arch x86_64"
    puts ${cache} "} else {"
    puts ${cache} "  QT_ARCH=i386"
    puts ${cache} "  QT_TARGET_ARCH=i386"
    puts ${cache} "}"
    puts ${cache} "QMAKE_MACOSX_DEPLOYMENT_TARGET=${macosx_deployment_target}"
    puts ${cache} "QMAKE_MAC_SDK=macosx${configure.sdk_version}"

    # respect configure.compiler but still allow qmake to find correct Xcode clang based on SDK
    if { ${configure.compiler} ne "clang" } {
        puts ${cache} "QMAKE_CC=${configure.cc}"
        puts ${cache} "QMAKE_CXX=${configure.cxx}"
        puts ${cache} "QMAKE_LINK_C=${configure.cc}"
        puts ${cache} "QMAKE_LINK_C_SHLIB=${configure.cc}"
        puts ${cache} "QMAKE_LINK=${configure.cxx}"
        puts ${cache} "QMAKE_LINK_SHLIB=${configure.cxx}"
    }

    set qt_version [exec ${prefix}/bin/pkg-config --modversion Qt5Core]

    # save certain configure flags
    set qmake5_cxx11_flags ""
    set qmake5_cxx_flags   ""
    set qmake5_l_flags     ""
    foreach flag ${configure.cxxflags} {
        if { ${flag} eq "-D_GLIBCXX_USE_CXX11_ABI=0" } {
            lappend qmake5_cxx11_flags ${flag}
        }
    }
    foreach flag ${configure.ldflags} {
    }
    set qmake5_cxx11_flags [join ${qmake5_cxx11_flags} " "]
    set qmake5_cxx_flags   [join ${qmake5_cxx11_flags} " "]
    set qmake5_l_flags     [join ${qmake5_l_flags}     " "]

    if { [vercmp ${qt_version} 5.6.0] >= 0 } {
        if { ${configure.cxx_stdlib} ne "libc++" } {
            # override C++ flags set in ${prefix}/libexec/qt5/mkspecs/common/clang-mac.conf
            #    so value of ${configure.cxx_stdlib} can always be used
            puts ${cache} QMAKE_CXXFLAGS-=-stdlib=libc++
            puts ${cache} QMAKE_LFLAGS-=-stdlib=libc++
            puts ${cache} QMAKE_CXXFLAGS+=-stdlib=${configure.cxx_stdlib}
            puts ${cache} QMAKE_LFLAGS+=-stdlib=${configure.cxx_stdlib}
        }
        if {${qmake5_cxx11_flags} ne ""} {
            puts ${cache} QMAKE_CXXFLAGS+="${qmake5_cxx11_flags}"
        }
    } elseif { [vercmp ${qt_version} 5.5.0] == 0 } {

        # always use the same standard library
        puts ${cache} QMAKE_CXXFLAGS+=-stdlib=${configure.cxx_stdlib}
        puts ${cache} QMAKE_LFLAGS+=-stdlib=${configure.cxx_stdlib}

        # override C++ flags set in ${prefix}/libexec/qt5/mkspecs/common/clang-mac.conf
        #    so value of ${configure.cxx_stdlib} can always be used
        if { ${configure.cxx_stdlib} ne "libc++" } {
            puts ${cache} QMAKE_CXXFLAGS_CXX11-=-stdlib=libc++
            puts ${cache} QMAKE_LFLAGS_CXX11-=-stdlib=libc++
            puts ${cache} QMAKE_CXXFLAGS_CXX11+=-stdlib=${configure.cxx_stdlib}
            puts ${cache} QMAKE_LFLAGS_CXX11+=-stdlib=${configure.cxx_stdlib}
        }
        if {${qmake5_cxx11_flags} ne ""} {
            puts ${cache} QMAKE_CXXFLAGS_CXX11+="${qmake5_cxx11_flags}"
        }
    } else {
        # always use the same standard library
        puts ${cache} QMAKE_CXXFLAGS+=-stdlib=${configure.cxx_stdlib}
        puts ${cache} QMAKE_LFLAGS+=-stdlib=${configure.cxx_stdlib}
        if {${qmake5_cxx11_flags} ne ""} {
            puts ${cache} QMAKE_CXXFLAGS+="${qmake5_cxx11_flags}"
        }
    }
    if {${qmake5_cxx_flags} ne "" } {
        puts ${cache} QMAKE_CXXFLAGS+="${qmake5_cxx_flags}"
    }
    if {${qmake5_l_flags} ne "" } {
        puts ${cache} QMAKE_LFLAGS+="${qmake5_l_flags}"
    }

    # accommodating variant request varies depending on how qtbase was built
    set base_debug false
    foreach qt_test_name ${available_qt_versions} {
        if { [string range ${qt_test_name} end-3 end] eq "-kde" } {
            set qt_test_port_name ${qt_test_name}
        } else {
            set qt_test_port_name ${qt_test_name}-qtbase
        }
        if {![catch {set result [active_variants ${qt_test_port_name} debug ""]}]} {
            if {$result} {
                # code to be executed if $depspec is active with at least all variants in
                # $required and none from $forbidden
                set base_debug true
                break
            } else {
                # code to be executed if $depspec is active, but either not with all
                # variants in $required or any variant in $forbidden
            }
        } else {
            # code to be executed if $depspec isn't active
        }
    }

    # determine if the user wants to build debug libraries
    if { [variant_exists debug] && [variant_isset debug] } {
        set this_debug true
    } else {
        set this_debug false
    }

    # determine of qmake's default and user requests are compatible; override qmake if necessary
    if { ${this_debug} && !${base_debug}  } {
        puts ${cache} "QT_CONFIG+=debug_and_release build_all debug"
        puts ${cache} "CONFIG+=debug"
        puts ${cache} "CONFIG-=release"
    }

    if { !${this_debug} && ${base_debug}  } {
        puts ${cache} "QT_CONFIG-=debug_and_release build_all debug"
        puts ${cache} "CONFIG-=debug"
        puts ${cache} "CONFIG+=release"
    }

    close ${cache}
}

# see https://trac.macports.org/ticket/53186
destroot.destdir "INSTALL_ROOT=${destroot}"

# add debug variant if one does not exist and one is requested via qt5.debug_variant
# variant is added in eval_variants so that qt5.debug_variant can be set anywhere in the Portfile
rename ::eval_variants ::real_qmake5_eval_variants
proc eval_variants {variations} {
    global qt5.debug_variant
    if { ![variant_exists debug] && [tbool qt5.debug_variant] } {
        variant debug description {Build both release and debug libraries} {}
    }
    uplevel ::real_qmake5_eval_variants $variations
}

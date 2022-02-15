# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup defines standard settings when using qmake.
#
# Usage:
# PortGroup                     qmake5 1.0

PortGroup                       qt5 1.0
PortGroup                       active_variants 1.1
PortGroup                       legacysupport 1.1

options qt5.add_spec qt5.debug_variant qt5.top_level qt5.cxxflags qt5.ldflags qt5.frameworkpaths qt5.spec_cmd
default qt5.add_spec yes
default qt5.debug_variant yes
default qt5.top_level {${configure.dir}}
default qt5.cxxflags {}
default qt5.ldflags {}
default qt5.frameworkpaths {}
default qt5.spec_cmd "-spec "

# with the -r option, the examples do not install correctly (no source code)
#     the install_sources target is not created in the Makefile(s)
configure.cmd                   ${qt_qmake_cmd}
#configure.cmd                   ${qt_qmake_cmd} -r

configure.pre_args-replace      --prefix=${prefix} "PREFIX=${prefix}"
configure.universal_args-delete --disable-dependency-tracking

platform macosx {
    # Use Xcode if CLT doesn't ship with an SDK
    # See: https://trac.macports.org/ticket/58779
    if { !${use_xcode} && ![file exists ${configure.developer_dir}/SDKs] } {
        use_xcode yes
    }
}

pre-configure {
    #
    # -spec specifies build configuration (compiler, 32-bit/64-bit, etc.)
    #
    if { [tbool qt5.add_spec] } {
        if {[vercmp ${qt5.version} 5.9]>=0} {
            configure.args-append "${qt5.spec_cmd}${qt_qmake_spec}"
        } else {
            if {[variant_exists universal] && [variant_isset universal]} {
                global merger_configure_args
                lappend merger_configure_args(i386)   {*}${qt5.spec_cmd}${qt_qmake_spec_32}
                lappend merger_configure_args(x86_64) {*}${qt5.spec_cmd}${qt_qmake_spec_64}
            } else {
                configure.args-append "${qt5.spec_cmd}${qt_qmake_spec}"
            }
        }
    }

    # starting with Xcode 7.0, the SDK for build OS version might not be available
    # see https://trac.macports.org/ticket/53597
    #
    # avoid --show-sdk-path since it is not available on all platforms
    # see https://github.com/macports/macports-ports/commit/9887e90d69f4265f9056cddc45e41551d7400235#commitcomment-49824261
    if {[catch {exec /usr/bin/xcrun --sdk macosx${configure.sdk_version} --find ld} result]} {
        configure.sdk_version
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
    set cache_file "${qt5.top_level}/.qmake.cache"
    set cache [open ${cache_file} w 0644]
    ui_debug "QT5 Qmake Cache ${cache_file}"
    if {[vercmp ${qt5.version} 5.9] >= 0} {
        if {[variant_exists universal] && [variant_isset universal]} {
            puts ${cache} "QMAKE_APPLE_DEVICE_ARCHS=${configure.universal_archs}"
        } elseif { ${configure.build_arch} ne "" } {
            puts ${cache} "QMAKE_APPLE_DEVICE_ARCHS=${configure.build_arch}"
        } else {
            # If `supported_archs` is `noarch`, `configure.build_arch` can be empty (see e.g. qt5-qtbase-docs).
            # Having an empty QMAKE_APPLE_DEVICE_ARCHS can cause an error.
            # Even if it is not really needed, not having a QMAKE_APPLE_DEVICE_ARCHS at all can also cause an error.
            puts ${cache} "QMAKE_APPLE_DEVICE_ARCHS=${build_arch}"
        }
    } else {
        #
        # set QT_ARCH and QT_TARGET_ARCH manually since they may be
        #     incorrect in ${qt_mkspecs_dir}/qconfig.pri
        #     if qtbase was built universal
        #
        # set -arch x86_64 since macx-clang spec file assumes it is the default
        #
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
    }
    puts ${cache} "QMAKE_MACOSX_DEPLOYMENT_TARGET=${macosx_deployment_target}"
    puts ${cache} "QMAKE_MAC_SDK=macosx${configure.sdk_version}"

    # https://github.com/qt/qtbase/commit/d64940891dffcb951f4b76426490cbc94fb4aba7
    # Enable ccache support if active and available in given qt5 version
    if { [option configure.ccache] && [vercmp ${qt5.version} 5.9.2] >= 0 } {
        puts ${cache} "CONFIG+=ccache"
    }

    # respect configure.compiler but still allow qmake to find correct Xcode clang based on SDK
    if { ${configure.compiler} ne "clang" } {
        puts ${cache} "QMAKE_CC=${configure.cc}"
        puts ${cache} "QMAKE_CXX=${configure.cxx}"
        puts ${cache} "QMAKE_LINK_C=${configure.cc}"
        puts ${cache} "QMAKE_LINK_C_SHLIB=${configure.cc}"
        puts ${cache} "QMAKE_LINK=${configure.cxx}"
        puts ${cache} "QMAKE_LINK_SHLIB=${configure.cxx}"
    }

    # save certain configure flags
    set qmake5_cxx11_flags ""
    set qmake5_cxx_flags   ""
    set qmake5_c_flags     ""
    set qmake5_l_flags     ""
    foreach flag ${configure.cxxflags} {
        if { ${flag} eq "-D_GLIBCXX_USE_CXX11_ABI=0" } {
            lappend qmake5_cxx11_flags ${flag}
        }
    }
    foreach flag ${configure.cppflags} {
        lappend qmake5_c_flags   ${flag}
        lappend qmake5_cxx_flags ${flag}
    }
    # Need to respect ldflags as needed for legacysupport linking
    foreach flag ${configure.ldflags} {
        lappend qmake5_l_flags ${flag}
    }
    set qmake5_cxx11_flags [join ${qmake5_cxx11_flags} " "]
    set qmake5_cxx_flags   [join ${qmake5_cxx_flags}   " "]
    set qmake5_c_flags     [join ${qmake5_c_flags}     " "]
    set qmake5_l_flags     [join ${qmake5_l_flags}     " "]

    if { [vercmp ${qt5.version} 5.6] >= 0 } {
        # see https://trac.macports.org/ticket/59128 for `${configure.cxx_stdlib} ne ""` test
        if { ${configure.cxx_stdlib} ne "libc++" && ${configure.cxx_stdlib} ne "" } {
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
    } elseif { [vercmp ${qt5.version} 5.5] >= 0 } {

        # always use the same standard library
        puts ${cache} QMAKE_CXXFLAGS+=-stdlib=${configure.cxx_stdlib}
        puts ${cache} QMAKE_LFLAGS+=-stdlib=${configure.cxx_stdlib}

        # override C++ flags set in ${prefix}/libexec/qt5/mkspecs/common/clang-mac.conf
        #    so value of ${configure.cxx_stdlib} can always be used
        if { ${configure.cxx_stdlib} ne "libc++" && ${configure.cxx_stdlib} ne "" } {
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
        if { ${configure.cxx_stdlib} ne "" } {
            puts ${cache} QMAKE_CXXFLAGS+=-stdlib=${configure.cxx_stdlib}
            puts ${cache} QMAKE_LFLAGS+=-stdlib=${configure.cxx_stdlib}
        }
        if {${qmake5_cxx11_flags} ne ""} {
            puts ${cache} QMAKE_CXXFLAGS+="${qmake5_cxx11_flags}"
        }
    }
    if {${qmake5_cxx_flags} ne "" } {
        puts ${cache} QMAKE_CXXFLAGS+="${qmake5_cxx_flags}"
    }
    if {${qmake5_c_flags} ne "" } {
        puts ${cache} QMAKE_CFLAGS+="${qmake5_c_flags}"
    }
    if {${qmake5_l_flags} ne "" } {
        puts ${cache} QMAKE_LFLAGS+="${qmake5_l_flags}"
    }

    if {${os.platform} eq "darwin" && ${os.major} < 11} {
        # use newer cctools on older platforms to handle output from newer clang versions
        depends_build-append port:cctools
        puts ${cache} QMAKE_AR="${prefix}/bin/ar\ cq"
        puts ${cache} QMAKE_RANLIB="${prefix}/bin/ranlib"
    }

    # accommodating variant request varies depending on how qtbase was built
    set base_debug false
    foreach {qt_test_name qt_test_info} [array get available_qt_versions] {
        set qt_test_base_port [lindex ${qt_test_info} 0]
        if {![catch {set result [active_variants ${qt_test_base_port} debug ""]}]} {
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

    # determine if qmake's default and user requests are compatible; override qmake if necessary
    if { ${this_debug} && !${base_debug}  } {
        puts ${cache} "QT_CONFIG+=debug_and_release build_all debug"
        puts ${cache} "CONFIG+=debug_and_release build_all"
        puts ${cache} "CONFIG-=release"
    }

    if { !${this_debug} && ${base_debug}  } {
        puts ${cache} "QT_CONFIG-=debug_and_release build_all debug"
        puts ${cache} "CONFIG-=debug debug_and_release build_all"
        puts ${cache} "CONFIG+=release"
    }

    # respect configure.optflags
    if {[vercmp ${qt5.version} 5.9] >= 0} {
        puts ${cache} "CONFIG+=optimize_size"
        puts ${cache} "QMAKE_CFLAGS_OPTIMIZE_SIZE=${configure.optflags}"
    } else {
        puts ${cache} "QMAKE_CXXFLAGS_RELEASE~=s/-O.+/${configure.optflags}/g"
    }

    foreach flag ${qt5.cxxflags} {
        puts ${cache} "QMAKE_CXXFLAGS+=${flag}"
    }

    foreach flag ${qt5.ldflags} {
        puts ${cache} "QMAKE_LFLAGS+=${flag}"
    }

    foreach flag ${qt5.frameworkpaths} {
        puts ${cache} "QMAKE_FRAMEWORKPATH+=${flag}"
    }

    # Boost PG support
    if { [info exists boost.version] } {
        puts ${cache} "QMAKE_CXXFLAGS+=[boost::cxx_flags]"
        puts ${cache} "QMAKE_LFLAGS+=[boost::ld_flags]"
        puts ${cache} "BOOST_DIR=[boost::install_area]"
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

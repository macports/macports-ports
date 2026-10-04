# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup defines standard settings when using qmake.
#
# Usage:
# PortGroup                     qmake6 1.0

PortGroup                       active_variants 1.1
PortGroup                       qt6 1.0

options qt6.add_spec qt6.debug_variant qt6.top_level qt6.cxxflags qt6.ldflags qt6.frameworkpaths qt6.spec_cmd
default qt6.add_spec yes
default qt6.debug_variant yes
default qt6.top_level {${configure.dir}}
default qt6.cxxflags {}
default qt6.ldflags {}
default qt6.frameworkpaths {}
default qt6.spec_cmd "-spec "

configure.cmd           ${qt6.dir}/bin/qmake
configure.pre_args-replace \
                        --prefix=${prefix} "PREFIX=${prefix}"
configure.args-append   "${qt6.spec_cmd}macx-clang"

platform macosx {
    # Use Xcode if CLT doesn't ship with an SDK
    # See: https://trac.macports.org/ticket/58779
    if { !${use_xcode} && ![file exists ${configure.developer_dir}/SDKs] } {
        use_xcode yes
    }
}

pre-configure {
    set cache_file "${qt6.top_level}/.qmake.cache"
    set cache [open ${cache_file} w 0644]
    ui_debug "QT6 Qmake Cache ${cache_file}"
    if {[variant_exists universal] && [variant_isset universal]} {
        puts ${cache} "QMAKE_APPLE_DEVICE_ARCHS=${configure.universal_archs}"
    } elseif { ${configure.build_arch} ne "" } {
        puts ${cache} "QMAKE_APPLE_DEVICE_ARCHS=${configure.build_arch}"
    } else {
        # If `supported_archs` is `noarch`, `configure.build_arch` can be empty (see e.g. qt6-qtbase-docs).
        # Having an empty QMAKE_APPLE_DEVICE_ARCHS can cause an error.
        # Even if it is not really needed, not having a QMAKE_APPLE_DEVICE_ARCHS at all can also cause an error.
        puts ${cache} "QMAKE_APPLE_DEVICE_ARCHS=${build_arch}"
    }
    puts ${cache} "QMAKE_MACOSX_DEPLOYMENT_TARGET=${macosx_deployment_target}"

    # https://github.com/qt/qtbase/commit/d64940891dffcb951f4b76426490cbc94fb4aba7
    # Enable ccache support if active and available in given qt6 version
    if { [option configure.ccache] } {
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
    set qmake6_cxx11_flags [list]
    set qmake6_cxx_flags   [list]
    set qmake6_c_flags     [list]
    set qmake6_l_flags     [list]
    foreach flag ${configure.cxxflags} {
        if { ${flag} eq "-D_GLIBCXX_USE_CXX11_ABI=0" } {
            lappend qmake6_cxx11_flags ${flag}
        }
    }
    foreach flag ${configure.cppflags} {
        lappend qmake6_c_flags   ${flag}
        lappend qmake6_cxx_flags ${flag}
    }
    # Need to respect ldflags as needed for legacysupport linking
    foreach flag ${configure.ldflags} {
        lappend qmake6_l_flags ${flag}
    }
    set qmake6_cxx11_flags [join ${qmake6_cxx11_flags} " "]
    set qmake6_cxx_flags   [join ${qmake6_cxx_flags}   " "]
    set qmake6_c_flags     [join ${qmake6_c_flags}     " "]
    set qmake6_l_flags     [join ${qmake6_l_flags}     " "]

    # see https://trac.macports.org/ticket/59128 for `${configure.cxx_stdlib} ne ""` test
    if { ${configure.cxx_stdlib} ne "libc++" && ${configure.cxx_stdlib} ne "" } {
        # override C++ flags set in ${prefix}/libexec/qt6/mkspecs/common/clang-mac.conf
        #    so value of ${configure.cxx_stdlib} can always be used
        puts ${cache} QMAKE_CXXFLAGS-=-stdlib=libc++
        puts ${cache} QMAKE_LFLAGS-=-stdlib=libc++
        puts ${cache} QMAKE_CXXFLAGS+=-stdlib=${configure.cxx_stdlib}
        puts ${cache} QMAKE_LFLAGS+=-stdlib=${configure.cxx_stdlib}
    }
    if {${qmake6_cxx11_flags} ne ""} {
        puts ${cache} QMAKE_CXXFLAGS+="${qmake6_cxx11_flags}"
    }

    if {${qmake6_cxx_flags} ne "" } {
        puts ${cache} QMAKE_CXXFLAGS+="${qmake6_cxx_flags}"
    }
    if {${qmake6_c_flags} ne "" } {
        puts ${cache} QMAKE_CFLAGS+="${qmake6_c_flags}"
    }
    if {${qmake6_l_flags} ne "" } {
        puts ${cache} QMAKE_LFLAGS+="${qmake6_l_flags}"
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

    puts ${cache} "CONFIG+=optimize_size"
    puts ${cache} "QMAKE_CFLAGS_OPTIMIZE_SIZE=${configure.optflags}"

    foreach flag ${qt6.cxxflags} {
        puts ${cache} "QMAKE_CXXFLAGS+=${flag}"
    }

    foreach flag ${qt6.ldflags} {
        puts ${cache} "QMAKE_LFLAGS+=${flag}"
    }

    foreach flag ${qt6.frameworkpaths} {
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

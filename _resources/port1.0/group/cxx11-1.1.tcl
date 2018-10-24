# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup introduces no new options. Simply including this
# PortGroup indicates that a port requires C++11
#
# Ideally the functionality of this PortGroup should be integrated into
# MacPorts base as a new option.

PortGroup compiler_blacklist_versions 1.0

# Compilers supporting C++11 are GCC >= 4.6 and clang >= 3.3.

if {${configure.cxx_stdlib} eq "libstdc++"} {

    # see https://trac.macports.org/ticket/53194
    configure.cxx_stdlib macports-libstdc++

    proc cxx11.add_dependencies {} {
        global os.major os.platform
        depends_lib-delete port:libgcc
        depends_lib-append port:libgcc
        if {${os.platform} eq "darwin" && ${os.major} < 13} {
            # prior to OS X Mavericks, libstdc++ was the default C++ runtime, so
            #    assume MacPorts libstdc++ must be ABI compatible with system libstdc++
            # for OS X Mavericks and above, users must select libstdc++, so
            #    assume they want default ABI compatibility
            # see https://gcc.gnu.org/onlinedocs/gcc-5.2.0/libstdc++/manual/manual/using_dual_abi.html
            configure.cxxflags-delete    -D_GLIBCXX_USE_CXX11_ABI=0
            configure.cxxflags-append    -D_GLIBCXX_USE_CXX11_ABI=0
            configure.objcxxflags-delete -D_GLIBCXX_USE_CXX11_ABI=0
            configure.objcxxflags-append -D_GLIBCXX_USE_CXX11_ABI=0
        }
    }
    # do not force all Portfiles to switch from depends_lib to depends_lib-append
    port::register_callback cxx11.add_dependencies

    if {(${os.platform} eq "darwin" && ${os.major} < 10) || ${build_arch} eq "ppc" || ${build_arch} eq "ppc64"} {
        # ports will build with gcc6, gcc4ABI-compatible
        pre-configure {
            ui_msg "C++11 ports are compiling with GCC. EXPERIMENTAL."
        }
        compiler.whitelist  macports-gcc-6
        universal_variant   no
    } else {
        compiler.whitelist  macports-clang-5.0
    }

    # see https://trac.macports.org/ticket/54766
    depends_lib-append port:libgcc

    compiler.blacklist-append   macports-gcc-4.3 macports-gcc-4.4 macports-gcc-4.5 macports-gcc \
        macports-llvm-gcc-4.2 apple-gcc-4.0 apple-gcc-4.2 gcc-3.3 gcc gcc-4.0 llvm-gcc-4.2 \
        macports-dragonegg-3.3 macports-dragonegg-3.4
} else {
    # GCC compilers cannot use libc++
    # We do not know what "cc" is, so blacklist it as well.
    compiler.blacklist-append   *gcc* {clang < 500} cc
}

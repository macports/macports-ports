# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# This PortGroup helps to maintain gnuradio dependencies coherent between
# gnuradio and gnuradio modules.
#
# Usage:
#
# PortGroup           gnuradio 1.0
#

PortGroup           cmake 1.1
PortGroup           boost 1.0

categories          science comms
platforms           darwin macosx

# declare which gnuradio are you using
options gnuradio.type
default gnuradio.type "gnuradio"

options gnuradio.python_version
options gnuradio.default_python_variant

if {[string first "37" $subport] > 1} {
    default gnuradio.python_versions { 2.7 }
    default gnuradio.default_python_variant +python27
} else {
    # the following versions use all the same python
    default gnuradio.python_versions { 3.8 3.9 3.10 }
    default gnuradio.default_python_variant +python39
}

# use C/C++11
compiler.c_standard   2011
compiler.cxx_standard 2011
boost.version 1.71

# see https://github.com/macports/macports-ports/pull/7805
license_noconflict-append openssl

# see https://github.com/macports/macports-ports/pull/7805
license_noconflict-append graphviz

# Define the available variants
foreach py_ver ${gnuradio.python_versions} {
    set py_ver_no_dot [join [split ${py_ver} "."] ""]
    set variant_line {variant python${py_ver_no_dot} description "Build with python ${py_ver} support"}
    foreach py_over ${gnuradio.python_versions} {
        if { ${py_ver} == ${py_over} } { continue }
        set py_over_no_dot [join [split ${py_over} "."] ""]
        append variant_line " conflicts python${py_over_no_dot}"
    }
    append variant_line { { } }
    eval $variant_line
    if {[variant_isset python${py_ver_no_dot}]} {
        if {${gnuradio.default_python_variant} != "+python${py_ver_no_dot}"} {
            set gnuradio.default_python_variant ""
        }
    }
}

# set default python variant if not selected
if {${gnuradio.default_python_variant} != ""} {
    default_variants-append "${gnuradio.default_python_variant}"
}

# If a python variant is enabled, activate it
set active_python_version ""
set active_python_version_no_dot ""
foreach py_ver ${gnuradio.python_versions} {
    set py_ver_no_dot [join [split ${py_ver} "."] ""]
    if {[variant_isset python${py_ver_no_dot}]} {
        set active_python_version        ${py_ver}
        set active_python_version_no_dot ${py_ver_no_dot}
    }
}

depends_build-append \
    port:pkgconfig

depends_lib-append \
    port:fftw-3-single \
    path:lib/libmpir.dylib:mpir \
    path:lib/libvolk.dylib:volk \
    port:gmp \
    port:python${active_python_version_no_dot}

# need matplotlib for polar encoder/decoder, runtime only
depends_run-append \
    port:py${active_python_version_no_dot}-matplotlib \
    port:py${active_python_version_no_dot}-opengl \
    port:py${active_python_version_no_dot}-scipy \
    port:py${active_python_version_no_dot}-numpy \
    port:py${active_python_version_no_dot}-cheetah

if {[string first "37" $subport] > 1} {
    # still require cppunit for testing; NOTE: cppunit is checked for
    # during configure, so we need it to be in depends_lib or
    # depends_build to be used correctly. Choose the latter since it's
    # not required for runtime; just for build/test.
    depends_build-append \
        port:cppunit
} else {
    # add dependencies for gnuradio >= 3.8
}

if {[string first "gr37-" $subport] >= 0} {
    depends_lib-append \
        port:gnuradio37

    depends_build-append \
        port:swig3-python

    configure.args-append \
        -DSWIG_EXECUTABLE=${prefix}/bin/swig3
} elseif {[string first "gr-" $subport] >= 0} {
    depends_lib-append \
        path:lib/libgnuradio-runtime.dylib:gnuradio

    depends_build-append \
        port:swig-python

    configure.args-append \
        -DSWIG_EXECUTABLE=${prefix}/bin/swig
}

# set build type to release or debug, not "MacPorts" since the GR
# CMake system checks for a valid value and this is not one of them
if {[variant_isset debug]} {
    cmake.build_type Debug
} else {
    cmake.build_type Release
}

# specify the Python version to use
set python_framework_dir ${frameworks_dir}/Python.framework/Versions/${active_python_version}
configure.args-append \
    -DPYTHON_EXECUTABLE=${python_framework_dir}/bin/python${active_python_version} \
    -DPYTHON_INCLUDE_DIR=${python_framework_dir}/Headers \
    -DPYTHON_LIBRARY=${python_framework_dir}/Python \
    -DGR_PYTHON_DIR=${python_framework_dir}/lib/python${active_python_version}/site-packages \
    -DDOXYGEN_DOT_EXECUTABLE=${prefix}/bin/dot \
    -DDOXYGEN_EXECUTABLE=${prefix}/bin/doxygen \
    -DCMAKE_MODULES_DIR=${prefix}/share/cmake \
    -DGMP_INCLUDE_DIR= \
    -DGMP_LIBRARY= \
    -DGMPXX_LIBRARY= \
    -DMPIR_INCLUDE_DIR=${prefix}/include \
    -DMPIR_LIBRARY=${prefix}/lib/libmpir.dylib \
    -DMPIRXX_LIBRARY=${prefix}/lib/libmpirxx.dylib \
    -DENABLE_DOXYGEN=OFF \
    -DENABLE_SPHINX=OFF

# remove top-level library and include paths, such that internal ones
# are searched before any already-installed ones.
configure.cppflags-delete -I${prefix}/include
configure.ldflags-delete  -L${prefix}/lib

# TODO check "macports-libstdc++" or "libstdc++" should not needed anymore, right?
# disable C/CXX standard extensions (e.g., "gnu++11" and "gnu11"
# rather than "c++11" and "c11"). GNU Radio itself does not
# require these extensions, and when compiling with Clang they
# don't really do anything anyway; so, just disable them.
configure.args-append \
    -DCMAKE_CXX_EXTENSIONS=OFF \
    -DCMAKE_C_EXTENSIONS=OFF

variant docs description "Install documentation" {
    # texlive-latex not needed from 3.9.0.0
    depends_build-append \
        port:doxygen \
        path:bin/dot:graphviz \
        port:py${active_python_version_no_dot}-sphinx \
        port:texlive-latex

    configure.args-delete \
        -DENABLE_DOXYGEN=OFF \
        -DENABLE_SPHINX=OFF \
        -DSPHINX_EXECUTABLE=

    configure.args-append \
        -DENABLE_DOXYGEN=ON \
        -DENABLE_SPHINX=ON \
        -DSPHINX_EXECUTABLE=${python_framework_dir}/bin/sphinx-build
}

default_variants-append \
    +docs

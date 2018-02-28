# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2010-2016 The MacPorts Project
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
# This PortGroup automatically sets up the standard environment for
# building an octave module.
#
# Usage:
#
#   PortGroup               octave 1.0
#   octave.setup            module version
#
# where module is the name of the module (e.g. communications) and
# version is its version.

options octave.module

# some header files from Octave require C++-11
# Octave requires c++-11 but can not use cxx11 PortGroup because Octave also
#    requires fortran from gcc
# Compilers supporting C++11 are GCC >= 4.6 and clang >= 3.3.
PortGroup compiler_blacklist_versions 1.0
compiler.blacklist-append   {*gcc-3*} {*gcc-4.[0-5]} {clang < 500} cc

# override universal_setup found in portutil.tcl so it uses muniversal PortGroup
# see https://trac.macports.org/ticket/51643
proc universal_setup {args} {
    if {[variant_exists universal]} {
        ui_debug "universal variant already exists, so not adding the default one"
    } elseif {[exists universal_variant] && ![option universal_variant]} {
        ui_debug "universal_variant is false, so not adding the default universal variant"
    } elseif {[exists use_xmkmf] && [option use_xmkmf]} {
        ui_debug "using xmkmf, so not adding the default universal variant"
    } elseif {![exists os.universal_supported] || ![option os.universal_supported]} {
        ui_debug "OS doesn't support universal builds, so not adding the default universal variant"
    } elseif {[llength [option supported_archs]] == 1} {
        ui_debug "only one arch supported, so not adding the default universal variant"
    } else {
        ui_debug "adding universal variant via PortGroup muniversal"
        uplevel "PortGroup muniversal 1.0"
        uplevel "default universal_archs_supported {\"i386 x86_64\"}"
    }
}

proc octave.setup {module version} {
    global octave.module

    octave.module               ${module}
    name                        octave-${module}
    version                     ${version}
    categories                  math science
    homepage                    http://octave.sourceforge.net/${octave.module}/
    master_sites                sourceforge:octave
    distname                    ${octave.module}-${version}

    depends_lib-append          path:bin/octave:octave

    worksrcdir                  ${octave.module}

    # do not build in parallel; many can't, and these are small builds
    # anyway, so no major need for this.

    use_parallel_build          no

    # configure_make.m calls "make --jobs n ..."
    # use environmental variable to set the number of jobs to 1
    # parallel build is a problem for octave-optiminterp

    configure.env-append        OMP_NUM_THREADS=1

    livecheck.type              regex
    livecheck.url               https://octave.sourceforge.io/${octave.module}/
    livecheck.regex             "Package Version:</td><td>(\\d+(\\.\\d+)*)</td>"
}

post-extract {
    # rename the effective worksrcdir to always be ${octave.module}

    set worksrcdir_name [exec /bin/ls ${workpath} | grep -v -E "^\\."]
    if {[string equal ${worksrcdir_name} ${octave.module}] == 0} {
        # work-around for case-insensitive file systems when the
        # extract directory name is the same as the octave module name
        # except for letter case; should always work no matter if the
        # file system is case-insensitive or case-sensitive.

        move ${workpath}/${worksrcdir_name} ${workpath}/tmp-${worksrcdir_name}
        move ${workpath}/tmp-${worksrcdir_name} ${workpath}/${octave.module}
    }
}

configure.universal_args-delete --disable-dependency-tracking

pre-configure {

    system -W ${workpath} "/usr/bin/tar cvfz ${distname}.tar.gz ${octave.module}"

    if { [variant_exists universal] && [variant_isset universal] } {
        global merger_configure_env
        global merger_configure_args

        foreach arch ${universal_archs_supported} {
            lappend merger_configure_env(${arch}) \
                OCTAVE_ARCH=${arch}
        }

        foreach arch ${universal_archs_supported} {
            set merger_configure_args(${arch}) \
                "'try; pkg build -verbose -nodeps ${workpath}/tmp-build-${arch} ${workpath}/${distname}.tar.gz; catch; disp(lasterror.message); exit(1); end_try_catch;'"
        }

    } else {
        configure.env-append OCTAVE_ARCH=${build_arch}
        configure.args \
            "'try; pkg build -verbose -nodeps ${workpath}/tmp-build ${workpath}/${distname}.tar.gz; catch; disp(lasterror.message); exit(1); end_try_catch;'"

        # fortran arch flag is not set automatically
        if {${build_arch} eq "x86_64" || ${build_arch} eq "ppc64"} {
            configure.fflags-append -m64
        } else {
            configure.fflags-append -m32
        }
    }

    configure.cmd /usr/bin/arch -arch \$OCTAVE_ARCH ${prefix}/bin/octave-cli

    configure.pre_args -q -f -H --eval
    configure.post_args

    configure.cxxflags-append -std=c++11
}

build.cmd /usr/bin/true
build.pre_args
build.args
build.post_args

pre-destroot {
    set octave_api_version [exec "${prefix}/bin/octave-config" -p API_VERSION]

    destroot.cmd /usr/bin/arch -arch \$OCTAVE_ARCH ${prefix}/bin/octave-cli
    destroot.pre_args -q -f -H --eval

    if { ${os.arch} eq "i386" } {
        if { ${os.major} >= 9 && [sysctl hw.cpu64bit_capable] == 1 } {
            set short_host_name x86_64-apple-${os.platform}${os.major}.x.x
        } else {
            set short_host_name i686-apple-${os.platform}${os.major}.x.x
        }
    } else {
        if { ${os.major} >= 9 && [sysctl hw.cpu64bit_capable] == 1 } {
            set short_host_name powerpc64-apple-${os.platform}${os.major}.x.x
        } else {
            set short_host_name powerpc-apple-${os.platform}${os.major}.x.x
        }
    }

    if { [variant_exists universal] && [variant_isset universal] } {
        global merger_destroot_env
        global merger_destroot_args

        foreach arch ${universal_archs_supported} {
            set octave_install_share ${destroot}-${arch}${prefix}/share/octave/packages
            set octave_install_lib   ${destroot}-${arch}${prefix}/lib/octave/packages
            set octave_tgz_file ${workpath}/tmp-build-${arch}/[exec /bin/ls ${workpath}/tmp-build-${arch}]

            lappend merger_destroot_env(${arch}) \
                OCTAVE_ARCH=${arch}

            destroot.args

            set merger_destroot_args(${arch}) \
                "'try;pkg prefix ${octave_install_share} ${octave_install_lib}; pkg install -verbose -nodeps -local ${octave_tgz_file}; delete(\"~/.octave_packages\"); catch; disp(lasterror.message); exit(1); end_try_catch;'"
        }

    } else {
        set octave_install_share ${destroot}${prefix}/share/octave/packages
        set octave_install_lib   ${destroot}${prefix}/lib/octave/packages
        set octave_tgz_file ${workpath}/tmp-build/[exec /bin/ls ${workpath}/tmp-build]

        destroot.env-append OCTAVE_ARCH=${build_arch}

        destroot.args \
            "'try; pkg prefix ${octave_install_share} ${octave_install_lib}; pkg install -verbose -nodeps -local ${octave_tgz_file}; catch; disp(lasterror.message); exit(1); end_try_catch;'"
    }

    destroot.post_args
}

post-deactivate {
    set octave_install_share ${prefix}/share/octave/packages
    set octave_install_lib   ${prefix}/lib/octave/packages
    system "${prefix}/bin/octave-cli -q -f -H --eval 'try; pkg prefix ${octave_install_share} ${octave_install_lib}; pkg -verbose -global rebuild; catch; disp(lasterror.message); exit(1); end_try_catch;'"
}

post-activate {
    set octave_install_share ${prefix}/share/octave/packages
    set octave_install_lib   ${prefix}/lib/octave/packages
    system "${prefix}/bin/octave-cli -q -f -H --eval 'try; pkg prefix ${octave_install_share} ${octave_install_lib}; pkg -verbose -global rebuild; disp(lasterror.message); catch; exit(1); end_try_catch;'"
}

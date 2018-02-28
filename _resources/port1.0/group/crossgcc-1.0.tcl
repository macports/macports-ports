# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2011-2016 The MacPorts Project
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
# This PortGroup automatically sets all the fields of the various cross gcc
# ports (e.g. arm-none-eabi-gcc).
#
# Usage:
#
#   PortGroup           crossgcc 1.0
#
#   crossgcc.setup      arm-none-eabi 4.6.1
#
#   # Optional: libc support
#   crossgcc.setup_libc newlib 1.19.0
#
#   # Optional: additional language support (e.g. Objective-C/Objective-C++)
#   crossgcc.languages-append objc obj-c++

options crossgcc.target \
        crossgcc.languages

default crossgcc.languages {{c c++}}

array set crossgcc.versions_info {
    7.1.0 {bzip2 {
        rmd160  a228dc45a09eda91b1a201d234f9013b3009b461
        sha256  8a8136c235f64c6fef69cac0d73a46a1a09bb250776a050aec8f9fc880bebc17
    }}
    7.2.0 {xz {
        rmd160  fa8eed36c78cf135f9cc88e60845996b5cfaba52
        sha256  1cf7adf8ff4b5aa49041c8734bbcf1ad18cc4c94d0029aae0f4e48841088479a
    }}
    7.3.0 {xz {
        rmd160  31f6934a0e0c0ca84b6668110f9afdb91c1f9023 \
        sha256  832ca6ae04636adbb430e865a1451adf6979ab44ca1c8374f61fba65645ce15c
    }}
}

proc crossgcc.setup {target version} {
    global crossgcc.target crossgcc.version crossgcc.versions_info

    set crossgcc.target $target
    set crossgcc.version $version

    uplevel {
        name            ${crossgcc.target}-gcc
        version         ${crossgcc.version}
        categories      cross devel
        platforms       darwin
        license         GPL-3+
        maintainers     nomaintainer

        description     The GNU compiler collection for ${crossgcc.target}
        long_description \
            The GNU compiler collection, including front ends for C, C++, Objective-C \
            and Objective-C++ for cross development for ${crossgcc.target}.

        homepage        https://gcc.gnu.org/
        master_sites    gnu:gcc/gcc-${version}/:gcc

        if {[info exists crossgcc.versions_info($version)]} {
            use_[lindex [set crossgcc.versions_info($version)] 0] yes

            checksums   {*}[lindex [set crossgcc.versions_info($version)] 1]
        } else {
            # the old default
            use_bzip2   yes
        }

        dist_subdir     gcc[lindex [split ${version} .] 0]
        distfiles       gcc-${version}${extract.suffix}:gcc

        worksrcdir      gcc-${version}

        depends_lib     port:${crossgcc.target}-binutils \
                        port:gmp \
                        port:mpfr \
                        port:libiconv \
                        port:libmpc \
                        port:zlib

        depends_build   port:gettext

        # Extract gcc distfiles only. libc tarball might be available as gzip only;
        # handled below in post-extract in the variant.
        extract.only    gcc-${version}${extract.suffix}

        # Build in a different directory, as advised in the README file.
        post-extract {
            file mkdir "${workpath}/build"
        }

        post-patch {
                # Fix the info pages and related stuff.
                #
                # path:     path to the doc directory (e.g. gas/doc/)
                # makefile: path to Makefile.in (e.g. gas/doc/Makefile.in)
                # name:     name of the info page (e.g. as)
                # suffix:   suffix of the source page (texinfo or texi)
                #
                #   path        makefile                 name         suffix
                set infopages {
                    gcc/doc     gcc/Makefile.in          cpp          texi
                    gcc/doc     gcc/Makefile.in          cppinternals texi
                    gcc/doc     gcc/Makefile.in          gcc          texi
                    gcc/doc     gcc/Makefile.in          gccint       texi
                    gcc/doc     gcc/Makefile.in          gccinstall   info
                    gcc/fortran gcc/fortran/Make-lang.in gfortran     texi
                    libquadmath libquadmath/Makefile.in  libquadmath  info
                    libgomp     libgomp/Makefile.in      libgomp      info
                }

                foreach { path makefile name suffix } $infopages {
                    set src      ${worksrcpath}/${path}/${name}.${suffix}
                    set makefile ${worksrcpath}/${makefile}
                    # If the makefile doesn't exists, skip it.
                    if { ! [file exists ${makefile}] } {continue}

                    # Fix the source
                    reinplace "s|setfilename ${name}.info|setfilename ${crossgcc.target}-${name}.info|g" ${src}
                    reinplace "s|(${name})|(${crossgcc.target}-${name})|g" ${src}
                    reinplace "s|@file{${name}}|@file{${crossgcc.target}-${name}}|g" ${src}

                    # Rename the source
                    file rename ${worksrcpath}/${path}/${name}.${suffix} \
                                ${worksrcpath}/${path}/${crossgcc.target}-${name}.${suffix}

                    # Fix the Makefile
                    reinplace -E "s:\[\[:<:\]\]${name}\\.(info|pod|${suffix}):${crossgcc.target}-&:g" ${makefile}

                    # Fix install-info's dir.
                    # (note: this may be effectless if there was no info dir to be fixed)
                    reinplace "s|--info-dir=\$(DESTDIR)\$(infodir)|--dir-file=\$(DESTDIR)\$(infodir)/${crossgcc.target}-gcc-dir|g" ${makefile}
                }

                # Do not install libiberty
                reinplace {/^install:/s/ .*//} ${worksrcpath}/libiberty/Makefile.in
        }

        # the generated compiler doesn't accept -arch
        configure.cc_archflags
        configure.cxx_archflags
        configure.objc_archflags
        configure.ld_archflags

        # the bootstrap compiler doesn't accept -stdlib
        configure.cxx_stdlib

        # We don't need system includes(this prevents xgcc to include system-wide
        # unwind.h if it is present)!
        compiler.cpath

        configure.dir   ${workpath}/build
        configure.cmd   ${worksrcpath}/configure
        configure.args  --target=${crossgcc.target} \
                        --infodir=${prefix}/share/info \
                        --mandir=${prefix}/share/man \
                        --datarootdir=${prefix}/share/${name} \
                        --with-system-zlib \
                        --with-gmp=${prefix} \
                        --with-mpfr=${prefix} \
                        --with-mpc=${prefix} \
                        --enable-stage1-checking \
                        --enable-multilib

        # The Portfile may modify crossgcc.languages, thus, evaluate the option
        # late in this pre-configure phase
        pre-configure {
            configure.args-append --enable-languages="[join ${crossgcc.languages} ","]"
        }

        configure.env-append \
            AR_FOR_TARGET=${crossgcc.target}-ar \
            AS_FOR_TARGET=${crossgcc.target}-as \
            LD_FOR_TARGET=${crossgcc.target}-ld \
            NM_FOR_TARGET=${crossgcc.target}-nm \
            OBJDUMP_FOR_TARGET=${crossgcc.target}-objdump \
            RANLIB_FOR_TARGET=${crossgcc.target}-ranlib \
            STRIP_FOR_TARGET=${crossgcc.target}-strip

        # https://trac.macports.org/ticket/29104
        # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=48301
        if {[vercmp ${xcodeversion} 4.3] < 0} {
            compiler.blacklist llvm-gcc-4.2
        }

        universal_variant no

        build.dir               ${workpath}/build

        # this port installs files to ${prefix}/${crossgcc.target}
        destroot.violate_mtree yes

        pre-destroot {
            # gcc needs the cross directory structure to be present
            # in order to fill it during installation.
            file mkdir "${destroot}/${prefix}/${crossgcc.target}/bin"
            file mkdir "${destroot}/${prefix}/${crossgcc.target}/lib"
        }

        post-destroot {
            # FSF propaganda (should already be there or would conflict)
            file delete -force "${destroot}/${prefix}/share/man/man7"
        }

        livecheck.type  regex
        livecheck.url   https://ftp.gnu.org/gnu/gcc/
        livecheck.regex gcc-(\[0-9\]+\\.\[0-9.\]+)/
    # uplevel
    }
# crossgcc.setup
}

proc crossgcc.setup_libc {libc_name libc_version} {
    global crossgcc.libc_name crossgcc.libc_version

    set crossgcc.libc_name $libc_name
    set crossgcc.libc_version $libc_version

    switch -exact $libc_name {
        newlib {
            uplevel {
                set dnewlib newlib-${crossgcc.libc_version}.tar.gz

                master_sites-append https://sourceware.org/pub/newlib/:newlib
                distfiles-append ${dnewlib}:newlib

                post-extract {
                    system -W ${workpath} "tar -xzf ${distpath}/newlib-${crossgcc.libc_version}.tar.gz"
                    ln -s ${workpath}/newlib-${crossgcc.libc_version}/newlib ${workpath}/gcc-${version}/
                }

                configure.args-append --with-newlib
            }
        }
        default {
            pre-fetch {
                ui_error "libc $libc_name is not supported by port group crossgcc"
                return -code error "unsupported libc"
            }
        }
    }
}

# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
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

default crossgcc.languages "c c++"

array set crossgcc.versions_info {
    7.1.0 {bzip2 {
        rmd160  a228dc45a09eda91b1a201d234f9013b3009b461
        sha256  8a8136c235f64c6fef69cac0d73a46a1a09bb250776a050aec8f9fc880bebc17 \
        size    84303533
    }}
    7.2.0 {xz {
        rmd160  fa8eed36c78cf135f9cc88e60845996b5cfaba52
        sha256  1cf7adf8ff4b5aa49041c8734bbcf1ad18cc4c94d0029aae0f4e48841088479a \
        size    62312628
    }}
    7.3.0 {xz {
        rmd160  31f6934a0e0c0ca84b6668110f9afdb91c1f9023 \
        sha256  832ca6ae04636adbb430e865a1451adf6979ab44ca1c8374f61fba65645ce15c \
        size    62462388
    }}
    7.4.0 {xz {
        rmd160  77d3cdafe7df748fa484a300e9513acb3ee2c2e1 \
        sha256  eddde28d04f334aec1604456e536416549e9b1aa137fc69204e65eb0c009fe51 \
        size    62601888
    }}
    8.1.0 {xz {
        rmd160  de00e96f3d70b6a08215930a6884672e56975d05 \
        sha256  1d1866f992626e61349a1ccd0b8d5253816222cdc13390dcfaa74b093aa2b153 \
        size    63372320
    }}
    8.2.0 {xz {
        rmd160  4fba19867980d04bed1e62d46d4787c99f4fd13d \
        sha256  196c3c04ba2613f893283977e6011b2345d1cd1af9abeac58e916b1aab3e0080 \
        size    63460876
    }}
    8.3.0 {xz {
        rmd160  59396f7136301466d0ec15eb7307558c0da692df \
        sha256  64baadfe6cc0f4947a84cb12d7f0dfaf45bb58b7e92461639596c21e02d97d2c \
        size    63694700
    }}
    9.1.0 {xz {
        rmd160  b9dd53082905c4ca2f7f8291af1e4d015bc97d39 \
        sha256  79a66834e96a6050d8fe78db2c3b32fb285b230b855d0a66288235bc04b327a0 \
        size    70546856
    }}
    9.2.0 {xz {
        rmd160  a51d7f812f45980c517c4505e04a217cf319a992 \
        sha256  ea6ef08f121239da5695f76c9b33637a118dcf63e24164422231917fa61fb206 \
        size    70607648
    }}
    9.3.0 {xz {
        rmd160  e0ade31726b8fbb1eb308e2b1383a79633aef996 \
        sha256  71e197867611f6054aa1119b13a0c0abac12834765fe2d81f35ac57f84f742d1 \
        size    70533868
    }}
    10.2.0 {xz {
        rmd160  73f182e7d40e5c2988b2b8cd80cfca601f20e9fc \
        sha256  b8dd4368bb9c7f0b98188317ee0254dd8cc99d1e3a18d0ff146c855fe16c1d8c \
        size    75004144
    }}
    10.3.0 {xz {
        rmd160  8edb715cf1159fd8de773d0d5208d2e83ca36402 \
        sha256  64f404c1a650f27fc33da242e1f2df54952e3963a49e06e73f6940f3223ac344 \
        size    76692288
    }}
    11.1.0 {xz {
        rmd160  083384ca351ea1cb6e04d15425af2103c908edf4 \
        sha256  4c4a6fb8a8396059241c2e674b85b351c26a5d678274007f076957afa1cc9ddf \
        size    78877216
    }}
    11.2.0 {xz {
        rmd160  0fdd0b2c0954ccbd32e24f027d7b55fd26dcc627 \
        sha256  d08edc536b54c372a1010ff6619dd274c0f1603aa49212ba20f7aa2cda36fa8b \
        size    80888824
    }}
    11.3.0 {xz {
        rmd160  0c54f3971b4afbd78954d46852f733ff3fae266c \
        sha256  b47cf2818691f5b1e21df2bb38c795fac2cfbd640ede2d0a5e1c89e338a3ac39 \
        size    81141364
    }}
}

array set newlib.versions_info {
    2.4.0 {gz {
        rmd160  e7a98a00aca89aad0ee2e2b98993fd8e643d98ce \
        sha256  545b3d235e350d2c61491df8b9f775b1b972f191380db8f52ec0b1c829c52706 \
        size    17574364
    }}
    3.0.0 {gz {
        rmd160  505d486c9c658d10ed3b1af13459b2f289680b1f \
        sha256  c8566335ee74e5fcaeb8595b4ebd0400c4b043d6acb3263ecb1314f8f5501332 \
        size    18168046
    }}
    3.1.0 {gz {
        rmd160  bf4f474ef482a8ba0b2d57254051d79c48c5a633 \
        sha256  fb4fa1cc21e9060719208300a61420e4089d6de6ef59cf533b57fe74801d102a \
        size    17958952
    }}
    4.1.0 {gz {
        rmd160  9fa5c18bad59e99e6e98062e223c2dd9a065072a \
        sha256  f296e372f51324224d387cc116dc37a6bd397198756746f93a2b02e9a5d40154 \
        size    18648429
    }}
}

proc crossgcc.setup {target version} {
    global crossgcc.target crossgcc.version crossgcc.versions_info

    set crossgcc.target $target
    set crossgcc.version $version

    uplevel {
        PortGroup       compiler_blacklist_versions 1.0
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

            checksums   gcc-${version}${extract.suffix} {*}[lindex [set crossgcc.versions_info($version)] 1]
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
                        path:lib/pkgconfig/isl.pc:isl \
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
                    reinplace -q "s|setfilename ${name}.info|setfilename ${crossgcc.target}-${name}.info|g" ${src}
                    reinplace -q "s|(${name})|(${crossgcc.target}-${name})|g" ${src}
                    reinplace -q "s|@file{${name}}|@file{${crossgcc.target}-${name}}|g" ${src}

                    # Rename the source
                    file rename ${worksrcpath}/${path}/${name}.${suffix} \
                                ${worksrcpath}/${path}/${crossgcc.target}-${name}.${suffix}

                    # Fix the Makefile
                    reinplace -q -E "s:\[\[:<:\]\]${name}\\.(info|pod|${suffix}):${crossgcc.target}-&:g" ${makefile}

                    # Fix install-info's dir.
                    # (note: this may be effectless if there was no info dir to be fixed)
                    reinplace -q "s|--info-dir=\$(DESTDIR)\$(infodir)|--dir-file=\$(DESTDIR)\$(infodir)/${crossgcc.target}-gcc-dir|g" ${makefile}
                }

                # Do not install libiberty
                reinplace -q {/^install:/s/ .*//} ${worksrcpath}/libiberty/Makefile.in
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

        # https://trac.macports.org/ticket/57153
        configure.args-append --disable-libcc1

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
        # Failed to build with clang from Xcode 4.5
        # fatal error: error in backend: ran out of registers during register allocation
        compiler.blacklist  {clang >= 421 < 422}

        # Opportunistic links zstd for LTO byte code compression
        if {[vercmp ${version} "10.0"] >= 0} {
            depends_lib-append  port:zstd
        }

        # Section taken from gcc11 Portfile
        if {[vercmp ${version} "11.0"] >= 0} {
            # https://trac.macports.org/ticket/29067
            # https://trac.macports.org/ticket/29104
            # https://trac.macports.org/ticket/47996
            # https://trac.macports.org/ticket/58493
            compiler.blacklist-append {clang < 800} gcc-4.0 *gcc-4.2 {llvm-gcc-4.2 < 2336.1} {macports-clang-3.[4-7]}

            # https://build.macports.org/builders/ports-10.13_x86_64-builder/builds/105513/steps/install-port/logs/stdio
            # c++/v1/functional:1408:2: error: no member named 'fancy_abort' in namespace 'std::__1'; did you mean simply 'fancy_abort'?
            compiler.blacklist-append {clang < 1000}
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
                set suffix ".tar.gz"
                if {[info exists newlib.versions_info(${crossgcc.libc_version})]} {
                    set suffix ".tar.[lindex [set newlib.versions_info(${crossgcc.libc_version})] 0]"
                }
                set dnewlib newlib-${crossgcc.libc_version}${suffix}

                master_sites-append https://sourceware.org/pub/newlib/:newlib
                distfiles-append ${dnewlib}:newlib

                if {[info exists newlib.versions_info(${crossgcc.libc_version})]} {
                    checksums-append ${dnewlib} {*}[lindex [set newlib.versions_info(${crossgcc.libc_version})] 1]
                }

                post-extract {
                    system -W ${workpath} "tar -xf ${distpath}/${dnewlib}"
                    ln -s ${workpath}/newlib-${crossgcc.libc_version}/newlib ${workpath}/gcc-${version}/
                    ln -s ${workpath}/newlib-${crossgcc.libc_version}/libgloss ${workpath}/gcc-${version}/
                }

                configure.args-append --with-newlib --with-libgloss
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

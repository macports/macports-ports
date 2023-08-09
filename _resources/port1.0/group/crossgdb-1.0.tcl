# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup automatically sets all the fields of the various cross gdb
# ports (e.g. arm-none-eabi-gdb).
#
# Usage:
#
#   PortGroup           crossgdb 1.0
#   crossgdb.setup      arm-none-eabi 11.1

options crossgdb.target

array set crossgdb.version_info {
    11.1 {xz {
        rmd160  da07d7504be6c7d11c98751e0cbef75685daceba \
        sha256  cccfcc407b20d343fb320d4a9a2110776dd3165118ffd41f4b1b162340333f94 \
        size    22040696
    }}
    11.2 {xz {
        rmd160  47951f9273bf702dbdfb226b606687cb4ca49316
        sha256  1497c36a71881b8671a9a84a0ee40faab788ca30d7ba19d8463c3cc787152e32
        size    22039420
    }}
    12.1 {xz {
        rmd160  53ce945d3a130f90d164e69f2d3856a9c332bd96 \
        sha256  0e1793bf8f2b54d53f46dea84ccfd446f48f81b297b28c4f7fc017b818d69fed \
        size    22470332
    }}
    13.1 {xz {
        rmd160  ac5732b3a6e943070e308086be89cccc96394da0 \
        sha256  115ad5c18d69a6be2ab15882d365dda2a2211c14f480b3502c6eba576e2e95a0 \
        size    23665472
    }}
}

proc crossgdb.setup {target version} {
    global crossgdb.target crossgdb.version crossgdb.version_info

    set crossgdb.target ${target}
    set crossgdb.version ${version}

    uplevel {
        name                ${crossgdb.target}-gdb
        version             ${crossgdb.version}
        categories          cross devel
        platforms           darwin
        license             GPL-3+
        maintainers         nomaintainer

        description         GDB: The GNU Project Debugger for ${crossgdb.target}
        long_description    {*}${description}

        homepage            https://www.gnu.org/software/gdb/
        master_sites        gnu:gdb

        if {[info exists crossgdb.version_info(${version})]} {
            use_[lindex [set crossgdb.version_info(${version})] 0] yes

            checksums gdb-${version}${extract.suffix} {*}[lindex [set crossgdb.version_info(${version})] 1]
        } else {
            # the old default
            use_bzip2       yes
        }

        dist_subdir         gdb[lindex [split ${version} .] 0]
        distfiles           gdb-${version}${extract.suffix}:gdb

        worksrcdir          gdb-${version}

        # These dependencies are listed under depends_lib rather than
        # depends_build because gdb will link with libraries they provide if
        # installed. There may be more. See variable host_libs in configure.ac.
        # port:guile should also be a dependency, but currently does not build
        # universally.
        # https://trac.macports.org/ticket/48767
        depends_lib-append  port:${crossgdb.target}-gcc \
                            port:boehmgc \
                            port:expat \
                            port:gmp \
                            port:libiconv \
                            port:ncurses \
                            port:zlib

        post-patch {
            # Fix the info pages and related stuff.
            #
            # path:     path to the doc directory (e.g. gas/doc/)
            # makefile: path to Makefile.in (e.g. gas/doc/Makefile.in)
            # name:     name of the info page (e.g. as)
            # suffix:   suffix of the source page (texinfo or texi)
            #
            #   path        makefile                name        suffix
            set infopages {
                bfd/doc     bfd/doc/Makefile.in     bfd         texi
                gdb/doc     gdb/doc/Makefile.in     annotate    texinfo
                gdb/doc     gdb/doc/Makefile.in     gdb         texinfo
                gdb/doc     gdb/doc/Makefile.in     stabs       texinfo
            }

            foreach { path makefile name suffix } ${infopages} {
                set src      ${worksrcpath}/${path}/${name}.${suffix}
                set makefile ${worksrcpath}/${makefile}
                # If the makefile doesn't exists, skip it.
                if { ! [file exists ${makefile}] } {continue}

                # Fix the source
                reinplace -q "s|setfilename ${name}.info|setfilename ${crossgdb.target}-${name}.info|g" ${src}
                reinplace -q "s|(${name})|(${crossgdb.target}-${name})|g" ${src}
                reinplace -q "s|@file{${name}}|@file{${crossgdb.target}-${name}}|g" ${src}

                # Rename the source
                file rename ${worksrcpath}/${path}/${name}.${suffix} \
                    ${worksrcpath}/${path}/${crossgdb.target}-${name}.${suffix}

                # Fix the Makefile
                reinplace -q -E "s:\[\[:<:\]\]${name}\\.(info|pod|${suffix}):${crossgdb.target}-&:g" ${makefile}

                # Fix install-info's dir.
                # (note: this may be effectless if there was no info dir to be fixed)
                reinplace -q "s|--info-dir=\$(DESTDIR)\$(infodir)|--dir-file=\$(DESTDIR)\$(infodir)/${crossgdb.target}-gdb-dir|g" ${makefile}
            }

            # Do not install libiberty
            reinplace -q {/^install:/s/ .*//} ${worksrcpath}/libiberty/Makefile.in
        }

        # gdb is not supported on macOS ARM now
        # See https://inbox.sourceware.org/gdb/3185c3b8-8a91-4beb-a5d5-9db6afb93713@Spark
        supported_archs x86_64 i386

        # Needs C++11; halfway redundant due to the blacklist above, but make
        # sure selected compiler supports the standard - getting rid of old
        # Apple GCC versions and the like?
        compiler.cxx_standard 2011

        # Tell MacPorts to pick a TLS-compatible compiler
        # See https://trac.macports.org/ticket/65105
        compiler.thread_local_storage yes

        configure.dir       ${workpath}/build
        configure.cmd       ${worksrcpath}/configure
        configure.args      --target=${crossgdb.target} \
                            --infodir=${prefix}/share/info \
                            --mandir=${prefix}/share/man \
                            --with-docdir=${prefix}/share/doc \
                            --with-gdb-datadir=${prefix}/share/${name} \
                            --without-guile \
                            --without-python \
                            --disable-werror

        pre-configure {
            file mkdir ${configure.dir}
        }

        build.dir ${configure.dir}

        # All cross ports violate the mtree layout and installs files to
        # ${prefix}/${crossgdb.target}
        destroot.violate_mtree yes

        # All *-binutils cross ports is not universal
        universal_variant no

        post-destroot {
            # Avoid conflicts with ${crossgdb.target}-binutils and another
            # ${crossgdb.target} ports
            file delete ${destroot}${prefix}/share/info/${crossgdb.target}-bfd.info
            file delete ${destroot}${prefix}/share/info/ctf-spec.info

            # Avoid conflicts with gdb, also see
            # https://trac.macports.org/ticket/43098
            file delete -force ${destroot}${prefix}/share/locale
            file delete -force ${destroot}${prefix}/include/gdb
            file delete ${destroot}${prefix}/share/info/bfd.info

            # Avoid conflicts with another crossgdb ports
            move ${destroot}${prefix}/include/sim \
                ${destroot}${prefix}/include/${crossgdb.target}-sim
        }

        notes "
The header files for sim have been moved to avoid conflicts with other
cross gdb ports. The files are located in the following path:
    ${prefix}/include/${crossgdb.target}-sim
"

        if {${os.platform} eq "darwin" && ${os.major} >= 12} {
            notes-append "
You will need to codesign ${prefix}/bin/${crossgdb.target}-gdb

See https://sourceware.org/gdb/wiki/BuildingOnDarwin#Giving_gdb_permission_to_control_other_processes
for more information.
"
        }

        livecheck.type  regex
        livecheck.url   https://ftp.gnu.org/gnu/gdb/
        livecheck.regex gdb-(\\d+(?:\\.\\d+)+)\\.tar
    }
}

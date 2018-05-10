# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup automatically sets all the fields of the various cross binutils
# ports (e.g. spu-binutils).
#
# Usage:
#
#   PortGroup               crossbinutils 1.0
#   crossbinutils.setup     spu 2.27

options crossbinutils.target

array set crossbinutils.versions_info {
    2.30 {xz {
        rmd160  7f439bd642e514e89075a47758414ea65c50c3b3 \
        sha256  6e46b8aeae2f727a36f0bd9505e405768a72218f1796f0d09757d45209871ae6 \
        size    20286700
    }}
}

proc crossbinutils.setup {target version} {
    global master_sites workpath worksrcpath extract.suffix prefix crossbinutils.target crossbinutils.versions_info

    crossbinutils.target ${target}

    name            ${target}-binutils
    version         ${version}
    categories      cross devel
    platforms       darwin
    license         GPL-3+
    maintainers     nomaintainer

    description     FSF Binutils for ${target} cross development
    long_description \
        Free Software Foundation development toolchain ("binutils") for \
        ${target} cross development.

    homepage        https://www.gnu.org/software/binutils/binutils.html
    master_sites    gnu:binutils \
                    http://mirrors.ibiblio.org/gnu/ftp/gnu/binutils/
    dist_subdir     binutils
    distname        binutils-${version}
    worksrcdir      binutils-[string trimright ${version} {[a-zA-Z]}]

    if {[info exists crossbinutils.versions_info($version)]} {
        use_[lindex [set crossbinutils.versions_info($version)] 0] yes

        checksums   {*}[lindex [set crossbinutils.versions_info($version)] 1]
    } else {
        # the old default
        use_bzip2   yes
        #use_xz yes
    }

    post-extract {
        delete ${worksrcpath}/etc
        file mkdir ${workpath}/build
    }

    post-patch {
        set infopages {
            gas/doc         as
            bfd/doc         bfd
            binutils/doc    binutils
            gprof           gprof
            ld              ld
        }

        foreach {dir page} ${infopages} {
            # Fix texinfo source file
            set tex [glob -directory ${worksrcpath}/${dir} ${page}.texi*]
            reinplace \
                /setfilename/s/${page}/${crossbinutils.target}-${page}/ ${tex}
            reinplace s/(${page})/(${crossbinutils.target}-${page})/g ${tex}
            reinplace \
                "s/@file{${page}}/@file{${crossbinutils.target}-${page}}/g" \
                ${tex}
            move ${tex} \
                ${worksrcpath}/${dir}/${crossbinutils.target}-${page}[file extension ${tex}]

            # Fix Makefile
            reinplace -E \
                s/\[\[:<:\]\]${page}\\.(info|texi)/${crossbinutils.target}-&/g \
                ${worksrcpath}/${dir}/Makefile.in
        }

        # Fix packages' names.
        foreach dir {bfd binutils gas gold gprof ld opcodes} {
            reinplace "/^ PACKAGE=/s/=.*/=${crossbinutils.target}-${dir}/" \
                ${worksrcpath}/${dir}/configure
        }

        # Install target-compatible libbfd/libiberty in the target's directory
        reinplace "s|bfdlibdir=.*|bfdlibdir='${prefix}/${crossbinutils.target}/host/lib'|g" \
            ${worksrcpath}/bfd/configure                                \
            ${worksrcpath}/opcodes/configure
        reinplace "s|bfdincludedir=.*|bfdincludedir='${prefix}/${crossbinutils.target}/host/include'|g"  \
            ${worksrcpath}/bfd/configure                                             \
            ${worksrcpath}/opcodes/configure

        reinplace "s|\$(libdir)|\"${prefix}/${crossbinutils.target}/host/lib\"|g" \
            ${worksrcpath}/libiberty/Makefile.in
        reinplace "s|/\$(MULTIOSDIR)||g" \
            ${worksrcpath}/libiberty/Makefile.in
    }

    depends_lib \
        port:gettext \
        port:zlib

    configure.dir   ${workpath}/build
    configure.cmd   ${worksrcpath}/configure

    configure.ldflags-append \
        -lintl

    configure.args \
        --target=${target} \
        --program-prefix=${target}- \
        --enable-install-libiberty=${prefix}/${crossbinutils.target}/host  \
        --enable-install-libbfd

    build.dir ${workpath}/build

    destroot.violate_mtree yes

    post-destroot {
        set docdir ${prefix}/share/doc/${name}
        xinstall -d ${destroot}${docdir}
        xinstall -m 644 \
            {*}[glob -type f ${worksrcpath}/{COPYING*,ChangeLog,MAINTAINERS,README*}] \
            ${destroot}${docdir}
    }

    universal_variant no

    livecheck.type  regex
    livecheck.url   [lindex ${master_sites} 1]
    livecheck.regex "binutils-((?!.*binutils.*|\\${extract.suffix}).*)\\${extract.suffix}"
}

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
    2.26 {bzip2 {
        rmd160  ce0400ffcc1200280854fefb29f97b63507bad14 \
        sha256  c2ace41809542f5237afc7e3b8f32bb92bc7bc53c6232a84463c423b0714ecd9 \
        size    25543552
    }}
    2.30 {xz {
        rmd160  7f439bd642e514e89075a47758414ea65c50c3b3 \
        sha256  6e46b8aeae2f727a36f0bd9505e405768a72218f1796f0d09757d45209871ae6 \
        size    20286700
    }}
    2.31 {xz {
        rmd160  cc4eece9d281ca10511e0618fac1f6ddbd9b42df \
        sha256  231036df7ef02049cdbff0681f4575e571f26ea8086cf70c2dcd3b6c0f4216bf \
        size    20445772
    }}
    2.31.1 {xz {
        rmd160  9eeff67d0ae96bfb1bd1db20991b90166d5b15c5 \
        sha256  5d20086ecf5752cc7d9134246e9588fa201740d540f7eb84d795b1f7a93bca86 \
        size    20467996
    }}
    2.32 {xz {
        rmd160  cfff50aae6534512a51fbb720e30f37484f8193e \
        sha256  0ab6c55dd86a92ed561972ba15b9b70a8b9f75557f896446c82e8b36e473ee04 \
        size    20774880
    }}
    2.33.1 {xz {
        rmd160  f621e04d98d257acbc1f82a4043e565cf91207b4 \
        sha256  ab66fc2d1c3ec0359b8e08843c9f33b63e8707efdff5e4cc5c200eae24722cbf \
        size    21490848
    }}
    2.34 {xz {
        rmd160  8ee249f7c98c925ef650eaca3b4d1710d75be4e7 \
        sha256  f00b0e8803dc9bab1e2165bd568528135be734df3fabf8d0161828cd56028952 \
        size    21637796
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

        checksums   binutils-${version}${extract.suffix} {*}[lindex [set crossbinutils.versions_info($version)] 1]
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
            reinplace -q \
                /setfilename/s/${page}/${crossbinutils.target}-${page}/ ${tex}
            reinplace -q s/(${page})/(${crossbinutils.target}-${page})/g ${tex}
            reinplace -q \
                "s/@file{${page}}/@file{${crossbinutils.target}-${page}}/g" \
                ${tex}
            move ${tex} \
                ${worksrcpath}/${dir}/${crossbinutils.target}-${page}[file extension ${tex}]

            # Fix Makefile
            reinplace -q -E \
                s/\[\[:<:\]\]${page}\\.(info|texi)/${crossbinutils.target}-&/g \
                ${worksrcpath}/${dir}/Makefile.in
        }

        # Fix packages' names.
        foreach dir {bfd binutils gas gold gprof ld opcodes} {
            reinplace -q "/^ PACKAGE=/s/=.*/=${crossbinutils.target}-${dir}/" \
                ${worksrcpath}/${dir}/configure
        }

        # Install target-compatible libbfd/libiberty in the target's directory
        reinplace -q "s|bfdlibdir=.*|bfdlibdir='${prefix}/${crossbinutils.target}/host/lib'|g" \
            ${worksrcpath}/bfd/configure                                \
            ${worksrcpath}/opcodes/configure
        reinplace -q "s|bfdincludedir=.*|bfdincludedir='${prefix}/${crossbinutils.target}/host/include'|g"  \
            ${worksrcpath}/bfd/configure                                             \
            ${worksrcpath}/opcodes/configure

        reinplace -q "s|\$(libdir)|\"${prefix}/${crossbinutils.target}/host/lib\"|g" \
            ${worksrcpath}/libiberty/Makefile.in
        reinplace -q "s|/\$(MULTIOSDIR)||g" \
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
        --enable-install-libiberty=${prefix}/${crossbinutils.target}/host

    build.dir ${workpath}/build

    destroot.violate_mtree yes

    post-destroot {
        set docdir ${prefix}/share/doc/${name}
        xinstall -d ${destroot}${docdir}
        xinstall -m 0644 \
            {*}[glob -type f ${worksrcpath}/{COPYING*,ChangeLog,MAINTAINERS,README*}] \
            ${destroot}${docdir}
    }

    universal_variant no

    livecheck.type  regex
    livecheck.url   [lindex ${master_sites} 1]
    livecheck.regex "binutils-((?!.*binutils.*|\\${extract.suffix}).*)\\${extract.suffix}"
}

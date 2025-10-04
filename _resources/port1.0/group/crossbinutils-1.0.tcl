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
    2.35 {xz {
        rmd160  3825ec98bfd8b00009a616e20976c4296aac69bf \
        sha256  1b11659fb49e20e18db460d44485f09442c8c56d5df165de9461eb09c8302f85 \
        size    22042160
    }}
    2.35.1 {xz {
        rmd160  75614738ce319177ab4f66d6d68618343c5a3184 \
        sha256  3ced91db9bf01182b7e420eab68039f2083aed0a214c0424e257eae3ddee8607 \
        size    22031720
    }}
    2.36 {xz {
        rmd160  3b9c7a8546771796e405645ed713008e79243868 \
        sha256  5788292cc5bbcca0848545af05986f6b17058b105be59e99ba7d0f9eb5336fb8 \
        size    22760136
    }}
    2.36.1 {xz {
        rmd160  65047a9edd726380fa1e117514513c86b77cf3a0 \
        sha256  e81d9edf373f193af428a0f256674aea62a9d74dfe93f65192d4eae030b0f3b0 \
        size    22772248
    }}
    2.37 {xz {
        rmd160  55280d11b786b931cb53819bc5b3b5d6b6b4383d \
        sha256  820d9724f020a3e69cb337893a0b63c2db161dadcb0e06fc11dc29eb1e84a32c \
        size    22916924
    }}
    2.38 {xz {
        rmd160  e6d37fd602fefa25560937efb57ed3b126d7578b \
        sha256  e316477a914f567eccc34d5d29785b8b0f5a10208d36bbacedcc39048ecfe024 \
        size    23651408
    }}
    2.39 {xz {
        rmd160  eb5d638227d0543d3055fc7e6d8d8c28534f55c9 \
        sha256  645c25f563b8adc0a81dbd6a41cffbf4d37083a382e02d5d3df4f65c09516d00 \
        size    25167756
    }}
    2.40 {xz {
        rmd160  3ba72b8be2349251a51108e59cdb03bb4382fa45 \
        sha256  0f8a4c272d7f17f369ded10a4aca28b8e304828e95526da482b0ccc4dfc9d8e1 \
        size    25241484
    }}
    2.41 {xz {
        rmd160  17d22bc99e0eee2dc8b77083f16634a634057927 \
        sha256  ae9a5789e23459e59606e6714723f2d3ffc31c03174191ef0d015bdf06007450 \
        size    26765692
    }}
    2.42 {xz {
        rmd160  1aecf0d749c7eb0941f7e1f0be0006d8a8833dd8 \
        sha256  f6e4d41fd5fc778b06b7891457b3620da5ecea1006c6a4a41ae998109f85a800 \
        size    27567160
    }}
    2.43 {xz {
        rmd160  b634d06c82b630337f4b5aa1c91646d9946f592a \
        sha256  b53606f443ac8f01d1d5fc9c39497f2af322d99e14cea5c0b4b124d630379365 \
        size    28175768
    }}
    2.43.1 {xz {
        rmd160  6f8ed9d308d81752726f80939826621ed441d11b \
        sha256  13f74202a3c4c51118b797a39ea4200d3f6cfbe224da6d1d95bb938480132dfd \
        size    28174300
    }}
    2.44 {xz {
        rmd160  44386f5741ed548a4648f0b71192a301efa4e351 \
        sha256  ce2017e059d63e67ddb9240e9d4ec49c2893605035cd60e92ad53177f4377237 \
        size    27285788
    }}
    2.45 {xz {
        rmd160  04407793ec050b946eb982f1572e2806c63a3fb2 \
        sha256  c50c0e7f9cb188980e2cc97e4537626b1672441815587f1eab69d2a1bfbef5d2 \
        size    27868232
    }}
}

proc crossbinutils.setup {target version} {
    global master_sites workpath worksrcpath extract.suffix prefix crossbinutils.target crossbinutils.versions_info

    crossbinutils.target ${target}

    default name        ${target}-binutils
    version             ${version}
    default categories  {cross devel}
    default license     GPL-3+
    default maintainers nomaintainer

    description     FSF Binutils for ${target} cross development
    long_description \
        Free Software Foundation development toolchain ("binutils") for \
        ${target} cross development.

    homepage        https://www.gnu.org/software/binutils/binutils.html
    master_sites    gnu:binutils
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
        # Install target-compatible libbfd/bfd-plugins/libiberty in the target's directory
        reinplace -q "s|bfdlibdir=.*|bfdlibdir='${prefix}/${crossbinutils.target}/host/lib'|g" \
            ${worksrcpath}/bfd/configure                                \
            ${worksrcpath}/opcodes/configure
        reinplace -q "s|bfdincludedir=.*|bfdincludedir='${prefix}/${crossbinutils.target}/host/include'|g"  \
            ${worksrcpath}/bfd/configure                                             \
            ${worksrcpath}/opcodes/configure

        reinplace -q "s|\$(libdir)/bfd-plugins|\"${prefix}/${crossbinutils.target}/host/lib/bfd-plugins\"|g" \
            ${worksrcpath}/ld/Makefile.in

        reinplace -q "s|\$(libdir)|\"${prefix}/${crossbinutils.target}/host/lib\"|g" \
            ${worksrcpath}/libiberty/Makefile.in
        reinplace -q "s|/\$(MULTIOSDIR)||g" \
            ${worksrcpath}/libiberty/Makefile.in
    }

    depends_build \
        port:texinfo

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
        --enable-install-libiberty=${prefix}/${crossbinutils.target}/host \
        --infodir=${prefix}/share/info/${target} \
        --mandir=${prefix}/share/man \
        --datarootdir=${prefix}/share/${crossbinutils.target} \
        --with-system-zlib

    # Opportunistic links zstd for compression
    if {[vercmp ${version} >= "2.40"]} {
        depends_lib-append  port:zstd
    }

    # fatal error: error in backend: Cannot select: intrinsic %llvm.x86.sha1rnds4
    # https://github.com/macports/macports-ports/pull/27345#issuecomment-2601373548
    if {[vercmp ${version} >= "2.41"]} {
        compiler.blacklist-append {clang < 1001}
    }

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
}

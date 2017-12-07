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
#
# This PortGroup automatically sets all the fields of the various cross binutils
# ports (e.g. spu-binutils).
#
# Usage:
#
#   PortGroup               crossbinutils 1.0
#   crossbinutils.setup     spu 2.27

options crossbinutils.target

proc crossbinutils.setup {target version} {
    global master_sites workpath worksrcpath extract.suffix prefix crossbinutils.target

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
    use_bzip2       yes

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

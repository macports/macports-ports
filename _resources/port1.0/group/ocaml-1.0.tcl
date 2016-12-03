# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2011 Markus Weissmann <mww@macports.org>
# Copyright (c) 2011 The MacPorts Project
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
# 3. Neither the name of Apple Computer, Inc. nor the names of its
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
# Usage:
# PortGroup     ocaml 1.0

# ocaml is not universal
universal_variant no

# ocaml executable
global ocaml
set ocaml "${prefix}/bin/ocaml"

# standard place to install OCaml libraries -- same as [exec ocamlfind printconf destdir]
global ocamlfind_dir
set ocamlfind_dir "${prefix}/lib/ocaml/site-lib"

# most often it is used with a 'destroot' prefix
global ocamlfind_destdir
set ocamlfind_destdir "${destroot}${ocamlfind_dir}"

# ocamlfind wrapper -- automagicaly obeys destroot
global ocamlfind_wrapper
set ocamlfind_wrapper "${workpath}/ocamlfind"

depends_lib-append  port:ocaml

# create a clever wrapper for ocamlfind
post-extract {
    set wrapper [open ${ocamlfind_wrapper} "w"]
    puts ${wrapper} "#!/bin/sh"
    puts ${wrapper} "if \[ \"\$1\" = \"install\" \]; then"
    puts ${wrapper} "    ${prefix}/bin/ocamlfind \"\$@\" -destdir ${ocamlfind_destdir} -ldconf ignore"
    puts ${wrapper} "else"
    puts ${wrapper} "    ${prefix}/bin/ocamlfind \"\$@\""
    puts ${wrapper} "fi"
    close ${wrapper}
    file attributes ${ocamlfind_wrapper} -permissions +x
}

# if this is an oasis/setup.ml based installation
proc use_oasis {option} {
    depends_build-append port:ocaml-findlib
    if {${option} == "yes"} {
        global ocaml prefix ocamlfind_wrapper
        global configure.cmd configure.pre_args
        configure.cmd ${ocaml}
        configure.pre_args "setup.ml -configure --override prefix ${prefix} --override ocamlfind ${ocamlfind_wrapper}"
        global build.cmd build.target
        build.cmd ${configure.cmd}
        build.target "setup.ml -build"
        global destroot.cmd destroot.target
        destroot.cmd ${configure.cmd}
        destroot.target "setup.ml -install"
        destroot.destdir
    }
}

proc use_oasis_doc {option} {
    if {${option} == "yes"} {
        global ocaml worksrcpath
        post-build {
            system -W ${worksrcpath} "${ocaml} setup.ml -doc"
        }
    }
}

pre-destroot {
    xinstall -m 755 -d ${ocamlfind_destdir}/stublibs
}


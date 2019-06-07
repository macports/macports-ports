# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
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
    xinstall -m 0755 -d ${ocamlfind_destdir}/stublibs
}


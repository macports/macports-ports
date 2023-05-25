# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup provides support for building Common Lisp packages.
#
# Usage:
# PortGroup           common_lisp 1.0
#
# This PortGroup implements similar with Debian layout for Common Lisp with
# dedicated system and sources folder inside ${prefix}/share/common-lisp.
#
# Produced port is stricly noarch and shouldn't contain any binary image,
# to avoid mass revbump of ports for each update of any lisp.

options common_lisp.prefix
default common_lisp.prefix      {${prefix}/share/common-lisp}

options common_lisp.build
default common_lisp.build       {${workpath}/build}

options common_lisp.use_sbcl
# See: https://trac.macports.org/ticket/66002
default common_lisp.use_sbcl    [expr { ${os.platform} eq "darwin" && ${os.major} >= 18 }]

categories                      lisp

use_configure                   no

supported_archs                 noarch
platforms                       any

universal_variant               no

default test.run                yes

proc common_lisp.add_dependencies {} {
    if {[option common_lisp.use_sbcl]} {
        depends_build-delete    port:sbcl
        depends_build-append    port:sbcl
    }
}

port::register_callback common_lisp.add_dependencies

build {
    file delete -force ${common_lisp.build}/source
    file delete -force ${common_lisp.build}/system

    xinstall -m 0755 -d ${common_lisp.build}/source
    xinstall -m 0755 -d ${common_lisp.build}/system

    file copy ${worksrcpath} ${common_lisp.build}/source/${subport}

    foreach f [glob -dir ${common_lisp.build}/source/${subport} -tails *.asd] {
        ln -sf ../source/${subport}/$f ${common_lisp.build}/system/$f
    }

    if {[option common_lisp.use_sbcl]} {
        foreach item [glob -dir ${common_lisp.build}/system -tails *.asd] {
            common_lisp.sbcl_load "load-op" [string range ${item} 0 end-4]
        }
    }
 }

destroot {
    xinstall -m 0755 -d ${destroot}${common_lisp.prefix}

    file copy ${common_lisp.build}/source ${destroot}${common_lisp.prefix}
    file copy ${common_lisp.build}/system ${destroot}${common_lisp.prefix}
}

test {
    if {![option test.run]} {
        ui_info "Tests are disabled"
        return
    }

    if {[option common_lisp.use_sbcl]} {
        foreach item [glob -dir ${common_lisp.build}/system -tails *.asd] {
            common_lisp.sbcl_load "test-op" [string range ${item} 0 end-4]
        }
    }
}

proc common_lisp.sbcl_load {op name} {
    global workpath prefix common_lisp.build common_lisp.prefix

    ui_info "Execute ${op} at ${name} by SBCL"

    set lisp-system-path "#p\"${common_lisp.prefix}/system/\""
    set lisp-build-system-path "#p\"${common_lisp.build}/system/\""

    set loadcmd ${prefix}/bin/sbcl

    append loadcmd " --no-userinit "
    append loadcmd " --non-interactive"
    append loadcmd " --eval '(require \"asdf\")'"
    append loadcmd " --eval '(setf asdf:*central-registry* (list* (quote *default-pathname-defaults*) ${lisp-build-system-path} ${lisp-system-path} asdf:*central-registry*))'"
    append loadcmd " --eval '(asdf:operate (quote asdf:${op}) (quote ${name}))'"

    system -W ${workpath} "${loadcmd}"
}

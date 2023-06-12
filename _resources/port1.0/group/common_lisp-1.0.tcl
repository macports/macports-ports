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

PortGroup                       active_variants 1.1

options common_lisp.prefix
default common_lisp.prefix      {${prefix}/share/common-lisp}

options common_lisp.build
default common_lisp.build       {${workpath}/build}

options common_lisp.threads
default common_lisp.threads     no

options common_lisp.sbcl
default common_lisp.sbcl        yes

options common_lisp.ecl
# ECL doesn't support i386 and PPC, as an easy way enable it only on 10.7+
default common_lisp.ecl         [expr { ${os.platform} eq "darwin" && ${os.major} >= 11 }]

options common_lisp.clisp
default common_lisp.clisp       yes

categories                      lisp

use_configure                   no

supported_archs                 noarch
platforms                       any

universal_variant               no

default test.run                yes

namespace eval common_lisp      {}

proc common_lisp::add_dependencies {} {
    global common_lisp.sbcl
    global common_lisp.ecl
    global common_lisp.clisp

    if {[option common_lisp.sbcl]} {
        depends_build-delete    port:sbcl
        depends_build-append    port:sbcl
    }

    if {[option common_lisp.ecl]} {
        depends_build-delete    port:ecl
        depends_build-append    port:ecl
    }

    if {[option common_lisp.clisp]} {
        depends_build-delete    port:clisp
        depends_build-append    port:clisp
    }
}

port::register_callback common_lisp::add_dependencies

proc common_lisp::respect_threads_support {} {
    global common_lisp.sbcl
    global common_lisp.ecl
    global common_lisp.clisp

    if {[option common_lisp.threads] && [option common_lisp.sbcl]} {
        common_lisp.sbcl    no

        catch {common_lisp.sbcl [active_variants sbcl threads]}

        if {![option common_lisp.sbcl]} {
            catch {common_lisp.sbcl [active_variants sbcl fancy]}
        }

        if {![option common_lisp.sbcl]} {
            ui_debug "Exclude SBCL because it doesn't support threads"
        }
    }

    if {[option common_lisp.threads] && [option common_lisp.clisp]} {
        common_lisp.clisp   no

        catch {common_lisp.clisp [active_variants clisp threads]}

        if {![option common_lisp.clisp]} {
            ui_debug "Exclude CLISP because it doesn't support threads"
        }
    }
}

pre-build {
    common_lisp::respect_threads_support
}

build {
    file delete -force ${common_lisp.build}/source
    file delete -force ${common_lisp.build}/system

    xinstall -m 0755 -d ${common_lisp.build}/source
    xinstall -m 0755 -d ${common_lisp.build}/system

    file copy ${worksrcpath} ${common_lisp.build}/source/${subport}

    foreach f [glob -dir ${common_lisp.build}/source/${subport} -tails *.asd] {
        ln -sf ../source/${subport}/$f ${common_lisp.build}/system/$f
    }

    foreach item [glob -dir ${common_lisp.build}/system -tails *.asd] {
        common_lisp::asdf_operate "load-op" [string range ${item} 0 end-4]
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

    foreach item [glob -dir ${common_lisp.build}/system -tails *.asd] {
        common_lisp::asdf_operate "test-op" [string range ${item} 0 end-4]
    }
}

proc common_lisp::asdf_operate {op name} {
    global common_lisp.sbcl
    global common_lisp.ecl
    global common_lisp.clisp

    if {[option common_lisp.sbcl]} {
        common_lisp::sbcl_asdf_operate ${op} ${name}
    }

    if {[option common_lisp.ecl]} {
        common_lisp::ecl_asdf_operate ${op} ${name}
    }

    if {[option common_lisp.clisp]} {
        common_lisp::clisp_asdf_operate ${op} ${name}
    }
}

proc common_lisp::sbcl_asdf_operate {op name} {
    global prefix
    ui_info "Execute asdf:${op} at ${name} by SBCL"

    common_lisp::run "${prefix}/bin/sbcl --no-sysinit --no-userinit --non-interactive" "--eval" ${op} ${name}
}

proc common_lisp::ecl_asdf_operate {op name} {
    global prefix
    ui_info "Execute asdf:${op} at ${name} by ECL"

    common_lisp::run "${prefix}/bin/ecl -q" "--eval" ${op} ${name}
}

proc common_lisp::clisp_asdf_operate {op name} {
    global prefix
    ui_info "Execute asdf:${op} at ${name} by CLISP"

    common_lisp::run "${prefix}/bin/clisp --quiet --quiet" "-x" ${op} ${name}
}

proc common_lisp::run {lisp eval_arg op name} {
    global workpath common_lisp.build common_lisp.prefix

    set lisp-system-path "#p\"${common_lisp.prefix}/system/\""
    set lisp-build-system-path "#p\"${common_lisp.build}/system/\""

    set loadcmd ${lisp}

    append loadcmd " ${eval_arg} '(require \"asdf\")'"
    append loadcmd " ${eval_arg} '(setf asdf:*central-registry* (list* (quote *default-pathname-defaults*) ${lisp-build-system-path} ${lisp-system-path} asdf:*central-registry*))'"
    append loadcmd " ${eval_arg} '(asdf:operate (quote asdf:${op}) (quote ${name}))'"

    set tempdir [mkdtemp "/tmp/common_lisp.XXXXXXXX"]
    if { ! [catch {system -W ${tempdir} "${loadcmd} 2>&1"}] } {
        file delete -force ${tempdir}
    } else {
        file delete -force ${tempdir}
        return -code error "asdf:${op} cannot be executed"
    }
}

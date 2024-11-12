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

options common_lisp.ffi
default common_lisp.ffi         no

options common_lisp.sbcl
default common_lisp.sbcl        yes

options common_lisp.ecl
# boehmgc has random failures on macOS which makes ECL useless
# See: https://github.com/ivmai/bdwgc/issues/103
default common_lisp.ecl         no

options common_lisp.clisp
default common_lisp.clisp       yes

options common_lisp.ccl
# CLL doesn't support arm64 yet, and seems that stable working on 10.10+
default common_lisp.ccl         {[expr { ${os.platform} eq "darwin" && ${os.major} >= 14  && ${os.arch} ne "arm" }]}

options common_lisp.abcl
# ABCL requires java and support OpenJDK 21 before 10.14 fragile
default common_lisp.abcl        {[expr { ${os.platform} eq "darwin" && ${os.major} >= 18 }]}

options common_lisp.build_run
default common_lisp.build_run   yes

options common_lisp.systems
default common_lisp.systems     {*.asd}

categories-append               lisp

use_configure                   no

supported_archs                 noarch
platforms                       any

universal_variant               no

default test.run                yes

namespace eval common_lisp      {}

proc common_lisp::add_dependencies {} {
    if {[option common_lisp.sbcl]} {
        depends_build-delete    port:sbcl \
                                port:sbcl-devel \
                                path:bin/sbcl:sbcl \
                                path:bin/sbcl:sbcl-devel

        depends_build-append    path:bin/sbcl:sbcl
    }

    if {[option common_lisp.ecl]} {
        depends_build-delete    port:ecl \
                                port:ecl-devel \
                                path:bin/ecl:ecl \
                                path:bin/ecl:ecl-devel

        depends_build-append    path:bin/ecl:ecl
    }

    if {[option common_lisp.clisp]} {
        depends_build-delete    port:clisp
        depends_build-append    port:clisp
    }

    if {[option common_lisp.abcl]} {
        depends_build-delete    port:abcl
        depends_build-append    port:abcl
    }

    if {[option common_lisp.ccl]} {
        depends_build-delete    port:ccl
        depends_build-append    port:ccl
    }
}

port::register_callback common_lisp::add_dependencies

proc common_lisp::respect_threads_support {} {
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

    if {[option common_lisp.ffi] && [option common_lisp.abcl]} {
        common_lisp.abcl   no

        catch {common_lisp.abcl [active_variants abcl ffi]}

        if {![option common_lisp.abcl]} {
            ui_debug "Exclude ABCL because it doesn't support FFI"
        }
    }
}

pre-build {
    common_lisp::respect_threads_support
}

pre-test {
    common_lisp::respect_threads_support
}

build {
    file delete -force ${common_lisp.build}

    xinstall -m 0755 -d ${common_lisp.build}/source
    xinstall -m 0755 -d ${common_lisp.build}/system

    file copy ${worksrcpath} ${common_lisp.build}/source/${subport}

    foreach f [glob -dir ${common_lisp.build}/source/${subport} -tails {*}[option common_lisp.systems]] {
        ln -sf ../source/${subport}/$f ${common_lisp.build}/system
    }

    if {[option common_lisp.build_run]} {
        foreach item [glob -dir ${common_lisp.build}/system -tails *.asd] {
            common_lisp::asdf_operate "build-op" [string range ${item} 0 end-4] ${common_lisp.build}/system
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

    foreach item [glob -dir ${common_lisp.build}/system -tails *.asd] {
        common_lisp::asdf_operate "test-op" [string range ${item} 0 end-4] ${common_lisp.build}/system
    }
}

proc common_lisp::asdf_operate {op name build_system_path} {
    if {[option common_lisp.sbcl]} {
        common_lisp::sbcl_asdf_operate ${op} ${name} ${build_system_path}
    }

    if {[option common_lisp.ecl]} {
        common_lisp::ecl_asdf_operate ${op} ${name} ${build_system_path}
    }

    if {[option common_lisp.clisp]} {
        common_lisp::clisp_asdf_operate ${op} ${name} ${build_system_path}
    }

    if {[option common_lisp.abcl]} {
        common_lisp::abcl_asdf_operate ${op} ${name} ${build_system_path}
    }

    if {[option common_lisp.ccl]} {
        common_lisp::ccl_asdf_operate ${op} ${name} ${build_system_path}
    }
}

proc common_lisp::sbcl_asdf_operate {op name build_system_path} {
    global prefix
    ui_info "Execute asdf:${op} at ${name} by SBCL"

    common_lisp::run "${prefix}/bin/sbcl --no-sysinit --no-userinit --non-interactive" "--eval" ${op} ${name} ${build_system_path}
}

proc common_lisp::ecl_asdf_operate {op name build_system_path} {
    global prefix
    ui_info "Execute asdf:${op} at ${name} by ECL"

    common_lisp::run "${prefix}/bin/ecl -q" "--eval" ${op} ${name} ${build_system_path}
}

proc common_lisp::clisp_asdf_operate {op name build_system_path} {
    global prefix
    ui_info "Execute asdf:${op} at ${name} by CLISP"

    common_lisp::run "${prefix}/bin/clisp --quiet --quiet" "-x" ${op} ${name} ${build_system_path}
}

proc common_lisp::abcl_asdf_operate {op name build_system_path} {
    global prefix workpath
    ui_info "Execute asdf:${op} at ${name} by ABCL"

    # ABCL runs on java and java uses NSHomeDirectory which ignores HOME env
    # here I redefine user-homedir-pathname to use expected home folder everywhere
    # See: https://github.com/armedbear/abcl/issues/614
    common_lisp::run "${prefix}/bin/abcl --noinit --eval '(defun user-homedir-pathname () #p\"${workpath}/.home/\")'" "--eval" ${op} ${name} ${build_system_path}
}

proc common_lisp::ccl_asdf_operate {op name build_system_path} {
    global prefix build_arch
    ui_info "Execute asdf:${op} at ${name} by CCL"

    set ccl ccl64
    # This must be build_arch, not configure.build_arch:
    if { ${build_arch} in [list i386 ppc] } {
        set ccl ccl
    }

    # cleaner approach is somehow enforce different value to NSHomeDirectory
    common_lisp::run "${prefix}/bin/${ccl} --no-init --batch" "--eval" ${op} ${name} ${build_system_path}
}
proc common_lisp::run {lisp eval_arg op name build_system_path} {
    global workpath common_lisp.build common_lisp.prefix

    set lisp-system-path "#p\"${common_lisp.prefix}/system/\""
    set lisp-build-system-path "#p\"${build_system_path}/\""

    set loadcmd ${lisp}

    # CLisp has a bug which leads to loading upper case system name when it defines via :
    # to avoid that the system name should be double quoted.
    # See: https://gitlab.com/gnu-clisp/clisp/-/issues/46
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

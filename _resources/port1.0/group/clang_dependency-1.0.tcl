# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# This portgroup is to help prevent circular dependencies for ports that
# recent clang builds depend on, switching it to clang-11-bootstrap

proc clang_dependency.clang_bootstrap {} {
    global os.platform os.major prefix configure.compiler

    # When MacPorts decided to use MacPorts clang replace it to
    # clang-11-bootstrap when it possible, to break circular dependencies.
    if {[regexp {macports-clang-(.*)} ${configure.compiler} -> clang_v]} {

        # detects when decided clang is already installed
        if {![catch {lindex [registry_active clang-${clang_v}] 0}]} {
            ui_debug "${configure.compiler} is installed, do not replace by clang-11-bootstrap"
            return
        }

        # clang-11-bootstrap can build clang up to 15,
        # future clang / llvm may requires future patches.
        if {[vercmp ${clang_v} 15] >= 0} {
            ui_debug "clang-11-bootstrap can't replace ${configure.compiler}"
            return
        }

        ui_debug "Replace ${configure.compiler} by clang-11-bootstrap"

        depends_build-delete    port:clang-${clang_v}
        depends_build-append    port:clang-11-bootstrap
        depends_skip_archcheck-append \
                                clang-11-bootstrap
        configure.cc            ${prefix}/libexec/clang-11-bootstrap/bin/clang
        configure.cxx           ${prefix}/libexec/clang-11-bootstrap/bin/clang++

        if {${os.major} < 11} {
            configure.env-append \
                                AR=${prefix}/libexec/clang-11-bootstrap/bin/llvm-ar \
                                RANLIB=${prefix}/libexec/clang-11-bootstrap/bin/llvm-ranlib
        }
    }
}

clang_dependency.clang_bootstrap

port::register_callback clang_dependency.clang_bootstrap

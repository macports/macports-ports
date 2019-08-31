# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup         haskell_stack 1.0
#
# This PortGroup configures the build to use the Haskell Stack tool. It
# modifies the defaults for a number of variables, so your Portfile should take
# care not to accidentally overwrite them.
#
# The PortGroup will automatically add the required build dependencies for
# port:stack, and if haskell_stack.system_ghc is set, for port:ghc.
#
# The configure, build, destroot and test phases are set up (although the test
# phase is not enabled automatically). A default livecheck is configured to
# hackage.haskell.org using ${name}.
#
# This PortGroup offers the following options:
#
# haskell_stack.stack_root
#   The root directory for stack, passed as --stack-root in configure.args,
#   build.args, destroot.args. Defaults to ${workpath}/.stack.
#
# haskell_stack.system_ghc
#   Boolean indicating whether the system GHC should be used for port. Setting
#   this to yes will add a dependency to ghc and pass --system-ghc in
#   configure.args, build.args and destroot.args. Defaults to no.

options haskell_stack.system_ghc
default haskell_stack.system_ghc {no}

proc haskell_stack.system_ghc_flags {} {
    if {[option haskell_stack.system_ghc]} {
        return "--system-ghc"
    }
    return ""
}

proc haskell_stack.add_dependencies {} {
    depends_build-append port:stack
    if {[option haskell_stack.system_ghc]} {
        depends_build-append port:ghc
    }
}
port::register_callback haskell_stack.add_dependencies

options haskell_stack.stack_root
default haskell_stack.stack_root {${workpath}/.stack}

post-extract {
    xinstall -m 0755 -d "[option haskell_stack.stack_root]"
}

# libHSbase shipped with GHC links against system libiconv, which provides the
# 'iconv' symbol, but not the 'libiconv' symbol. Because the compilation
# process statically links libHSbase.a, we must have /usr/lib in the library
# search path first :/
compiler.library_path
compiler.cpath

default configure.cmd       {${prefix}/bin/stack}
default configure.pre_args  {}
default configure.args      {setup \
                                --stack-root [option haskell_stack.stack_root]\
                                --with-gcc ${configure.cc} \
                                --allow-different-user \
                                [haskell_stack.system_ghc_flags]}

default build.cmd           {${prefix}/bin/stack}
default build.target        {build}
default build.args          {--stack-root [option haskell_stack.stack_root] \
                                --with-gcc ${configure.cc} \
                                --allow-different-user \
                                [haskell_stack.system_ghc_flags]}

default destroot.cmd        {${prefix}/bin/stack}
default destroot.target     {install}
default destroot.args       {--stack-root [option haskell_stack.stack_root] \
                                --local-bin-path ${destroot}${prefix}/bin \
                                --with-gcc ${configure.cc} \
                                --allow-different-user \
                                [haskell_stack.system_ghc_flags]}
default destroot.destdir    {}

default test.cmd            {${prefix}/bin/stack}
default test.target         {test}

default livecheck.type      {regex}
default livecheck.url       {https://hackage.haskell.org/package/${name}}
default livecheck.regex     {"/package/[quotemeta ${name}]-\\\[^/\\\]+/[quotemeta ${name}]-(\\\[^\\\"\\\]+)[quotemeta ${extract.suffix}]"}

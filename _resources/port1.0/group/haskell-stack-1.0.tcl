# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup         haskell-stack 1.0
#
# This PortGroup configures the build to use the Haskell Stack tool. Note that
# this PortGroup does not set defaults, but sets the values directly, i.e. you
# should take care not to accidentally overwrite them.
#
# The stack root is available as the $stack_root variable after including this
# PortGroup. The configure, build, destroot and test phases have been setup
# (although the test phase is not enabled automatically). A dependency on
# port:stack is also automatically added.

depends_build-append  \
                    port:stack

set stack_root      ${workpath}/.stack

post-extract {
    xinstall -m 0755 -d ${stack_root}
}

configure.cmd       ${prefix}/bin/stack
configure.pre_args
configure.args      setup \
                    --stack-root ${stack_root} \
                    --with-gcc ${configure.cc} \
                    --allow-different-user

build.cmd           ${prefix}/bin/stack
build.target        build
build.args          --stack-root ${stack_root} \
                    --with-gcc ${configure.cc} \
                    --allow-different-user

destroot.cmd        ${prefix}/bin/stack
destroot.target     install
destroot.args       --stack-root ${stack_root} \
                    --local-bin-path ${destroot}${prefix}/bin \
                    --with-gcc ${configure.cc} \
                    --allow-different-user
destroot.destdir

test.cmd            ${prefix}/bin/stack
test.target         test

# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# This PortGroup supports the Dart build system

options dart.bin

default dart.bin          {${prefix}/bin/dart}

default supported_archs   {arm64 x86_64}
default universal_variant no
default use_configure     no

default depends_build     port:dart-sdk

default build.cmd         {${dart.bin} compile exe}
default build.args        {-o bin/${name}}
default build.target      bin/main.dart

default test.cmd          {${dart.bin} test}
default test.args         ""
default test.target       ""

destroot {
    ui_error "No destroot phase in the Portfile!"
    ui_msg "Here is an example destroot phase:"
    ui_msg
    ui_msg "destroot {"
    ui_msg {    xinstall -m 0755 ${worksrcpath}/bin/${name} ${destroot}${prefix}/bin/}
    ui_msg "}"
    ui_msg
    ui_msg "Please check if there are additional files (configuration, documentation, etc.) that need to be installed."
    error "destroot phase not implemented"
}

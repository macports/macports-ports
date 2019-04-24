# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup automatically sets all the fields of the various hs-HOC
# bindings ports (e.g. hs-HOC-Foundation).
#
# Usage:
#
#   PortGroup        hocbinding 1.0
#   hocbinding.setup framework version source
#
# where framework is the name of the bound framework (e.g. Foundation), version
# is the version of the binding, and if the framework additional code is in HOC
# source itself, source is "hoc"; otherwise don't use source.
#
# Example:
#
#   PortGroup        hocbinding 1.0
#   hocbinding.setup Foundation 0.7-r413 hoc

PortGroup haskell 1.0

options hocbinding.framework
options hocbinding.deps
default hocbinding.deps {{}}

proc hocbinding.setup {framework version {source ""}} {
    global description name prefix worksrcpath

    hocbinding.framework ${framework}

    haskell.setup   HOC-${framework} ${version}
    name            hs-HOC-${framework}
    categories      devel
    platforms       darwin

    description ${framework} framework bindings for HOC
    long_description ${description}

    if {${source} eq "hoc"} {
        homepage    https://code.google.com/p/hoc/

        worksrcdir  hoc/Bindings/Generated/HOC-${framework}

        post-extract {
            xinstall -d ${worksrcpath}
        }

        depends_build-append \
            port:hs-hoc

        pre-configure {
            set args ""
            foreach dep ${hocbinding.deps} {
                append args " -d ${dep}"
            }

            system "cd [file dirname ${worksrcpath}] && \
                hoc-ifgen -f ${hocbinding.framework} -b ../binding-script.txt \
                    -a ../AdditionalCode ${args}"
        }

        post-destroot {
            set pidir ${prefix}/share/HOC
            xinstall -d ${destroot}${pidir}
            xinstall -m 0644 ${worksrcpath}/${hocbinding.framework}.pi \
                ${destroot}${pidir}
        }
    }

    universal_variant no
}

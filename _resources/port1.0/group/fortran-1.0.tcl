# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup provides support for building Fortran packages.
#
# Usage:
# PortGroup         fortran 1.0

PortGroup           compiler_blacklist_versions 1.0
PortGroup           compilers 1.0
PortGroup           github 1.0

default categories  "fortran"

depends_build-append \
                    port:fpm

global os.platform os.arch os.major
if {${os.major} < 14} {
	# FPM uses Git to fetch modules. Put it here so that we do not keep getting failures.
	depends_build-append    path:bin/git:git
	git.cmd                 ${prefix}/bin/git
}

# https://github.com/fortran-lang/fpm/issues/1059
# Drop this upon the next release of FPM:
compiler.blacklist-append \
                    macports-gcc-14
if {${os.platform} ne "darwin" || ${os.major} > 9} {
    default_variants-append \
                    +gcc13
}

# Clang of 10.7 fails with multiple packages: error: invalid instruction mnemonic 'cvtsi2sdl'
compiler.blacklist-append \
                    *gcc-4.* {clang < 500}

platform darwin powerpc {
    compiler.blacklist-append *clang*
}

compilers.choose    fc f90
compilers.setup     require_fortran -g95

# For now, avoid universal:
default universal_variant no

use_configure       no

pre-build {
    # Make gfortran symbolic link
    xinstall -m 0755 -d ${workpath}/bin
    ln -s ${configure.fc} ${workpath}/bin/gfortran

    build.env-append \
        PATH=$env(PATH):${workpath}/bin \
        FC=${configure.fc}
}

build.cmd           ${prefix}/bin/fpm install
build.target

options             fortran.profile
global              prefix
default profile     release
build.cmd-append    --verbose --prefix="${workpath}${prefix}" --profile="${profile}"

global name
destroot {
    set bindir ${workpath}${prefix}/bin
    if {[file exists ${bindir}] && [file isdirectory ${bindir}]} {
    xinstall -d ${destroot}${prefix}/bin
        fs-traverse exe ${bindir} {
            if {[file exists ${exe}] && [file isfile ${exe}]} {
                xinstall -m 0755 ${exe} ${destroot}${prefix}/bin/
            }
        }
    }
    set incdir ${workpath}${prefix}/include
    if {[file exists ${incdir}] && [file isdirectory ${incdir}]} {
    xinstall -d ${destroot}${prefix}/include/${name}
        fs-traverse inc ${incdir} {
            if {[file exists ${inc}] && [file isfile ${inc}]
                && ([string match "*.h" ${inc}]
                || [string match "*.mod" ${inc}])} {
                    xinstall -m 0644 ${inc} ${destroot}${prefix}/include/${name}/
            }
        }
    }
    set libdir ${workpath}${prefix}/lib
    if {[file exists ${libdir}] && [file isdirectory ${libdir}]} {
    xinstall -d ${destroot}${prefix}/lib
        fs-traverse lib ${libdir} {
            if {[file exists ${lib}] && [file isfile ${lib}]
                && ([string match "*.a" ${lib}]
                || [string match "*.dylib" ${lib}])} {
                    xinstall -m 0644 ${lib} ${destroot}${prefix}/lib/
            }
        }
    }
}

pre-test {
    test.env-append \
        PATH=$env(PATH):${workpath}/bin \
        FC=${configure.fc}
}

test.cmd            ${prefix}/bin/fpm test
test.target
test.cmd-append     --flag="-I${workpath}${prefix}/include" \
                    --link-flag="-L${workpath}${prefix}/lib" \
                    --profile="${profile}" \
                    --verbose

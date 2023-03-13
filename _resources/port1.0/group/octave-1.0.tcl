# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup automatically sets up the standard environment for
# building an octave module.
#
# Usage:
#
#   PortGroup               octave 1.0
#   octave.module           module
#
# where module is the name of the module (e.g. communications)

options octave.module octave.config_h

# do not use this option unless absolutely necessary
# see comments below
# this should eventually be removed
default octave.config_h {no}

# some header files from Octave require C++-11
compiler.cxx_standard  2011
# error: field has incomplete type 'const octave::cdef_class'
PortGroup compiler_blacklist_versions 1.0
compiler.blacklist-append {clang < 700}

# see https://trac.macports.org/ticket/51643
PortGroup muniversal 1.0
default universal_archs_supported {i386 x86_64}

proc octave.setup {module version} {
    global octave.module
    octave.module               ${module}
    version                     ${version}
}

option_proc octave.module octave.set_module
proc octave.set_module {opt action args} {
    global octave.module
    if {$action eq "set"} {
        name     octave-${octave.module}
        homepage https://octave.sourceforge.io/${octave.module}/
    }
}

default categories   "math science"
default master_sites [list sourceforge:project/octave/Octave%20Forge%20Packages/Individual%20Package%20Releases \
                        sourceforge:octave]
default distname     {${octave.module}-${version}}
default worksrcdir   {${octave.module}}
# do not build in parallel; many can't, and these are small builds
# anyway, so no major need for this.
default use_parallel_build {no}
default livecheck.type     {regex}
default livecheck.url      {https://octave.sourceforge.io/${octave.module}/}
default livecheck.regex    {"package=${octave.module}-(\\\\d+(.\\\\d+)*)"}

depends_lib-append   path:bin/octave:octave
# do not force all Portfiles to switch from depends_lib to depends_lib-append
proc octave.add_dependencies {} {
    depends_lib-delete path:bin/octave:octave
    depends_lib-append path:bin/octave:octave
}
port::register_callback octave.add_dependencies

# configure_make.m calls "make --jobs n ..."
# use environmental variable to set the number of jobs to 1
# parallel build is a problem for octave-optiminterp
configure.env-append OMP_NUM_THREADS=1
# do not force all Portfiles to switch from configure.env to configure.env-append
proc octave.add_env {} {
    global configure.cxx

    configure.env-delete OMP_NUM_THREADS=1
    configure.env-append OMP_NUM_THREADS=1

    # Octave defaults to compilers used to build it
    # see https://trac.macports.org/ticket/57419
    configure.env-delete LD_CXX=${configure.cxx}
    configure.env-append LD_CXX=${configure.cxx}

    configure.env-delete DL_LD=${configure.cxx}
    configure.env-append DL_LD=${configure.cxx}
}
port::register_callback octave.add_env

post-extract {
    # rename the effective worksrcdir to always be ${octave.module}

    if {[exec /bin/ls ${workpath} | grep -v -E "^\\." | awk "END \{print NR\}"] == 2} {
        delete ${workpath}/${octave.module}
        move [glob ${workpath}/*-*] ${workpath}/${octave.module}
    }
    if {[exec /bin/ls ${workpath} | grep -c "-"] == 2 && ![string match [glob ${workpath}/*-*] ${workpath}/${octave.module}]} {
        move [glob ${workpath}/*-*] ${workpath}/${octave.module}
    }

#     set worksrcdir_name [exec /bin/ls ${workpath} | grep -v -E "^\\."]
#     if {[string equal ${worksrcdir_name} ${octave.module}] == 0} {
#         # work-around for case-insensitive file systems when the
#         # extract directory name is the same as the octave module name
#         # except for letter case; should always work no matter if the
#         # file system is case-insensitive or case-sensitive.
# 
#         move ${workpath}/${worksrcdir_name} ${workpath}/tmp-${worksrcdir_name}
#         move ${workpath}/tmp-${worksrcdir_name} ${workpath}/${octave.module}
#     }
}

configure.universal_args-delete --disable-dependency-tracking

pre-configure {

    set tar [findBinary tar ${portutil::autoconf::tar_path}]
    system -W ${workpath} "${tar} cvfz ${distname}.tar.gz ${octave.module}"

    if { [variant_exists universal] && [variant_isset universal] } {
        global merger_configure_env
        global merger_configure_args

        foreach arch ${universal_archs_supported} {
            lappend merger_configure_env(${arch}) \
                OCTAVE_ARCH=${arch}
        }

        foreach arch ${universal_archs_supported} {
            set merger_configure_args(${arch}) \
                "'try; pkg build -verbose -nodeps ${workpath}/tmp-build-${arch} ${workpath}/${distname}.tar.gz; catch; disp(lasterror.message); exit(1); end_try_catch;'"
        }

    } else {
        configure.env-append OCTAVE_ARCH=${configure.build_arch}
        configure.args \
            "'try; pkg build -verbose -nodeps ${workpath}/tmp-build ${workpath}/${distname}.tar.gz; catch; disp(lasterror.message); exit(1); end_try_catch;'"

        # fortran arch flag is not set automatically
        if {${configure.build_arch} in [list arm64 ppc64 x86_64]} {
            configure.fflags-append -m64
        } else {
            configure.fflags-append -m32
        }
    }

    if { ${supported_archs} eq "noarch" } {
        configure.cmd ${prefix}/bin/octave-cli
    } else {
        configure.cmd /usr/bin/arch -arch \$OCTAVE_ARCH ${prefix}/bin/octave-cli
    }

    configure.pre_args -q -f -H --eval
    configure.post_args

    configure.cxxflags-append -std=c++11
}

build {}

pre-destroot {
    set octave_api_version [exec "${prefix}/bin/octave-config" -p API_VERSION]

    if { ${supported_archs} eq "noarch" } {
        destroot.cmd ${prefix}/bin/octave-cli
    } else {
        destroot.cmd /usr/bin/arch -arch \$OCTAVE_ARCH ${prefix}/bin/octave-cli
    }

    destroot.pre_args -q -f -H --eval

    if { ${os.arch} eq "i386" } {
        if { ${os.major} >= 9 && ![catch {sysctl hw.cpu64bit_capable} result] && $result == 1 } {
            set short_host_name x86_64-apple-${os.platform}${os.major}.x.x
        } else {
            set short_host_name i686-apple-${os.platform}${os.major}.x.x
        }
    } else {
        if { ${os.major} >= 9 && ![catch {sysctl hw.cpu64bit_capable} result] && $result == 1 } {
            set short_host_name powerpc64-apple-${os.platform}${os.major}.x.x
        } else {
            set short_host_name powerpc-apple-${os.platform}${os.major}.x.x
        }
    }

    if { [variant_exists universal] && [variant_isset universal] } {
        global merger_destroot_env
        global merger_destroot_args

        foreach arch ${universal_archs_supported} {
            set octave_install_share ${destroot}-${arch}${prefix}/share/octave/packages
            set octave_install_lib   ${destroot}-${arch}${prefix}/lib/octave/packages
            set octave_tgz_file ${workpath}/tmp-build-${arch}/[exec /bin/ls ${workpath}/tmp-build-${arch}]

            lappend merger_destroot_env(${arch}) \
                OCTAVE_ARCH=${arch}

            destroot.args

            set merger_destroot_args(${arch}) \
                "'try;pkg prefix ${octave_install_share} ${octave_install_lib}; pkg install -verbose -nodeps -local ${octave_tgz_file}; delete(\"~/.octave_packages\"); catch; disp(lasterror.message); exit(1); end_try_catch;'"
        }

    } else {
        set octave_install_share ${destroot}${prefix}/share/octave/packages
        set octave_install_lib   ${destroot}${prefix}/lib/octave/packages
        set octave_tgz_file ${workpath}/tmp-build/[exec /bin/ls ${workpath}/tmp-build]

        destroot.env-append OCTAVE_ARCH=${configure.build_arch}

        destroot.args \
            "'try; pkg prefix ${octave_install_share} ${octave_install_lib}; pkg install -verbose -nodeps -local ${octave_tgz_file}; catch; disp(lasterror.message); exit(1); end_try_catch;'"
    }

    destroot.post_args
}

post-deactivate {
    set octave_install_share ${prefix}/share/octave/packages
    set octave_install_lib   ${prefix}/lib/octave/packages
    system "${prefix}/bin/octave-cli -q -f -H --eval 'try; pkg prefix ${octave_install_share} ${octave_install_lib}; pkg -verbose -global rebuild; catch; disp(lasterror.message); exit(1); end_try_catch;'"
}

post-activate {
    set octave_install_share ${prefix}/share/octave/packages
    set octave_install_lib   ${prefix}/lib/octave/packages
    system "${prefix}/bin/octave-cli -q -f -H --eval 'try; pkg prefix ${octave_install_share} ${octave_install_lib}; pkg -verbose -global rebuild; disp(lasterror.message); catch; exit(1); end_try_catch;'"
}

# octave/config.h was removed from octave 4.4
# some packages, however, still depend on it for information
# see https://savannah.gnu.org/bugs/?41027
# eventually, this code should be removed
default compiler.cpath {[octave._cpath]}
proc octave._cpath {} {
    global prefix octave.config_h worksrcpath
    if {${octave.config_h}} {
        return "${prefix}/include ${worksrcpath}/macports_compat ${worksrcpath}/macports_compat/octave"
    } else {
        return ${prefix}/include
    }
}

pre-configure {
    if {${octave.config_h}} {
        xinstall -d -m 0755 ${worksrcpath}/macports_compat/octave
        set configf [open "${worksrcpath}/macports_compat/octave/config.h" w 0644]

        puts  ${configf} "#include <octave/octave-config.h>"
        foreach v {LOCALVERFCNFILEDIR LOCALVEROCTFILEDIR LOCALVERARCHLIBDIR CANONICAL_HOST_TYPE} {
            set mv [exec ${prefix}/bin/octave-config -p ${v}]
            puts  ${configf} "#define OCTAVE_${v}  \"${mv}\""
        }
        close ${configf}
    }
}

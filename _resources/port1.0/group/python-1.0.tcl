# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# Usage:
# name should be of the form py-foo for modules
# subports pyXY-foo are declared for each XY in python.versions

# for apps (i.e. not named py-foo), no subports will be defined
# only the python.default_version will be used
# you can change that in variants if you want

# options:
# python.versions: which versions this module supports, e.g. "26 27 31"
#   always set this (even if you have your own subport blocks)
# python.default_version: which version will be installed if the user asks
#   for py-foo rather than pyXY-foo
# python.consistent_destroot: set consistent environment values in build and destroot phases
#
# Note: setting these options requires name to be set beforehand

PortGroup       compiler_wrapper 1.0

categories      python

use_configure   no

# we want the default universal variant added despite not using configure
universal_variant yes

post-extract {
    # Prevent setuptools' easy_install from downloading dependencies
    set fs [open $env(HOME)/.pydistutils.cfg w+]
    puts $fs {[easy_install]}
    puts $fs {index_url = ''}
    puts $fs {find_links = ''}
    close $fs
    # Same for pip
    file mkdir $env(HOME)/.config/pip
    set fs [open $env(HOME)/.config/pip/pip.conf w+]
    puts $fs {[install]}
    puts $fs {no-deps = yes}
    puts $fs {no-index = yes}
    close $fs
}

pre-destroot {
    xinstall -d -m 0755 ${destroot}${prefix}/share/doc/${subport}/examples
}

# python.rootname: The "proper" name of the software. For a module
#   pyXY-foo, this defaults to "foo"; for an app "foobar", this defaults
#   to "foobar".

options python.rootname
default python.rootname {[regsub ^py- [option name] ""]}

default master_sites    {pypi:[string index ${python.rootname} 0]/${python.rootname}}
default distname        {${python.rootname}-${version}}

options python.versions python.version python.default_version
option_proc python.versions python_set_versions
default python.default_version {[python_get_default_version]}
default python.version         {[python_get_version]}

# see https://trac.macports.org/ticket/34562
options python.consistent_destroot
default python.consistent_destroot yes

proc python_get_version {} {
    if {[string match py-* [option name]]} {
        return [string range [option subport] 2 [string first "-" [option subport]]-1]
    } else {
        return [option python.default_version]
    }
}

proc python_get_default_version {} {
    global python.versions
    set def_v 310
    if {[info exists python.versions]} {
        if {${def_v} in ${python.versions}} {
            return ${def_v}
        } else {
            return [lindex ${python.versions} end]
        }
    } else {
        return ${def_v}
    }
}

proc python_set_env_compilers {phase} {
    if {[option supported_archs] eq "noarch"} {
        return
    }
    foreach tag [option compwrap.compilers_to_wrap] {
        if {[option configure.${tag}] ne ""} {
            ${phase}.env-append [string toupper $tag]=[compwrap::wrap_compiler ${tag}]
        }
    }
}

proc python_set_versions {option action args} {
    if {$action ne "set"} {
        return
    }
    global name subport python._addedcode
    if {[string match py-* $name]} {
        foreach v [option $option] {
            subport py${v}[string trimleft $name py] {}
        }
        if {$subport eq $name || $subport eq ""} {
            # Ensure the stub port does not do anything with distfiles—not
            # if the port overrides distfiles, not if there's a post-extract
            # block (e.g. the github portgroup).
            distfiles
            pre-fetch {
                distfiles
            }
            fetch {}
            pre-checksum {
                distfiles
            }
            checksum {}
            pre-extract {
                distfiles
            }
            extract {}

            # set up py-foo as a stub port
            supported_archs noarch
            global python.version
            unset python.version
            patch {}
            build {}
            destroot {
                system "echo $name is a stub port > ${destroot}${prefix}/share/doc/${name}/README"
            }
        } else {
            set addcode 1
        }
    } else {
        set addcode 1
    }
    if {[info exists addcode] && ![info exists python._addedcode]} {
        pre-build {
            set pycflags ""
            set pycxxflags ""
            set pyobjcflags ""
            if {${python.add_archflags}} {
                if {[variant_exists universal] && [variant_isset universal]} {
                    build.env-append    LDFLAGS=${configure.universal_ldflags}
                    set pycflags ${configure.universal_cflags}
                    set pycxxflags ${configure.universal_cxxflags}
                    set pyobjcflags ${configure.universal_cflags}
                } else {
                    build.env-append    FFLAGS=${configure.f77_archflags} \
                                        F90FLAGS=${configure.f90_archflags} \
                                        FCFLAGS=${configure.fc_archflags} \
                                        LDFLAGS=${configure.ld_archflags}
                    set pycflags ${configure.cc_archflags}
                    set pycxxflags ${configure.cxx_archflags}
                    set pyobjcflags ${configure.objc_archflags}
                }
            }
            if {${python.set_cxx_stdlib}} {
                set pycxxflags [portconfigure::construct_cxxflags $pycxxflags]
            }
            if {${python.set_sdkroot}} {
                if {${configure.sdkroot} ne ""} {
                    append pycflags " -isysroot${configure.sdkroot}"
                    append pycxxflags " -isysroot${configure.sdkroot}"
                    append pyobjcflags " -isysroot${configure.sdkroot}"
                } else {
                    append pycflags " -isysroot/"
                    append pycxxflags " -isysroot/"
                    append pyobjcflags " -isysroot/"
                }
            }
            if {$pycflags ne ""} {
                build.env-append        CFLAGS=$pycflags
            }
            if {$pycxxflags ne ""} {
                build.env-append        CXXFLAGS=$pycxxflags
            }
            if {$pyobjcflags ne ""} {
                build.env-append        OBJCFLAGS=$pyobjcflags
            }
            if {${python.set_compiler}} {
                python_set_env_compilers build
            }
        }
        pre-destroot {
            set pycflags ""
            set pycxxflags ""
            set pyobjcflags ""
            if {${python.add_archflags} && ${python.consistent_destroot}} {
                if {[variant_exists universal] && [variant_isset universal]} {
                    destroot.env-append LDFLAGS=${configure.universal_ldflags}
                    set pycflags ${configure.universal_cflags}
                    set pycxxflags ${configure.universal_cxxflags}
                    set pyobjcflags ${configure.universal_cflags}
                } else {
                    destroot.env-append FFLAGS=${configure.f77_archflags} \
                                        F90FLAGS=${configure.f90_archflags} \
                                        FCFLAGS=${configure.fc_archflags} \
                                        LDFLAGS=${configure.ld_archflags}
                    set pycflags ${configure.cc_archflags}
                    set pycxxflags ${configure.cxx_archflags}
                    set pyobjcflags ${configure.objc_archflags}
                }
            }
            if {${python.set_cxx_stdlib} && ${python.consistent_destroot}} {
                set pycxxflags [portconfigure::construct_cxxflags $pycxxflags]
            }
            if {${python.set_sdkroot} && ${python.consistent_destroot}} {
                if {${configure.sdkroot} ne ""} {
                    append pycflags " -isysroot${configure.sdkroot}"
                    append pycxxflags " -isysroot${configure.sdkroot}"
                    append pyobjcflags " -isysroot${configure.sdkroot}"
                } else {
                    append pycflags " -isysroot/"
                    append pycxxflags " -isysroot/"
                    append pyobjcflags " -isysroot/"
                }
            }
            if {$pycflags ne ""} {
                destroot.env-append     CFLAGS=$pycflags
            }
            if {$pycxxflags ne ""} {
                destroot.env-append     CXXFLAGS=$pycxxflags
            }
            if {$pyobjcflags ne ""} {
                destroot.env-append     OBJCFLAGS=$pyobjcflags
            }
            if {${python.set_compiler} && ${python.consistent_destroot}} {
                python_set_env_compilers destroot
            }
        }
        post-destroot {
            if {${python.link_binaries}} {
                foreach bin [glob -nocomplain -tails -directory "${destroot}${python.prefix}/bin" *] {
                    if {[catch {file type "${destroot}${prefix}/bin/${bin}${python.link_binaries_suffix}"}]} {
                        ln -s "${python.prefix}/bin/${bin}" "${destroot}${prefix}/bin/${bin}${python.link_binaries_suffix}"
                    }
                }
            }
            if {${python.move_binaries}} {
                foreach bin [glob -nocomplain -tails -directory "${destroot}${prefix}/bin" *] {
                    move ${destroot}${prefix}/bin/${bin} \
                        ${destroot}${prefix}/bin/${bin}${python.move_binaries_suffix}
                }
            }
        }
        set python._addedcode 1
    }
}

option_proc python.default_version python_set_default_version
proc python_set_default_version {option action args} {
    if {$action ne "set"} {
        return
    }
    if {![string match py-* [option name]]} {
        python.versions [option python.default_version]
    }
}


options python.branch python.prefix python.bin python.lib python.libdir \
        python.include python.pkgd python.pep517 python.pep517_backend \
        python.add_dependencies
# for pythonXY, python.branch is X.Y, for pythonXYZ, it's X.YZ
default python.branch   {[string index ${python.version} 0].[string range ${python.version} 1 end]}
default python.prefix   {${frameworks_dir}/Python.framework/Versions/${python.branch}}
default python.bin      {${python.prefix}/bin/python${python.branch}}
default python.lib      {${python.prefix}/Python}
default python.pkgd     {${python.prefix}/lib/python${python.branch}/site-packages}
default python.libdir   {${python.prefix}/lib/python${python.branch}}
default python.include  {[python_get_defaults include]}
default build.cmd       {[python_get_defaults build_cmd]}
default build.target    {[python_get_defaults build_target]}
default destroot.cmd    {[python_get_defaults destroot_cmd]}
default destroot.destdir {[python_get_defaults destroot_destdir]}
default destroot.target {[python_get_defaults destroot_target]}

default python.pep517   no
default python.pep517_backend   setuptools

default python.add_dependencies yes
proc python_add_dependencies {} {
    if {[option python.add_dependencies]} {
        global subport python.version python.default_version
        if {[string match py-* $subport]} {
            # set up py-foo as a stub port that depends on the default pyXY-foo
            depends_lib-delete port:py${python.default_version}[string trimleft $subport py]
            depends_lib-append port:py${python.default_version}[string trimleft $subport py]
        } else {
            depends_lib-delete port:python${python.version}
            depends_lib-append port:python${python.version}
            if {[option python.pep517]} {
                depends_build-delete    port:py${python.version}-build \
                                        port:py${python.version}-python-install
                depends_build-append    port:py${python.version}-build \
                                        port:py${python.version}-python-install
                switch -- [option python.pep517_backend] {
                    setuptools {
                        depends_build-delete    port:py${python.version}-setuptools \
                                                port:py${python.version}-wheel
                        depends_build-append    port:py${python.version}-setuptools \
                                                port:py${python.version}-wheel
                    }
                    flit {
                        depends_build-delete    port:py${python.version}-flit_core
                        depends_build-append    port:py${python.version}-flit_core
                    }
                    poetry {
                        depends_build-delete    port:py${python.version}-poetry-core
                        depends_build-append    port:py${python.version}-poetry-core
                    }
                    default {}
                }
            }
        }
    }
}
port::register_callback python_add_dependencies


proc python_get_defaults {var} {
    global python.version python.branch python.prefix python.bin python.pep517 workpath
    switch -- $var {
        binary_suffix {
            if {[string match py-* [option name]]} {
                return -${python.branch}
            } else {
                return ""
            }
        }
        build_cmd {
            if {${python.pep517}} {
                return "${python.bin} -m build --wheel --no-isolation --outdir ${workpath}"
            } else {
                return "${python.bin} setup.py --no-user-cfg"
            }
        }
        build_target {
            if {${python.pep517}} {
                return ""
            } else {
                return build[python_get_defaults jobs_arg]
            }
        }
        destroot_cmd {
            if {${python.pep517}} {
                return "${python.bin} -m install --verbose"
            } else {
                return "${python.bin} setup.py --no-user-cfg"
            }
        }
        destroot_destdir {
            global destroot
            if {${python.pep517}} {
                return "--destdir ${destroot}"
            } else {
                return "--prefix=${python.prefix} --root=${destroot}"
            }
        }
        destroot_target {
            if {${python.pep517}} {
                return [glob -nocomplain -directory ${workpath} *.whl]
            } else {
                return install
            }
        }
        include {
            set inc_dir "${python.prefix}/include/python${python.branch}"
            if {[file exists ${inc_dir}]} {
                return ${inc_dir}
            } else {
                # look for "${inc_dir}*" and pick the first one found;
                # make assumptions if none are found
                if {[catch {glob ${inc_dir}*} inc_dirs]} {
                    # append 'm' suffix if 30 <= PyVer <= 37
                    # Py27- and Py38+ do not use this suffix
                    if {${python.version} < 30 || ${python.version} > 37} {
                        return ${inc_dir}
                    } else {
                        return ${inc_dir}m
                    }
                } else {
                    return [lindex ${inc_dirs} 0]
                }
            }
        }
        jobs_arg {
            if {${python.version} >= 35 && [option use_parallel_build]} {
                return " -j[option build.jobs]"
            } else {
                return ""
            }
        }
        default {
            error "unknown option $var"
        }
    }
}

options python.add_archflags python.set_compiler \
        python.set_cxx_stdlib python.set_sdkroot \
        python.link_binaries python.link_binaries_suffix \
        python.move_binaries python.move_binaries_suffix

default python.add_archflags yes
default python.set_compiler yes
default python.set_cxx_stdlib yes
default python.set_sdkroot yes

default python.link_binaries yes
default python.link_binaries_suffix {[python_get_defaults binary_suffix]}

default python.move_binaries no
default python.move_binaries_suffix {[python_get_defaults binary_suffix]}

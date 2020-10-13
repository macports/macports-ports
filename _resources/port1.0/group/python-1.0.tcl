# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# Usage:
# name should be of the form py-foo for modules
# subports pyXY-foo are declared for each XY in python.versions

# for apps (i.e. not named py-foo), no subports will be defined
# only the python.default_version will be used
# you can change that in variants if you want

# options:
# python.versions: which versions this module supports, e.g. "27 38 39 pypy37"
#   always set this (even if you have your own subport blocks)
# python.default_version: which version will be installed if the user asks
#   for py-foo rather than pyXY-foo
# python.consistent_destroot: set consistent environment values in build and destroot phases
#
# Note: setting these options requires name to be set beforehand

categories      python

use_configure   no
# we want the default universal variant added despite not using configure
universal_variant yes

default build.target {build[python_get_defaults jobs_arg]}

post-extract {
    # Prevent setuptools' easy_install from downloading dependencies
    set fs [open $env(HOME)/.pydistutils.cfg w+]
    puts $fs {[easy_install]}
    puts $fs {allow_hosts = None}
    close $fs
    # Same for pip
    file mkdir $env(HOME)/.config/pip
    set fs [open $env(HOME)/.config/pip/pip.conf w+]
    puts $fs {[install]}
    puts $fs {no-deps = yes}
    puts $fs {no-index = yes}
    close $fs
}

pre-destroot    {
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
default python.version {[python_get_version]}

# see #34562
options python.consistent_destroot
default python.consistent_destroot yes

proc python_get_version {} {
    if {[string match py-* [option name]]} {
        set v [lindex [split [option subport] -] 0]

        if {[regexp {^py\d+$} ${v}]} {
            return [string range $v 2 end]
        } else {
            return ${v}
        }
    } else {
        return [option python.default_version]
    }
}

proc python_get_default_version {} {
    global python.versions
    set def_v 38
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

proc python_set_versions {option action args} {
    if {$action ne "set"} {
        return
    }
    global name subport python._addedcode
    if {[string match py-* $name]} {
        set rootname [join [lindex [split $name -] 1 end] -]
        foreach v [option $option] {
            # special handling of regular CPython versions
            if {[regexp {^\d+$} ${v}]} {
                set v py${v}
            }
            subport ${v}-${rootname} {
                global python.port
                depends_lib-append port:${python.port}
            }
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

            # set up py-foo as a stub port that depends on the default pyXY-foo
            supported_archs noarch
            global python.default_version python.version
            unset python.version
            if {[string match {[0-9]*} ${python.default_version}]} {
                depends_lib port:py${python.default_version}-${rootname}
            } else {
                depends_lib port:${python.default_version}-${rootname}
            }
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
                foreach var {cc objc cxx fc f77 f90} {
                    if {[set configure.${var}] ne ""} {
                        build.env-append [string toupper $var]=[set configure.${var}]
                    }
                }
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
                foreach var {cc objc cxx fc f77 f90} {
                    if {[set configure.${var}] ne ""} {
                        destroot.env-append [string toupper $var]=[set configure.${var}]
                    }
                }
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
    global name subport python.default_version python.rootname python.port
    if {[string match py-* $name]} {
        if {$subport eq $name || $subport eq ""} {
            if {[string match {[0-9]*} ${python.default_version}]} {
                set v py${python.default_version}
            } else {
                set v ${python.default_version}
            }
            depends_lib port:${v}-${python.rootname}
        }
    } else {
        python.versions ${python.default_version}
        depends_lib-append port:${python.port}
    }
}


options python.branch python.prefix python.bin python.lib python.libdir \
        python.include python.pkgd
# "CPython" or "PyPy"
default python.impl     {[python_get_defaults impl]}
# for pythonXYZ or pypyXYZ, python.branch is X.YZ
default python.branch   {[python_get_defaults branch]}
# for pythonXYZ or pypyXYZ, python.language_version is XYZ
default python.language_version \
                        {[string map {. {}} [python_get_defaults branch]]}
default python.prefix   {[python_get_defaults prefix]}
# e.g. py37 or pypy37, for dependencies, etc.
default python.headname {[python_get_defaults headname]}
default python.port     {[python_get_defaults port]}
default python.bin      {[python_get_defaults bin]}
default python.lib      {[python_get_defaults lib]}
default python.pkgd     {[python_get_defaults pkgd]}
default python.libdir   {[python_get_defaults libdir]}
default python.include  {[python_get_defaults include]}
default build.cmd       {${python.bin} setup.py --no-user-cfg}
default destroot.cmd    {${python.bin} setup.py --no-user-cfg}
default destroot.destdir {--prefix=${python.prefix} --root=${destroot}}


proc python_get_defaults {var} {
    global frameworks_dir prefix \
        python.impl python.version python.branch python.prefix

    switch -- $var {
        branch {
            set vs [regexp -inline {^[[:alpha:]]*(\d)(\d+)$} ${python.version}]
            return [join [lrange ${vs} 1 end] .]
        }
        impl {
            if {[string match py-* [option name]]} {
                set v [regexp -inline {^py(?:py)?\d+} [option subport]]
            } else {
                set v ${python.version}
            }

            if {[string match pypy* ${v}]} {
                return "PyPy"
            } else {
                return "CPython"
            }
        }
        prefix {
            if {${python.impl} eq "PyPy" && ${python.branch} == 2.7} {
                return ${prefix}/lib/pypy
            } elseif {${python.impl} eq "PyPy"} {
                return ${prefix}/lib/${python.version}
            } else {
                return ${frameworks_dir}/Python.framework/Versions/${python.branch}
            }
        }
        headname {
            if {${python.impl} eq "CPython"} {
                return py${python.version}
            } else {
                return ${python.version}
            }
        }
        port {
            if {${python.impl} eq "CPython"} {
                return python${python.version}
            } elseif {${python.impl} eq "PyPy" && ${python.branch} == 2.7} {
                return pypy
            } else {
                return ${python.version}
            }
        }
        bin {
            if {${python.impl} eq "PyPy"} {
                if {${python.branch} == 2.7} {
                    return ${python.prefix}/bin/pypy
                } else {
                    return ${python.prefix}/bin/pypy3
                }
            } elseif {${python.impl} eq "CPython"} {
                return ${python.prefix}/bin/python${python.branch}
            }
        }
        lib {
            if {${python.impl} eq "PyPy"} {
                if {${python.branch} == 2.7} {
                    return ${python.prefix}/bin/libpypy-c.dylib
                } else {
                    return ${python.prefix}/bin/libpypy3-c.dylib
                }
            } elseif {${python.impl} eq "CPython"} {
                return ${python.prefix}/Python
            }
        }
        pkgd {
            if {${python.impl} eq "PyPy"} {
                return ${python.prefix}/site-packages
            } elseif {${python.impl} eq "CPython"} {
                return ${python.prefix}/lib/python${python.branch}/site-packages
            }
        }
        libdir {
            if {${python.impl} eq "PyPy"} {
                if {${python.version} eq 27} {
                    return ${python.prefix}/lib-python/${python.branch}
                } else {
                    return ${python.prefix}/lib-python/[string index ${python.version} 0]
                }
            } elseif {${python.impl} eq "CPython"} {
                return ${python.prefix}/lib/python${python.branch}
            }
        }
        include {
            if {${python.impl} eq "PyPy"} {
                return ${python.prefix}/include
            }

            set inc_dir "${python.prefix}/include/python${python.branch}"
            if {[file exists ${inc_dir}]} {
                return ${inc_dir}
            } else {
                # look for "${inc_dir}*" and pick the first one found;
                # make assumptions if none are found
                if {[catch {set inc_dirs [glob ${inc_dir}*]}]} {
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
        binary_suffix {
            if {${python.impl} eq "PyPy"} {
                return -pypy${python.branch}
            } elseif {${python.impl} eq "CPython"} {
                return -${python.branch}
            }
        }
        jobs_arg {
            if {[vercmp ${python.branch} 3.5] >= 0 && [option use_parallel_build]} {
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

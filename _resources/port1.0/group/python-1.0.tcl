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

categories      python

use_configure   no
# we want the default universal variant added despite not using configure
universal_variant yes

build.target    build

post-extract {
    # Prevent setuptools' easy_install from downloading dependents
    set fs [open $env(HOME)/.pydistutils.cfg w+]
    puts $fs {[easy_install]}
    puts $fs {allow_hosts = None}
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

options python.versions python.version python.default_version
option_proc python.versions python_set_versions
default python.default_version {[python_get_default_version]}
default python.version {[python_get_version]}

# see #34562
options python.consistent_destroot
default python.consistent_destroot yes

proc python_get_version {} {
    if {[string match py-* [option name]]} {
        return [string range [option subport] 2 3]
    } else {
        return [option python.default_version]
    }
}
proc python_get_default_version {} {
    global python.versions
    if {[info exists python.versions]} {
        if {37 in ${python.versions}} {
            return 37
        } else {
            return [lindex ${python.versions} end]
        }
    } else {
        return 37
    }
}

proc python_set_versions {option action args} {
    if {$action ne "set"} {
        return
    }
    global name subport python._addedcode
    if {[string match py-* $name]} {
        foreach v [option $option] {

            subport py${v}[string trimleft $name py] { depends_lib-append port:python${v} }
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
            depends_lib port:py${python.default_version}[string trimleft $name py]
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
                    if {[vercmp [macports_version] 2.5.99] >= 0} {
                    build.env-append    LDFLAGS=${configure.universal_ldflags}
                    } else {
                    build.env-append    LDFLAGS="${configure.universal_ldflags}"
                    }
                    set pycflags ${configure.universal_cflags}
                    set pycxxflags ${configure.universal_cxxflags}
                    set pyobjcflags ${configure.universal_cflags}
                } else {
                    if {[vercmp [macports_version] 2.5.99] >= 0} {
                    build.env-append    FFLAGS=${configure.f77_archflags} \
                                        F90FLAGS=${configure.f90_archflags} \
                                        FCFLAGS=${configure.fc_archflags} \
                                        LDFLAGS=${configure.ld_archflags}
                    } else {
                    build.env-append    FFLAGS="${configure.f77_archflags}" \
                                        F90FLAGS="${configure.f90_archflags}" \
                                        FCFLAGS="${configure.fc_archflags}" \
                                        LDFLAGS="${configure.ld_archflags}"
                    }
                    set pycflags ${configure.cc_archflags}
                    set pycxxflags ${configure.cxx_archflags}
                    set pyobjcflags ${configure.objc_archflags}
                }
            }
            if {${python.set_cxx_stdlib}} {
                set pycxxflags [portconfigure::construct_cxxflags $pycxxflags]
            }
            if {${python.set_sdkroot} && ${configure.sdkroot} ne ""} {
                append pycflags " -isysroot${configure.sdkroot}"
                append pycxxflags " -isysroot${configure.sdkroot}"
                append pyobjcflags " -isysroot${configure.sdkroot}"
            }
            if {$pycflags ne ""} {
                if {[vercmp [macports_version] 2.5.99] >= 0} {
                build.env-append        CFLAGS=$pycflags
                } else {
                build.env-append        CFLAGS="$pycflags"
                }
            }
            if {$pycxxflags ne ""} {
                if {[vercmp [macports_version] 2.5.99] >= 0} {
                build.env-append        CXXFLAGS=$pycxxflags
                } else {
                build.env-append        CXXFLAGS="$pycxxflags"
                }
            }
            if {$pyobjcflags ne ""} {
                if {[vercmp [macports_version] 2.5.99] >= 0} {
                build.env-append        OBJCFLAGS=$pyobjcflags
                } else {
                build.env-append        OBJCFLAGS="$pyobjcflags"
                }
            }
            if {${python.set_compiler}} {
                foreach var {cc objc cxx fc f77 f90} {
                    if {[set configure.${var}] ne ""} {
                        if {[vercmp [macports_version] 2.5.99] >= 0} {
                        build.env-append [string toupper $var]=[set configure.${var}]
                        } else {
                        build.env-append [string toupper $var]="[set configure.${var}]"
                        }
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
                    if {[vercmp [macports_version] 2.5.99] >= 0} {
                    destroot.env-append LDFLAGS=${configure.universal_ldflags}
                    } else {
                    destroot.env-append LDFLAGS="${configure.universal_ldflags}"
                    }
                    set pycflags ${configure.universal_cflags}
                    set pycxxflags ${configure.universal_cxxflags}
                    set pyobjcflags ${configure.universal_cflags}
                } else {
                    if {[vercmp [macports_version] 2.5.99] >= 0} {
                    destroot.env-append FFLAGS=${configure.f77_archflags} \
                                        F90FLAGS=${configure.f90_archflags} \
                                        FCFLAGS=${configure.fc_archflags} \
                                        LDFLAGS=${configure.ld_archflags}
                    } else {
                    destroot.env-append FFLAGS="${configure.f77_archflags}" \
                                        F90FLAGS="${configure.f90_archflags}" \
                                        FCFLAGS="${configure.fc_archflags}" \
                                        LDFLAGS="${configure.ld_archflags}"
                    }
                    set pycflags ${configure.cc_archflags}
                    set pycxxflags ${configure.cxx_archflags}
                    set pyobjcflags ${configure.objc_archflags}
                }
            }
            if {${python.set_cxx_stdlib} && ${python.consistent_destroot}} {
                set pycxxflags [portconfigure::construct_cxxflags $pycxxflags]
            }
            if {${python.set_sdkroot} && ${python.consistent_destroot} && ${configure.sdkroot} ne ""} {
                append pycflags " -isysroot${configure.sdkroot}"
                append pycxxflags " -isysroot${configure.sdkroot}"
                append pyobjcflags " -isysroot${configure.sdkroot}"
            }
            if {$pycflags ne ""} {
                if {[vercmp [macports_version] 2.5.99] >= 0} {
                destroot.env-append     CFLAGS=$pycflags
                } else {
                destroot.env-append     CFLAGS="$pycflags"
                }
            }
            if {$pycxxflags ne ""} {
                if {[vercmp [macports_version] 2.5.99] >= 0} {
                destroot.env-append     CXXFLAGS=$pycxxflags
                } else {
                destroot.env-append     CXXFLAGS="$pycxxflags"
                }
            }
            if {$pyobjcflags ne ""} {
                if {[vercmp [macports_version] 2.5.99] >= 0} {
                destroot.env-append     OBJCFLAGS=$pyobjcflags
                } else {
                destroot.env-append     OBJCFLAGS="$pyobjcflags"
                }
            }
            if {${python.set_compiler} && ${python.consistent_destroot}} {
                foreach var {cc objc cxx fc f77 f90} {
                    if {[set configure.${var}] ne ""} {
                        if {[vercmp [macports_version] 2.5.99] >= 0} {
                        destroot.env-append [string toupper $var]=[set configure.${var}]
                        } else {
                        destroot.env-append [string toupper $var]="[set configure.${var}]"
                        }
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
    global name subport python.default_version
    if {[string match py-* $name]} {
        if {$subport eq $name || $subport eq ""} {
            depends_lib port:py${python.default_version}[string trimleft $name py]
        }
    } else {
        python.versions ${python.default_version}
        depends_lib-append port:python[option python.default_version]
    }
}


options python.branch python.prefix python.bin python.lib python.libdir \
        python.include python.pkgd
# for pythonXY, python.branch is X.Y
default python.branch   {[string range ${python.version} 0 end-1].[string index ${python.version} end]}
default python.prefix   {${frameworks_dir}/Python.framework/Versions/${python.branch}}
default python.bin      {${python.prefix}/bin/python${python.branch}}
default python.lib      {${python.prefix}/Python}
default python.pkgd     {${python.prefix}/lib/python${python.branch}/site-packages}
default python.libdir   {${python.prefix}/lib/python${python.branch}}
default python.include  {[python_get_defaults include]}
default build.cmd       {${python.bin} setup.py --no-user-cfg}
default destroot.cmd    {${python.bin} setup.py --no-user-cfg}
default destroot.destdir {--prefix=${python.prefix} --root=${destroot}}

proc python_get_defaults {var} {
    global python.version python.branch python.prefix
    switch -- $var {
        include {
            set inc_dir "${python.prefix}/include/python${python.branch}"
            if {[file exists ${inc_dir}]} {
                return ${inc_dir}
            } else {
                # look for "${inc_dir}*" and pick the first one found;
                # make assumptions if none are found
                if {[catch {set inc_dirs [glob ${inc_dir}*]}]} {
                    if {${python.version} < 30} {
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
            if {[string match py-* [option name]]} {
                return -${python.branch}
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

# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# $Id$
#
# Copyright (c) 2009-2012 The MacPorts Project
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of The MacPorts Project nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
# This PortGroup builds PHP extensions. Set name and version as for a normal
# standalone port, then set php.branches and optionally any other php options,
# described in more detail below.

default categories              php


# php.branches: the list of PHP branches for which the extension(s) will be
# built. For unified extension ports (name begins with "php-") setting
# php.branches is mandatory; there is no default. Example:
#
#   php.branches                5.3 5.4
#
# For unified ports, setting php.branches will create the subports.
#
# For single-branch extension ports (name begins with e.g. "php54-")
# php.branches is set automatically based on the port name and should not be
# changed.

options php.branches
option_proc php.branches        php._set_branches

proc php._set_branches {option action args} {
    if {"set" != ${action}} {
        return
    }

    # Sort the values so we can use lindex 0 and end to get the min and max branches respectively.
    option ${option} [lsort -command vercmp [option ${option}]]

    global php.default_branch php.rootname name subport

    if {[regexp {^php\d*-} ${name}]} {
        # Legacy dist_subdir to match old php5- port layout.
        if {[lindex [split [lindex [option ${option}] 0] .] 0] == "5"} {
            dist_subdir php5-${php.rootname}
        }

        if {[regexp {^php-} ${name}]} {
            # Create subport for each PHP branch.
            php.create_subports

            # Set up stub port.
            if {${name} == ${subport}} {
                supported_archs     noarch
                depends_run         port:php[php.suffix_from_branch ${php.default_branch}]-${php.rootname}

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

                patch {}
                use_configure       no
                build {}
                test {}
                destroot {
                    xinstall -d -m 755 ${destroot}${prefix}/share/doc/${subport}
                    system "echo \"${subport} is a stub port\" > ${destroot}${prefix}/share/doc/${subport}/README"
                }
            }
        } else {
            # Single-branch extension port; add the code to the port directly.
            php.add_port_code
        }
    }
}


# Set php.branches automatically if the port name includes the PHP branch.

option_proc name                php._set_name

proc php._set_name {option action args} {
    if {"set" != ${action}} {
        return
    }

    if {[regexp {^php\d+-} ${args}]} {
        php.branches            [php.branch_from_subport]
    }
}


# php.latest_stable_branch: the latest stable branch of PHP in the php port.
# Ports should not change this. It should be changed here in this portgroup
# when the php port is updated.

options php.latest_stable_branch
default php.latest_stable_branch 5.4


# php.default_branch: the branch of PHP for which the port should be installed
# (i.e. the subport on which a dependency will be declared) if the user
# installs the stub port. The default is the latest stable branch, if the port
# supports it, or otherwise the latest listed in ${php.branches}. Ports should
# not need to change this.

options php.default_branch
default php.default_branch      {[expr {[lsearch -exact ${php.branches} ${php.latest_stable_branch}] != -1 ? ${php.latest_stable_branch} : [lindex ${php.branches} end]}]}
option_proc php.default_branch  php._set_default_branch

proc php._set_default_branch {option action args} {
    if {"set" != ${action}} {
        return
    }

    global name subport php.rootname

    if {[regexp {^php-} ${name}] && ${name} == ${subport}} {
        depends_run             port:php[php.suffix_from_branch [option ${option}]]-${php.rootname}
    }
}


# php.rootname: for normal extension ports, the part of the port name after the
# "php-" prefix. The default distname is based on this, as are the names of the
# subports (if any). Extension ports should not need to set this, but other
# ports calling php.create_subports manually might.

options php.rootname
default php.rootname            {[php._get_rootname]}
proc php._get_rootname {} {
    global name
    regexp {^php\d*-(.+)$} ${name} -> rootname
    if {[info exists rootname]} {
        return ${rootname}
    }
    return ${name}
}


# php.create_subports: creates subports for each PHP branch
#
# For a normal extension port whose name starts with "php-" this will be called
# automatically when you set php.branches so you shouldn't need to call it
# manually unless for example you're adding PHP extension subports to a port
# that also installs other software.

proc php.create_subports {} {
    global php.branches php.rootname
    foreach branch ${php.branches} {
        subport php[php.suffix_from_branch ${branch}]-${php.rootname} {
            php.add_port_code
        }
    }
}


# php.extension_ini: the name of the automatically-generated ini file that
# loads the exension(s). There should be no need to change the default.

options php.extension_ini
default php.extension_ini       {${php.rootname}.ini}


# php.extensions: the list of normal extensions that will be listed in the
# port's ini file, which will cause PHP to load them. The default is to list
# all installed extensions, and most ports won't need to change this.

options php.extensions


# php.extensions.zend: the list of Zend extensions that will be listed in the
# port's ini file. The default is that none of the extensions are Zend
# extensions. Most extensions are normal extensions, not Zend extensions. Zend
# extensions are those that directly interact with the Zend engine, such as PHP
# accelerators and debuggers.

options php.extensions.zend
default php.extensions.zend     {}


# php.build_dirs: the list of directories we need to phpize, configure, build
# and destroot in. Most ports only need to phpize, configure, build and destroot
# in a single directory and so do not need to change this value, and should be
# setting worksrcdir instead. This option exists primarily so that some subports
# of the php port can install multiple related extensions at once.

options php.build_dirs
default php.build_dirs          {${worksrcpath}}


# php.pecl: whether this extension is hosted on PECL or not. When set to "yes"
# the homepage, master_sites, extract.suffix, and livecheck are set according
# to PECL standards.

options php.pecl
default php.pecl                no
option_proc php.pecl            php._set_pecl

proc php._set_pecl {option action args} {
    if {"set" != ${action}} {
        return
    }

    if {${args}} {
        global php.rootname

        php.pecl.name           ${php.rootname}
        master_sites            http://pecl.php.net/get/
        extract.suffix          .tgz

        livecheck.type          regexm
        php.pecl.prerelease     no
    }
}


# php.pecl.name: for PECL extensions, the name of the PECL project. The default
# distname, homepage and livecheck.url are based on this. The default is based
# on ${php.rootname} which is appropriate for most PECL extensions.

options php.pecl.name
default php.pecl.name           {${php.rootname}}
option_proc php.pecl.name       php._set_pecl_name

proc php._set_pecl_name {option action args} {
    if {"set" != ${action}} {
        return
    }

    global php.pecl

    if {${php.pecl}} {
        set pecl_homepage       http://pecl.php.net/package/${args}
        default distname        {${php.pecl.name}-${version}}
        homepage                ${pecl_homepage}
        livecheck.url           ${pecl_homepage}
    }
}


# php.pecl.prerelease: for PECL extensions, whether to allow livecheck to match
# pre-release versions or only stable versions. For most PECL extensions the
# default of "no" is appropriate, but for extensions that have not yet released
# their first stable version, you can set this to "yes".

options php.pecl.prerelease
default php.pecl.prerelease     no
option_proc php.pecl.prerelease php._set_pecl_prerelease

proc php._set_pecl_prerelease {option action args} {
    if {"set" != ${action}} {
        return
    }

    global php.pecl

    if {${php.pecl}} {
        if {${args}} {
            livecheck.regex     {>([0-9a-zA-Z.]+)</a></th>}
        } else {
            livecheck.regex     {>([0-9a-zA-Z.]+)</a></th>\s*<[^>]+>stable<}
        }
    }
}


# php: the name of this branch of PHP, e.g. "php53" or "php54".

options php
default php                     {php${php.suffix}}


# php.branch: the version number of this branch of PHP, e.g. "5.3" or "5.4".

options php.branch
default php.branch              {[php.branch_from_subport]}


# php.config: the path to the php-config script for this branch of PHP.

options php.config
default php.config              {${prefix}/bin/php-config${php.suffix}}


# php.extension_dir: the path to the directory extensions will be installed into
# for this branch of PHP.

options php.extension_dir
default php.extension_dir       {[exec ${php.config} --extension-dir 2>/dev/null]}


# php.ini: the path to the configuration file for this branch of PHP.

options php.ini
default php.ini                 {${prefix}/etc/${php}/php.ini}


# php.ini_dir: the directory the automatically-generated extension ini files
# will be installed into for this branch of PHP.

options php.ini_dir
default php.ini_dir             {${prefix}/var/db/${php}}


# php.ize: the path to the phpize script for this branch of PHP.

options php.ize
default php.ize                 {${prefix}/bin/phpize${php.suffix}}


# php.suffix: the suffix appended to file and directory names for this branch of
# PHP, e.g. "53" or "54".

options php.suffix
default php.suffix              {[php.suffix_from_branch ${php.branch}]}


# php._first_version: keep track of the first version line in the port.

global php._first_version
option_proc version             php._set_version

proc php._set_version {option action args} {
    if {"set" != ${action}} {
        return
    }

    global php._first_version

    if {![info exists php._first_version]} {
        set php._first_version [option ${option}]
    }
}


# If a subport has not changed the version, disable livecheck.

pre-livecheck {
    global name subport version php._first_version
    if {${name} != ${subport} && ${name} != "php" && ${version} == ${php._first_version}} {
        livecheck.type          none
    }
}


# php.add_port_code: adds the code to the port or subport to do the actual
# building. For normal extension ports, the portgroup automatically calls this
# for you when appropriate; the php port's extension subports are a special case
# and call it manually.

proc php.add_port_code {} {
    global php php.branch php.branches php.build_dirs php.config php.extension_ini php.extensions php.ini_dir php.rootname
    global destroot name subport version

    # Set up distfiles default for non-bundled extensions.
    default distname        {${php.rootname}-${version}}

    depends_build-append    port:autoconf

    depends_lib-append      port:${php}

    configure.pre_args-append --with-php-config=${php.config}

    configure.universal_args-delete --disable-dependency-tracking

    variant debug description {Enable debug support (useful to analyze a PHP-related core dump)} {}

    pre-configure {
        set php_debug_variant [regexp {/debug-[^/]+$} ${php.extension_dir}]
        if {${php_debug_variant} && ![variant_isset debug]} {
            ui_error "${subport} cannot be installed without the debug variant because ${php} is installed with the debug variant."
            return -code error "incompatible variant selection"
        } elseif {[variant_isset debug] && !${php_debug_variant}} {
            ui_error "${subport} cannot be installed with the debug variant because ${php} is installed without the debug variant."
            return -code error "incompatible variant selection"
        }
        foreach dir ${php.build_dirs} {
            ui_debug "Generating configure script in [file tail ${dir}]"
            system -W ${dir} "${php.ize}"
        }
    }

    configure {
        foreach configure.dir ${php.build_dirs} {
            ui_debug "Configuring in [file tail ${configure.dir}]"
            portconfigure::configure_main
        }
    }

    build {
        foreach build.dir ${php.build_dirs} {
            ui_debug "Building in [file tail ${build.dir}]"
            portbuild::build_main
        }
    }

    destroot.destdir        INSTALL_ROOT=${destroot}

    destroot {
        foreach destroot.dir ${php.build_dirs} {
            ui_debug "Staging in [file tail ${destroot.dir}]"
            portdestroot::destroot_main
        }
    }

    post-destroot {
        # Get the list of extensions that got installed by the port.
        set installed_extension_files [lsort [glob -nocomplain -tails -directory ${destroot}${php.extension_dir} *.so]]
        set installed_extensions {}
        foreach installed_extension_file ${installed_extension_files} {
            lappend installed_extensions [file rootname ${installed_extension_file}]
        }

        # If the portfile author didn't specify which extensions to load,
        # load all of them.
        if {![info exists php.extensions]} {
            if {0 < [llength ${php.extensions.zend}]} {
                set php.extensions {}
            } else {
                set php.extensions ${installed_extensions}
            }
        }

        foreach extension [concat ${php.extensions} ${php.extensions.zend}] {
            if {-1 == [lsearch -exact ${installed_extensions} ${extension}]} {
                ui_error "Cannot list extension \"${extension}\" in ${php.extension_ini} because the port only installed the extensions \"[join ${installed_extensions} "\", \""]\""
                return -code error "invalid extension name"
            }
        }

        if {0 < [llength ${php.extensions}] || 0 < [llength ${php.extensions.zend}]} {
            xinstall -m 755 -d ${destroot}${php.ini_dir}
            set fp [open ${destroot}${php.ini_dir}/${php.extension_ini} w]
            puts $fp "; Do not edit this file; it is automatically generated by MacPorts. Any changes"
            puts $fp "; you make will be lost if you upgrade, uninstall or deactivate ${subport}."
            puts $fp "; To configure ${php}, edit ${php.ini}."
            foreach extension ${php.extensions.zend} {
                puts $fp "zend_extension=${php.extension_dir}/${extension}.so"
            }
            foreach extension ${php.extensions} {
                puts $fp "extension=${extension}.so"
            }
            close $fp
        }
    }

    post-install {
        if {[file exists ${php.ini}]} {
            set count 0
            set fp [open ${php.ini} r]
            while {![eof $fp]} {
                set line [gets $fp]
                regexp {^extension_dir *= *"?([^\"]*)"?} $line -> php_ini_extension_dir
                if {[info exists php_ini_extension_dir]} {
                    ui_debug "Found extension_dir ${php_ini_extension_dir} in ${php.ini}"
                    if {${php_ini_extension_dir} != ${php.extension_dir}} {
                        if {0 == ${count}} {
                            ui_msg "Your php.ini contains a line that will prevent ${subport}"
                            ui_msg "and other ${php} extensions from working. To fix this,"
                            ui_msg "edit ${php.ini} and delete this line:"
                            ui_msg ""
                        }
                        ui_msg ${line}
                        incr count
                    }
                    unset php_ini_extension_dir
                }
            }
            close $fp
        }
    }
}


# php.suffix_from_branch: calculates the suffix from the given branch.

proc php.suffix_from_branch {branch} {
    return [strsed ${branch} {g/\\.//}]
}


# php.branch_from_suffix: calculates the branch from the given suffix.

proc php.branch_from_suffix {suffix} {
    return [string index ${suffix} 0].[string range ${suffix} 1 end]
}


# php.branch_from_subport: calculates the branch from the subport.

proc php.branch_from_subport {} {
    global php.default_branch subport

    # For the subports, get the branch from ${subport}.
    regexp {^php(\d+)} ${subport} -> suffix
    if {[info exists suffix]} {
        return [php.branch_from_suffix ${suffix}]
    }

    # For the stub port, use the default branch.
    return ${php.default_branch}
}

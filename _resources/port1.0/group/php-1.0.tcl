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
# This PortGroup automatically sets up the standard environment for building
# a PHP extension.
#
# Usage:
#
#   PortGroup                   php 1.0
#   php.setup                   extension version source
#   php.branches                5.3 5.4
#
# where extension is the name of the extension (e.g. APC), version is its
# version, and if the extension is hosted at PECL, source is "pecl"; otherwise
# don't use source.
#
# php.branches must be set to the list of PHP branches for which this extension
# should be made available.
#
# If this is a Zend extension, use
#
#   php.type                    zend

### This portgroup is not ready to be used yet ###


# Options that relate to the PHP extension.
options php.branches
option_proc php.branches        php._set_branches
options php.build_dirs
default php.build_dirs          {[php.build_dirs_proc]}
options php.default_branch
default php.default_branch      {[lindex ${php.branches} end]}
options php.extension_ini
default php.extension_ini       {${php.rootname}.ini}
options php.extensions
options php.pecl_livecheck_stable
default php.pecl_livecheck_stable yes
option_proc php.pecl_livecheck_stable php._set_pecl_livecheck_stable
options php.rootname
default php.rootname            {[lindex ${php.extensions} 0]}
options php.type
default php.type                php

# Options that relate to the branch of PHP being used by a subport.
options php
default php                     {php${php.suffix}}
options php.branch
default php.branch              {[php.branch_from_subport]}
options php.config
default php.config              {${prefix}/bin/php-config${php.suffix}}
options php.extension_dir
default php.extension_dir       {[exec ${php.config} --extension-dir 2>/dev/null]}
options php.ini
default php.ini                 {${prefix}/etc/${php}/php.ini}
options php.ini_dir
default php.ini_dir             {${prefix}/var/db/${php}}
options php.ize
default php.ize                 {${prefix}/bin/phpize${php.suffix}}
options php.suffix
default php.suffix              {[php.suffix_from_branch ${php.branch}]}

# Private options you don't need to worry about.
options php._bundled
default php._bundled            {[string equal ${name} "php"]}


proc php._set_branches {option action args} {
    if {"set" != ${action}} {
        return
    }

    # Sort the values so we can use lindex 0 and end to get the min and max branches respectively.
    option ${option} [lsort -command vercmp [option ${option}]]

    global php.default_branch php.rootname php._bundled name subport
    if {[regexp {^php-} ${name}]} {
        # Legacy dist_subdir to match old php5- port layout.
        if {!${php._bundled}} {
            if {[lindex [split [lindex [option ${option}] 0] .] 0] == "5"} {
                dist_subdir php5-${php.rootname}
            }
        }

        # Create subport for each PHP branch.
        foreach branch [option ${option}] {
            subport php[php.suffix_from_branch ${branch}]-${php.rootname} {}
        }

        # Set up stub port.
        if {${name} == ${subport}} {
            supported_archs     noarch
            depends_run         port:php[php.suffix_from_branch ${php.default_branch}]-${php.rootname}
            fetch {}
            checksum {}
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
    }
}

proc php._set_pecl_livecheck_stable {option action args} {
    global livecheck.regex

    if {"set" != ${action}} {
        return
    }

    if {${args}} {
        livecheck.regex     {>([0-9a-zA-Z.]+)</a></th>\s*<[^>]+>stable<}
    } else {
        livecheck.regex     {>([0-9a-zA-Z.]+)</a></th>}
    }
}

proc php.setup {extensions version {source ""}} {
    global php php.branch php.branches php.build_dirs php.config php.extension_ini php.extensions php.homepage php.ini_dir php.rootname php._bundled
    global destroot name subport

    # Use "set" to preserve the list structure.
    set php.extensions          ${extensions}

    if {![info exists name]} {
        name                    php-${php.rootname}
    }
    version                     ${version}
    categories                  php

    if {${name} != ${subport}} {
        # Set up distfiles for non-bundled extensions.
        if {!${php._bundled}} {
            distname            ${php.rootname}-${version}
        }

        depends_lib-append      port:${php}

        # These are set only for the convenience of subports that want to access
        # these variables directly, e.g. the ${php}-openssl subport which wants
        # to move a file in ${build.dir} in a post-extract block.
        configure.dir           [lindex ${php.build_dirs} 0]
        build.dir               [lindex ${php.build_dirs} 0]
        destroot.dir            [lindex ${php.build_dirs} 0]

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
            xinstall -m 755 -d ${destroot}${php.ini_dir}
            if {"zend" == ${php.type}} {
                set extension_prefix "zend_extension=${php.extension_dir}/"
            } else {
                set extension_prefix "extension="
            }
            set fp [open ${destroot}${php.ini_dir}/${php.extension_ini} w]
            puts $fp "; Do not edit this file; it is automatically generated by MacPorts."
            puts $fp "; Any changes you make will be lost if you upgrade or uninstall ${subport}."
            puts $fp "; To configure ${php}, edit ${php.ini}."
            foreach extension ${php.extensions} {
                puts $fp "${extension_prefix}${extension}.so"
            }
            close $fp
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

    if {"pecl" == ${source}} {
        global php.pecl_livecheck_stable

        set php.homepage        http://pecl.php.net/package/${php.rootname}

        homepage                ${php.homepage}
        master_sites            http://pecl.php.net/get/
        extract.suffix          .tgz

        livecheck.type          regexm
        livecheck.url           ${php.homepage}
        php.pecl_livecheck_stable yes
    }
}

# Return the list of directories we need to phpize / configure / make in.
proc php.build_dirs_proc {} {
    global php.extensions php._bundled worksrcpath
    if {${php._bundled}} {
        set dirs {}
        foreach extension ${php.extensions} {
            lappend dirs ${worksrcpath}/ext/${extension}
        }
        return ${dirs}
    }
    return ${worksrcpath}
}

# Calculate suffix from given branch.
proc php.suffix_from_branch {branch} {
    return [strsed ${branch} {g/\\.//}]
}

# Calculate branch from given suffix.
proc php.branch_from_suffix {suffix} {
    return [string index ${suffix} 0].[string range ${suffix} 1 end]
}

# Calculate branch from subport.
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

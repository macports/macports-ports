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
# 
# where extension is the name of the extension (e.g. APC), version is its
# version, and if the extension is hosted at PECL, source is "pecl"; otherwise
# don't use source.
# 
# If this is a Zend extension, use
# 
#   php.type                    zend

### This portgroup is not ready to be used yet ###


default build.dir               {[lindex ${php.build_dirs} 0]}
default configure.dir           {[lindex ${php.build_dirs} 0]}
default destroot.dir            {[lindex ${php.build_dirs} 0]}
options php
default php                     {php${php.version}}
options php.build_dirs
default php.build_dirs          {[php.build_dirs_proc]}
options php.bundled
options php.config
default php.config              {${prefix}/bin/php-config${php.version}}
options php.extensions
options php.extension_dir
default php.extension_dir       {[exec ${php.config} --extension-dir 2>/dev/null]}
options php.ini
default php.ini                 {${php.rootname}.ini}
options php.inidir
default php.inidir              {${prefix}/var/db/${php}}
options php.php_ini
default php.php_ini             {${prefix}/etc/${php}/php.ini}
options php.phpize
default php.phpize              {${prefix}/bin/phpize${php.version}}
options php.rootname
default php.rootname            {[lindex ${php.extensions} 0]}
options php.source
default php.source              standalone
options php.type
default php.type                php
options php.version
options php.versions
default php.versions            {{54}}

proc php.setup {extensions version {source ""}} {
    global php php.build_dirs php.bundled php.config php.extensions php.homepage php.ini php.inidir php.rootname php.source php.version php.versions
    global destroot name subport
    
    # Use "set" to preserve the list structure.
    set php.extensions          ${extensions}
    
    php.source                  ${source}
    
    # Sort versions so we can use lindex 0 and end to get the min and max versions respectively.
    set php.versions            [lsort ${php.versions}]
    
    if {![info exists name]} {
        name                    php-${php.rootname}
    }
    version                     ${version}
    categories                  php
    
    if {[regexp {^php-} ${name}]} {
        foreach v ${php.versions} {
            subport php${v}-${php.rootname} {}
        }
    }
    
    regexp {^php(\d+)} ${subport} -> php.version
    
    php.bundled                 [regexp {^php\d+$} ${name}]
    
    if {${name} == ${subport}} {
        supported_archs         noarch
        distfiles
        depends_lib-append      port:php[lindex ${php.versions} end]-${php.rootname}
        use_configure           no
        build {}
        destroot {
            xinstall -d -m 755 ${destroot}${prefix}/share/doc/${subport}
            system "echo \"${name} is a stub port\" > ${destroot}${prefix}/share/doc/${subport}/README"
        }
    } else {
        # Set up distfiles for non-bundled extensions.
        if {!${php.bundled}} {
            distname            ${php.rootname}-${version}
            # Legacy dist_subdir to match old php5- port layout.
            if {[string index [lindex ${php.versions} 0] 0] == "5"} {
                dist_subdir     php5-${php.rootname}
            }
        }
        
        depends_lib-append      port:${php}
        
        configure.args-append   --with-php-config=${php.config}
        
        configure.universal_args-delete --disable-dependency-tracking
        
        variant debug description {Enable debug support (useful to analyze a PHP-related core dump)} {}
        
        pre-configure {
            set php_debug_variant [regexp {/debug-[^/]+$} ${php.extension_dir}]
            if {${php_debug_variant} && ![variant_isset debug]} {
                ui_error "${name} cannot be installed without the debug variant because PHP is installed with the debug variant."
                return -code error "incompatible variant selection"
            } elseif {[variant_isset debug] && !${php_debug_variant}} {
                ui_error "${name} cannot be installed with the debug variant because PHP is installed without the debug variant."
                return -code error "incompatible variant selection"
            }
            foreach dir ${php.build_dirs} {
                ui_debug "Generating configure script in [file tail ${dir}]"
                system "cd ${dir} && ${php.phpize}"
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
            xinstall -m 755 -d ${destroot}${php.inidir}
            if {"zend" == ${php.type}} {
                set extension_prefix "zend_extension=${php.extension_dir}/"
            } else {
                set extension_prefix "extension="
            }
            set fp [open ${destroot}${php.inidir}/${php.ini} w]
            puts $fp "; Do not edit this file; it is automatically generated by MacPorts."
            puts $fp "; Any changes you make will be lost if you upgrade or uninstall ${name}."
            puts $fp "; To configure PHP, edit ${php.php_ini}."
            foreach extension ${php.extensions} {
                puts $fp "${extension_prefix}${extension}.so"
            }
            close $fp
        }
        
        post-install {
            if {[file exists ${php.php_ini}]} {
                set count 0
                set fp [open ${php.php_ini} r]
                while {![eof $fp]} {
                    set line [gets $fp]
                    regexp {^extension_dir *= *"?([^\"]*)"?} $line -> phpiniextensiondir
                    if {[info exists phpiniextensiondir]} {
                        ui_debug "Found extension_dir ${phpiniextensiondir} in ${php.php_ini}"
                        if {${phpiniextensiondir} != ${php.extension_dir}} {
                            if {0 == ${count}} {
                                ui_msg "Your php.ini contains a line that will prevent ${name}"
                                ui_msg "and other PHP extensions from working. To fix this,"
                                ui_msg "edit ${php.php_ini} and delete this line:"
                                ui_msg ""
                            }
                            ui_msg ${line}
                            incr count
                        }
                        unset phpiniextensiondir
                    }
                }
                close $fp
            }
        }
    }
    
    if {"pecl" == ${source}} {
        set php.homepage        http://pecl.php.net/package/${php.rootname}/
        
        homepage                ${php.homepage}
        master_sites            http://pecl.php.net/get/
        extract.suffix          .tgz
        
        livecheck.type          regexm
        livecheck.url           ${php.homepage}
        livecheck.regex         {>([0-9.]+)</a></th>\s*<[^>]+>stable<}
    }
    
    if {${php.bundled}} {
        homepage                http://www.php.net/${php.rootname}
        
        pre-extract {
            foreach extension ${php.extensions} {
                extract.post_args-append ${worksrcdir}/ext/${extension}
            }
        }
        
        pre-configure {
            set php_version [exec ${php.config} --version 2>/dev/null]
            if {${version} != ${php_version}} {
                ui_error "${name} ${version} requires PHP ${version} but you have PHP ${php_version}."
                return -code error "incompatible PHP installation"
            }
        }
        
        destroot.target         install-modules install-headers
    }
}

proc php.build_dirs_proc {} {
    global php.extensions php.bundled worksrcpath
    if {${php.bundled}} {
        set dirs {}
        foreach extension ${php.extensions} {
            lappend dirs ${worksrcpath}/ext/${extension}
        }
        return ${dirs}
    }
    return ${worksrcpath}
}

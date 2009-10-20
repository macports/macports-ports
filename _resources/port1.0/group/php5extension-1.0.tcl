# $Id$
# 
# Copyright (c) 2009 The MacPorts Project
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
#   PortGroup               php5extension 1.0
#   php5extension.setup     extension version source
# 
# where extension is the name of the extension (e.g. APC), version is its
# version, and if the extension is hosted at PECL, source is "pecl"; otherwise
# don't use source.
# 
# If this is a Zend extension, use
# 
#   php5extension.type      zend


default build.dir                   {[php5extension.build_dir_proc]}
default build.target                {[php5extension.build_target_proc]}
default configure.args              {[php5extension.configure_args_proc]}
default configure.dir               {[php5extension.build_dir_proc]}
options php5extension.extension
options php5extension.extension_dir
default php5extension.extension_dir {[php5extension.extension_dir_proc]}
options php5extension.extract_dirs
default php5extension.extract_dirs  {ext/${php5extension.extension}}
options php5extension.ini
default php5extension.ini           {${php5extension.extension}.ini}
options php5extension.inidir
default php5extension.inidir        {${prefix}/var/db/php5}
options php5extension.type
default php5extension.type      php
options php5extension.source
default php5extension.source        standalone
options php5extension.use_phpize
default php5extension.use_phpize    yes

proc php5extension.setup {extension version {source ""}} {
    global php5extension.extension php5extension.ini php5extension.inidir php5extension.source
    global build.dir destroot prefix
    
    php5extension.extension     ${extension}
    php5extension.source        ${source}
    
    name                        php5-${php5extension.extension}
    version                     ${version}
    categories                  php
    distname                    ${php5extension.extension}-${version}
    
    depends_lib                 path:bin/phpize:php5
    
    pre-configure {
        if {"yes" == ${php5extension.use_phpize}} {
            system "cd ${configure.dir} && ${prefix}/bin/phpize"
        }
    }
    
    destroot.destdir            INSTALL_ROOT=${destroot}
    
    post-destroot {
        xinstall -m 755 -d ${destroot}${php5extension.inidir}
        set fp [open ${destroot}${php5extension.inidir}/${php5extension.ini} w]
        foreach extensionfile [glob -tails -directory ${destroot}${php5extension.extension_dir} *.so] {
            if {"zend" == ${php5extension.type}} {
                puts $fp "zend_extension=${php5extension.extension_dir}/${extensionfile}"
            } else {
                puts $fp "extension=${extensionfile}"
            }
        }
        close $fp
    }
    
    post-install {
        set phpini ${prefix}/etc/php5/php.ini
        if {[file exists ${phpini}]} {
            set count 0
            set fp [open ${phpini} r]
            while {![eof $fp]} {
                set line [gets $fp]
                regexp {^extension_dir *= *"?([^\"]*)"?} $line -> phpiniextensiondir
                if {[info exists phpiniextensiondir]} {
                    ui_debug "Found extension_dir ${phpiniextensiondir} in ${phpini}"
                    if {${phpiniextensiondir} != ${php5extension.extension_dir}} {
                        if {0 == ${count}} {
                            ui_msg "Your php.ini contains a line that will prevent ${name}"
                            ui_msg "and other PHP extensions from working. To fix this,"
                            ui_msg "edit ${phpini} and delete this line:"
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
    
    if {"pecl" == ${source}} {
        global php5extension.homepage
        set php5extension.homepage  http://pecl.php.net/package/${php5extension.extension}/
        
        homepage                    ${php5extension.homepage}
        master_sites                http://pecl.php.net/get/
        extract.suffix              .tgz
        
        livecheck.type              regexm
        livecheck.url               ${php5extension.homepage}
        livecheck.regex             {>([0-9.]+)</a></th>\s*<[^>]+>stable<}
    } elseif {"bundled" == ${source}} {
        homepage                    http://www.php.net/${php5extension.extension}
        master_sites                php
        
        dist_subdir                 php5
        distname                    php-${version}
        use_bzip2                   yes
        
        pre-extract {
            if {"yes" == ${php5extension.use_phpize}} {
                foreach extract_dir ${php5extension.extract_dirs} {
                    extract.post_args-append ${worksrcdir}/${extract_dir}
                }
            }
        }
        
        destroot {
            xinstall -d ${destroot}${php5extension.extension_dir}
            eval xinstall -m 644 [glob ${build.dir}/modules/*.so] ${destroot}${php5extension.extension_dir}
        }
        
        livecheck.type              regex
        livecheck.url               http://www.php.net/downloads.php
        livecheck.regex             get/php-(5\\.\[0-9.\]+)\\.tar
    }
}

proc php5extension.build_dir_proc {} {
    global php5extension.extension php5extension.source php5extension.use_phpize worksrcpath
    if {"bundled" == ${php5extension.source}} {
        if {"yes" == ${php5extension.use_phpize}} {
            return ${worksrcpath}/ext/${php5extension.extension}
        }
    }
    return ${worksrcpath}
}

proc php5extension.build_target_proc {} {
    global php5extension.source php5extension.use_phpize
    if {"bundled" == ${php5extension.source}} {
        if {"yes" != ${php5extension.use_phpize}} {
            return build-modules
        }
    }
    return all
}

proc php5extension.configure_args_proc {} {
    global php5extension.source php5extension.use_phpize
    if {"bundled" == ${php5extension.source}} {
        if {"yes" != ${php5extension.use_phpize}} {
            return {
                --disable-all
                --disable-cgi
                --without-pear
            }
        }
    }
    return {}
}

proc php5extension.extension_dir_proc {} {
    global prefix
    return [exec ${prefix}/bin/php-config --extension-dir]
}

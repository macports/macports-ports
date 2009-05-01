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


options php5extension.type
default php5extension.type      php

proc php5extension.setup {extension version {source ""}} {
    global php5extension.extension php5extension.ini php5extension.inidir
    global destroot prefix workpath worksrcpath
    
    set php5extension.extension ${extension}
    set php5extension.ini       ${extension}.ini
    set php5extension.inidir    ${prefix}/var/db/php5
    
    name                        php5-${php5extension.extension}
    version                     ${version}
    categories                  php
    distname                    ${php5extension.extension}-${version}
    
    depends_lib                 path:bin/phpize:php5
    
    pre-configure {
        system "cd ${worksrcpath} && ${prefix}/bin/phpize"
    }
    
    destroot.destdir            INSTALL_ROOT=${destroot}
    
    post-build {
        set fp [open ${workpath}/${php5extension.ini} w]
        if {"zend" == ${php5extension.type}} {
            puts $fp "zend_extension=[exec ${prefix}/bin/php-config --extension-dir]/${php5extension.extension}.so"
        } else {
            puts $fp "extension=${php5extension.extension}.so"
        }
        close $fp
    }
    
    post-destroot {
        xinstall -m 755 -d ${destroot}${php5extension.inidir}
        xinstall -m 644 ${workpath}/${php5extension.ini} ${destroot}${php5extension.inidir}
    }
    
    if {"pecl" == ${source}} {
        global php5extension.homepage
        set php5extension.homepage  http://pecl.php.net/package/${php5extension.extension}/
        
        homepage                    ${php5extension.homepage}
        master_sites                http://pecl.php.net/get/
        extract.suffix              .tgz
        
        livecheck.check             regex
        livecheck.url               ${php5extension.homepage}
        livecheck.regex             >(\[0-9.\]+)<
    }
}

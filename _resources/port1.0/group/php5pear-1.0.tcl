# $Id: php5pear-1.0.tcl 76571 2011-02-28 15:42:47Z pixilla@macports.org $
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
# This PortGroup automatically sets up the standard environment for installing
# a PHP PEAR classes.
# 
# Usage:
# 
#   PortGroup           php5pear 1.0
#   php5pear.setup      package version channel
# 
# where package is the name of the PEAR package (e.g. AUTH), version is its
# version, and channel is the channel hosting the package (default: pear.php.net).
# 

options php5pear.package
options php5pear.channel
options php5pear.bin-pre
options php5pear.bin
options php5pear.bin-post
options php5pear.cmd
options php5pear.destroot

proc php5pear.setup {php5pear.package version {php5pear.channel "pear.php.net"}} {
    global worksrcpath distname extract.suffix master_sites prefix
    global php5pear.bin-pre php5pear.bin php5pear.bin-post php5pear.cmd

    php5pear.package    ${php5pear.package}
    php5pear.channel    ${php5pear.channel}
    name                pear-${php5pear.package}
    version             ${version}
    categories          php
    distname            ${php5pear.package}-${version}
    extract.suffix      .tgz
    homepage            http://${php5pear.channel}/package/${php5pear.package}
    master_sites        http://${php5pear.channel}/get
    livecheck.type      regex
    livecheck.url       http://${php5pear.channel}/package/${php5pear.package}/download
    livecheck.regex     "http://download.${php5pear.channel}/package/${php5pear.package}-((?!\.tgz).*)${extract.suffix}"

    supported_archs     noarch
    use_parallel_build  yes
    depends_lib         path:bin/phpize:php5 port:php5-pear

    php5pear.destroot   ${worksrcpath}/packagingroot    
    php5pear.bin-pre    TZ=UTC
    php5pear.bin        ${prefix}/libexec/php/bin/pear
    php5pear.bin-post   -C ${prefix}/libexec/php/etc/pear.conf \
                        -c ${prefix}/libexec/php/etc/pear.conf

    extract.mkdir       yes
    extract {
        copy ${distpath}/${distname}${extract.suffix} ${worksrcpath}
    }

    configure {
        set fp [open "${prefix}/libexec/php/etc/pear.conf" r]
        set ccount [regexp -all "${php5pear.channel}" [read $fp]]
        close $fp
        if { ! $ccount && "${php5pear.channel}" != "pear.php.net" } {
            system "curl -s http://${php5pear.channel}/channel.xml -o ${worksrcpath}/channel.xml"
            system "${php5pear.bin-pre} ${php5pear.bin} ${php5pear.bin-post} channel-add ${worksrcpath}/channel.xml"
        } else {
            system "${php5pear.bin-pre} ${php5pear.bin} ${php5pear.bin-post} channel-update ${php5pear.channel}"
        }
    }
    
    build {
        system "${php5pear.bin-pre} ${php5pear.bin} ${php5pear.bin-post} config-show"
        system "cd ${worksrcpath} && ${php5pear.bin-pre} ${php5pear.bin} ${php5pear.bin-post} install --nodeps --offline --ignore-errors --packagingroot=${php5pear.destroot} ${distname}${extract.suffix}"
    }
    
    destroot {
        xinstall -d ${destroot}${prefix}/lib/php/pear
        foreach path [glob -nocomplain -directory ${php5pear.destroot}${prefix}/libexec/php/pear *] {
            copy ${path} ${destroot}${prefix}/lib/php/pear
        }
        if { [file exists "${destroot}${prefix}/lib/php/pear/generate_package_xml.php"] } {
            file rename "${destroot}${prefix}/lib/php/pear/generate_package_xml.php" "${destroot}${prefix}/lib/php/pear/conflict-${php5pear.package}-generate_package_xml.php"
        }
        if { [file exists "${destroot}${prefix}/lib/php/pear/package.php"] } {
            file rename "${destroot}${prefix}/lib/php/pear/package.php" "${destroot}${prefix}/lib/php/pear/conflict-${php5pear.package}-package.php"
        }
    }
}

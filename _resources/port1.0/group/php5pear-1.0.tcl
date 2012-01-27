# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# $Id$
# 
# Copyright (c) 2011 The MacPorts Project
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
# a PHP PEAR class.
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
options php5pear.cmd-pre
options php5pear.cmd-pear
options php5pear.cmd-phar
options php5pear.cmd-php
options php5pear.cmd-post
options php5pear.cmd
options php5pear.destroot
options php5pear.sourceroot
options php5pear.instpath
options php5pear.pearpath
options php5pear.installer
options php5pear.packagexml

proc php5pear.setup {php5pear.package version {php5pear.channel "pear.php.net"} {php5pear.packagexml "package.xml"}} {
    global worksrcpath distname extract.suffix master_sites prefix destroot distpath
    global php5pear.cmd-pre php5pear.cmd-pear php5pear.cmd-phar php5pear.cmd-php php5pear.cmd-post
    global php5pear.cmd php5pear.instpath php5pear.pearpath
    global php5pear.installer name php5pear.sourceroot
    
    # The pear name for the package.
    php5pear.package    ${php5pear.package}
    # The pear channel for the package.
    php5pear.channel    ${php5pear.channel}
    # The name of the package's xml file used by pear to build the package.
    # Note: so far the two known names are package.xml and package2.xml.
    php5pear.packagexml ${php5pear.packagexml}
    
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
    
    dist_subdir         pear
    supported_archs     noarch
    use_parallel_build  yes
    depends_lib         path:bin/phpize:php5 port:php5-pear
    
    # List of ports that pear-PEAR depends on.
    if {
        ${name} != "pear-Archive_Tar" &&
        ${name} != "pear-Console_Getopt" &&
        ${name} != "pear-Structures_Graph" &&
        ${name} != "pear-XML_Util" &&
        ${name} != "pear-PEAR"
    } {
        depends_lib-append    port:pear-PEAR
    }
    
    # Where the pear installer is installed for each port.
    php5pear.installer  ${worksrcpath}/installer
    # The base paths for our pear.conf.
    php5pear.instpath   ${prefix}/lib/php
    php5pear.pearpath   ${php5pear.instpath}/pear
    # Where we expand our source files.
    php5pear.sourceroot ${worksrcpath}/packagesource    
    # Where we instruct pear to install our package.
    php5pear.destroot   ${worksrcpath}/packagingroot    
    
    # The pear command we will use.
    php5pear.cmd-pear   ${php5pear.installer}/bin/pear
    # The phar file that contains our pear installer.
    php5pear.cmd-phar   ${prefix}/lib/php/pear/install-pear-nozlib.phar
    # The php binary we will use.
    php5pear.cmd-php    ${prefix}/bin/php
    # Args placed before the php or pear commands.
    php5pear.cmd-pre \
        cd ${php5pear.sourceroot} && \
        TZ=UTC \
        HOME=${php5pear.installer} \
        PHP_PEAR_INSTALL_DIR=${php5pear.installer}/pear \
        PHP_PEAR_BIN_DIR=${php5pear.installer}/bin \
        PHP_PEAR_PHP_BIN=${php5pear.cmd-php} \
        PHP_PEAR_CFG_DIR=${php5pear.installer}/pear/cfg \
        PHP_PEAR_DOC_DIR=${php5pear.installer}/pear/docs \
        PHP_PEAR_DATA_DIR=${php5pear.installer}/pear/data \
        PHP_PEAR_WWW_DIR=${php5pear.installer}/pear/www \
        PHP_PEAR_TEST_DIR=${php5pear.installer}/pear/tests \
        PHP_PEAR_SYSCONF_DIR=${php5pear.installer}
    # Args placed after php or pear commands.
    php5pear.cmd-post \
        -c ${php5pear.installer}/pear.conf \
        -C ${php5pear.installer}/pear.conf
    
    extract.mkdir       yes
    extract.post_args   "| tar --strip-components 1 -x -f - -C '${php5pear.sourceroot}'"
    
    pre-extract {
        xinstall -d ${php5pear.sourceroot}
    }
    
    post-extract {
        # Get the name of our package xml file.
        php5pear.packagexml [lindex [exec tar -tzf ${distpath}/${distname}${extract.suffix} | grep package.*\.xml] 0]
        # The "--strip-components 1" causes the loss of our package file so we will extract it now.
        system "tar -z -x -v -f '${distpath}/${distname}${extract.suffix}' -C '${php5pear.sourceroot}' ${php5pear.packagexml}"
        # Install the pear command using the phar file.
        system "${php5pear.cmd-pre} ${php5pear.cmd-php} ${php5pear.cmd-phar}"
    }
    
    post-patch {
        # Some ports use a "." baseinstalldir which can cause issues creating pears packagingroot directory.
        reinplace "s|baseinstalldir=\"\.\"|baseinstalldir=\"/\"|g" \
          ${php5pear.sourceroot}/${php5pear.packagexml}
    }
    
    configure {
        # Set up pear's conf file.
        # The order appears to be important; we get errors if we set php_dir before adding channels
        # and the directory is not writable.
        xinstall -d "${php5pear.installer}/pear/php"
        system "${php5pear.cmd-pre} ${php5pear.cmd-pear} ${php5pear.cmd-post} config-set auto_discover 1"
        if { "${php5pear.channel}" != "pear.php.net" } {
            system "curl -s http://${php5pear.channel}/channel.xml -o ${worksrcpath}/channel.xml"
            system "${php5pear.cmd-pre} ${php5pear.cmd-pear} ${php5pear.cmd-post} channel-add ${worksrcpath}/channel.xml"
            system "${php5pear.cmd-pre} ${php5pear.cmd-pear} ${php5pear.cmd-post} config-set default_channel ${php5pear.channel}"
        }
        # Change the install directories to the final destinations
        system "${php5pear.cmd-pre} ${php5pear.cmd-pear} ${php5pear.cmd-post} config-set php_dir ${php5pear.pearpath}"
        system "${php5pear.cmd-pre} ${php5pear.cmd-pear} ${php5pear.cmd-post} config-set bin_dir ${php5pear.pearpath}/bin"
        system "${php5pear.cmd-pre} ${php5pear.cmd-pear} ${php5pear.cmd-post} config-set doc_dir ${php5pear.pearpath}/docs"
        system "${php5pear.cmd-pre} ${php5pear.cmd-pear} ${php5pear.cmd-post} config-set data_dir ${php5pear.pearpath}/data"
        system "${php5pear.cmd-pre} ${php5pear.cmd-pear} ${php5pear.cmd-post} config-set www_dir ${php5pear.pearpath}/www"
        system "${php5pear.cmd-pre} ${php5pear.cmd-pear} ${php5pear.cmd-post} config-set test_dir ${php5pear.pearpath}/tests"
        system "${php5pear.cmd-pre} ${php5pear.cmd-pear} ${php5pear.cmd-post} config-show"
    }
    
    build {
        # Get the name of our package xml file.
        php5pear.packagexml [lindex [exec tar -tzf ${distpath}/${distname}${extract.suffix} | grep package.*\.xml] 0]
        # Install our package into our pear's packagingroot.
        system "${php5pear.cmd-pre} ${php5pear.cmd-pear} ${php5pear.cmd-post} install -n -f -P '${php5pear.destroot}' ${php5pear.packagexml}"
    }
    
    destroot {
        copy ${php5pear.destroot}${php5pear.instpath} ${destroot}${prefix}/lib
        # Remove all invisible "dot" files.
        fs-traverse -ignoreErrors item "${destroot}${php5pear.instpath}" {
            if {[string first . [file tail ${item}] 0] == 0} {
                # Using system rm because I could not find a way to delete dot files with [file delete].
                system "rm -R ${item}"
            }
        }
        if { [file exists "${destroot}${php5pear.pearpath}/generate_package_xml.php"] } {
            # Some pear packages contain package creation files so we remove them.
            delete "${destroot}${php5pear.pearpath}/generate_package_xml.php"
        }
        if { [file exists "${destroot}${php5pear.pearpath}/package.php"] } {
            # Some pear packages contain package creation files so we remove them.
            delete "${destroot}${php5pear.pearpath}/package.php"
        }
    }
}

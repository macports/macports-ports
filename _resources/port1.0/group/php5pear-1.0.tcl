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

# Args placed before the php or pear commands.
options php5pear.env
default php5pear.env    {
    "TZ=UTC \
    HOME=${php5pear.installer} \
    PHP_PEAR_INSTALL_DIR=${php5pear.installer}/pear \
    PHP_PEAR_BIN_DIR=${php5pear.installer}/bin \
    PHP_PEAR_PHP_BIN=${php5pear.cmd-php} \
    PHP_PEAR_CFG_DIR=${php5pear.installer}/pear/cfg \
    PHP_PEAR_DOC_DIR=${php5pear.installer}/pear/docs \
    PHP_PEAR_DATA_DIR=${php5pear.installer}/pear/data \
    PHP_PEAR_WWW_DIR=${php5pear.installer}/pear/www \
    PHP_PEAR_TEST_DIR=${php5pear.installer}/pear/tests \
    PHP_PEAR_SYSCONF_DIR=${php5pear.installer}"
}

# Args placed after php or pear commands.
options php5pear.configure.pre_args
default php5pear.configure.pre_args   {
    "-c ${php5pear.installer}/pear.conf \
    -C ${php5pear.installer}/pear.conf"
}

# Where we instruct pear to install our package.
options php5pear.destroot
default php5pear.destroot       {${worksrcpath}/packagingroot}

# Where the pear installer is installed for each port.
options php5pear.installer
default php5pear.installer      {${worksrcpath}/installer}

# Where we expand our source files.
options php5pear.sourceroot
default php5pear.sourceroot     {${worksrcpath}/packagesource}

# The base paths for our pear.conf.
options php5pear.instpath
default php5pear.instpath       {${prefix}/lib/php}
options php5pear.pearpath
default php5pear.pearpath       {${php5pear.instpath}/pear}

# The pear command we will use.
options php5pear.cmd-pear
default php5pear.cmd-pear       {${php5pear.installer}/bin/pear}

# The phar file that contains our pear installer.
options php5pear.cmd-phar
default php5pear.cmd-phar       {${prefix}/lib/php/pear/install-pear-nozlib.phar}

# The php binary we will use.
options php5pear.cmd-php
default php5pear.cmd-php        {${prefix}/bin/php}

# The pear channel for our package.
options php5pear.channel

# The name of the package xml file inside the pear package archive.
options php5pear.packagexml
default php5pear.packagexml     {[lindex [exec tar -tzf ${php5pear.packagefile} | grep package.*\.xml] 0]}

# Package name.
options php5pear.package

# Package file.
options php5pear.packagefile
default php5pear.packagefile    {"${distpath}/[lindex $distfiles 0]"}

proc php5pear.setup {package_name package_version {package_channel "pear.php.net"}} {
    global name extract.suffix version
    global php5pear.env php5pear.cmd-pear php5pear.destroot php5pear.sourceroot
    global php5pear.channel php5pear.package php5pear.packagexml

    # The pear name for the package.
    php5pear.package        ${package_name}
    # The pear channel for the package.
    php5pear.channel        ${package_channel}

    name                    pear-${php5pear.package}
    version                 ${package_version}
    categories              php
    distname                ${php5pear.package}-${version}
    extract.suffix          .tgz
    homepage                http://${php5pear.channel}/package/${php5pear.package}
    master_sites            http://${php5pear.channel}/get
    dist_subdir             pear
    supported_archs         noarch
    use_parallel_build      yes
    depends_lib             path:bin/phpize:php5 port:php5-pear

    # List of ports that pear-PEAR depends on.
    # Add some pear-PEAR deps to make programmatic creation of pear Portfiles easier.
    if {
        ${name} != "pear-Archive_Tar" &&
        ${name} != "pear-Console_Getopt" &&
        ${name} != "pear-Structures_Graph" &&
        ${name} != "pear-XML_Util" &&
        ${name} != "pear-PEAR"
    } {
        depends_lib-append  port:pear-PEAR
    } elseif {
        ${name} == "pear-PEAR"
    } {
        depends_lib-append  port:pear-Archive_Tar \
                            port:pear-Console_Getopt \
                            port:pear-Structures_Graph \
                            port:pear-XML_Util

    }

    extract.post_args-append   -C '${php5pear.sourceroot}' --strip-components 1

    pre-extract {
        xinstall -d "${php5pear.sourceroot}"
    }

    post-extract {
        # The "--strip-components 1" causes the loss of our package file so we will extract it now.
        extract.post_args-delete    --strip-components 1
        extract.post_args-append    ${php5pear.packagexml}
        command_exec                extract
    }

    post-patch {
        # Some ports use a "." baseinstalldir which can cause issues creating pears packagingroot directory.
        reinplace "s|baseinstalldir=\"\.\"|baseinstalldir=\"/\"|g" \
          ${php5pear.sourceroot}/${php5pear.packagexml}
    }

    configure.env           ${php5pear.env}
    configure.dir           ${php5pear.sourceroot}
    configure {
        # Install the pear command using the phar file.
        configure.cmd           ${php5pear.cmd-php}
        configure.pre_args      ${php5pear.cmd-phar}
        command_exec configure
        configure.cmd           ${php5pear.cmd-pear}
        configure.pre_args      -c ${php5pear.installer}/pear.conf \
                                -C ${php5pear.installer}/pear.conf
        # Set up pear's conf file.
        # The order appears to be important; we get errors if we set php_dir before adding channels
        # and the directory is not writable.
        xinstall -d "${php5pear.installer}/pear/php"
        set pear_config [list]
        lappend pear_config         "config-set auto_discover 1"
        if { "${php5pear.channel}" != "pear.php.net" } {
            lappend pear_config         "channel-discover ${php5pear.channel}"
            lappend pear_config         "config-set default_channel ${php5pear.channel}"
        }
        # Change the install directories to the final destinations
        lappend pear_config         "config-set php_dir ${php5pear.pearpath}"
        lappend pear_config         "config-set bin_dir ${php5pear.pearpath}/bin"
        lappend pear_config         "config-set cfg_dir ${php5pear.pearpath}/cfg"
        lappend pear_config         "config-set doc_dir ${php5pear.pearpath}/docs"
        lappend pear_config         "config-set data_dir ${php5pear.pearpath}/data"
        lappend pear_config         "config-set www_dir ${php5pear.pearpath}/www"
        lappend pear_config         "config-set test_dir ${php5pear.pearpath}/tests"
        lappend pear_config         "config-show"
        foreach pear_args $pear_config {
            configure.args          "${pear_args}"
            command_exec configure
        }
    }

    build {
        build.env           ${php5pear.env}
        build.dir           ${php5pear.sourceroot}
        build.cmd           ${php5pear.cmd-pear}
        build.target        install
        build.args          "-n -f -P '${php5pear.destroot}' ${php5pear.packagexml}"
        command_exec build
    }

    destroot {
        copy ${php5pear.destroot}${php5pear.instpath} ${destroot}${prefix}/lib
        # Remove all invisible "dot" files.
        fs-traverse -ignoreErrors item "${destroot}${php5pear.instpath}" {
            if {[string first . [file tail ${item}] 0] == 0} {
                if {[file tail ${item}] != "." && [file tail ${item}] != ".."} {
                    puts "Removing dot file ${item}"
                    delete ${item}
                }
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

    livecheck.type          regex
    livecheck.url           http://${php5pear.channel}/package/${php5pear.package}/download
    livecheck.regex         http://download.${php5pear.channel}/package/
    livecheck.regex-append  "${php5pear.package}-((?!\\${extract.suffix}).*)\\${extract.suffix}"
}

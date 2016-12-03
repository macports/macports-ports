# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2011-2013 The MacPorts Project
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
#   PortGroup           pear 1.0
#   pear.setup      package version channel
#
# where package is the name of the PEAR package (e.g. AUTH), version is its
# version, and channel is the channel hosting the package (default: pear.php.net).
#

# Args placed before the php or pear commands.
options pear.env
default pear.env    {
    "TZ=UTC \
    HOME=${pear.installer} \
    PHP_PEAR_INSTALL_DIR=${pear.installer}/pear \
    PHP_PEAR_BIN_DIR=${pear.installer}/bin \
    PHP_PEAR_PHP_BIN=${pear.cmd-php} \
    PHP_PEAR_CFG_DIR=${pear.installer}/pear/cfg \
    PHP_PEAR_DOC_DIR=${pear.installer}/pear/docs \
    PHP_PEAR_DATA_DIR=${pear.installer}/pear/data \
    PHP_PEAR_WWW_DIR=${pear.installer}/pear/www \
    PHP_PEAR_TEST_DIR=${pear.installer}/pear/tests \
    PHP_PEAR_SYSCONF_DIR=${pear.installer}"
}

# Args placed after php or pear commands.
options pear.configure.pre_args
default pear.configure.pre_args   {
    "-c ${pear.installer}/pear.conf \
    -C ${pear.installer}/pear.conf"
}

# Where we instruct pear to install our package.
options pear.destroot
default pear.destroot       {${worksrcpath}/packagingroot}

# Where the pear installer is installed for each port.
options pear.installer
default pear.installer      {${worksrcpath}/installer}

# Where we expand our source files.
options pear.sourceroot
default pear.sourceroot     {${worksrcpath}/packagesource}

# The base paths for our pear.conf.
options pear.instpath
default pear.instpath       {${prefix}/lib/php}
options pear.pearpath
default pear.pearpath       {${pear.instpath}/pear}

# The pear command we will use.
options pear.cmd-pear
default pear.cmd-pear       {${pear.installer}/bin/pear}

# The phar file that contains our pear installer.
options pear.cmd-phar
default pear.cmd-phar       {${prefix}/lib/php/pear/install-pear-nozlib.phar}

# The php binary we will use.
options pear.cmd-php
default pear.cmd-php        {/usr/bin/php}

# The pear channel for our package.
options pear.channel

# The name of the package xml file inside the pear package archive.
options pear.packagexml
default pear.packagexml     {[lindex [exec tar -tzf ${pear.packagefile} | grep package.*\.xml] 0]}

# Package name.
options pear.package

# Package file.
options pear.packagefile
default pear.packagefile    {"${distpath}/[lindex $distfiles 0]"}

proc pear.setup {package_name package_version {package_channel "pear.php.net"}} {
    global name extract.suffix version
    global pear.env pear.cmd-pear pear.destroot pear.sourceroot
    global pear.channel pear.package pear.packagexml

    # The pear name for the package.
    pear.package        ${package_name}
    # The pear channel for the package.
    pear.channel        ${package_channel}

    name                    pear-${pear.package}
    version                 ${package_version}
    categories              php
    distname                ${pear.package}-${version}
    extract.suffix          .tgz
    homepage                http://${pear.channel}/package/${pear.package}
    master_sites            http://${pear.channel}/get
    dist_subdir             pear
    supported_archs         noarch
    use_parallel_build      yes
    depends_build           port:pear-install-phar

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

    fetch.ignore_sslcert yes

    extract.post_args-append   -C '${pear.sourceroot}' --strip-components 1

    pre-extract {
        xinstall -d "${pear.sourceroot}"
    }

    post-extract {
        # The "--strip-components 1" causes the loss of our package file so we will extract it now.
        extract.post_args-delete    --strip-components 1
        extract.post_args-append    ${pear.packagexml}
        command_exec                extract
    }

    post-patch {
        # Some ports use a "." baseinstalldir which can cause issues creating pear's packagingroot directory.
        reinplace -locale C "s|baseinstalldir=\"\.\"|baseinstalldir=\"/\"|g" \
            ${pear.sourceroot}/${pear.packagexml}
    }

    configure.env           ${pear.env}
    configure.dir           ${pear.sourceroot}
    configure {
        # Install the pear command using the phar file.
        configure.cmd           ${pear.cmd-php}
        configure.pre_args      ${pear.cmd-phar}
        command_exec configure
        configure.cmd           ${pear.cmd-pear}
        configure.pre_args      -c ${pear.installer}/pear.conf \
                                -C ${pear.installer}/pear.conf
        # Set up pear's conf file.
        # The order appears to be important; we get errors if we set php_dir before adding channels
        # and the directory is not writable.
        xinstall -d "${pear.installer}/pear/php"
        set pear_config [list]
        lappend pear_config         "config-set auto_discover 1"
        if { "${pear.channel}" != "pear.php.net" } {
            lappend pear_config         "channel-discover ${pear.channel}"
            lappend pear_config         "config-set default_channel ${pear.channel}"
        }
        # Change the install directories to the final destinations
        lappend pear_config         "config-set php_dir ${pear.pearpath}"
        lappend pear_config         "config-set bin_dir ${pear.pearpath}/bin"
        lappend pear_config         "config-set cfg_dir ${pear.pearpath}/cfg"
        lappend pear_config         "config-set doc_dir ${pear.pearpath}/docs"
        lappend pear_config         "config-set data_dir ${pear.pearpath}/data"
        lappend pear_config         "config-set www_dir ${pear.pearpath}/www"
        lappend pear_config         "config-set test_dir ${pear.pearpath}/tests"
        lappend pear_config         "config-show"
        foreach pear_args $pear_config {
            configure.args          "${pear_args}"
            command_exec configure
        }
    }

    build {
        build.env           ${pear.env}
        build.dir           ${pear.sourceroot}
        build.cmd           ${pear.cmd-pear}
        build.target        install
        build.args          "-n -f -P '${pear.destroot}' ${pear.packagexml}"
        command_exec build
    }

    destroot {
        copy ${pear.destroot}${pear.instpath} ${destroot}${prefix}/lib
        # Remove all invisible "dot" files.
        fs-traverse -ignoreErrors item "${destroot}${pear.instpath}" {
            if {[string first . [file tail ${item}] 0] == 0} {
                if {[file tail ${item}] != "." && [file tail ${item}] != ".."} {
                    puts "Removing dot file ${item}"
                    delete ${item}
                }
            }
        }
        if { [file exists "${destroot}${pear.pearpath}/generate_package_xml.php"] } {
            # Some pear packages contain package creation files so we remove them.
            delete "${destroot}${pear.pearpath}/generate_package_xml.php"
        }
        if { [file exists "${destroot}${pear.pearpath}/package.php"] } {
            # Some pear packages contain package creation files so we remove them.
            delete "${destroot}${pear.pearpath}/package.php"
        }
    }

    livecheck.type          regex
    livecheck.url           http://${pear.channel}/package/${pear.package}/download
    livecheck.regex         http://download.${pear.channel}/package/${pear.package}-(.*?)${extract.suffix}
}

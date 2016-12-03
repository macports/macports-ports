# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

#
# values to be used in eg configuration files
#
options apache2.prefix
default apache2.prefix          {"${prefix}"}
options apache2.exec_prefix
default apache2.exec_prefix     {"${apache2.prefix}"}
options apache2.name
default apache2.name            {"${name}"}
options apache2.exec_name
default apache2.exec_name       {"httpd"}
options apache2.bindir
default apache2.bindir          {"${apache2.exec_prefix}/bin"}
options apache2.sbindir
default apache2.sbindir         {"${apache2.exec_prefix}/sbin"}
options apache2.libdir
default apache2.libdir          {"${apache2.exec_prefix}/lib/${apache2.name}"}
options apache2.libexecdir
default apache2.libexecdir      {"${apache2.libdir}/modules"}
options apache2.mandir
default apache2.mandir          {"${apache2.prefix}/share/${apache2.name}/man"}
options apache2.docdir
default apache2.docdir          {"${apache2.prefix}/share/doc/${apache2.name}"}
options apache2.sysconfdir
default apache2.sysconfdir      {"${apache2.prefix}/etc/${apache2.name}"}
options apache2.datadir
default apache2.datadir         {"${apache2.prefix}/www/${apache2.name}"}
options apache2.installbuilddir
default apache2.installbuilddir {"${apache2.datadir}/build"}
options apache2.errordir
default apache2.errordir        {"${apache2.datadir}/error"}
options apache2.iconsdir
default apache2.iconsdir        {"${apache2.datadir}/icons"}
options apache2.htdocsdir
default apache2.htdocsdir       {"${apache2.datadir}/html"}
options apache2.manualdir
default apache2.manualdir       {"${apache2.datadir}/manual"}
options apache2.cgidir
default apache2.cgidir          {"${apache2.datadir}/cgi-bin"}
options apache2.includedir
default apache2.includedir      {"${apache2.prefix}/include/${apache2.name}"}
options apache2.localstatedir
default apache2.localstatedir   {"${apache2.prefix}/var"}
options apache2.runtimedir
default apache2.runtimedir      {"${apache2.localstatedir}/run/${apache2.name}"}
options apache2.logfiledir
default apache2.logfiledir      {"${apache2.localstatedir}/log/${apache2.name}"}
options apache2.proxycachedir
default apache2.proxycachedir   {"${apache2.localstatedir}/tmp/${apache2.name}"}

options apache2.user
default apache2.user            {"_www"}
options apache2.group
default apache2.group           {"_www"}

# General settings
options apache2.listen_ports
default apache2.listen_ports    {{80 443}}
options apache2.contact
default apache2.contact         {"ops@example.com"}
options apache2.timeout
default apache2.timeout         {300}
options apache2.keepalive
default apache2.keepalive       {"On"}
options apache2.keepaliverequests
default apache2.keepaliverequests   {100}
options apache2.keepalivetimeout
default apache2.keepalivetimeout    {5}

# Security
options apache2.servertokens
default apache2.servertokens    {"Prod"}
options apache2.serversignature
default apache2.serversignature {"On"}
options apache2.traceenable
default apache2.traceenable     {"On"}

# mod_auth_openids
options apache2.allowed_openids
default apache2.allowed_openids {""}

# Prefork Attributes
options apache2.prefork.startservers
default apache2.prefork.startservers    {16}
options apache2.prefork.minspareservers
default apache2.prefork.minspareservers {16}
options apache2.prefork.maxspareservers
default apache2.prefork.maxspareservers {32}
options apache2.prefork.serverlimit
default apache2.prefork.serverlimit     {400}
options apache2.prefork.maxclients
default apache2.prefork.maxclients      {400}
options apache2.prefork.threadsperchild
default apache2.prefork.threadsperchild {10000}

# Worker Attributes
options apache2.worker.startservers
default apache2.worker.startservers    {4}
options apache2.worker.maxclients
default apache2.worker.maxclients      {1024}
options apache2.worker.minsparethreads
default apache2.worker.minsparethreads {64}
options apache2.worker.maxsparethreads
default apache2.worker.maxsparethreads {192}
options apache2.worker.threadsperchild
default apache2.worker.threadsperchild {64}

# Default modules to enable via include_recipe

set apache_default_modules(enmod)   {}
set apache_default_modules(dismod)  {}

#
# mimics installation via apxs, but under Debian/Ubuntu layout
# which renders apxs useless for activating modules
# has been made simpler as we always starts with a clean slate
#
# expanded functionality compared to apxs:
#   ++ optionally installs dylibs
#
proc apxsInstall { moduleName activate dylibs } {
    global apache2 destroot prefix

    xinstall -m 0755 -d -W ${destroot}${apache2.sysconfdir} \
    mods-available  mods-enabled

    # strip pre-/suffix from moduleName
    set moduleName [regsub {_module} ${moduleName} "" ]
    set moduleName [regsub {mod_}    ${moduleName} "" ]

    set  loadFileName   ${apache2.sysconfdir}/mods-available/${moduleName}.load
    set  loadFile       [open ${loadFileName} w 644]

    foreach libName ${dylibs}  {
        set  dylibFile   [ exec find ${prefix}/lib -type f -iname "lib${libName}*.dylib" ]
        puts ${loadFile} "LoadFile ${dylibFile}"
    }

    puts  ${loadFile} "LoadModule ${moduleName}_module ${apache2.libexecdir}/mod_${moduleName}.so"

    close ${loadFile}

    if { ${activate} == "yes" } {
        exec "${apache2.sbindir}/a2enmod" ${moduleName}
    }
}

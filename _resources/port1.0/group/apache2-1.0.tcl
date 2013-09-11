




#
# values to be used in eg configuration files
#
options apache.prefix
default apache.prefix           {"${prefix}"}
options apache.exec_prefix
default apache.exec_prefix      {"${apache.prefix}"}
options apache.name
default apache.name             {"${name}"}
options apache.exec_name
default apache.exec_name        {"httpd"}
options apache.bindir
default apache.bindir           {"${apache.exec_prefix}/bin"}
options apache.sbindir
default apache.sbindir          {"${apache.exec_prefix}/sbin"}
options apache.libdir
default apache.libdir           {"${apache.exec_prefix}/lib/${apache.name}"}
options apache.libexecdir
default apache.libexecdir       {"${apache.libdir}/modules"}
options apache.mandir
default apache.mandir           {"${apache.prefix}/share/${apache.name}/man"}
options apache.sysconfdir
default apache.sysconfdir       {"${apache.prefix}/etc/${apache.name}"}
options apache.datadir
default apache.datadir          {"${apache.prefix}/www/${apache.name}"}
options apache.installbuilddir
default apache.installbuilddir  {"${apache.datadir}/build"}
options apache.errordir
default apache.errordir         {"${apache.datadir}/error"}
options apache.iconsdir
default apache.iconsdir         {"${apache.datadir}/icons"}
options apache.htdocsdir
default apache.htdocsdir        {"${apache.datadir}/html"}
options apache.manualdir
default apache.manualdir        {"${apache.datadir}/manual"}
options apache.cgidir
default apache.cgidir           {"${apache.datadir}/cgi-bin"}
options apache.includedir
default apache.includedir       {"${apache.prefix}/include/${apache.name}"}
options apache.localstatedir
default apache.localstatedir    {"${apache.prefix}/var"}
options apache.runtimedir
default apache.runtimedir       {"${apache.localstatedir}/run/${apache.name}"}
options apache.logfiledir
default apache.logfiledir       {"${apache.localstatedir}/log/${apache.name}"}
options apache.proxycachedir
default apache.proxycachedir    {"${apache.localstatedir}/tmp/${apache.name}"}

options apache.user
default apache.user             {"_www"}
options apache.group
default apache.group            {"_www"}

# General settings
options apache.listen_ports
default apache.listen_ports     {{80 443}}
options apache.contact
default apache.contact          {"ops@example.com"}
options apache.timeout
default apache.timeout          {300}
options apache.keepalive
default apache.keepalive        {"On"}
set apache(keepaliverequests)   100
options apache.keepalivetimeout
default apache.keepalivetimeout {5}

# Security
options apache.servertokens
default apache.servertokens     {"Prod"}
options apache.serversignature
default apache.serversignature  {"On"}
options apache.traceenable
default apache.traceenable      {"On"}

# mod_auth_openids
options apache.allowed_openids
default apache.allowed_openids  {""}

# Prefork Attributes
options apache.prefork.startservers
default apache.prefork.startservers     {16}
options apache.prefork.minspareservers
default apache.prefork.minspareservers  {16}
options apache.prefork.maxspareservers
default apache.prefork.maxspareservers  {32}
options apache.prefork.serverlimit
default apache.prefork.serverlimit      {400}
options apache.prefork.maxclients
default apache.prefork.maxclients       {400}
options apache.prefork.threadsperchild
default apache.prefork.threadsperchild  {10000}

# Worker Attributes
options apache.worker.startservers
default apache.worker.startservers     {4}
options apache.worker.maxclients
default apache.worker.maxclients       {1024}
options apache.worker.minsparethreads
default apache.worker.minsparethreads  {64}
options apache.worker.maxsparethreads
default apache.worker.maxsparethreads  {192}
options apache.worker.threadsperchild
default apache.worker.threadsperchild  {64}

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
    global apache destroot prefix

    xinstall -m 0755 -d -W ${destroot}${apache.sysconfdir} \
        mods-available  mods-enabled

    # strip pre-/suffix from moduleName
    set moduleName [regsub {_module} ${moduleName} "" ]
    set moduleName [regsub {mod_}    ${moduleName} "" ]

    set  loadFileName   ${apache.sysconfdir}/mods-available/${moduleName}.load
    set  loadFile       [open ${loadFileName} w 644]

    foreach libName ${dylibs}  {
        set  dylibFile   [ exec find ${prefix}/lib -type f -iname "lib${libName}*.dylib" ]
        puts ${loadFile} "LoadFile ${dylibFile}"
    }

    puts  ${loadFile} "LoadModule ${moduleName}_module ${apache.libexecdir}/mod_${moduleName}.so"

    close ${loadFile}

    if { ${activate} == "yes" } {
            exec "${apache.sbindir}/a2enmod" ${moduleName}
    }

}

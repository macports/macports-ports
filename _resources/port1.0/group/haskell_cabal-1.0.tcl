# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup         haskell_cabal 1.0
#
# This PortGroup configures the build to use the Haskell Cabal tool. It
# modifies the defaults for a number of variables, so your Portfile should take
# care not to accidentally overwrite them.
#
# The PortGroup will automatically add the required build dependencies for
# port:cabal.
#
# The configure, build, destroot and test phases are set up (although the test
# phase is not enabled automatically). A default livecheck is configured to
# hackage.haskell.org using ${name}.
#
# This PortGroup offers the following options:
#
# haskell_cabal.bin
#   The cabal binary. Defaults to ${prefix}/bin/cabal.
#
# haskell_cabal.cabal_root
#   The root path for cabal. Defaults to ${workpath}/.home/.cabal .

proc haskell_cabal.add_dependencies {} {
    global name haskell_cabal.use_prebuilt
    if {[tbool haskell_cabal.use_prebuilt]} {
        depends_patch-append \
            port:cabal-prebuilt \
            port:ghc-prebuilt
        depends_build-append \
            port:cabal-prebuilt \
            port:ghc-prebuilt
    } else {
        depends_patch-append \
            port:cabal
        depends_build-append \
            port:cabal \
            port:ghc
        depends_lib-append \
            port:gmp \
            port:libiconv
    }
    depends_build-append \
        port:gsed
}
port::register_callback haskell_cabal.add_dependencies

proc haskell_cabal.getcabalbin {} {
    global prefix haskell_cabal.use_prebuilt
    if {[tbool haskell_cabal.use_prebuilt]} {
        return ${prefix}/bin/cabal-prebuilt
    } else {
        return ${prefix}/bin/cabal
    }
}

proc haskell_cabal.build_getjobsarg {args} {
    global build.jobs use_parallel_build
    if {![exists build.jobs] || ![tbool use_parallel_build]} {
        return ""
    }
    
    set jobs [option build.jobs]
    if {![string is integer -strict $jobs] || $jobs < 1} {
        return ""
    }
    return "-j$jobs"
}

proc haskell_cabal.get_env {} {
    global haskell_cabal.cabal_root haskell_cabal.use_prebuilt
    set myenv [list CABAL_CONFIG=${haskell_cabal.cabal_root}/config]
    if {[tbool haskell_cabal.use_prebuilt]} {
        lappend myenv \
                    GHC=${haskell_cabal.cabal_root}/bin/ghc \
                    PATH=${haskell_cabal.cabal_root}/bin:$::env(PATH)
    }
    return $myenv
}

options haskell_cabal.cabal_root
default haskell_cabal.cabal_root {${workpath}/.home/.cabal}

post-patch {
    xinstall -m 0755 -d [option haskell_cabal.cabal_root]
    set cabal_config_fd [open ${haskell_cabal.cabal_root}/config w+]
    set cabal_versions [regexp -all -inline {[0-9.]+} [exec ${haskell_cabal.bin} --version]]
    set cabal_install_version [lindex ${cabal_versions} 0]
    set cabal_library_version [lindex ${cabal_versions} end]
    foreach line [list \
                    "-- This is the configuration file for the 'cabal' command line tool." \
                    "--" \
                    "-- The available configuration options are listed below." \
                    "-- Some of them have default values listed." \
                    "--" \
                    "-- Lines (like this one) beginning with '--' are comments." \
                    "-- Be careful with spaces and indentation because they are" \
                    "-- used to indicate layout for nested sections." \
                    "--" \
                    "-- This config file was generated using the following versions" \
                    "-- of Cabal and cabal-install:" \
                    "-- Cabal library version: ${cabal_library_version}" \
                    "-- cabal-install version: ${cabal_install_version}" \
                    "" \
                    "" \
                    "-- cabal default configuration settings (MacPorts modified):" \
                    "repository hackage.haskell.org" \
                    "  url: https://hackage.haskell.org/" \
                    "  secure: True" \
                    "" \
                    "remote-repo-cache: ${haskell_cabal.cabal_root}/packages" \
                    "world-file: ${haskell_cabal.cabal_root}/world" \
                    "extra-prog-path: ${haskell_cabal.cabal_root}/bin" \
                    "build-summary: ${haskell_cabal.cabal_root}/logs/build.log" \
                    "remote-build-reporting: none" \
                    "jobs: \$ncpus" \
                    "documentation: True" \
                    "doc-index-file: \$htmldir/html/${subport}/index.html" \
                    "relocatable: True" \
                    "install-method: copy" \
                    "installdir: ${prefix}/bin" \
                    "logs-dir: [option haskell_cabal.cabal_root]/logs" \
                    "store-dir: [option haskell_cabal.cabal_root]/store" \
                    "" \
                    "install-dirs global" \
                    "  prefix: ${prefix}" \
                    "  bindir: ${prefix}/bin" \
                    "  libdir: ${prefix}/lib" \
                    "  libsubdir: ${subport}" \
                    "  dynlibdir: ${prefix}/lib" \
                    "  libexecdir: ${prefix}/libexec" \
                    "  libexecsubdir: ${subport}" \
                    "  datadir: ${prefix}/share/${subport}" \
                    "  docdir: ${prefix}/share/doc/${subport}" \
                    "  htmldir: ${prefix}/share/doc/${subport}" \
                    "  haddockdir: \$htmldir" \
                    "  sysconfdir: ${prefix}/etc/${subport}" \
                    "" \
                    "program-locations" \
                    "  gcc-location: ${configure.cc}" \
                    ] {
        puts ${cabal_config_fd} ${line}
    }
    close ${cabal_config_fd}
}

# cabal builds arm64 and x86_64 binaries
supported_archs     arm64 x86_64

options haskell_cabal.bin \
        haskell_cabal.env \
        haskell_cabal.global_flags \
        haskell_cabal.build_dir \
        haskell_cabal.use_prebuilt \
        haskell_cabal.datadir

default haskell_cabal.bin {[haskell_cabal.getcabalbin]}

default haskell_cabal.env \
        {[haskell_cabal.get_env]}

default haskell_cabal.global_flags \
        {--config-file=[option haskell_cabal.cabal_root]/config}

default haskell_cabal.build_dir     {${workpath}/dist}

# use to install prebuilt binaries for bootstrapping
default haskell_cabal.use_prebuilt  {no}

default haskell_cabal.datadir       {share/${subport}}

post-patch {
    if {[tbool haskell_cabal.use_prebuilt]} {
        xinstall -d ${haskell_cabal.cabal_root}/bin
        # bootstrap from *-prebuilt
        # the link to exedir_prebuilt got ghc and ghc-pkg is a hac
        # to accommodate cabal's hack method of locating ghc-pkg
        # https://github.com/haskell/cabal/blob/master/release-notes/Cabal-3.6.1.0.md
        set ghc_prebuilt_version \
                    [lindex [regexp -all -inline {[0-9.]+} [exec ${prefix}/bin/ghc-prebuilt --version]] 0]

        set exedir_prebuilt ${prefix}/lib/ghc-${ghc_prebuilt_version}-prebuilt/bin
        ln -s       ${exedir_prebuilt}/ghc-${ghc_prebuilt_version} \
                    ${haskell_cabal.cabal_root}/bin/ghc
        ln -s       ${exedir_prebuilt}/ghc-pkg-${ghc_prebuilt_version} \
                    ${haskell_cabal.cabal_root}/bin/ghc-pkg
        # provides symlinks to ${prefix}/bin/*-prebuilt for the rest
        foreach f {\
             cabal\
             ghci\
             haddock\
             hp2ps\
             hpc\
             hsc2hs\
             runghc\
             runhaskell\
             } {
             ln -s  ${prefix}/bin/${f}-prebuilt \
                    ${haskell_cabal.cabal_root}/bin/${f}
        }
    }
}

pre-configure {
    system -W ${worksrcpath} \
        "env ${haskell_cabal.env} ${haskell_cabal.bin} ${haskell_cabal.global_flags} update"
}

default configure.cmd       {${haskell_cabal.bin}\
                                ${haskell_cabal.global_flags}}
default configure.pre_args  {}
default configure.args      {configure}
default configure.env       {${haskell_cabal.env}}

default build.type          {cabal}
default build.cmd           {${haskell_cabal.bin}\
                                ${haskell_cabal.global_flags}}
default build.target        {${subport}}
default build.pre_args      {build}
default build.args          {${build.target}}
default build.post_args     {\
                                [haskell_cabal.build_getjobsarg]\
                                --builddir=${haskell_cabal.build_dir}\
                                --prefix=${prefix}\
                                --enable-relocatable\
                            }
default build.env           {${haskell_cabal.env}}

default destroot.cmd        {${haskell_cabal.bin}\
                                ${haskell_cabal.global_flags}}
default destroot.target     {${build.target}}
default destroot.pre_args   {install}
default destroot.args       {${destroot.target}}
default destroot.post_args  {\
                                [haskell_cabal.build_getjobsarg]\
                                --builddir=${haskell_cabal.build_dir}\
                                --installdir=${destroot}${prefix}/bin\
                                --enable-relocatable\
                            }
default destroot.env        {${haskell_cabal.env}}

default test.cmd            {${haskell_cabal.bin}\
                                ${haskell_cabal.global_flags}}
default test.target         {${build.target}}
default test.pre_args       {test}
default test.args           {${test.target}}
default test.post_args      {\
                                [haskell_cabal.build_getjobsarg]\
                                --builddir=${haskell_cabal.build_dir}\
                            }
default test.env            {${haskell_cabal.env}}

default livecheck.type      {regex}
default livecheck.url       {https://hackage.haskell.org/package/${name}}
default livecheck.regex     {"/package/[quotemeta ${name}]-\\\[^/\\\]+/[quotemeta ${name}]-(\\\[^\\\"\\\]+)[quotemeta ${extract.suffix}]"}


# binary sed hack to address unfixed cabal datadir issue:
# replace hardwired datadir in build directory with path
# of the same length using repeated /'s
# https://github.com/haskell/cabal/issues/3586
post-destroot {
    # find cabal data-files
    set build_datadirs {}
    if {[file isdirectory ${haskell_cabal.cabal_root}/store]} {
        fs-traverse f ${haskell_cabal.cabal_root}/store {
            if { [file isdirectory ${f}]
                && [file tail ${f}] eq {share}} {
                lappend build_datadirs ${f}
            }
        }
    }
    if {[llength ${build_datadirs}] > 0} {
        foreach binfile [glob -nocomplain ${destroot}${prefix}/bin/*] {
            if {!([file isfile ${binfile}] && [file type ${binfile}] eq {file})} {
                continue
            }
            xinstall -m 0755 \
                ${binfile} \
                ${binfile}.slash_hack
            foreach build_datadir ${build_datadirs} {
                set extra_slashes \
                    [expr {[string length ${build_datadir}] - [string length ${prefix}/${haskell_cabal.datadir}]}]
                if {${extra_slashes} >= 0} {
                    set slash_hack \
                        [string repeat / [expr {${extra_slashes} + 1}]]
                    set datadir_slash_hack \
                        [strsed ${prefix}/${haskell_cabal.datadir} "g|/${haskell_cabal.datadir}\$|${slash_hack}${haskell_cabal.datadir}|"]
                    set build_datadir_esc \
                        [strsed ${build_datadir} {g|/|\\/|}]
                    set datadir_slash_hack_esc \
                        [strsed ${datadir_slash_hack} {g|/|\\/|}]
                    system -W ${destroot}${prefix}/bin \
                        "gsed -i -e\
                            's/${build_datadir_esc}/${datadir_slash_hack_esc}/g'\
                            ${binfile}.slash_hack"
                }
            }
            if {[file size ${binfile}.slash_hack] == [file size ${binfile}]} {
                delete  ${binfile}
                xinstall -m 0755 \
                    ${binfile}.slash_hack \
                    ${binfile}
            }
            delete  ${binfile}.slash_hack
            if {${configure.build_arch} eq {arm64}} {
                system "codesign -f -s - ${binfile}"
            }
        }
    }
}

# Default cabal configuration file with available options

# -- This is the configuration file for the 'cabal' command line tool.
# --
# -- The available configuration options are listed below.
# -- Some of them have default values listed.
# --
# -- Lines (like this one) beginning with '--' are comments.
# -- Be careful with spaces and indentation because they are
# -- used to indicate layout for nested sections.
# --
# -- This config file was generated using the following versions
# -- of Cabal and cabal-install:
# -- Cabal library version: 3.4.0.0
# -- cabal-install version: 3.4.0.0
# 
# 
# repository hackage.haskell.org
#   url: http://hackage.haskell.org/
#   -- secure: True
#   -- root-keys:
#   -- key-threshold: 3
# 
# -- default-user-config:
# -- ignore-expiry: False
# -- http-transport:
# -- nix: False
# -- local-no-index-repo:
# remote-repo-cache: /opt/local/var/macports/build/_opt_local_ports_textproc_pandoc/pandoc/work/.home/.cabal/packages
# -- logs-dir: /opt/local/var/macports/build/_opt_local_ports_textproc_pandoc/pandoc/work/.home/.cabal/logs
# world-file: /opt/local/var/macports/build/_opt_local_ports_textproc_pandoc/pandoc/work/.home/.cabal/world
# -- store-dir:
# -- active-repositories:
# -- verbose: 1
# -- compiler: ghc
# -- cabal-file:
# -- with-compiler:
# -- with-hc-pkg:
# -- program-prefix: 
# -- program-suffix: 
# -- library-vanilla: True
# -- library-profiling:
# -- shared:
# -- static:
# -- executable-dynamic: False
# -- executable-static: False
# -- profiling:
# -- executable-profiling:
# -- profiling-detail:
# -- library-profiling-detail:
# -- optimization: True
# -- debug-info: False
# -- library-for-ghci:
# -- split-sections: False
# -- split-objs: False
# -- executable-stripping:
# -- library-stripping:
# -- configure-option:
# -- user-install: True
# -- package-db:
# -- flags:
# -- extra-include-dirs:
# -- deterministic:
# -- cid:
# -- extra-lib-dirs:
# -- extra-framework-dirs:
# extra-prog-path: /opt/local/var/macports/build/_opt_local_ports_textproc_pandoc/pandoc/work/.home/.cabal/bin
# -- instantiate-with:
# -- tests: False
# -- coverage: False
# -- library-coverage:
# -- exact-configuration: False
# -- benchmarks: False
# -- relocatable: False
# -- response-files:
# -- allow-depending-on-private-libs:
# -- cabal-lib-version:
# -- constraint:
# -- preference:
# -- solver: modular
# -- allow-older: False
# -- allow-newer: False
# -- write-ghc-environment-files:
# -- documentation: False
# -- doc-index-file: $datadir/doc/$arch-$os-$compiler/index.html
# -- target-package-db:
# -- max-backjumps: 4000
# -- reorder-goals: False
# -- count-conflicts: True
# -- fine-grained-conflicts: True
# -- minimize-conflict-set: False
# -- independent-goals: False
# -- shadow-installed-packages: False
# -- strong-flags: False
# -- allow-boot-library-installs: False
# -- reject-unconstrained-dependencies: none
# -- reinstall: False
# -- avoid-reinstalls: False
# -- force-reinstalls: False
# -- upgrade-dependencies: False
# -- index-state:
# -- root-cmd:
# -- symlink-bindir:
# build-summary: /opt/local/var/macports/build/_opt_local_ports_textproc_pandoc/pandoc/work/.home/.cabal/logs/build.log
# -- build-log:
# remote-build-reporting: none
# -- report-planning-failure: False
# -- per-component: True
# -- one-shot: False
# -- run-tests:
# jobs: $ncpus
# -- keep-going: False
# -- offline: False
# -- lib: False
# -- package-env:
# -- overwrite-policy:
# -- install-method:
# installdir: /opt/local/var/macports/build/_opt_local_ports_textproc_pandoc/pandoc/work/.home/.cabal/bin
# -- username:
# -- password:
# -- password-command:
# -- builddir:
# 
# haddock
#   -- keep-temp-files: False
#   -- hoogle: False
#   -- html: False
#   -- html-location:
#   -- executables: False
#   -- tests: False
#   -- benchmarks: False
#   -- foreign-libraries: False
#   -- all:
#   -- internal: False
#   -- css:
#   -- hyperlink-source: False
#   -- quickjump: False
#   -- hscolour-css:
#   -- contents-location:
# 
# init
#   -- interactive: False
#   -- cabal-version: 2.4
#   -- license:
#   -- tests:
#   -- test-dir:
#   -- language: Haskell2010
#   -- application-dir: app
#   -- source-dir: src
# 
# install-dirs user
#   -- prefix: /opt/local/var/macports/build/_opt_local_ports_textproc_pandoc/pandoc/work/.home/.cabal
#   -- bindir: $prefix/bin
#   -- libdir: $prefix/lib
#   -- libsubdir: $abi/$libname
#   -- dynlibdir: $libdir/$abi
#   -- libexecdir: $prefix/libexec
#   -- libexecsubdir: $abi/$pkgid
#   -- datadir: $prefix/share
#   -- datasubdir: $abi/$pkgid
#   -- docdir: $datadir/doc/$abi/$pkgid
#   -- htmldir: $docdir/html
#   -- haddockdir: $htmldir
#   -- sysconfdir: $prefix/etc
# 
# install-dirs global
#   -- prefix: /usr/local
#   -- bindir: $prefix/bin
#   -- libdir: $prefix/lib
#   -- libsubdir: $abi/$libname
#   -- dynlibdir: $libdir/$abi
#   -- libexecdir: $prefix/libexec
#   -- libexecsubdir: $abi/$pkgid
#   -- datadir: $prefix/share
#   -- datasubdir: $abi/$pkgid
#   -- docdir: $datadir/doc/$abi/$pkgid
#   -- htmldir: $docdir/html
#   -- haddockdir: $htmldir
#   -- sysconfdir: $prefix/etc
# 
# program-locations
#   -- alex-location:
#   -- ar-location:
#   -- c2hs-location:
#   -- cpphs-location:
#   -- doctest-location:
#   -- gcc-location:
#   -- ghc-location:
#   -- ghc-pkg-location:
#   -- ghcjs-location:
#   -- ghcjs-pkg-location:
#   -- greencard-location:
#   -- haddock-location:
#   -- happy-location:
#   -- haskell-suite-location:
#   -- haskell-suite-pkg-location:
#   -- hmake-location:
#   -- hpc-location:
#   -- hsc2hs-location:
#   -- hscolour-location:
#   -- jhc-location:
#   -- ld-location:
#   -- pkg-config-location:
#   -- runghc-location:
#   -- strip-location:
#   -- tar-location:
#   -- uhc-location:
# 
# program-default-options
#   -- alex-options:
#   -- ar-options:
#   -- c2hs-options:
#   -- cpphs-options:
#   -- doctest-options:
#   -- gcc-options:
#   -- ghc-options:
#   -- ghc-pkg-options:
#   -- ghcjs-options:
#   -- ghcjs-pkg-options:
#   -- greencard-options:
#   -- haddock-options:
#   -- happy-options:
#   -- haskell-suite-options:
#   -- haskell-suite-pkg-options:
#   -- hmake-options:
#   -- hpc-options:
#   -- hsc2hs-options:
#   -- hscolour-options:
#   -- jhc-options:
#   -- ld-options:
#   -- pkg-config-options:
#   -- runghc-options:
#   -- strip-options:
#   -- tar-options:
#   -- uhc-options:

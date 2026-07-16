# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup         haskell_stack 1.0
#
# This PortGroup configures the build to use the Haskell Stack tool. It
# modifies the defaults for a number of variables, so your Portfile should take
# care not to accidentally overwrite them.
#
# The PortGroup will automatically add the required build dependencies for
# port:stack, and if haskell_stack.system_ghc is set, for port:ghc.
#
# The configure, build, destroot and test phases are set up (although the test
# phase is not enabled automatically). A default livecheck is configured to
# hackage.haskell.org using ${name}.
#
# This PortGroup offers the following options:
#
# haskell_stack.bin
#   The stack binary. Defaults to ${prefix}/bin/stack.
#
# haskell_stack.stack_root
#   The root directory for stack, passed as STACK_ROOT in haskell_stack.env.
#   Defaults to ${workpath}/.home/.stack.
#
# haskell_stack.yaml
#   The location of the stack.yaml config file, passed as STACK_YAML in
#   haskell_stack.env. Defaults to ${worksrcpath}/stack.yaml.
#
# haskell_stack.env
#   Environment variables used in configure, build, destroot, and test
#   phases. Defaults to STACK_ROOT=${haskell_stack.stack_root}
#   STACK_YAML=${haskell_stack.yaml}
#
# haskell_stack.system_ghc
#   Boolean indicating whether the system GHC should be used for port. Setting
#   this to yes will add a dependency to ghc and pass --system-ghc in
#   haskell_stack.default_args. Defaults to no.
#
# haskell_stack.default_args
#   Default arguments for stack used across invocations in configure, build, and
#   destroot phases. Defaults to --with-gcc ${configure.cc}
#   --allow-different-user --system-ghc (if haskell_stack.system_ghc is set)

options \
    haskell_stack.bin \
    haskell_stack.bindirs \
    haskell_stack.default_args \
    haskell_stack.env \
    haskell_stack.stack_root \
    haskell_stack.system_ghc \
    haskell_stack.use_init \
    haskell_stack.yaml

# default master_sites for non-GitHub ports
if {![info exists github.master_sites]} {
    default master_sites \
        {https://hackage.haskell.org/package/${subport}-${version}}
} 

default haskell_stack.system_ghc    {no}
default haskell_stack.bindirs       {${destroot}${prefix}/bin}

proc haskell_stack.system_ghc_flags {} {
    if {[option haskell_stack.system_ghc]} {
        return "--system-ghc"
    }
    return ""
}

proc haskell_stack.add_dependencies {} {
    global name
    if { ${name} ne "stack" } { 
        depends_build-append port:stack
    }
    if {[option haskell_stack.system_ghc]} {
        depends_build-append port:ghc
    }
    depends_build-append \
        port:cctools \
        port:file \
        port:grep \
        port:gsed \
        path:bin/openssl:openssl
}
port::register_callback haskell_stack.add_dependencies

default haskell_stack.stack_root {${workpath}/.home/.stack}

post-extract {
    xinstall -m 0755 -d "[option haskell_stack.stack_root]"
}

# stack builds arm64 and x86_64 binaries
supported_archs     arm64 x86_64

# libHSbase shipped with GHC links against system libiconv, which provides the
# 'iconv' symbol, but not the 'libiconv' symbol. Because the compilation
# process statically links libHSbase.a, we must have /usr/lib in the library
# search path first :/
compiler.library_path
compiler.cpath

# Builds (sometimes) fail if ccache is enabled in MacPorts
configure.ccache    no

default haskell_stack.bin   ${prefix}/bin/stack
default haskell_stack.default_args \
    {--with-gcc ${configure.cc} \
         --allow-different-user \
         [haskell_stack.system_ghc_flags]}

default haskell_stack.yaml  {${worksrcpath}/stack.yaml}

default haskell_stack.env \
    {STACK_ROOT=[option haskell_stack.stack_root] \
         STACK_YAML=[option haskell_stack.yaml]}

default haskell_stack.use_init yes

pre-configure {
    if {[option haskell_stack.use_init]} {
        if {![file exists ${haskell_stack.yaml}]} {
            system -W ${worksrcpath} \
                "env ${haskell_stack.env} ${haskell_stack.bin} init ${haskell_stack.default_args}"
        }
    }
}

default configure.cmd       {${haskell_stack.bin}}
default configure.pre_args  {}
default configure.args      {setup ${haskell_stack.default_args}}
default configure.universal_args {}
default configure.env       {${haskell_stack.env}}

default build.cmd           {${haskell_stack.bin}}
default build.target        {build}
default build.args          {${haskell_stack.default_args}}
default build.env           {${haskell_stack.env}}

default destroot.cmd        {${haskell_stack.bin}}
default destroot.target     {install}
default destroot.args       {${haskell_stack.default_args} \
                                --local-bin-path ${destroot}${prefix}/bin}
default destroot.destdir    {}
default destroot.env        {${haskell_stack.env}}

default test.cmd            {${haskell_stack.bin}}
default test.target         {test}
default test.env            {${haskell_stack.env}}

default livecheck.type      {regex}
default livecheck.url       {https://hackage.haskell.org/package/${name}}
default livecheck.regex     {"/package/[quotemeta ${name}]-\\\[^/\\\]+/[quotemeta ${name}]-(\\\[^\\\"\\\]+)[quotemeta ${extract.suffix}]"}

post-destroot {
    # strip binaries
    foreach bindir ${haskell_stack.bindirs} {
        foreach binfile [glob -nocomplain ${bindir}/*] {
            if {([file isfile ${binfile}]
                && [file type ${binfile}] eq {file}
                && [file executable ${binfile}]
                && [regexp -nocase -- \
                    {application/x-.*(binary|executable)} \
                        [lindex [exec file --mime-type ${binfile}] end]])} {
                system -W ${bindir} \
                        "strip ${binfile}"
                if {${configure.build_arch} eq {arm64}} {
                    system -W ${bindir} \
                        "codesign -f -s - ${binfile}"
                }
            }
        }
    }

    # binary sed hack to address unfixed cabal datadir issue:
    # replace hardwired datadir in build directory with path
    # of the same length using repeated /'s
    # https://github.com/haskell/cabal/issues/3586
    # find cabal data-files
    foreach bindir ${haskell_stack.bindirs} {
        foreach binfile [glob -nocomplain ${bindir}/*] {
            if {!([file isfile ${binfile}]
                  && [file type ${binfile}] eq {file}
                  && [file executable ${binfile}]
                  && [regexp -nocase -- \
                          {application/x-.*(binary|executable)} \
                          [lindex [exec file --mime-type ${binfile}] end]])} {
                continue
            }
            set build_installsubdirs [list]
            foreach sdir [exec sh -c "LC_ALL='C' ggrep -E -a -o -e '${haskell_stack.stack_root}(/\[-_.\[:alnum:]]+)+' ${binfile} 2>/dev/null || true"] {
                lappend build_installsubdirs ${sdir}
            }
            if {[llength ${build_installsubdirs}] > 0} {
                xinstall -m 0755 \
                    ${binfile} \
                    ${binfile}.slash_hack
                foreach build_idir ${build_installsubdirs} {
                    if {![string trim [exec sh -c \
                        "if LC_ALL='C' ggrep -F -a -c -q -e [shellescape ${build_idir}] \
                            [shellescape ${binfile}.slash_hack] 2>/dev/null; \
                                then echo '1'; else echo '0'; fi"]]} {
                        continue
                    }
                    set replacesubdir \
                        share/${subport}
                    set replacedir \
                        ${prefix}/${replacesubdir}
                    set extra_slashes \
                        [expr {[string length ${build_idir}] - [string length ${replacedir}]}]
                    if {${extra_slashes} >= 0} {
                        set slash_hack \
                            [string repeat / [expr {${extra_slashes} + 1}]]
                        set installsubdir_slash_hack \
                            [strsed ${replacedir} "g|/${replacesubdir}\$|${slash_hack}${replacesubdir}|"]
                        set build_idir_esc \
                            [strsed ${build_idir} {g|/|\\/|}]
                        set installsubdir_slash_hack_esc \
                            [strsed ${installsubdir_slash_hack} {g|/|\\/|}]
                        system -W ${bindir} \
                            "gsed -i -e\
                                's/${build_idir_esc}/${installsubdir_slash_hack_esc}/g'\
                                ${binfile}.slash_hack"
                    }
                }
                if {([file size ${binfile}.slash_hack] \
                    == [file size ${binfile}])
                    && ([exec openssl dgst -ripemd160 ${binfile}.slash_hack] \
                            ne [exec openssl dgst -ripemd160 ${binfile}])} {
                    # gsed created a different file of the same size
                    delete ${binfile}
                    xinstall -m 0755 \
                        ${binfile}.slash_hack \
                        ${binfile}
                    if {${configure.build_arch} eq {arm64}} {
                        system "codesign -f -s - ${binfile}"
                    }
                }
                delete ${binfile}.slash_hack
            }
        }
    }
}

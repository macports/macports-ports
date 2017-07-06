# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:filetype=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2004 Robert Shaw <rshaw@opendarwin.org>,
#                    Toby Peterson <toby@opendarwin.org>
# Copyright (c) 2002 Apple Computer, Inc.
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
# 3. Neither the name of Apple Computer, Inc. nor the names of its
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

# portfile configuration options
# perl5.branches: the major perl versions supported by this module. A
#   subport will be created for each. e.g. p5.12-foo, p5.10-foo, ...
# perl5.branches must be set in the portfile
# perl5.default_branch: the branch used when you request p5-foo
# perl5.use_search_cpan_org: if true use search.cpan.org instead of
#    metacpan.org for livecheck and homepage. Default: false.
options perl5.default_branch perl5.branches perl5.use_search_cpan_org
default perl5.default_branch {[perl5_get_default_branch]}
default perl5.use_search_cpan_org {false}

proc perl5_get_default_branch {} {
    global prefix perl5.branches
    # use whatever ${prefix}/bin/perl5 was chosen, and if none, fall back to 5.24
    if {![catch {set val [lindex [split [exec ${prefix}/bin/perl5 -V:version] {'}] 1]}]} {
        set ret [join [lrange [split $val .] 0 1] .]
    } else {
        set ret 5.24
    }
    # if the above default is not supported by this module, use the latest it does support
    if {[info exists perl5.branches] && [lsearch -exact ${perl5.branches} $ret] == -1} {
        set ret [lindex ${perl5.branches} end]
    }
    return $ret
}

proc perl5.extract_config {var {default ""}} {
    global perl5.bin

    if {[catch {set val [lindex [split [exec ${perl5.bin} -V:${var}] {'}] 1]}]} {
        set val ${default}
    }

    return $val
}

# Create perl subports
proc perl5.create_subports {branches rootname} {
    foreach v ${branches} {
        subport p${v}-${rootname} {
            depends_lib-append port:perl${v}
            perl5.major ${v}
        }
    }
}

# Set perl variant options and defaults
options perl5.default_variant perl5.variant perl5.set_default_variant perl5.conflict_variants perl5.require_variant
# The default variant derived from perl5.default_branch if not set in Portfile.
default perl5.default_variant {[string map {. _} perl${perl5.default_branch}]}
# The name of the selected variant or empty if there is not one.
default perl5.variant {}
# Control whether to set a default perl variant or not.
default perl5.set_default_variant {true}
# Control whether to conflict the perl variants or not. Probably almost always true.
default perl5.conflict_variants {true}
# Control whether a perl variant is required and if true produce an error if a perl variant is not set.
default perl5.require_variant {false}
# Get variant names from branches
proc perl5.get_variant_names {branches} {
    set ret {}
    foreach branch ${branches} {
        lappend ret "perl[string map {. _} ${branch}]"
    }
    return $ret
}
# Create perl variants
proc perl5.create_variants {branches} {
    global name perl5.major perl5.default_variant perl5.variant perl5.set_default_variant perl5.conflict_variants perl5.require_variant perl5.variants
    set perl5.variants [perl5.get_variant_names ${branches}]
    foreach branch ${branches} {
        set index [lsearch ${branches} ${branch}]
        set variant [lindex ${perl5.variants} ${index}]
# Add conflicts
        set conflicts {}
        if {${perl5.conflict_variants}} {
            set conflicts "conflicts {[lreplace ${perl5.variants} ${index} ${index}]}"
        }
        eval "variant ${variant} ${conflicts} description Use MacPorts perl${branch} {}"
        if {[variant_isset ${variant}]} {
            perl5.variant ${variant}
        }
    }
# Set default perl variant
    if {${perl5.variant} eq {} && ${perl5.set_default_variant}} {
        default_variants-append +${perl5.default_variant}
        if {[variant_isset ${perl5.default_variant}]} {
            perl5.variant ${perl5.default_variant}
        }
    }
# Set perl version and deps
    foreach branch ${branches} {
        set index [lsearch ${branches} ${branch}]
        set variant [lindex ${perl5.variants} ${index}]
        if {[variant_isset ${variant}]} {
            perl5.major ${branch}
            depends_lib-append port:perl${branch}
        }
    }
# Require perl variant
    pre-fetch {
        if {![variant_isset ${perl5.variant}] && ${perl5.require_variant}} {
            ui_error "${name} requires one of these variants: ${perl5.variants}"
            return -code error "absence of required perl variant"
        }
    }
}

# Set some variables.
options perl5.version perl5.major perl5.arch perl5.lib perl5.bindir perl5.archlib perl5.bin
default perl5.version {[perl5.extract_config version]}
default perl5.major {${perl5.default_branch}}
default perl5.arch {[perl5.extract_config archname ${os.platform}]}
default perl5.bin {${prefix}/bin/perl${perl5.major}}

# define installation libraries as vendor location
default perl5.lib {[perl5.extract_config vendorlib]}
default perl5.bindir {${prefix}/libexec/perl${perl5.major}}
default perl5.archlib {${perl5.lib}/${perl5.arch}}

default configure.universal_args {}

options perl5.link_binaries perl5.link_binaries_suffix
default perl5.link_binaries yes
default perl5.link_binaries_suffix {-${perl5.major}}

# define these empty initially, they are set by perl5.setup arguments
set perl5.module ""
set perl5.moduleversion ""
set perl5.cpandir ""

# perl5 group setup procedure
proc perl5.setup {module vers {cpandir ""}} {
    global perl5.branches perl5.default_branch perl5.bin perl5.lib \
           perl5.module perl5.moduleversion perl5.cpandir perl5.use_search_cpan_org \
           prefix subport name

    # define perl5.module
    set perl5.module ${module}
    set perl5.moduleversion $vers

    # define perl5.cpandir
    # check if optional CPAN dir specified to perl5.setup
    if {[string length ${cpandir}] == 0} {
        # if not, default to the first word (before a dash) from the
        # module name, this is the normal convention on CPAN
        set perl5.cpandir [lindex [split ${perl5.module} {-}] 0]
    } else {
        # else, use what was passed
        set perl5.cpandir ${cpandir}
    }

    if {![info exists name]} {
        name            p5-[string tolower ${perl5.module}]
    }
    version             [perl5_convert_version ${perl5.moduleversion}]
    categories          perl
    
    if {${perl5.use_search_cpan_org}} {
        homepage        http://search.cpan.org/dist/${perl5.module}/
    } else {
        homepage        https://metacpan.org/pod/[string map {"-" "::"} ${perl5.module}]
    }

    master_sites        perl_cpan:${perl5.cpandir}
    distname            ${perl5.module}-${perl5.moduleversion}
    dist_subdir         perl5

    if {[string match p5-* $name]} {
        set rootname        [string range $name 3 end]
        perl5.create_subports ${perl5.branches} ${rootname}

        if {$subport eq $name} {
            perl5.major
            distfiles
            supported_archs noarch
            replaced_by p[option perl5.default_branch]-${rootname}
            depends_lib-append port:p[option perl5.default_branch]-${rootname}
            use_configure no
            build {}
            destroot {
                xinstall -d -m 755 ${destroot}${prefix}/share/doc/${name}
                system "echo $name is a stub port > ${destroot}${prefix}/share/doc/${name}/README"
            }
        }
    } else {
        depends_lib-append port:perl${perl5.default_branch}
    }
    if {![string match p5-* $name] || $subport ne $name} {
        configure.cmd       ${perl5.bin}
        configure.env       PERL_AUTOINSTALL=--skipdeps
        configure.pre_args  Makefile.PL
        default configure.args {"INSTALLDIRS=vendor CC=\"${configure.cc}\" LD=\"${configure.cc}\""}

        # CCFLAGS can be passed in to "configure" but it's not necessarily inherited.
        # LDFLAGS can't be passed in (or if it can, it's not easy to figure out how).
        post-configure {
            fs-traverse file ${configure.dir} {
                if {[file isfile ${file}] && [file tail ${file}] eq "Makefile"} {
                    ui_info "Fixing flags in [string map "${configure.dir}/ {}" ${file}]"
                    reinplace -locale C -q "/^CCFLAGS *=/s/$/ [get_canonical_archflags cc]/" ${file}
                    reinplace -locale C -q "/^OTHERLDFLAGS *=/s/$/ [get_canonical_archflags ld]/" ${file}
                }
            }
        }

        test.run            yes

        destroot.target     pure_install

        post-destroot {
            fs-traverse file ${destroot}${perl5.lib} {
                if {[file isfile ${file}] && [file tail ${file}] eq ".packlist"} {
                    ui_info "Fixing paths in [string map "${destroot}${perl5.lib}/ {}" ${file}]"
                    reinplace -n -q "s|${destroot}||p" ${file}
                }
            }
            if {${perl5.link_binaries}} {
                foreach bin [glob -nocomplain -tails -directory "${destroot}${perl5.bindir}" *] {
                    if {[catch {file type "${destroot}${prefix}/bin/${bin}${perl5.link_binaries_suffix}"}]} {
                        ln -s "${perl5.bindir}/${bin}" "${destroot}${prefix}/bin/${bin}${perl5.link_binaries_suffix}"
                    }
                }
            }
        }
    }

    livecheck.type      regexm
    
    if {${perl5.use_search_cpan_org}} {
        livecheck.url       http://search.cpan.org/dist/${perl5.module}/
        livecheck.regex     >[quotemeta ${perl5.module}]-(\[^"\]+?)<
    } else {
        livecheck.url       https://fastapi.metacpan.org/v1/release/${perl5.module}/
        livecheck.regex     \"name\" : \"[quotemeta ${perl5.module}]-(\[^"\]+?)\"
    }

    default livecheck.version {${perl5.moduleversion}}
}

# Switch from default MakeMaker-style routine to Module::Build-style.
proc perl5.use_module_build {} {
    global perl5.bin destroot perl5.major

    if {${perl5.major} eq ""} {
        return
    }

    depends_lib-append  port:p${perl5.major}-module-build

    configure.pre_args  Build.PL
    default configure.args {"--installdirs=vendor --config cc=\"${configure.cc}\" --config ld=\"${configure.cc}\""}

    build.cmd           ${perl5.bin}
    build.pre_args      Build
    build.args          build

    test.pre_args       Build
    test.args           test

    destroot.cmd        ${perl5.bin}
    destroot.pre_args   Build
    destroot.args       install
    destroot.destdir    --destdir=${destroot}
}

# Convert a floating-point version to an equivalent dotted decimal one.
# If version is expressed as a perl v-string, strip the leading "v"
proc perl5_convert_version {vers} {
    if {[string index $vers 0] eq "v"} {
        set start 1
    } else {
        set start 0
    }
    set index [string first . $vers]
    set other_dot [string first . [string range $vers [expr {$index + 1}] end]]
    if {$index == -1 || $other_dot != -1} {
        return [string range $vers $start end]
    }
    set ret [string range $vers $start [expr {$index - 1}]]
    incr index
    set fractional [string range $vers $index end]
    set index 0
    while {$index < [string length $fractional] || $index < 6} {
        set sub [string range $fractional $index [expr {$index + 2}]]
        if {[string length $sub] < 3} {
            append sub [string repeat "0" [expr {3 - [string length $sub]}]]
        }
        append ret ".[scan $sub %u]"
        incr index 3
    }
    return $ret
}

# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:filetype=tcl:et:sw=4:ts=4:sts=4
# $Id$
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
# perl5.default_branch: the branch used when you request p5-foo
options perl5.default_branch perl5.branches
default perl5.default_branch {[perl5_get_default_branch]}
# perl5.branches exists here for backward compatibility with old p5 portfiles.
# You should still set it in the portfile.
default perl5.branches {"5.8 5.10 5.12 5.14"}
proc perl5_get_default_branch {} {
    global prefix
    # use whatever ${prefix}/bin/perl5 was chosen, and if none, fall back to 5.12
    if {![catch {set val [lindex [split [exec ${prefix}/bin/perl5 -V:version] {'}] 1]}]} {
        return [join [lrange [split $val .] 0 1] .]
    } else {
        return 5.12
    }
}

proc perl5.extract_config {var {default ""}} {
    global perl5.bin

    if {[catch {set val [lindex [split [exec ${perl5.bin} -V:${var}] {'}] 1]}]} {
        set val ${default}
    }

    return $val
}

# Set some variables.
options perl5.version perl5.major perl5.arch perl5.lib perl5.bindir perl5.archlib perl5.bin
default perl5.version {[perl5.extract_config version]}
default perl5.major {${perl5.default_branch}}
default perl5.arch {[perl5.extract_config archname ${os.platform}]}
default perl5.bin {${prefix}/bin/perl${perl5.major}}

# define installation libraries as vendor location
default perl5.lib {${prefix}/lib/perl5/vendor_perl/${perl5.version}}
default perl5.bindir {${prefix}/libexec/perl${perl5.major}}
default perl5.archlib {${perl5.lib}/${perl5.arch}}

default livecheck.version {${perl5.moduleversion}}

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
           perl5.module perl5.moduleversion perl5.cpandir \
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
    homepage            http://search.cpan.org/dist/${perl5.module}/

    master_sites        perl_cpan:${perl5.cpandir}
    distname            ${perl5.module}-${perl5.moduleversion}
    dist_subdir         perl5

    if {[string match p5-* $name]} {
        set rootname        [string range $name 3 end]

        foreach v ${perl5.branches} {
            subport p${v}-${rootname} {
                depends_lib port:perl${v}
                perl5.major ${v}
            }
        }

        if {$subport == $name} {
            perl5.major
            distfiles
            supported_archs noarch
            replaced_by p[option perl5.default_branch]-${rootname}
            depends_lib port:p[option perl5.default_branch]-${rootname}
            use_configure no
            build {}
            destroot {
                xinstall -d -m 755 ${destroot}${prefix}/share/doc/${name}
                system "echo $name is a stub port > ${destroot}${prefix}/share/doc/${name}/README"
            }
        }
    } else {
        depends_lib port:perl${perl5.default_branch}
    }
    if {![string match p5-* $name] || $subport != $name} {
        configure.cmd       ${perl5.bin}
        configure.env       PERL_AUTOINSTALL=--skipdeps
        configure.pre_args  Makefile.PL
        default configure.args {"INSTALLDIRS=vendor CC=\"${configure.cc}\" LD=\"${configure.cc}\""}

        # CCFLAGS can be passed in to "configure" but it's not necessarily inherited.
        # LDFLAGS can't be passed in (or if it can, it's not easy to figure out how).
        post-configure {
            system "find ${worksrcpath} -name Makefile -type f -print0 | xargs -0 /usr/bin/sed -i \"\" '/^CCFLAGS *=/s/$/ [get_canonical_archflags cc]/' \;"
            system "find ${worksrcpath} -name Makefile -type f -print0 | xargs -0 /usr/bin/sed -i \"\" '/^OTHERLDFLAGS *=/s/$/ [get_canonical_archflags ld]/'"
        }

        test.run            yes

        destroot.target     pure_install

        post-destroot {
            fs-traverse file ${destroot}${perl5.lib} {
                if {[file tail ${file}] eq ".packlist"} {
                    ui_info "Fixing packlist ${file}"
                    reinplace -n "s|${destroot}||p" ${file}
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
    livecheck.url       http://search.cpan.org/dist/${perl5.module}/
    livecheck.regex     _gaq.push\\(\\\["_setCustomVar",5,"Release","[quotemeta ${perl5.module}]-(\[^"\]+?)\"
}

# Switch from default MakeMaker-style routine to Module::Build-style.
proc perl5.use_module_build {} {
    global perl5.bin destroot perl5.major

    if {${perl5.major} == ""} {
        return
    }

    depends_lib-append  port:p${perl5.major}-module-build

    configure.pre_args  Build.PL
    default configure.args {"installdirs=vendor --config cc=\"${configure.cc}\" --config ld=\"${configure.cc}\""}

    build.cmd           ${perl5.bin}
    build.pre_args      Build
    build.args          build

    test.pre_args       Build
    test.args           test

    destroot.cmd        ${perl5.bin}
    destroot.pre_args   Build
    destroot.args       install
    destroot.destdir    destdir=${destroot}
}

# Convert a floating-point version to a dotted-integer one.
proc perl5_convert_version {vers} {
    set index [string first . $vers]
    set other_dot [string first . [string range $vers [expr $index + 1] end]]
    if {$index == -1 || $other_dot != -1} {
        return $vers
    }
    set ret [string range $vers 0 [expr $index - 1]]
    incr index
    set fractional [string range $vers $index end]
    set index 0
    while {$index < [string length $fractional] || $index < 6} {
        set sub [string range $fractional $index [expr $index + 2]]
        if {[string length $sub] < 3} {
            append sub [string repeat "0" [expr 3 - [string length $sub]]]
        }
        append ret ".[scan $sub %u]"
        incr index 3
    }
    return $ret
}

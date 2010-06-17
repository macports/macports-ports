# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# $Id$
# portgroup for swig language bindings

categories      devel lang
homepage        http://www.swig.org/
platforms       darwin
master_sites    sourceforge
default distname        {swig-${version}}
dist_subdir     swig

depends_build	port:bison \
                port:gsed

depends_lib     port:swig

if {[info exists supported_archs]} {
    supported_archs noarch
} else {
    universal_variant no
}

# for use in post-destroot
options         swig.lang

proc swigbinding-setup {lang prettyname} {
    name            swig-${lang}
    description     $prettyname binding for swig
    long_description    \
        SWIG is a software development tool that connects programs written in C \
        and C++ with a variety of high-level programming languages. This is the \
        $prettyname binding.
    
    # we can't have each port just pass in its info for this stuff, since we
    # have to turn all other bindings off as well as turning this one on
    array set bindings { \
        python      {port:python_select     python=${prefix}/bin/python} \
        perl        {path:bin/perl:perl5    perl5=${prefix}/bin/perl} \
        gcj         {port:gcc44             "gcj=${prefix}/bin/gcj-mp-4.4 --with-gcjh=${prefix}/bin/gcjh-mp-4.4"} \
        guile       {port:guile             guile} \
        mzscheme    {port:mzscheme          mzscheme} \
        ruby        {port:ruby              ruby} \
        php5        {path:bin/php:php5      php} \
        ocaml       {port:ocaml             ocaml} \
        pike        {port:pike              pike} \
        lua         {port:lua               lua} \
        chicken     {port:chicken           chicken} \
        allegro     {port:allegro           allegrocl} \
        clisp       {port:clisp             clisp} \
        r           {port:R                 r} \
        tcl         {port:tcl               tcl} \
        csharp      {port:mono              csharp} \
        octave      {port:octave            octave} \
        java        {bin:java:kaffe         java}
    }

    foreach binding [array names bindings] {
        set arg      [lindex $bindings($binding) 1]
        set arg_name [lindex [split ${arg} =] 0]
        if {$binding == $lang} {
            depends_lib-append      [lindex $bindings($lang) 0]
            configure.args-append   --with-${arg}
            destroot.args           lib-languages="${arg_name}"
            swig.lang               ${arg_name}
        } else {
            configure.args-append   --without-${arg_name}
        }
    }
    
    post-destroot {
        delete ${destroot}${prefix}/bin
        delete ${destroot}${prefix}/share/man
        foreach f [glob -directory ${destroot}${prefix}/share/swig/${version} *] {
            if {[file tail $f] != ${swig.lang}} {
                delete $f
            }
        }
    }
}

post-patch {
    # The configure script should use GNU sed
    reinplace "s/\[\[:<:\]\]sed\[\[:>:\]\]/gsed/g" ${worksrcpath}/configure
}

build.target

test.run            yes
test.target         check

livecheck.type      regex
livecheck.url       http://www.swig.org/download.html
livecheck.regex     {swig-(\d+(?:\.\d+)*)}

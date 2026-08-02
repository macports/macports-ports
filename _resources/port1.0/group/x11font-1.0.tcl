# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup       x11font 1.0
# x11font.setup   portname version fontsubdir
# where portname is just the name for the port (and should match the
# distname for simplicity), version is the port's version, and the fontsubdir
# is the subdirectory of ${prefix}/share/fonts used by this font.
# This automatically defines name, version, categories, homepage,
# master_sites, and depends_build as appropriate, and sets up
# configure.args, post-destroot, post-activate, and post-deactivate.
#

proc x11font.setup {myportname myportversion myfontsubdir} {
    global homepage prefix name extract.suffix master_sites x11font_myfontdir

    name             ${myportname}
    version          ${myportversion}
    categories       x11 x11-font graphics
    supported_archs  noarch
    platforms        any
    installs_libs    no
    homepage         https://www.x.org/
    master_sites     xorg:individual/font/
    use_bzip2        yes
    depends_build    bin:bdftopcf:bdftopcf \
                     path:bin/pkg-config:pkgconfig \
                     port:xorg-font-util bin:gzip:gzip
    depends_lib      port:fontconfig port:mkfontscale
    set x11font_myfontdir    ${prefix}/share/fonts/${myfontsubdir}
    configure.args   --with-fontdir=${x11font_myfontdir}

    post-destroot {
        foreach fontsFile {fonts.alias fonts.dir fonts.list fonts.scale fonts.cache-1} {
            if {[file exists ${destroot}${x11font_myfontdir}/${fontsFile}]} {
                delete ${destroot}${x11font_myfontdir}/${fontsFile}
            }
        }
    }

    post-activate {
        system "mkfontscale ${x11font_myfontdir}"
        system "mkfontdir ${x11font_myfontdir}"
        system "fc-cache ${x11font_myfontdir}"
    }

    post-deactivate {
        system "mkfontscale ${x11font_myfontdir}"
        system "mkfontdir ${x11font_myfontdir}"
        system "fc-cache ${x11font_myfontdir}"
    }

    livecheck.type      regex
    livecheck.regex     ${name}-(\[\\d.\]+)${extract.suffix}
    livecheck.url       https://xorg.freedesktop.org/archive/individual/font/?C=M&O=D
}

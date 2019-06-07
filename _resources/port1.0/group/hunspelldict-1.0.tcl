# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup automatically sets all the fields of the various hunspell
# directories ports (e.g. hunspell-dict-en_US).
#
# Usage:
#
#   PortGroup               hunspelldict 1.0
#   hunspelldict.setup      locale version lang source
#
# If the dictionary is hosted on the OpenOffice.org website, set "source" to
# "ooo", otherwise don't use it.
#
# Example:
#
#   PortGroup               unspelldict 1.0
#   hunspelldict.setup      en_US 2006-02-07 {English (United States)} ooo

options hunspelldict.locale

proc hunspelldict.setup {locale version lang {source {}}} {
    global description distfiles master_sites name worksrcpath

    hunspelldict.locale ${locale}

    name        hunspell-dict-${locale}
    version     ${version}
    categories  textproc
    platforms   darwin
    supported_archs noarch

    description {*}${lang} dictionary for hunspell
    long_description ${description}

    homepage    http://wiki.services.openoffice.org/wiki/Dictionaries

    if {${source} eq "ooo"} {
        dist_subdir ${name}/${version}
        distname    ${locale}
        use_zip     yes

        master_sites \
            http://archive.services.openoffice.org/pub/mirror/OpenOffice.org/contrib/dictionaries/

        extract.mkdir   yes

        use_configure no
        build {}
        destroot {
            set locale ${hunspelldict.locale}

            set dictdir ${prefix}/share/hunspell
            xinstall -d ${destroot}${dictdir}
            xinstall -m 0644 -W ${worksrcpath} ${locale}.aff ${locale}.dic \
                ${destroot}${dictdir}
        }

        livecheck.type  regex
        livecheck.regex \
            [quotemeta ${master_sites}${distfiles}].*(\\d{4}-\\d{2}-\\d{2})
    }
}

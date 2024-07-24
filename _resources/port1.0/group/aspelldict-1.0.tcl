# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup automatically sets all the fields of the various aspell
# directories ports (e.g. aspell-dict-uk).
#
# Usage:
#
#   PortGroup               aspelldict 1.0
#   aspelldict.setup        locale version lang aspell_version
#
# You can get ${aspell_version} from ${distname}. For example in
# "aspell6-uk-1.4.0-0.tar.bz2" is 6. You can find the list of all dictionaries
# here <https://ftp.gnu.org/gnu/aspell/dict/0index.html>
#
# Example:
#
#   PortGroup               aspelldict 1.0
#   aspelldict.setup        uk 1.4.0-0 {Ukrainian} 6

proc aspelldict.setup {locale version lang {aspell-version {}}} {
    global description prefix

    name                 aspell-dict-${locale}
    version              ${version}
    categories           textproc
    supported_archs      noarch
    platforms            any

    description         {*}${lang} dictionary for aspell
    long_description    {*}${description}
    homepage            https://aspell.net/

    distname            aspell${aspell-version}-${locale}-${version}
    use_bzip2           yes
    master_sites        gnu:aspell/dict/${locale}

    depends_build-append port:aspell
    configure.pre_args
    configure.args      --vars \
                        ASPELL=${prefix}/bin/aspell \
                        WORD_LIST_COMPRESS=${prefix}/bin/word-list-compress

    livecheck.type      regex
    livecheck.url       https://ftp.gnu.org/gnu/aspell/dict/0index.html
    livecheck.regex     >aspell(?:5|6)?-${locale}-(.*?)\\.tar\\.
}

# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2010 The MacPorts Project
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
# 3. Neither the name of The MacPorts Project nor the names of its
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

        extract.dir ${worksrcpath}
        pre-extract {
            xinstall -d ${worksrcpath}
        }

        use_configure no
        build {}
        destroot {
            set locale ${hunspelldict.locale}

            set dictdir ${prefix}/share/hunspell
            xinstall -d ${destroot}${dictdir}
            xinstall -m 644 -W ${worksrcpath} ${locale}.aff ${locale}.dic \
                ${destroot}${dictdir}
        }

        livecheck.type  regex
        livecheck.regex \
            [quotemeta ${master_sites}${distfiles}].*(\\d{4}-\\d{2}-\\d{2})
    }
}

# $Id$
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
# This PortGroup automatically sets up the standard environment for
# building an octave module.
#
# Usage:
#
#   PortGroup               octave 1.0
#   octave.setup            module version
#
# where module is the name of the module (e.g. communications) and
# version is its version.

options octave.module

proc octave.setup {module version} {
    global octave.module

    octave.module               ${module}
    name                        octave-${module}
    version                     ${version}
    categories                  math science
    homepage                    http://octave.sourceforge.net/${octave.module}/
    master_sites                sourceforge:octave
    distname                    ${octave.module}-${version}

    depends_lib                 path:bin/octave:octave

    worksrcdir                  ${octave.module}

    # octave is not universal

    universal_variant           no

    # do not build in parallel; many can't, and these are small builds
    # anyway, so no major need for this.

    use_parallel_build          no

    configure.pre_args
    configure.post_args

    livecheck.type              regex
    livecheck.url               http://octave.sourceforge.net/packages.php
    livecheck.regex             http://downloads\\.sourceforge\\.net/octave/${octave.module}-(\\d+(\\.\\d+)*)\\.tar

}

post-extract {

    # rename the effective worksrcdir to always be ${octave.module}

    set worksrcdir_name [exec /bin/ls ${workpath} | grep -v -E "^\\."]
    if {[string equal ${worksrcdir_name} ${octave.module}] == 0} {
	move ${workpath}/${worksrcdir_name} ${workpath}/${octave.module}
    }

}

post-patch {
    # In 10.8+, set the locale to "C" otherwise /usr/bin/sed can fail
    # with an error when processing unicode characters.

    set locale ""
    platform darwin {
	if {${os.major} >= 12} {
	    set locale "-locale \"C\""
	}
    }

    # do not auto-load; like, ever.  Not all files will need this, but
    # it's a simple catch-all.

    eval [subst {
	reinplace ${locale} "/Autoload/s@yes@no@g" ${worksrcpath}/DESCRIPTION
    }]

    # create a tarball of the resulting patched module

    xinstall -d -m 755 ${workpath}
    system "cd ${workpath} && tar zcf .tmp/${octave.module}.tar.gz ${worksrcdir}"
    delete ${worksrcpath}
}

pre-configure {

    # set parameters, now that variables are available for use

    configure.cmd ${prefix}/bin/octave
    configure.args -q -f --eval 'pkg build -verbose -nodeps ${worksrcpath} ${workpath}/.tmp/${octave.module}.tar.gz'

    # fix usage of LAPACK_LIBS to include FLIBS, such that -lgfortran
    # is always paired with the appropriate -Lpath statement.

    configure.env-append \
	LAPACK_LIBS='[exec ${prefix}/bin/mkoctfile -p FLIBS] [exec ${prefix}/bin/mkoctfile -p LAPACK_LIBS]'

    platform darwin {
	if {${os.major} >= 12} {

	    # In 10.8+, set the LC_CTYPE (locale) to "C" otherwise
	    # /usr/bin/sed can fail with an error when processing
	    # unicode characters.

	    configure.env-append LC_CTYPE="C"
	}
    }
}

# dummy build phase, since this has already been done

build {}

destroot.keepdirs   ${destroot}${prefix}/lib/octave/packages \
                    ${destroot}${prefix}/share/octave/packages

pre-destroot {
    xinstall -d -m 755 ${destroot}${prefix}/lib/octave/packages
    xinstall -d -m 755 ${destroot}${prefix}/share/octave/packages
}

destroot {
    xinstall    -m 644 ${worksrcpath}/${distname}.tar.gz ${destroot}${prefix}/share/octave/${octave.module}.tar.gz
}

post-deactivate {
    system "${prefix}/bin/octave -q -f --eval 'pkg prefix ${prefix}/share/octave/packages ${prefix}/lib/octave/packages; pkg uninstall -nodeps ${octave.module}'"
    system "${prefix}/bin/octave -q -f --eval 'pkg prefix ${prefix}/share/octave/packages ${prefix}/lib/octave/packages; pkg rebuild'"
}

post-activate {
    system "${prefix}/bin/octave -q -f --eval 'pkg prefix ${prefix}/share/octave/packages ${prefix}/lib/octave/packages; pkg install -verbose -global ${prefix}/share/octave/${octave.module}.tar.gz'"
    system "${prefix}/bin/octave -q -f --eval 'pkg prefix ${prefix}/share/octave/packages ${prefix}/lib/octave/packages; pkg rebuild'"
}

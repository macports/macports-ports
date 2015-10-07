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

    depends_lib-append          path:bin/octave:octave

    worksrcdir                  ${octave.module}

    # depend on the Fortran compiler used to build octave

    if {[catch {set installed [lindex [registry_active octave] 0]}]} {
	ui_msg "Warning in octave 1.0 PortGroup:"
	ui_msg "  Cannot find port 'octave' in the registry."
	ui_msg "  This should never happen!"
	ui_msg "  Continuing, and hoping for the best!"
    } else {
        set _variants [lindex ${installed} 3]
	set gcc1 [string first {gcc} ${_variants}]
	if {${gcc1} != -1} {
	    # using +gccXY; retrieve that string
	    set gcc [string range ${_variants} ${gcc1} [expr ${gcc1} + 4]]
	} else {
	    # must be using +g95
	    set gcc "g95"
	}
	#depends_lib-append port:${gcc}
    }

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

	# work-around for case-insensitive file systems when the
	# extract directory name is the same as the octave module name
	# except for letter case; should always work no matter if the
	# file system is case-insensitive or case-sensitive.

	move ${workpath}/${worksrcdir_name} ${workpath}/tmp-${worksrcdir_name}
	move ${workpath}/tmp-${worksrcdir_name} ${workpath}/${octave.module}

    }
}

pre-configure {

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

    system "cd ${workpath} && tar zcf .tmp/${octave.module}.tar.gz ${worksrcdir}"

    # delete the module's code since it is not used by Octave, but
    # remake the directory since configure (sometimes) expects it to
    # "cd" into for that stage.

    delete ${worksrcpath}
    xinstall -d -m 755 ${worksrcpath}

    # set parameters, now that variables are available for use

    configure.cmd ${prefix}/bin/octave
    configure.args -q -f --eval 'pkg build -verbose -nodeps ${worksrcpath} ${workpath}/.tmp/${octave.module}.tar.gz'

    # fix usage of LAPACK_LIBS to include FLIBS, such that -lgfortran
    # is always paired with the appropriate -Lpath statement.

    set GFORTRAN [glob ${prefix}/lib/libgcc/libgfortran*]
    set QUADMATH [glob ${prefix}/lib/libgcc/libquadmath*]
    set FLIBS [exec ${prefix}/bin/mkoctfile -p FLIBS | sed -e "s@-L\[^ \]* @@g" -e "s@-lgfortran@${GFORTRAN}@g" -e "s@-lquadmath@${QUADMATH}@g"]
    set FLIBS "-L${prefix}/lib/libgcc ${FLIBS}"
    set LAPACK_LIBS [exec ${prefix}/bin/mkoctfile -p LAPACK_LIBS | sed -e "s@-L\[^ \]* @@g" -e "s@-lgfortran@${GFORTRAN}@g" -e "s@-lquadmath@${QUADMATH}@g"]
    set LAPACK_LIBS "${FLIBS} ${LAPACK_LIBS}"

    ui_msg "GFORTRAN is '${GFORTRAN}'"
    ui_msg "QUADMATH is '${QUADMATH}'"
    ui_msg "FLIBS is '${FLIBS}'"
    ui_msg "LAPACK_LIBS is '${LAPACK_LIBS}'"

    configure.env-append \
	FLIBS='${FLIBS}' \
	LAPACK_LIBS='${LAPACK_LIBS}'

    # In 10.8+, set the LC_CTYPE (locale) to "C" otherwise
    # /usr/bin/sed can fail with an error when processing unicode
    # characters.

    platform darwin {
	if {${os.major} >= 12} {
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
    xinstall -m 644 ${worksrcpath}/${distname}.tar.gz ${destroot}${prefix}/share/octave/${octave.module}.tar.gz
}

pre-deactivate {
    ui_debug "${prefix}/bin/octave -V -q -f --eval 'pkg prefix ${prefix}/share/octave/packages ${prefix}/lib/octave/packages; pkg uninstall -nodeps ${octave.module}'"
    system "${prefix}/bin/octave -V -q -f --eval 'pkg prefix ${prefix}/share/octave/packages ${prefix}/lib/octave/packages; pkg uninstall -nodeps ${octave.module}'"
    ui_debug "${prefix}/bin/octave -V -q -f --eval 'pkg prefix ${prefix}/share/octave/packages ${prefix}/lib/octave/packages; pkg rebuild'"
    system "${prefix}/bin/octave -V -q -f --eval 'pkg prefix ${prefix}/share/octave/packages ${prefix}/lib/octave/packages; pkg rebuild'"

    # remove cruft left behind; cruft sometimes happens ;)
    foreach global_dir {lib/octave/packages share/octave/packages} {
	if {![catch {set stk_dirs [glob ${prefix}/${global_dir}/${octave.module}*]}]} {
	    foreach stk_dir ${stk_dirs} {
		ui_debug "removing cruft directory ${stk_dir}"
		file delete -force ${stk_dir}
	    }
	}
    }
}

post-activate {

    # remove cruft left behind; cruft sometimes happens ;)
    foreach global_dir {lib/octave/packages share/octave/packages} {
	if {![catch {set stk_dirs [glob ${prefix}/${global_dir}/${octave.module}*]}]} {
	    foreach stk_dir ${stk_dirs} {
		ui_debug "removing cruft directory ${stk_dir}"
		file delete -force ${stk_dir}
	    }
	}
    }

    ui_debug "${prefix}/bin/octave -V -q -f --eval 'pkg prefix ${prefix}/share/octave/packages ${prefix}/lib/octave/packages; pkg install -verbose -global ${prefix}/share/octave/${octave.module}.tar.gz'"
    system "${prefix}/bin/octave -V -q -f --eval 'pkg prefix ${prefix}/share/octave/packages ${prefix}/lib/octave/packages; pkg install -verbose -global ${prefix}/share/octave/${octave.module}.tar.gz'"
    ui_debug "${prefix}/bin/octave -V -q -f --eval 'pkg prefix ${prefix}/share/octave/packages ${prefix}/lib/octave/packages; pkg rebuild'"
    system "${prefix}/bin/octave -V -q -f --eval 'pkg prefix ${prefix}/share/octave/packages ${prefix}/lib/octave/packages; pkg rebuild'"
}

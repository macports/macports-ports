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
# 
# This PortGroup automatically sets up the standard environment for building
# an octave module.
# 
# Usage:
# 
#   PortGroup               octave 1.0
#   octave.setup            module version
# 
# where module is the name of the module (e.g. communications) and version is
# its version.


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
    
    depends_lib                 port:octave
    
    # octave is not universal
    universal_variant           no
    
    livecheck.type              regex
    livecheck.url               http://octave.sourceforge.net/packages.php
    livecheck.regex             http://downloads\\.sourceforge\\.net/octave/${octave.module}-(\\d+(\\.\\d+)*)\\.tar
}

post-destroot {
    move ${destroot}${prefix}/share/octave/octave_packages ${destroot}${prefix}/share/octave/octave_packages_${name}
}

post-activate {
    system "${prefix}/bin/octave --eval \"pkg rebuild\""
}

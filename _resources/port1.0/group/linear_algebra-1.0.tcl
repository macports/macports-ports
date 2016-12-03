# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2016 The MacPorts Project
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
# This PortGroup sets up variants for serial linear algebra (Accelerate/ATLAS/OpenBLAS/OpenBLAS-devel).
#
# Usage:
#
#   PortGroup               linear_algebra 1.0
#
#   If only BLAS and not LAPACK is used, set:
#   linalg.setup blas_only
#   If BLAS/LAPACK are only called from C and not Fortran, then Accelerate can be used
#   directly and vecLibFort is not needed. Set:
#   linalg.setup noveclibfort
#
#   in pre-configure, a line like this may be needed:
#   configure.args-append --with-blas="-L${prefix}/lib ${linalglib}"
#
#   If +threads and +atlas are set, the threaded ATLAS library will be used.
#

# scalapack.

PortGroup active_variants 1.1

default linalglib ""
default blas_only 0
default noveclibfort 0

proc linalg.setup {args} {
    global blas_only, noveclibfort

    foreach v $args {
        if {$v == "blas_only"} {
            set blas_only 1
        } elseif {$v == "noveclibfort"} {
            set noveclibfort 1
        } else {
            ui_error "Internal error: Unknown argument '$v' to linalg.setup."
            return -code error "Internal error: Unknown argument '$v' to linalg.setup."
        }
    }
}

if {![variant_isset accelerate] && ![variant_isset atlas] && ![variant_isset openblas]} {
    default_variants-append +accelerate
}

# choose one of the following for serial linear algebra
variant accelerate conflicts atlas openblas description {Build with linear algebra from built-in Accelerate framework} {
    if {$noveclibfort == 0} {
        depends_lib-append      port:vecLibFort
        set linalglib           -lvecLibFort
    } else {
        set linalglib           "-framework Accelerate"
    }
}

variant atlas conflicts accelerate openblas description {Build with linear algebra from ATLAS} {
    depends_lib-append      port:atlas
    if {[variant_isset threads]} {
        set linalglib       -ltatlas
    } else {
        set linalglib       -lsatlas
    }
}

variant openblas conflicts accelerate atlas description {Build with linear algebra from OpenBLAS} {
    # allow OpenBLAS-devel too
    depends_lib-append      path:lib/libopenblas.dylib:OpenBLAS
    if {$blas_only == 0} {
        require_active_variants path:lib/libopenblas.dylib:OpenBLAS lapack
    }
    set linalglib           -lopenblas
}

if {![variant_isset accelerate] && ![variant_isset openblas] && ![variant_isset atlas] } {
    ui_error "You must select either the +accelerate, +atlas, or +openblas variant for linear algebra."
    return -code error "No linear-algebra variant selected."
}

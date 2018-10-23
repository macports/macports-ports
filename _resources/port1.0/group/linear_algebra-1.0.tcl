# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
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

options linalglib \
        blas_only \
        noveclibfort

default linalglib ""
default blas_only no
default noveclibfort no

proc linalg.setup {args} {
    global blas_only, noveclibfort

    foreach v $args {
        if {$v == "blas_only"} {
            blas_only yes
        } elseif {$v == "noveclibfort"} {
            noveclibfort yes
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
    if {!$noveclibfort} {
        depends_lib-append      port:vecLibFort
        linalglib               -lvecLibFort
    } else {
        linalglib               -framework Accelerate
    }
}

variant atlas conflicts accelerate openblas description {Build with linear algebra from ATLAS} {
    depends_lib-append      port:atlas
    if {[variant_isset threads]} {
        linalglib           -ltatlas
    } else {
        linalglib           -lsatlas
    }
}

variant openblas conflicts accelerate atlas description {Build with linear algebra from OpenBLAS} {
    # allow OpenBLAS-devel too
    depends_lib-append      path:lib/libopenblas.dylib:OpenBLAS
    if {!$blas_only} {
        require_active_variants path:lib/libopenblas.dylib:OpenBLAS lapack
    }
    linalglib               -lopenblas
}

if {![variant_isset accelerate] && ![variant_isset openblas] && ![variant_isset atlas] } {
    ui_error "You must select either the +accelerate, +atlas, or +openblas variant for linear algebra."
    return -code error "No linear-algebra variant selected."
}

*** config/acx_blas.m4.orig	Fri Jul  7 11:28:45 2006
--- config/acx_blas.m4	Thu Oct  5 10:06:27 2006
***************
*** 36,43 ****
  
  AC_DEFUN([ACX_BLAS], [
  AC_PREREQ(2.50)
! AC_REQUIRE([AC_F77_LIBRARY_LDFLAGS])
! acx_blas_ok=no
  
  AC_ARG_WITH(blas,
  	[AC_HELP_STRING([--with-blas=<lib>], [use BLAS library <lib>])])
--- 36,43 ----
  
  AC_DEFUN([ACX_BLAS], [
  AC_PREREQ(2.50)
! #AC_REQUIRE([AC_F77_LIBRARY_LDFLAGS])
! acx_blas_ok=yes
  
  AC_ARG_WITH(blas,
  	[AC_HELP_STRING([--with-blas=<lib>], [use BLAS library <lib>])])
***************
*** 49,56 ****
  esac
  
  # Get fortran linker names of BLAS functions to check for.
! AC_F77_FUNC(sgemm)
! AC_F77_FUNC(dgemm)
  
  acx_blas_save_LIBS="$LIBS"
  LIBS="$LIBS $FLIBS"
--- 49,56 ----
  esac
  
  # Get fortran linker names of BLAS functions to check for.
! #AC_F77_FUNC(sgemm)
! #AC_F77_FUNC(dgemm)
  
  acx_blas_save_LIBS="$LIBS"
  LIBS="$LIBS $FLIBS"

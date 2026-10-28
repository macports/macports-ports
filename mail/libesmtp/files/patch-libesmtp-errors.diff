*** errors.c.orig	2006-03-30 19:28:00.000000000 +0200
--- errors.c	2006-03-30 19:49:13.000000000 +0200
***************
*** 31,36 ****
--- 31,37 ----
  #include <stdio.h>
  #include <errno.h>
  #include <string.h>
+ #include <strings.h>
  #include <stdlib.h>
  #if HAVE_LWRES_NETDB_H
  # include <lwres/netdb.h>
***************
*** 256,264 ****
    SMTPAPI_CHECK_ARGS (buf != NULL && buflen > 0, NULL);
  
    if (error < 0)
! #if HAVE_WORKING_STRERROR_R
!     return strerror_r (-error, buf, buflen);
! #elif HAVE_STRERROR_R
      {
        /* Assume the broken OSF1 strerror_r which returns an int. */
        int n = strerror_r (-error, buf, buflen);
--- 257,263 ----
    SMTPAPI_CHECK_ARGS (buf != NULL && buflen > 0, NULL);
  
    if (error < 0)
! #if HAVE_STRERROR_R
      {
        /* Assume the broken OSF1 strerror_r which returns an int. */
        int n = strerror_r (-error, buf, buflen);

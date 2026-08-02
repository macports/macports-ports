*** domain_resolver.c.orig	2006-05-13 13:35:39.000000000 +0200
--- domain_resolver.c	2006-05-13 13:37:52.000000000 +0200
***************
*** 25,30 ****
--- 25,32 ----
  #include <paths.h>
  #endif
  #ifdef	HAVE_RESOLV_H
+ #include <netinet/in.h>
+ #include <arpa/nameser_compat.h>
  #include <resolv.h>
  #endif
  

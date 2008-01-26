diff -ur qmail-1.03.orig/strerr_sys.c qmail-1.03/strerr_sys.c
--- strerr_sys.c.orig	Mon Jun 15 06:53:16 1998
+++ strerr_sys.c	Sat Jun  5 15:52:46 2004
@@ -1,7 +1,7 @@
 #include "error.h"
 #include "strerr.h"
 
-struct strerr strerr_sys;
+struct strerr strerr_sys = {0,0,0,0};
 
 void strerr_sysinit()
 {

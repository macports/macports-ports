--- marc.c.orig	2004-11-06 06:25:45.000000000 -0500
+++ marc.c	2005-04-04 06:56:30.000000000 -0400
@@ -23,6 +23,7 @@
 	 Computer Innovations Optimizing C86
 */
 #include <stdio.h>
+#include <string.h>
 #include "arc.h"
 
 #if	UNIX
@@ -48,7 +49,6 @@
 int nargs;			       /* number of arguments */
 char *arg[];			       /* pointers to arguments */
 {
-    char *makefnam();		       /* filename fixup routine */
     char *envfind();
 #if	!_MTS
     char *arctemp2, *mktemp();		/* temp file stuff */

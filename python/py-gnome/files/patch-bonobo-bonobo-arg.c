--- bonobo/bonobo-arg.c.orig	Sun Feb  1 23:20:45 2004
+++ bonobo/bonobo-arg.c	Sun Feb  1 23:21:01 2004
@@ -1,5 +1,6 @@
 /* -*- Mode: C; c-basic-offset: 4 -*- */
 
+#define NO_IMPORT_PYGOBJECT
 #include <pygobject.h>
 #include <pyorbit.h>
 #include <bonobo/bonobo-types.h>

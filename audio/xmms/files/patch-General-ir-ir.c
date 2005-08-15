--- General/ir/ir.c.orig	2005-08-15 13:05:40.000000000 +0900
+++ General/ir/ir.c	2005-08-15 13:05:43.000000000 +0900
@@ -16,10 +16,10 @@
 #include "ir.h"
 
 /* Important stuff to know */
-static gboolean keepGoing = FALSE;
+gboolean keepGoing = FALSE;
 
 /* The thread handle */
-static pthread_t irapp_thread;
+pthread_t irapp_thread;
 
 /* Declarations for calls that we need to mention in the plugin struct */
 static void init(void);

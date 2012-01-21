--- ./src/pygpgme-context.c.orig	2006-02-14 05:05:15.000000000 +0100
+++ ./src/pygpgme-context.c	2010-05-19 09:37:51.000000000 +0200
@@ -92,6 +92,8 @@ pygpgme_context_init(PyGpgmeContext *sel
         return -1;
     }
 
+    gpgme_check_version(NULL);
+
     if (pygpgme_check_error(gpgme_new(&self->ctx)))
         return -1;
 

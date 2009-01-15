--- ./midori/main.c.orig	2008-12-01 09:07:11.000000000 +0100
+++ ./midori/main.c	2009-01-15 21:29:00.000000000 +0100
@@ -1143,9 +1143,11 @@ main (int    argc,
         return 1;
     }
 
+#if HAVE_LIBSOUP
     /* libSoup uses threads, therefore if WebKit is built with libSoup
        or Midori is using it, we need to initialize threads. */
     if (!g_thread_supported ()) g_thread_init (NULL);
+#endif
     stock_items_init ();
     g_set_application_name (_("Midori"));
 

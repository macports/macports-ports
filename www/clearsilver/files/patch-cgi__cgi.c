--- ./cgi/cgi.c.orig	2007-07-12 04:38:03.000000000 +0200
+++ ./cgi/cgi.c	2012-04-23 18:02:21.533510630 +0200
@@ -585,11 +585,11 @@
   struct _cgi_parse_cb *my_pcb;
 
   if (method == NULL || ctype == NULL)
-    return nerr_raise(NERR_ASSERT, "method and type must not be NULL to register cb");
+    return nerr_raise(NERR_ASSERT, "%s", "method and type must not be NULL to register cb");
 
   my_pcb = (struct _cgi_parse_cb *) calloc(1, sizeof(struct _cgi_parse_cb));
   if (my_pcb == NULL)
-    return nerr_raise(NERR_NOMEM, "Unable to allocate memory to register parse cb");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory to register parse cb");
 
   my_pcb->method = strdup(method);
   my_pcb->ctype = strdup(ctype);
@@ -600,7 +600,7 @@
     if (my_pcb->ctype != NULL)
       free(my_pcb->ctype);
     free(my_pcb);
-    return nerr_raise(NERR_NOMEM, "Unable to allocate memory to register parse cb");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory to register parse cb");
   }
   if (!strcmp(my_pcb->method, "*"))
     my_pcb->any_method = 1;
@@ -753,7 +753,7 @@
   *cgi = NULL;
   mycgi = (CGI *) calloc (1, sizeof(CGI));
   if (mycgi == NULL)
-    return nerr_raise(NERR_NOMEM, "Unable to allocate space for CGI");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate space for CGI");
 
   mycgi->time_start = ne_timef();
 

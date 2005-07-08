--- lib/client.c	2003-11-11 08:26:06.000000000 -0800
+++ lib/client.c.new	2005-03-26 13:32:11.000000000 -0800
@@ -61,7 +61,6 @@
 
 static cmech_list_t *cmechlist; /* global var which holds the list */
 
-static sasl_global_callbacks_t global_callbacks;

 static int _sasl_client_active = 0;
 

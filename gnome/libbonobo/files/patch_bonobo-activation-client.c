--- bonobo-activation/bonobo-activation-client.c.org	Sun Apr  4 20:20:35 2004
+++ bonobo-activation/bonobo-activation-client.c	Sun Apr  4 20:22:18 2004
@@ -197,7 +197,12 @@
         return result;
 }
 
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#elif
 extern char **environ;
+#endif
 
 void
 bonobo_activation_register_client (Bonobo_ActivationContext context,

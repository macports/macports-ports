--- glib/gi18n.h~	2007-07-21 05:05:22.000000000 -0400
+++ glib/gi18n.h	2007-07-21 05:07:01.000000000 -0400
@@ -25,10 +25,14 @@
 #define _(String) gettext (String)
 #define Q_(String) g_strip_context ((String), gettext (String))
 #ifdef gettext_noop
+#ifndef N_
 #define N_(String) gettext_noop (String)
+#endif
 #else
+#ifndef N_
 #define N_(String) (String)
 #endif
+#endif
 
 #endif  /* __G_I18N_H__ */
 

--- gobject/pygobject.h.orig	Tue Sep 28 08:54:37 2004
+++ gobject/pygobject.h	Sun Oct 24 18:15:47 2004
@@ -7,6 +7,8 @@
 #include <glib.h>
 #include <glib-object.h>
 
+G_BEGIN_DECLS
+
 /* Work around bugs in PyGILState api fixed in 2.4.0a4 */
 #if PY_HEXVERSION < 0x020400A4
 #define PYGIL_API_IS_BUGGY TRUE
@@ -137,14 +139,14 @@
 					const GParamSpec* pspec);
     PyTypeObject *enum_type;
     PyObject *(*enum_add)(PyObject *module,
-			  const char *typename,
+			  const char *typename_,
 			  const char *strip_prefix,
 			  GType gtype);
     PyObject* (*enum_from_gtype)(GType gtype, int value);
     
     PyTypeObject *flags_type;
     PyObject *(*flags_add)(PyObject *module,
-			   const char *typename,
+			   const char *typename_,
 			   const char *strip_prefix,
 			   GType gtype);
     PyObject* (*flags_from_gtype)(GType gtype, int value);
@@ -252,5 +254,7 @@
 }
 
 #endif /* !_INSIDE_PYGOBJECT_ */
+
+G_END_DECLS
 
 #endif /* !_PYGOBJECT_H_ */

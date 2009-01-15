--- ./midori/gjs.c.orig	2008-12-01 09:07:11.000000000 +0100
+++ ./midori/gjs.c	2009-01-15 21:24:11.000000000 +0100
@@ -1028,6 +1028,8 @@ gjs_global_context_new (void)
     #else
     JSGlobalContextRef js_context = JSGlobalContextCreate (NULL);
     #endif
+    #else
+    JSGlobalContextRef js_context = JSGlobalContextCreate (NULL);
     #endif
     JSObjectRef js_object = gjs_object_new (js_context, "GJS", NULL);
     _js_object_set_property (js_context, JSContextGetGlobalObject (js_context),

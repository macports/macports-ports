--- ./util/neo_hdf.c.orig	2007-07-12 03:52:37.000000000 +0200
+++ ./util/neo_hdf.c	2012-04-23 17:53:28.104660092 +0200
@@ -59,7 +59,7 @@
   *hdf = calloc (1, sizeof (HDF));
   if (*hdf == NULL)
   {
-    return nerr_raise (NERR_NOMEM, "Unable to allocate memory for hdf element");
+    return nerr_raise (NERR_NOMEM, "%s", "Unable to allocate memory for hdf element");
   }
 
   (*hdf)->top = top;
@@ -406,7 +406,7 @@
 
   _walk_hdf(hdf, name, &obj);
   if (obj == NULL) 
-    return nerr_raise(NERR_ASSERT, "Unable to set attribute on none existant node");
+    return nerr_raise(NERR_ASSERT, "%s", "Unable to set attribute on none existant node");
 
   if (obj->attr != NULL)
   {
@@ -645,7 +645,7 @@
     char *new_name = (char *) malloc(strlen(hdf->value) + 1 + strlen(name) + 1);
     if (new_name == NULL)
     {
-      return nerr_raise(NERR_NOMEM, "Unable to allocate memory");
+      return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory");
     }
     strcpy(new_name, hdf->value);
     strcat(new_name, ".");
@@ -792,7 +792,7 @@
       char *new_name = (char *) malloc(strlen(hp->value) + strlen(s) + 1);
       if (new_name == NULL)
       {
-        return nerr_raise(NERR_NOMEM, "Unable to allocate memory");
+        return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory");
       }
       strcpy(new_name, hp->value);
       strcat(new_name, s);
@@ -866,7 +866,7 @@
   k = vsprintf_alloc(fmt, ap);
   if (k == NULL)
   {
-    return nerr_raise(NERR_NOMEM, "Unable to allocate memory for format string");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory for format string");
   }
   v = strchr(k, '=');
   if (v == NULL)
@@ -1025,7 +1025,7 @@
     if (copy == NULL)
     {
       _dealloc_hdf_attr(dest);
-      return nerr_raise(NERR_NOMEM, "Unable to allocate copy of HDF_ATTR");
+      return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate copy of HDF_ATTR");
     }
     copy->key = strdup(src->key);
     copy->value = strdup(src->value);
@@ -1033,7 +1033,7 @@
     if ((copy->key == NULL) || (copy->value == NULL))
     {
       _dealloc_hdf_attr(dest);
-      return nerr_raise(NERR_NOMEM, "Unable to allocate copy of HDF_ATTR");
+      return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate copy of HDF_ATTR");
     }
     if (last) {
       last->next = copy;
@@ -1339,7 +1339,7 @@
   if (str.buf == NULL)
   {
     *s = strdup("");
-    if (*s == NULL) return nerr_raise(NERR_NOMEM, "Unable to allocate empty string");
+    if (*s == NULL) return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate empty string");
   }
   else
   {
@@ -1831,7 +1831,7 @@
   string_init(&line);
 
   if (path == NULL) 
-    return nerr_raise(NERR_ASSERT, "Can't read NULL file");
+    return nerr_raise(NERR_ASSERT, "%s", "Can't read NULL file");
 
   if (top->fileload)
   {

--- ./util/dict.c.orig	2005-07-01 02:48:26.000000000 +0200
+++ ./util/dict.c	2012-04-23 17:58:36.491954556 +0200
@@ -92,14 +92,14 @@
 
   /* check if we can set a new value */
   if(! (newval->value || newval->new))
-    return nerr_raise(NERR_ASSERT, "value or new are NULL");
+    return nerr_raise(NERR_ASSERT, "%s", "value or new are NULL");
 
   if(! (my_item = calloc(1, sizeof(struct dictItem))))
-    return nerr_raise(NERR_NOMEM, "Unable to allocate new dictItem");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate new dictItem");
 
   if(! (my_item->id = strdup(id))) {
     free(my_item);
-    return nerr_raise(NERR_NOMEM, "Unable to allocate new id for dictItem");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate new id for dictItem");
   }
 
   /* set new value */
@@ -171,7 +171,7 @@
 
   /* check for entry (maybe not found...) */
   if(! entry)
-    return nerr_raise(NERR_NOT_FOUND, "Entry is NULL");
+    return nerr_raise(NERR_NOT_FOUND, "%s", "Entry is NULL");
 
   /* only use entry if not deleted */
   if(! entry->deleted) {
@@ -226,7 +226,7 @@
   /* create new item and insert entry */
   entry = calloc(1, sizeof(struct dictEntry));
   if (entry == NULL)
-    return nerr_raise(NERR_NOMEM, "Unable to allocate memory for dictEntry");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory for dictEntry");
     
   /* create/insert item (or cleanup) */
   err = dictNewItem(dict, entry, id, newval, NULL);
@@ -559,7 +559,7 @@
   do {
 
     if(! (dict = calloc(1, sizeof(struct _dictCtx))))
-      return nerr_raise (NERR_NOMEM, "Unable to allocate memory for dictCtx");
+      return nerr_raise (NERR_NOMEM, "%s", "Unable to allocate memory for dictCtx");
 
     dict->useCase = useCase;
     dict->hash = python_string_hash;

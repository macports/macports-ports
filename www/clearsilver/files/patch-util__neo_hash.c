--- ./util/neo_hash.c.orig	2006-10-19 01:57:24.000000000 +0200
+++ ./util/neo_hash.c	2012-04-23 17:56:07.096509854 +0200
@@ -27,7 +27,7 @@
 
   my_hash = (NE_HASH *) calloc(1, sizeof(NE_HASH));
   if (my_hash == NULL)
-    return nerr_raise(NERR_NOMEM, "Unable to allocate memory for NE_HASH");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory for NE_HASH");
 
   my_hash->size = 256;
   my_hash->num = 0;
@@ -38,7 +38,7 @@
   if (my_hash->nodes == NULL)
   {
     free(my_hash);
-    return nerr_raise(NERR_NOMEM, "Unable to allocate memory for NE_HASHNODES");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory for NE_HASHNODES");
   }
 
   *hash = my_hash;
@@ -88,7 +88,7 @@
   {
     *node = (NE_HASHNODE *) malloc(sizeof(NE_HASHNODE));
     if (node == NULL)
-      return nerr_raise(NERR_NOMEM, "Unable to allocate NE_HASHNODE");
+      return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate NE_HASHNODE");
 
     (*node)->hashv = hashv;
     (*node)->key = key;
@@ -226,7 +226,7 @@
   /* We always double in size */
   new_nodes = (NE_HASHNODE **) realloc (hash->nodes, (hash->size*2) * sizeof(NE_HASHNODE));
   if (new_nodes == NULL)
-    return nerr_raise(NERR_NOMEM, "Unable to allocate memory to resize NE_HASH");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory to resize NE_HASH");
 
   hash->nodes = new_nodes;
   orig_size = hash->size;

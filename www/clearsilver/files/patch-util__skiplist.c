--- ./util/skiplist.c.orig	2005-06-30 20:52:10.000000000 +0200
+++ ./util/skiplist.c	2012-04-23 17:57:31.184893991 +0200
@@ -152,7 +152,7 @@
 {
 
   if(! (*item = malloc(SIZEOFITEM(level))))
-    return nerr_raise(NERR_NOMEM, "Unable to allocate space for skipItem");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate space for skipItem");
 
   /* init new item */
   (*item)->locks = 0;
@@ -364,10 +364,10 @@
 
   *skip = NULL;
   if(! (list = calloc(1, sizeof(struct skipList_struct))))
-    return nerr_raise(NERR_NOMEM, "Unable to allocate memore for skiplist");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memore for skiplist");
 
   if (maxLevel == 0)
-    return nerr_raise(NERR_ASSERT, "maxLevel must be greater than 0");
+    return nerr_raise(NERR_ASSERT, "%s", "maxLevel must be greater than 0");
 
   if(maxLevel >= SKIP_MAXLEVEL)                              /* check limits */
     maxLevel = SKIP_MAXLEVEL-1;
@@ -526,9 +526,9 @@
   skipItem x, y;
 
   if (value == 0)
-    return nerr_raise(NERR_ASSERT, "value must be non-zero");
+    return nerr_raise(NERR_ASSERT, "%s", "value must be non-zero");
   if (key == 0 || key == (UINT32)-1)
-    return nerr_raise(NERR_ASSERT, "key must not be 0 or -1");
+    return nerr_raise(NERR_ASSERT, "%s", "key must not be 0 or -1");
 
   level = list->levelHint;
 

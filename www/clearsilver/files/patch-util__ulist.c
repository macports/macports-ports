--- ./util/ulist.c.orig	2005-06-30 20:52:11.000000000 +0200
+++ ./util/ulist.c	2012-04-23 17:51:17.958055320 +0200
@@ -61,13 +61,13 @@
   r_ul = (ULIST *) calloc (1, sizeof (ULIST));
   if (r_ul == NULL)
   {
-    return nerr_raise(NERR_NOMEM, "Unable to create ULIST: Out of memory");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to create ULIST: Out of memory");
   }
   r_ul->items = (void **) calloc (size, sizeof(void *));
   if (r_ul->items == NULL)
   {
     free (r_ul);
-    return nerr_raise(NERR_NOMEM, "Unable to create ULIST: Out of memory");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to create ULIST: Out of memory");
   }
 
   r_ul->num = 0;
@@ -121,7 +121,7 @@
 NEOERR *uListPop (ULIST *ul, void **data)
 {
   if (ul->num == 0)
-    return nerr_raise(NERR_OUTOFRANGE, "uListPop: empty list");
+    return nerr_raise(NERR_OUTOFRANGE, "%s", "uListPop: empty list");
 
   *data = ul->items[ul->num - 1];
   ul->num--;

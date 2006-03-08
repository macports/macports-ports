--- libs/callbacks.c.org	2006-03-07 23:51:23.000000000 -0800
+++ libs/callbacks.c	2006-03-07 23:52:18.000000000 -0800
@@ -665,7 +665,7 @@
     skip_second_release = FALSE;
 
     for (tree_id=0; tree_id<TREECOUNT; tree_id++) {      
-      static gboolean unsel(GtkTreeModel *,GtkTreePath *, GtkTreeIter *, gpointer);
+      static gboolean (*unsel)(GtkTreeModel *,GtkTreePath *, GtkTreeIter *, gpointer);
       /*printf("DBG: treeview is  0x%x==0x%x\n",tree_details->treestuff[tree_id].treeview,treeview);*/
       if (treeview != tree_details->treestuff[tree_id].treeview){
         /* unselect all in auxiliary treeview */

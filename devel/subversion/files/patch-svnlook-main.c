--- subversion/svnlook/main.c.orig
+++ subversion/svnlook/main.c   (working copy)
@@ -515,7 +515,7 @@
       svn_node_kind_t kind;
       const char *piece = ((const char **) (path_pieces->elts))[i];
       full_path = svn_path_join (full_path, piece, pool);
-      SVN_ERR (svn_io_check_path (full_path, &kind, pool));
+      SVN_ERR (svn_io_check_resolved_path (full_path, &kind, pool));
 
       /* Does this path component exist at all? */
       if (kind == svn_node_none)


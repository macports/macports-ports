--- src/menu-method.c.org	Thu Sep 16 15:24:59 2004
+++ src/menu-method.c	Thu Sep 16 15:25:13 2004
@@ -117,12 +117,6 @@
 					    GnomeVFSURI              *uri,
 					    GnomeVFSOpenMode          mode,
 					    FileHandle              **handle);
-static GnomeVFSResult file_handle_create   (MenuMethod               *method,
-					    GnomeVFSURI              *uri,
-					    GnomeVFSOpenMode          mode,
-					    FileHandle              **handle,
-					    gboolean                  exclusive,
-					    unsigned int              perms);
 static void           file_handle_unref    (FileHandle               *handle);
 static GnomeVFSResult file_handle_read     (FileHandle               *handle,
 					    gpointer                  buffer,

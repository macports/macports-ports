--- src/craft.c.orig	Thu Dec 12 15:03:41 2002
+++ src/craft.c	Thu Dec 12 15:05:31 2002
@@ -85,12 +85,12 @@
       /* xrLog (LOG_DEBUG, "name = %s (len = %d)", name, len); */
 
       if (strncmp (name, "libcraft", 8) == 0 &&
-	  strcmp (name + len - 3, ".so") == 0)
+	  strcmp (name + len - 6, ".dylib") == 0)
 	{
 	  char shortname[1024];
 
-	  strncpy (shortname, name + 8, len - 11);
-	  shortname[len-11] = '\0';
+	  strncpy (shortname, name + 8, len - 14);
+	  shortname[len-14] = '\0';
 
 	  /* Try loading it. Don't worry about the return value. */
 	  xrCraftLoadByName (shortname);
@@ -115,7 +115,7 @@
   struct xrCraft *craft;
 
   /* Try to construct the name of the shared library containing this craft. */
-  snprintf (filename, sizeof filename, "craft/libcraft%s.so", name);
+  snprintf (filename, sizeof filename, "craft/libcraft%s.dylib", name);
 
   /* See if we can open this track. Make sure we resolve all link-time
    * errors now, and make sure that symbols from the track don't pollute
@@ -130,7 +130,7 @@
     }
 
   /* The shared library contains one symbol of interest: ``craft'' */
-  craft_struct = dlsym (lib, "craft");
+  craft_struct = dlsym (lib, "_craft");
 
   /* This is OK. This symbol should never actually be NULL. */
   if (craft_struct == NULL)

--- src/craft.c.orig	Thu Dec 12 12:33:22 2002
+++ src/craft.c	Thu Dec 12 12:33:58 2002
@@ -130,7 +130,7 @@
     }
 
   /* The shared library contains one symbol of interest: ``craft'' */
-  craft_struct = dlsym (lib, "craft");
+  craft_struct = dlsym (lib, "_craft");
 
   /* This is OK. This symbol should never actually be NULL. */
   if (craft_struct == NULL)

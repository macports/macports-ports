--- Source/script.cpp.old	Fri Feb  4 05:55:29 2005
+++ Source/script.cpp	Thu Mar  3 17:48:58 2005
@@ -2670,7 +2670,7 @@
         MANAGE_WITH(incfile, free);
         strcpy(incfile, f);
         glob_t globbuf;
-        if (!GLOB(incfile, GLOB_NOSORT, NULL, &globbuf))
+        if (!GLOB(incfile, GLOB_NOSORT, NULL, &globbuf) && globbuf.gl_pathc > 0)
         {
           for (unsigned int i = 0; i < globbuf.gl_pathc; i++)
           {

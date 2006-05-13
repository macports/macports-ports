diff -Nru src/plugins/wordleaker/wordextractor.cc ./src/plugins/wordleaker/wordextractor.cc
--- src/plugins/wordleaker/wordextractor.cc	2006-03-11 02:10:50.000000000 +0200
+++ ./src/plugins/wordleaker/wordextractor.cc	2006-04-17 12:06:04.000000000 +0300
@@ -84,7 +84,7 @@
 		      &t))
       return NULL;
       
-    return strndup(f, 128);
+    return strdup(f);
   }
   
   static const char * idToProduct( unsigned int id ) {

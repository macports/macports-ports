--- main.cc.orig	Sun Feb 13 17:59:27 2005
+++ main.cc	Sun Feb 13 17:59:37 2005
@@ -191,7 +191,7 @@
 void Ocrad::internal_error( const char * msg ) throw()
   {
   char buf[80];
-  std::snprintf( buf, sizeof( buf ), "internal error: %s.\n", msg );
+  snprintf( buf, sizeof( buf ), "internal error: %s.\n", msg );
   show_error( buf );
   exit( 3 );
   }

--- Theme.h	Thu Aug 21 02:20:20 2003
+++ Theme.h.new	Tue Sep  7 12:03:55 2004
@@ -81,7 +81,7 @@
 #ifndef WIN32
       DIR *dir;
       if ((dir = opendir(ThemeDir.c_str())) == NULL) {
-	ThemeDir = "/usr/share/games/gav/" + ThemeDir;
+	ThemeDir = "__PREFIX__/share/games/gav/" + ThemeDir;
 	if ((dir = opendir(ThemeDir.c_str())) == NULL) {
 	  std::cerr << "Cannot find themes directory\n";
 	  exit(0);

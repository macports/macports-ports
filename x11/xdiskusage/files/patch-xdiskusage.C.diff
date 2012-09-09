--- xdiskusage.C.orig	2004-09-21 07:23:14.000000000 +0200
+++ xdiskusage.C	2011-06-21 21:34:20.000000000 +0200
@@ -392,8 +392,8 @@
       strncpy(pathbuf, path, 1024);
       for (int i=0; i<10; i++) {
 	char *p = (char*)fl_filename_name(pathbuf);
-	int i = readlink(pathbuf, p, 1024-(p-pathbuf));
-	if (i < 0) {
+	int j = readlink(pathbuf, p, 1024-(p-pathbuf));
+	if (j < 0) {
 	  if (errno != EINVAL) {
 	    strcat(pathbuf, ": no such file");
 	    fl_alert(pathbuf);
@@ -401,8 +401,8 @@
 	  }
 	  break;
 	}
-	if (*p == '/') {memmove(pathbuf, p, i); p = pathbuf;}
-	p[i] = 0;
+	if (*p == '/') {memmove(pathbuf, p, j); p = pathbuf;}
+	p[j] = 0;
 	path = pathbuf;
       }
     }
@@ -988,7 +988,7 @@
 void OutputWindow::sort_cb(Fl_Widget* o, void*v) {
   OutputWindow* d = (OutputWindow*)(o->window());
   int (*compare)(const Node*, const Node*);
-  switch ((int)v) {
+  switch ((unsigned long)v) {
   case 's': compare = largestfirst; break;
   case 'r': compare = smallestfirst; break;
   case 'a': compare = alphabetical; break;
@@ -1001,7 +1001,7 @@
 
 void OutputWindow::columns_cb(Fl_Widget* o, void*v) {
   OutputWindow* d = (OutputWindow*)(o->window());
-  int n = (int)v;
+  unsigned long n = (unsigned long)v;
   ::ncols = n;
   if (n == d->ncols) return;
   if (d->current_depth > d->root_depth+n-1) {

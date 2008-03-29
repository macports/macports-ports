--- install3/obsoletes.c.orig	2008-02-02 22:30:16.000000000 +0100
+++ install3/obsoletes.c	2008-03-29 13:23:17.000000000 +0100
@@ -20,13 +20,14 @@
 static struct orphan *orphan_new(struct pkg *pkg, tn_array *caps) 
 {
     struct orphan *o;
+    int i;
 
     o = n_malloc(sizeof(*o));
     o->pkg = pkg_link(pkg);
     o->reqs = capreq_arr_new(4);
     n_array_ctl_set_freefn(o->reqs, NULL); /* weak ref */
     
-    for (int i=0; i < n_array_size(caps); i++) {
+    for (i=0; i < n_array_size(caps); i++) {
         const struct capreq *req;
         struct capreq *cap = n_array_nth(caps, i);
 

diff -uNr gcc-3.1.1.orig/gcc/stmt.c gcc-3.1.1/gcc/stmt.c
--- m3-sys/m3cc/gcc/gcc/stmt.c	Wed Apr 17 10:43:57 2002
+++ m3-sys/m3cc/gcc/gcc/stmt.c	Sun Sep  8 13:30:33 2002
@@ -5166,12 +5166,15 @@
       /* We deliberately use calloc here, not cmalloc, so that we can suppress
 	 this optimization if we don't have enough memory rather than
 	 aborting, as xmalloc would do.  */
-      && (cases_seen =
-	  (unsigned char *) really_call_calloc (bytes_needed, 1)) != NULL)
+        && (cases_seen = (unsigned char *)alloca(bytes_needed) ) != NULL )
+/*      && (cases_seen = */
+/*	  (unsigned char *) really_call_calloc (bytes_needed, 1)) != NULL) */
     {
       HOST_WIDE_INT i;
       tree v = TYPE_VALUES (type);
+      unsigned char *x;
 
+      for( x = cases_seen; x < cases_seen + bytes_needed; x++){ *x = 0; }
       /* The time complexity of this code is normally O(N), where
 	 N being the number of members in the enumerated type.
 	 However, if type is a ENUMERAL_TYPE whose values do not

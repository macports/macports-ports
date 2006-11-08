--- require.scm.orig	2006-10-22 04:43:34.000000000 +0200
+++ require.scm	2006-11-08 21:51:48.000000000 +0100
@@ -19,6 +19,13 @@
 ;@
 (define *slib-version* "3a4")
 
+;;;; Accommodate scm versions < 5e3 which set *features* but not
+;;;; slib:features
+;;;;   -- tb@debian.org, 10/24/2006
+(if (and (eq? (scheme-implementation-type) 'SCM)
+	 (not (defined? slib:features)))
+    (define slib:features *features*))
+
 ;;;; MODULES
 ;@
 (define *catalog* #f)

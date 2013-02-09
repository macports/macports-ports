--- setup.py.orig	2013-02-09 04:17:06.000000000 -0600
+++ setup.py	2013-02-09 04:24:46.000000000 -0600
@@ -10,9 +10,9 @@
 VERSION = '1.5'
 
 INCLUDES = {
-    'darwin': ['/usr/local/include'],
-    'linux': [],
-    'freebsd7': ['/usr/local/include'],
+    'darwin': ['@PREFIX@/include'],
+    'linux': ['@PREFIX@/include'],
+    'freebsd7': ['@PREFIX@/include'],
     'win32': ['c:/icu/include'],
     'sunos5': [],
 }
@@ -35,9 +35,9 @@
 }
 
 LFLAGS = {
-    'darwin': ['-L/usr/local/lib'],
-    'linux': [],
-    'freebsd7': ['-L/usr/local/lib'],
+    'darwin': ['-L@PREFIX@/lib'],
+    'linux': ['-L@PREFIX@/lib'],
+    'freebsd7': ['-L@PREFIX@/lib'],
     'win32': ['/LIBPATH:c:/icu/lib'],
     'sunos5': [],
 }

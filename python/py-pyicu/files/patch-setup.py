--- setup.py.orig	2014-06-05 14:43:04.000000000 -0700
+++ setup.py	2014-06-09 13:17:26.000000000 -0700
@@ -10,9 +10,9 @@
 VERSION = '1.8'
 
 INCLUDES = {
-    'darwin': ['/usr/local/include'],
-    'linux': [],
-    'freebsd': ['/usr/local/include'],
+    'darwin': ['@PREFIX@/include'],
+    'linux': ['@PREFIX@/include'],
+    'freebsd': ['@PREFIX@/include'],
     'win32': ['c:/icu/include'],
     'sunos5': [],
 }
@@ -35,9 +35,9 @@
 }
 
 LFLAGS = {
-    'darwin': ['-L/usr/local/lib'],
-    'linux': [],
-    'freebsd': ['-L/usr/local/lib'],
+    'darwin': ['-L@PREFIX@/lib'],
+    'linux': ['-L@PREFIX@/lib'],
+    'freebsd': ['-L@PREFIX@/lib'],
     'win32': ['/LIBPATH:c:/icu/lib'],
     'sunos5': [],
 }

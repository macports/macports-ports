--- setup.py.orig	2009-07-14 15:18:20.000000000 +0400
+++ setup.py	2009-07-14 15:21:18.000000000 +0400
@@ -11,7 +11,7 @@
 ICU_VERSION = '3.8'   # version 3.6 is also supported
 
 INCLUDES = {
-    'darwin': ['/usr/local/icu-%s/include' %(ICU_VERSION)],
+    'darwin': ['@PREFIX@/include'],
     'linux2': [],
     'win32': [],
 }
@@ -23,7 +23,7 @@
 }
 
 LFLAGS = {
-    'darwin': ['-L/usr/local/icu-%s/lib' %(ICU_VERSION)],
+    'darwin': ['-L@PREFIX@/lib'],
     'linux2': [],
     'win32': [],
 }

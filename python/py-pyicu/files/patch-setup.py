--- setup.py.orig	2016-11-11 10:59:29.000000000 -0800
+++ setup.py	2017-01-03 13:51:45.000000000 -0800
@@ -11,9 +11,9 @@
 ICU_VERSION = subprocess.check_output(('icu-config', '--version')).strip()
 
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
@@ -36,9 +36,9 @@
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

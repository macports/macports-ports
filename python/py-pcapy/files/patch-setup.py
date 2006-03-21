--- setup.py.orig	2005-09-14 09:06:56.000000000 -0600
+++ setup.py	2006-03-21 14:27:58.000000000 -0700
@@ -6,8 +6,8 @@
 PACKAGE_NAME = 'pcapy'
 
 # You might want to change these to reflect your specific configuration
-include_dirs = []
-library_dirs = []
+include_dirs = ['@@PREFIX@@/include']
+library_dirs = ['@@PREFIX@@/lib']
 libraries = []
 
 if sys.platform =='win32':

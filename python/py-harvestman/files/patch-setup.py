--- setup.py.orig	Fri Feb 13 18:07:36 2004
+++ setup.py	Wed Apr 28 18:42:46 2004
@@ -4,13 +4,13 @@
 from distutils.core import setup
 
 setup(name="HarvestMan",
-      version="1.3.2",
+      version="1.3.4",
       description="HarvestMan - Multithreaded Offline Browser/Web Crawler",
       author="Anand B Pillai",
       author_email="anand_pillai@fastmail.fm",
       url="http://harvestman.freezope.org/",
       license="Open Software License v 1.1",
       packages = ['HarvestMan', 'HarvestMan.utils'],
-      data_files = [('lib/site-packages', ['extra/Sgmlop.py', 'extra/Sgmlop.pyd']),],
+#      data_files = [('lib/site-packages', ['extra/Sgmlop.py', 'extra/Sgmlop.pyd']),],
       )
 

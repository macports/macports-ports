--- setup.py	Wed Aug  4 18:41:16 2004
+++ setup.py.new	Sat Oct  9 15:29:07 2004
@@ -39,7 +39,7 @@
     datadir or prefix,
     'share',
     'doc',
-    'getmail-%s' % __version__
+    'getmail'
 )
 
 GETMAILMANDIR = os.path.join(

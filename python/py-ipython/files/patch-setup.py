--- setup.py	Wed Dec  1 00:32:32 2004
+++ setup.py.new	Sun Dec  5 20:50:27 2004
@@ -99,7 +99,7 @@
 
 # I can't find how to make distutils create a nested dir. structure, so
 # in the meantime do it manually. Butt ugly.
-docdirbase  = 'share/doc/ipython-%s' % version
+docdirbase  = 'share/doc/py-ipython'
 manpagebase = 'share/man/man1'
 
 # We only need to exclude from this things NOT already excluded in the

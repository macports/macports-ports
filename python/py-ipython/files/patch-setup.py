--- setup.py	Thu Nov  4 08:35:11 2004
+++ setup.py.new	Tue Nov 30 13:08:17 2004
@@ -88,7 +88,7 @@
 
 # I can't find how to make distutils create a nested dir. structure, so
 # in the meantime do it manually. Butt ugly.
-docdirbase  = 'share/doc/IPython'
+docdirbase  = 'share/doc/py-ipython'
 manpagebase = 'share/man/man1'
 docfiles    = filter(isfile, glob('doc/*[!~|.lyx|.sh|.1|.1.gz]'))
 examfiles   = filter(isfile, glob('doc/examples/*.py'))

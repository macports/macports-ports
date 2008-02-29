--- Lib/site.py	Tue Jul 20 04:28:28 2004
+++ Lib/site.py.new	Mon Apr  4 10:47:12 2005
@@ -186,6 +186,7 @@
             else:
                 sitedirs = [prefix, os.path.join(prefix, "lib", "site-packages")]
             if sys.platform == 'darwin':
+                sitedirs.append( os.path.join('__PREFIX__', 'lib', 'python2.4', 'site-packages') )
                 # for framework builds *only* we add the standard Apple
                 # locations. Currently only per-user, but /Library and
                 # /Network/Library could be added too

--- setup.py	Thu Jul 18 15:55:36 2002
+++ setup.py.diffme	Wed Jan  7 21:09:12 2004
@@ -20,15 +20,15 @@
 name = "MySQL-%s" % os.path.basename(sys.executable)
 version = "0.9.2"
 
-mysqlclient = thread_safe_library and "mysqlclient_r" or "mysqlclient"
+mysqlclient = thread_safe_library and "mysqlclient"
 
 # include files and library locations should cover most platforms
 include_dirs = [
-    '/usr/include/mysql', '/usr/local/include/mysql',
+   '__PREFIX/include/mysql',  '/usr/include/mysql', '/usr/local/include/mysql',
     '/usr/local/mysql/include/mysql'
     ]
 library_dirs = [
-    '/usr/lib/mysql', '/usr/local/lib/mysql',
+    '__PREFIX/lib/mysql', '/usr/lib/mysql', '/usr/local/lib/mysql',
     '/usr/local/mysql/lib/mysql'
     ]
 
@@ -69,8 +69,8 @@
     library_dirs = ['/c/mysql/lib']
     extra_compile_args.append('-DMS_WIN32')
 elif sys.platform[:6] == "darwin": # Mac OS X
-    include_dirs.append('/sw/include')
-    library_dirs.append('/sw/lib')
+    include_dirs = ['__PREFIX/include/mysql']
+    library_dirs = ['__PREFIX/lib/mysql']
     extra_link_args.append('-flat_namespace')
 elif sys.platform == 'linux2' and os.environ.get('HOSTTYPE') == 'alpha':
     libraries.extend(['ots', 'cpml'])

--- FSObject.py.orig	Sat Sep 14 11:23:19 2002
+++ FSObject.py	Mon Dec 15 21:03:42 2003
@@ -180,16 +180,18 @@
             self._fs_update_mtime()
         except EnvironmentError, err: 
             if (err[0] == errno.EACCES):
-                if os.path.exists(tmp_path):
+                if os.path.exists(self._fs_data.path):
                     raise 'Forbidden', HTTPResponse()._error_html(
                         'Forbidden',
                         "Sorry, you do not have permission to overwrite "
-                        "this file.<p>")
+                        "this file: %s<p>"
+                        % self._fs_data.path)
                 else:
                     raise 'Forbidden', HTTPResponse()._error_html(
                         'Forbidden',
                         "Sorry, you do not have permission to write "
-                        "to this directory.<p>")
+                        "to this directory: %s<p>"
+                        % os.path.dirname(self._fs_data.path))
             else: raise
 
     def _fs_write(self,file,write_props=1):
@@ -235,16 +237,18 @@
             self._fs_props.write()
         except EnvironmentError, err: 
             if (err[0] == errno.EACCES):
-                if os.path.exists(tmp_path):
+                if os.path.exists(self._fs_props.path):
                     raise 'Forbidden', HTTPResponse()._error_html(
                         'Forbidden',
                         "Sorry, you do not have permission to overwrite "
-                        "this file.<p>")
+                        "this file: %s<p>"
+                        % self._fs_props.path)
                 else:
                     raise 'Forbidden', HTTPResponse()._error_html(
                         'Forbidden',
                         "Sorry, you do not have permission to write "
-                        "to this directory.<p>")
+                        "to this directory: %s<p>"
+                        % os.path.dirname(self._fs_props.path))
             else: raise
 
     def _fs_write_props(self,file):

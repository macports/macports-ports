--- lib/python/zdaemon/zdctl.py.orig	Thu Dec  4 22:07:10 2003
+++ lib/python/zdaemon/zdctl.py	Thu Dec  4 22:07:23 2003
@@ -207,7 +207,7 @@
                 "-x", "exitcodes", ",".join(map(str, self.options.exitcodes)))
             args += self._get_override("-z", "directory")
             args.extend(self.options.program)
-            if self.options.daemon:
+            if not self.options.daemon:
                 flag = os.P_WAIT
             else:
                 flag = os.P_NOWAIT


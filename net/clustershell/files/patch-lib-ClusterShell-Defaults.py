--- lib/ClusterShell/Defaults.py	2016-11-21 12:50:40.000000000 -0800
+++ lib/ClusterShell/Defaults.py	2016-11-21 12:51:42.000000000 -0800
@@ -69,7 +69,7 @@
 
 def config_paths(config_name):
     """Return default path list for a ClusterShell config file name."""
-    return ['/etc/clustershell/%s' % config_name, # system-wide config file
+    return ['@MACPORTS_PREFIX@/etc/clustershell/%s' % config_name, # system-wide config file
             # default pip --user config file
             os.path.expanduser('~/.local/etc/clustershell/%s' % config_name),
             # per-user config (top override)

--- zeroinstall//zerostore/unpack.py.orig	2007-06-28 17:35:31.000000000 +0200
+++ zeroinstall//zerostore/unpack.py	2007-10-15 09:34:05.000000000 +0200
@@ -30,7 +30,7 @@ _tar_version = None
 def _get_tar_version():
 	global _tar_version
 	if _tar_version is None:
-		_tar_version = os.popen('tar --version 2>&1').next().strip()
+		_tar_version = os.popen('tar --version 2>&1 | sed "s/ +CVE-....-....//g"').next().strip()
 		debug("tar version = %s", _tar_version)
 	return _tar_version
 

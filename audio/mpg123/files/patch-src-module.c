http://sourceforge.net/tracker/?func=detail&aid=2901661&group_id=135704&atid=733194
--- src/module.c-orig	2009-11-18 11:21:01.000000000 -0600
+++ src/module.c	2009-12-02 11:35:53.000000000 -0600
@@ -121,13 +121,13 @@
 		goto om_bad;
 	}
 	/* Work out the path of the module to open */
-	module_path_len = strlen(type) + 1 + strlen(name) + strlen(MODULE_FILE_SUFFIX) + 1;
+	module_path_len = 2 + strlen(type) + 1 + strlen(name) + strlen(MODULE_FILE_SUFFIX) + 1;
 	module_path = malloc( module_path_len );
 	if (module_path == NULL) {
 		error1( "Failed to allocate memory for module name: %s", strerror(errno) );
 		goto om_bad;
 	}
-	snprintf( module_path, module_path_len, "%s_%s%s", type, name, MODULE_FILE_SUFFIX );
+	snprintf( module_path, module_path_len, "./%s_%s%s", type, name, MODULE_FILE_SUFFIX );
 	/* Display the path of the module created */
 	debug1( "Module path: %s", module_path );
 

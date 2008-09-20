--- erts/emulator/sys/unix/erl_unix_sys_ddll.c	2007-11-26 20:01:23.000000000 +0100
+++ erts/emulator/sys/unix/erl_unix_sys_ddll.c	2008-09-07 10:13:54.000000000 +0200
@@ -127,6 +127,7 @@
 	    } else {
 		ret = ERL_DE_ERROR_UNSPECIFIED;
 	    }
+		NSDestroyObjectFileImage(ofile);
 	    break;
 	/* XXX:PaN should anything return something else ? */
 	/*case NSObjectFileImageInappropriateFile:
@@ -240,7 +241,15 @@
 int erts_sys_ddll_close(void *handle)
 {
 #if defined(HAVE_MACH_O_DYLD_H)
-    return ERL_DE_NO_ERROR; /* XXX:PaN No close functionality in MacOSX??? */
+    {
+	int ret;
+	if (NSUnLinkModule((NSModule) handle, NSUNLINKMODULE_OPTION_NONE)) {
+	    ret = ERL_DE_NO_ERROR;
+	} else {
+	    ret = ERL_DE_ERROR_UNSPECIFIED;
+	}
+	return ret;
+    }
 #elif defined(HAVE_DLOPEN)
     {
 	int ret;

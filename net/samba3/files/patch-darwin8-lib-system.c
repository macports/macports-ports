--- lib/system.c	2005-07-28 15:19:45.000000000 +0200
+++ lib/system.c	2005-08-26 15:21:01.000000000 +0200
@@ -1373,7 +1373,12 @@
 ssize_t sys_getxattr (const char *path, const char *name, void *value, size_t size)
 {
 #if defined(HAVE_GETXATTR)
+#if DARWINOS
+	int options = 0;
+	return getxattr(path, name, value, size, 0, options);
+#else
 	return getxattr(path, name, value, size);
+#endif
 #elif defined(HAVE_EXTATTR_GET_FILE)
 	char *s;
 	int attrnamespace = (strncmp(name, "system", 6) == 0) ? 
@@ -1427,7 +1432,12 @@
 ssize_t sys_fgetxattr (int filedes, const char *name, void *value, size_t size)
 {
 #if defined(HAVE_FGETXATTR)
+#if DARWINOS
+	int options = 0;
+	return fgetxattr(filedes, name, value, size, 0, options);
+#else
 	return fgetxattr(filedes, name, value, size);
+#endif
 #elif defined(HAVE_EXTATTR_GET_FD)
 	char *s;
 	int attrnamespace = (strncmp(name, "system", 6) == 0) ? 
@@ -1615,7 +1625,12 @@
 ssize_t sys_listxattr (const char *path, char *list, size_t size)
 {
 #if defined(HAVE_LISTXATTR)
+#if DARWINOS
+	int options = 0;
+	return listxattr(path, list, size, options);
+#else
 	return listxattr(path, list, size);
+#endif
 #elif defined(HAVE_EXTATTR_LIST_FILE)
 	extattr_arg arg;
 	arg.path = path;
@@ -1647,7 +1662,12 @@
 ssize_t sys_flistxattr (int filedes, char *list, size_t size)
 {
 #if defined(HAVE_FLISTXATTR)
+#if DARWINOS
+	int options = 0;
+	return flistxattr(filedes, list, size, options);
+#else
 	return flistxattr(filedes, list, size);
+#endif
 #elif defined(HAVE_EXTATTR_LIST_FD)
 	extattr_arg arg;
 	arg.filedes = filedes;
@@ -1663,7 +1683,12 @@
 int sys_removexattr (const char *path, const char *name)
 {
 #if defined(HAVE_REMOVEXATTR)
+#if DARWINOS
+	int options = 0;
+	return removexattr(path, name, options);
+#else
 	return removexattr(path, name);
+#endif
 #elif defined(HAVE_EXTATTR_DELETE_FILE)
 	char *s;
 	int attrnamespace = (strncmp(name, "system", 6) == 0) ? 
@@ -1711,7 +1736,12 @@
 int sys_fremovexattr (int filedes, const char *name)
 {
 #if defined(HAVE_FREMOVEXATTR)
+#if DARWINOS
+	int options = 0;
+	return fremovexattr(filedes, name, options);
+#else
 	return fremovexattr(filedes, name);
+#endif
 #elif defined(HAVE_EXTATTR_DELETE_FD)
 	char *s;
 	int attrnamespace = (strncmp(name, "system", 6) == 0) ? 
@@ -1740,7 +1770,12 @@
 int sys_setxattr (const char *path, const char *name, const void *value, size_t size, int flags)
 {
 #if defined(HAVE_SETXATTR)
+#if DARWINOS
+	int options = 0;
+	return setxattr(path, name, value, size, 0, options);
+#else
 	return setxattr(path, name, value, size, flags);
+#endif
 #elif defined(HAVE_EXTATTR_SET_FILE)
 	char *s;
 	int retval = 0;
@@ -1796,7 +1831,12 @@
 int sys_fsetxattr (int filedes, const char *name, const void *value, size_t size, int flags)
 {
 #if defined(HAVE_FSETXATTR)
+#if DARWINOS
+	int options = 0;
+	return fsetxattr(filedes, name, value, size, 0, options);
+#else
 	return fsetxattr(filedes, name, value, size, flags);
+#endif
 #elif defined(HAVE_EXTATTR_SET_FD)
 	char *s;
 	int retval = 0;

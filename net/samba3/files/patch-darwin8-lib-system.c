--- lib/system.c	2005-04-14 08:14:23.000000000 +0200
+++ lib/system.c	2005-06-03 00:31:51.000000000 +0200
@@ -1372,7 +1372,13 @@
 ssize_t sys_getxattr (const char *path, const char *name, void *value, size_t size)
 {
 #if defined(HAVE_GETXATTR)
+	#if DARWINOS
+		int options = 0;
+
+		return getxattr(path, name, value, size, 0, options);		
+	#else
 	return getxattr(path, name, value, size);
+	#endif
 #elif defined(HAVE_ATTR_GET)
 	int retval, flags = 0;
 	int valuelength = (int)size;
@@ -1412,7 +1418,13 @@
 ssize_t sys_fgetxattr (int filedes, const char *name, void *value, size_t size)
 {
 #if defined(HAVE_FGETXATTR)
+	#if DARWINOS
+		int options = 0;
+
+		return fgetxattr(filedes, name, value, size, 0, options);		
+	#else
 	return fgetxattr(filedes, name, value, size);
+	#endif
 #elif defined(HAVE_ATTR_GETF)
 	int retval, flags = 0;
 	int valuelength = (int)size;
@@ -1500,7 +1512,12 @@
 ssize_t sys_listxattr (const char *path, char *list, size_t size)
 {
 #if defined(HAVE_LISTXATTR)
+	#if DARWINOS
+		int options = 0;
+		return listxattr(path, list, size, options);	
+	#else
 	return listxattr(path, list, size);
+	#endif
 #elif defined(HAVE_ATTR_LIST) && defined(HAVE_SYS_ATTRIBUTES_H)
 	return irix_attr_list(path, 0, list, size, 0);
 #else
@@ -1524,7 +1541,12 @@
 ssize_t sys_flistxattr (int filedes, char *list, size_t size)
 {
 #if defined(HAVE_FLISTXATTR)
+	#if DARWINOS
+		int options = 0;
+		return flistxattr(filedes, list, size, options);	
+	#else
 	return flistxattr(filedes, list, size);
+	#endif
 #elif defined(HAVE_ATTR_LISTF)
 	return irix_attr_list(NULL, filedes, list, size, 0);
 #else
@@ -1536,7 +1558,12 @@
 int sys_removexattr (const char *path, const char *name)
 {
 #if defined(HAVE_REMOVEXATTR)
+	#if DARWINOS
+		int options = 0;
+		return removexattr(path, name, options);	
+	#else
 	return removexattr(path, name);
+	#endif
 #elif defined(HAVE_ATTR_REMOVE)
 	int flags = 0;
 	char *attrname = strchr(name,'.') +1;
@@ -1570,7 +1597,12 @@
 int sys_fremovexattr (int filedes, const char *name)
 {
 #if defined(HAVE_FREMOVEXATTR)
+	#if DARWINOS
+		int options = 0;
+		return fremovexattr(filedes, name, options);	
+	#else
 	return fremovexattr(filedes, name);
+	#endif
 #elif defined(HAVE_ATTR_REMOVEF)
 	int flags = 0;
 	char *attrname = strchr(name,'.') +1;
@@ -1592,7 +1624,13 @@
 int sys_setxattr (const char *path, const char *name, const void *value, size_t size, int flags)
 {
 #if defined(HAVE_SETXATTR)
+	#if DARWINOS
+		int options = 0; 
+				
+		return setxattr(path, name, value, size, 0, options);		
+	#else
 	return setxattr(path, name, value, size, flags);
+	#endif
 #elif defined(HAVE_ATTR_SET)
 	int myflags = 0;
 	char *attrname = strchr(name,'.') +1;
@@ -1630,7 +1668,13 @@
 int sys_fsetxattr (int filedes, const char *name, const void *value, size_t size, int flags)
 {
 #if defined(HAVE_FSETXATTR)
+	#if DARWINOS
+		int options = 0;
+
+		return fsetxattr(filedes, name, value, size, 0, options);		
+	#else
 	return fsetxattr(filedes, name, value, size, flags);
+	#endif
 #elif defined(HAVE_ATTR_SETF)
 	int myflags = 0;
 	char *attrname = strchr(name,'.') +1;

--- source/network.c.orig	Wed Feb  2 18:53:30 2005
+++ source/network.c	Wed Feb  2 18:54:21 2005
@@ -287,8 +287,11 @@
 	 * return *len == 0 for port != -1, then /dcc breaks.
 	 */
 	if ((family == AF_UNIX) || 
-            (family == AF_INET && port == -1 && LocalIPv4HostName == NULL) ||
-            (family == AF_INET6 && port == -1 && LocalIPv6HostName == NULL))
+            (family == AF_INET && port == -1 && LocalIPv4HostName == NULL)
+#ifdef INET6
+            || (family == AF_INET6 && port == -1 && LocalIPv6HostName == NULL)
+#endif
+            )
 	{
 		*len = 0;
 		return 0;		/* No vhost needed */
@@ -296,8 +299,10 @@
 
 	if (family == AF_INET)
 		lhn = LocalIPv4HostName;
+#ifdef INET6
 	else if (family == AF_INET6)
 		lhn = LocalIPv6HostName;
+#endif
 	else
 		lhn = NULL;
 

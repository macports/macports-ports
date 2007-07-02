--- ./smart/util/filetools.py.jbj	2005-08-27 19:27:09.000000000 -0400
+++ ./smart/util/filetools.py	2005-08-27 19:28:33.000000000 -0400
@@ -65,7 +65,10 @@
         pass
 
 def setCloseOnExecAll():
-    for fd in range(3,resource.getrlimit(resource.RLIMIT_NOFILE)[1]):
+    nfmax = resource.getrlimit(resource.RLIMIT_NOFILE)[1]
+    if nfmax > 4096:
+	nfmax = 4096
+    for fd in range(3,nfmax):
         try:
             flags = fcntl.fcntl(fd, fcntl.F_GETFL, 0)
             flags |= fcntl.FD_CLOEXEC

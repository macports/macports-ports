--- src/lib/ioloop-select.c.old	2005-12-12 19:21:05.000000000 -0800
+++ src/lib/ioloop-select.c	2005-12-12 19:21:49.000000000 -0800
@@ -113,7 +113,7 @@
 	       sizeof(fd_set));
 	memcpy(&tmp_write_fds, &ioloop->handler_context->write_fds,
 	       sizeof(fd_set));
-	memcpy(&tmp_except_fds, &ioloop->handler_data->except_fds,
+	memcpy(&tmp_except_fds, &ioloop->handler_context->except_fds,
 	       sizeof(fd_set));
 
 	ret = select(ioloop->handler_context->highest_fd + 1,

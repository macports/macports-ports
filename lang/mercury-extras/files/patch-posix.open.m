--- posix/posix.open.m.sav	Fri Aug  6 11:40:52 2004
+++ posix/posix.open.m	Fri Aug  6 11:41:17 2004
@@ -52,6 +52,7 @@
 :- pragma c_header_code("
 	#include <unistd.h>
 	#include <fcntl.h>
+	#include <sys/aio.h>
 ").
 
 %------------------------------------------------------------------------------%

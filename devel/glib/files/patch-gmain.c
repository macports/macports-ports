--- gmain.c~	Mon Feb 26 22:00:21 2001
+++ gmain.c	Sun Aug 24 13:46:51 2003
@@ -187,6 +187,8 @@
 /* SunOS has poll, but doesn't provide a prototype. */
 #  if defined (sun) && !defined (__SVR4)
 extern gint poll (GPollFD *ufds, guint nfsd, gint timeout);
+#else
+#include <poll.h>      /* The opengroup defines the poll.h header as standard */
 #  endif  /* !sun */
 static GPollFunc poll_func = (GPollFunc) poll;
 #else	/* !HAVE_POLL */

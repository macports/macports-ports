--- glib-1.2.8/gmain.c~	Thu May 18 22:58:48 2000
+++ glib-1.2.8/gmain.c	Sun Aug 24 13:44:20 2003
@@ -187,6 +187,8 @@
 /* SunOS has poll, but doesn't provide a prototype. */
 #  if defined (sun) && !defined (__SVR4)
 extern gint poll (GPollFD *ufds, guint nfsd, gint timeout);
+#else
+#include <poll.h>      /* The opengroup defines the poll.h header as standard */
 #  endif  /* !sun */
 static GPollFunc poll_func = (GPollFunc) poll;
 #else	/* !HAVE_POLL */

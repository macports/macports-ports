--- glib/gmain.c~	Thu Jun  5 20:54:27 2003
+++ glib/gmain.c	Sun Aug 24 16:34:02 2003
@@ -249,6 +249,8 @@
 /* SunOS has poll, but doesn't provide a prototype. */
 #  if defined (sun) && !defined (__SVR4)
 extern gint poll (GPollFD *ufds, guint nfsd, gint timeout);
+#else
+#include <poll.h>      /* The opengroup defines the poll.h header as standard */
 #  endif  /* !sun */
 #else	/* !HAVE_POLL */
 

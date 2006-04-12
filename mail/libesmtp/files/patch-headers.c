*** headers.c.orig	2006-03-30 19:30:35.000000000 +0200
--- headers.c	2006-03-30 19:57:05.000000000 +0200
***************
*** 29,36 ****
--- 29,38 ----
  #include <stdio.h>
  #include <stdarg.h>
  #include <string.h>
+ #include <strings.h>
  #include <stdlib.h>
  #include <unistd.h>
+ #include <sys/time.h>
  #include <time.h>
  #include <errno.h>
  
***************
*** 168,174 ****
      {
  #ifdef HAVE_GETTIMEOFDAY
        if (gettimeofday (&tv, NULL) == -1) /* This shouldn't fail ... */
! 	snprintf (buf, sizeof buf, "%ld.%ld.%d@%s", tv.tv_sec, tv.tv_usec,
  		  getpid (), message->session->localhost);
        else /* ... but if it does fall back to using time() */
  #endif
--- 170,176 ----
      {
  #ifdef HAVE_GETTIMEOFDAY
        if (gettimeofday (&tv, NULL) == -1) /* This shouldn't fail ... */
! 	snprintf (buf, sizeof buf, "%ld.%d.%d@%s", tv.tv_sec, tv.tv_usec,
  		  getpid (), message->session->localhost);
        else /* ... but if it does fall back to using time() */
  #endif

--- libmutt/charset.h.org	Tue Oct 28 17:41:29 2003
+++ libmutt/charset.h	Tue Oct 28 17:51:04 2003
@@ -16,6 +16,10 @@
  *     Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111, USA.
  */
 
+#ifndef ICONV_CONST
+#define ICONV_CONST const
+#endif
+
 #ifndef _CHARSET_H
 #define _CHARSET_H
 
@@ -25,12 +29,6 @@
 
 #ifndef HAVE_ICONV_T_DEF
 typedef void *iconv_t;
-#endif
-
-#ifndef HAVE_ICONV
-iconv_t iconv_open (const char *, const char *);
-size_t iconv (iconv_t, ICONV_CONST char **, size_t *, char **, size_t *);
-int iconv_close (iconv_t);
 #endif
 
 int mutt_convert_string (char **, const char *, const char *, int);

--- libmutt/charset.c.org	Tue Oct 28 17:57:23 2003
+++ libmutt/charset.c	Tue Oct 28 17:57:57 2003
@@ -286,27 +286,6 @@
 }
 
 
-#ifndef HAVE_ICONV
-
-iconv_t iconv_open (const char *tocode, const char *fromcode)
-{
-  return (iconv_t)(-1);
-}
-
-size_t iconv (iconv_t cd, ICONV_CONST **inbuf, size_t *inbytesleft,
-	      char **outbuf, size_t *outbytesleft)
-{
-  return 0;
-}
-
-int iconv_close (iconv_t cd)
-{
-  return 0;
-}
-
-#endif /* !HAVE_ICONV */
-
-
 /*
  * Like iconv_open, but canonicalises the charsets
  */

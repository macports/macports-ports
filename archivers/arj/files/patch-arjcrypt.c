--- arjcrypt.c-orig	Sun Jun 22 15:12:28 2003
+++ arjcrypt.c	Tue Aug  3 12:51:15 2004
@@ -321,13 +321,10 @@
 
 /* Main routine - just a stub. Don't even need it in an OS/2 DLL. */
 
-#if TARGET==DOS
 int main()
 {
- out_str(M_ARJCRYPT_BANNER);
  return(0);
 }
-#endif
 
 /* External entry */
 

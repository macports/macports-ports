--- ../vnc_unixsrc/include/vncauth.h	2000-06-11 12:00:51.000000000 +0000
+++ include/vncauth.h	2007-05-15 10:20:58.000000000 +0000
@@ -25,6 +25,7 @@
 #define CHALLENGESIZE 16
 
 extern int vncEncryptAndStorePasswd(char *passwd, char *fname);
+extern int vncEncryptAndStorePasswd2(char *passwd, char *passwdViewOnly, char *fname);
 extern char *vncDecryptPasswdFromFile(char *fname);
 extern void vncRandomBytes(unsigned char *bytes);
 extern void vncEncryptBytes(unsigned char *bytes, char *passwd);

--- lib/krb4.c.orig	Thu Nov 11 11:34:24 2004
+++ lib/krb4.c	Wed Feb 23 15:39:22 2005
@@ -199,7 +199,8 @@
 {
   int ret;
   char *p;
-  int len;
+  unsigned char *ptr;
+  size_t len;
   KTEXT_ST adat;
   MSG_DAT msg_data;
   int checksum;
@@ -275,11 +276,17 @@
     return AUTH_ERROR;
   }
   p += 5;
-  len = Curl_base64_decode(p, (char *)adat.dat);
-  if(len < 0) {
+  len = Curl_base64_decode(p, &ptr);
+  if(len > sizeof(adat.dat)-1) {
+    free(ptr);
+    len=0;
+  }
+  if(!len || !ptr) {
     Curl_failf(data, "Failed to decode base64 from server");
     return AUTH_ERROR;
   }
+  memcpy((char *)adat.dat, ptr, len);
+  free(ptr);
   adat.length = len;
   ret = krb_rd_safe(adat.dat, adat.length, &d->key,
                     (struct sockaddr_in *)hisctladdr,
@@ -317,10 +324,11 @@
   char *name;
   char *p;
   char passwd[100];
-  int tmp;
+  size_t tmp;
   ssize_t nread;
   int save;
   CURLcode result;
+  unsigned char *ptr;
 
   save = Curl_set_command_prot(conn, prot_private);
 
@@ -346,12 +354,18 @@
   }
 
   p += 2;
-  tmp = Curl_base64_decode(p, (char *)tkt.dat);
-  if(tmp < 0) {
+  tmp = Curl_base64_decode(p, &ptr);
+  if(tmp >= sizeof(tkt.dat)) {
+    free(ptr);
+    tmp=0;
+  }
+  if(!tmp || !ptr) {
     Curl_failf(conn->data, "Failed to decode base64 in reply.\n");
     Curl_set_command_prot(conn, save);
     return CURLE_FTP_WEIRD_SERVER_REPLY;
   }
+  memcpy((char *)tkt.dat, ptr, tmp);
+  free(ptr);
   tkt.length = tmp;
   tktcopy.length = tkt.length;
 

--- aes.c	Thu Jan 24 15:02:24 2002
+++ aes.c	Sat Dec 18 22:11:50 2004
@@ -84,7 +84,7 @@
 ***************/
 static void
 aes_dealloc(AesObject *rijnp) {
-  PyMem_DEL(rijnp);  /* add it back to the free object list. */
+  free(rijnp);
 }
 
 /***************

See: https://github.com/pluskid/rmmseg-cpp/commit/279bd6fdb6307b24068d343005cfbf918bba88d7
--- aes.c	2024-03-09 12:42:29
+++ aes.c	2024-03-09 12:59:17
@@ -100,8 +100,8 @@
 
   Check_Type(key, T_STRING);
 
-  hexkey_len=RSTRING(key)->len;
-  hexkey=RSTRING(key)->ptr;
+  hexkey_len=RSTRING_LEN(key);
+  hexkey=RSTRING_PTR(key);
 
 
   if (hexkey_len != 16*2 && hexkey_len != 24*2 && hexkey_len != 32*2) {
@@ -139,8 +139,8 @@
   u1byte out_blk[16];
 
   Check_Type(args, T_STRING); /* make sure it's a string */
-  data_len=RSTRING(args)->len;
-  data=RSTRING(args)->ptr;
+  data_len=RSTRING_LEN(args);
+  data=RSTRING_PTR(args);
 
   Data_Get_Struct(self,AesObject, rijnp);
   if (data_len != 16) {
@@ -179,8 +179,8 @@
   int i;
 
   Check_Type(args,T_STRING); /* make sure it's a string. */
-  src=RSTRING(args)->ptr;
-  src_len=RSTRING(args)->len;
+  src=RSTRING_PTR(args);
+  src_len=RSTRING_LEN(args);
 
   if (src_len != 16) {
     rb_raise(rb_eArgError, "wrong data length (must be 16 bytes, found %d bytes)", src_len);
@@ -217,8 +217,8 @@
 
   Check_Type(args,T_STRING);  /* make sure it's a string. */
   
-  src=RSTRING(args)->ptr;
-  srclen=RSTRING(args)->len;
+  src=RSTRING_PTR(args);
+  srclen=RSTRING_LEN(args);
 
    Data_Get_Struct(self,AesObject,rijnp);
   
@@ -274,8 +274,8 @@
   VALUE retvalue;
 
   Check_Type(args, T_STRING); /* make sure it's a string */
-  srclen=RSTRING(args)->len;
-  src=RSTRING(args)->ptr;
+  srclen=RSTRING_LEN(args);
+  src=RSTRING_PTR(args);
 
   Data_Get_Struct(self,AesObject, rijnp);
 
@@ -315,8 +315,8 @@
   u1byte out_blk[16];
 
   Check_Type(args, T_STRING); /* make sure it's a string */
-  data_len=RSTRING(args)->len;
-  data=RSTRING(args)->ptr;
+  data_len=RSTRING_LEN(args);
+  data=RSTRING_PTR(args);
 
 
   if (data_len != 16) {

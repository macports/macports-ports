--- include/prothon/prothon.h.orig	Mon Jan  3 20:46:37 2005
+++ include/prothon/prothon.h	Mon Jan  3 20:47:35 2005
@@ -718,7 +718,7 @@
 
 // SET_STRING_DATA: Change an existing object's data to string data
 // clobbers any esisting data pointer
-void c2pr_strcpy(isp ist, obj_p obj, char* p, size_t len);
+void c2pr_strcpy(isp ist, obj_p obj, char* p, data_size_t len);
 
 // PR_STRPTR: retreive string object as a C string
 char* pr2c_strptr(isp ist, obj_p str_obj);

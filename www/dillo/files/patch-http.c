--- src/IO/http.c.sav	Mon May 12 11:47:25 2003
+++ src/IO/http.c	Mon May 12 11:47:43 2003
@@ -252,7 +252,7 @@
 #endif
    SocketData_t *S;
    DilloHost *dh;
-   socklen_t socket_len = 0;
+   size_t socket_len = 0;
 
    S = a_Klist_get_data(ValidSocks, GPOINTER_TO_INT(Info->LocalKey));
 

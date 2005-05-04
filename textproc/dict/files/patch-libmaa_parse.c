--- libmaa/parse.c.orig	2005-05-03 20:43:33.000000000 -0700
+++ libmaa/parse.c	2005-05-03 20:44:32.000000000 -0700
@@ -75,7 +75,7 @@
 
    if (!cpp) {
       if ((cpp = getenv( "KHEPERA_CPP" ))) {
-         PRINTF(MAA_PARSE,(__FUNCTION__ ": Using KHEPERA_CPP from %s\n",cpp));
+         PRINTF(MAA_PARSE,("%s: Using KHEPERA_CPP from %s\n",__FUNCTION__, cpp));
       }
       
                                 /* Always look for gcc's cpp first, since
@@ -86,7 +86,7 @@
          
          if (fread( buf, 1, 1023, tmp ) > 0) {
             if ((t = strchr( buf, '\n' ))) *t = '\0';
-            PRINTF(MAA_PARSE,(__FUNCTION__ ": Using GNU cpp from %s\n",buf));
+            PRINTF(MAA_PARSE,("%s: Using GNU cpp from %s\n",__FUNCTION__,buf));
             cpp = str_find( buf );
             extra_options = "-nostdinc -nostdinc++";
          }
@@ -103,7 +103,7 @@
          for (pt = cpps; **pt; pt++) {
             if (!access( *pt, X_OK )) {
                PRINTF(MAA_PARSE,
-                      (__FUNCTION__ ": Using system cpp from %s\n",*pt));
+                      ("%s: Using system cpp from %s\n",__FUNCTION__,*pt));
                cpp = *pt;
                break;
             }
@@ -123,7 +123,7 @@
    sprintf( buffer, "%s -I. %s %s 2>/dev/null", cpp,
 	    _prs_cpp_options ? _prs_cpp_options : "", filename );
 
-   PRINTF(MAA_PARSE,(__FUNCTION__ ": %s\n",buffer));
+   PRINTF(MAA_PARSE,("%s: %s\n",__FUNCTION__,buffer));
    if (!(yyin = popen( buffer, "r" )))
       err_fatal_errno( __FUNCTION__,
 		       "Cannot open \"%s\" for read\n", filename );

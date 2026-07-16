--- ./cgi/html.c.orig	2006-10-20 01:26:35.000000000 +0200
+++ ./cgi/html.c	2012-04-23 18:02:55.987510632 +0200
@@ -388,7 +388,7 @@
 	    url = (char *) malloc(url_len+1);
 	    if (url == NULL)
 	    {
-	      err = nerr_raise(NERR_NOMEM,
+	      err = nerr_raise(NERR_NOMEM, "%s",
 		  "Unable to allocate memory to convert url");
 	      break;
 	    }
@@ -401,7 +401,7 @@
 	    url = (char *) malloc(url_len+1);
 	    if (url == NULL)
 	    {
-	      err = nerr_raise(NERR_NOMEM,
+	      err = nerr_raise(NERR_NOMEM, "%s",
 		  "Unable to allocate memory to convert url");
 	      break;
 	    }
@@ -419,7 +419,7 @@
 	  free(esc_url);
 	  if (new_url == NULL)
 	  {
-	    err = nerr_raise(NERR_NOMEM, "Unable to allocate memory to convert url");
+	    err = nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory to convert url");
 	    break;
 	  }
 	  err = string_append (out, new_url);

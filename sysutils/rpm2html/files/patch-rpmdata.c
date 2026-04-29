--- rpmdata.c.orig	2005-08-18 23:15:53.000000000 +0200
+++ rpmdata.c	2007-06-25 15:43:11.000000000 +0200
@@ -900,19 +900,19 @@
 /*
  * Try to protect an e-mail address from a spam bot.
  * The "<someone@domain.tld>" is replaced
- *      with "<someone(at)domain.tld>".
+ *      with "<someone(at)domain(dot)tld>".
  */
 
 static unsigned char *buffer = NULL;
 static int buffer_size = 2000;
 static char *at = "(at)";
+static char *dot = "(dot)";
 char *protectEmail(char *string) {
     if (rpm2html_protect_emails == 0 || string == NULL)
         return string;
 
     unsigned char *cur, *end;
     unsigned char c;
-    int magick = 0;
 
     if (buffer == NULL) {
         buffer = (char *) xmlMalloc(buffer_size * sizeof(char));
@@ -938,13 +938,12 @@
 	    cur = &buffer[delta];
 	}
         c = (unsigned char) *(string++);
-        if (c == '<')
-            magick = 1;
-        if (c == '>')
-            magick = 0;
-	if (c == '@' && magick) {
+	if (c == '@') {
 	    strcpy(cur, at);
 	    cur += strlen(at);
+	} else if (c == '.') {
+	    strcpy(cur, dot);
+	    cur += strlen(dot);
 	} else {
 	    *(cur++) = c;
 	}

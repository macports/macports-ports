--- man.cgi.orig	Mon Dec  9 16:15:13 2002
+++ man.cgi	Mon Dec  9 16:18:06 2002
@@ -64,7 +64,7 @@
 
 ##  man2html program (needs to be a full pathname)
 
-$ManConvPrg	= '/usr/local/bin/man2html';
+$ManConvPrg	= '/opt/local/bin/man2html';
 
 ##  Flag if the -cgiurl option should be used
 
@@ -124,9 +124,10 @@
 ##  know about
 
 @ManPath	= qw(
+    /opt/local/man
+    /opt/local/share/man
+    /usr/share/man
     /usr/local/man
-    /usr/openwin/man
-    /usr/man
 );
 
 ##  PATH setting.  Modify as see fit.  Once useful modification
@@ -134,7 +135,8 @@
 ##  be invoked over the systems nroff when man formats a manpage.
 
 @Path   	= qw(
-    /opt/FSFgroff/bin
+    /opt/local/bin
+    /usr/local/bin
     /bin
     /usr/bin
 );

--- ripper.y.orig	Sat May  8 20:24:20 2004
+++ ripper.y	Sat May  8 20:27:36 2004
@@ -2304,7 +2304,6 @@
 
 static VALUE rip_do_parse _((VALUE));
 static VALUE rip_ensure _((VALUE));
-extern VALUE rb_thread_pass _((void));
 
 struct rip_arg {
     struct ruby_parser *parser;
@@ -2320,11 +2319,14 @@
 {
     struct ruby_parser *parser;
     struct rip_arg arg;
+    struct timeval wait;
+    wait.tv_sec=0;
+    wait.tv_usec=100*2;
 
     Data_Get_Struct(self, struct ruby_parser, parser);
 
     while (parser->parsing) {
-        rb_thread_pass();
+        rb_thread_wait_for(wait);
     }
     parser->parsing = 1;
     arg.parser = parser;
@@ -2807,7 +2809,7 @@
 		    break;
 		  case 'p':	/* /p is obsolete */
 		    rb_warn("/p option is obsolete; use /m\n\tnote: /m does not change ^, $ behavior");
-		    options |= RE_OPTION_POSIXLINE;
+		    /* options |= RE_OPTION_POSIXLINE; */
 		    break;
 		  case 'm':
 		    options |= RE_OPTION_MULTILINE;

diff -wubr ../mapm3-old/lib/iolib.h ./lib/iolib.h
--- ../mapm3-old/lib/iolib.h	Tue Feb  9 08:35:27 1993
+++ ./lib/iolib.h	Fri Nov 15 08:16:04 2002
@@ -292,7 +292,13 @@
 #define fnl(fp) fwrite(fp,"\n")
 
 void finput();  /* args: FILE *fp; char *str; int max_input_chars; */
-void fgetln();  /* args: FILE *fp; side-effects global char *ln; 
+#ifdef _SYS_DARWIN
+#define fgetln(x) mapmfgetln(x)
+void mapmfgetln();
+#else
+void fgetln();
+#endif
+/* args: FILE *fp; side-effects global char *ln; 
    Finput() and fgetln() both return a filter()ed line, and on end-of-file, the
    ENDOFILE message is sent. Str must have room for max_input_chars+1 chars,
    and only max_input_chars-1 chars can usually be read, as a '\n' may be read

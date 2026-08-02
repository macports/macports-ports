--- killfile.c.old	2006-05-06 11:17:31.000000000 -0400
+++ killfile.c	2006-05-06 11:17:45.000000000 -0400
@@ -55,7 +55,6 @@
 void print_debug(PKillStruct, const char *);
 void debug_one_kill(POneKill);
 void add_to_linkedlist(pmy_regex *, pmy_regex);
-const char *strnstr(const char *, const char *);
 pmy_regex regex_scan(char *, char, int, int, char);
 int regex_check(char *, pmy_regex, int);
 

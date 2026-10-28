--- common/key.h.orig	2009-09-14 11:42:00.000000000 -0700
+++ common/key.h	2009-09-14 11:42:10.000000000 -0700
@@ -196,19 +196,6 @@
 	(KEYS_WAITING(sp) &&						\
 	    FL_ISSET((sp)->wp->i_event[(sp)->wp->i_next].e_flags, CH_MAPPED))
 
-/*
- * Ex/vi commands are generally separated by whitespace characters.  We
- * can't use the standard isspace(3) macro because it returns true for
- * characters like ^K in the ASCII character set.  The 4.4BSD isblank(3)
- * macro does exactly what we want, but it's not portable yet.
- *
- * XXX
- * Note side effect, ch is evaluated multiple times.
- */
-#ifndef isblank
-#define	isblank(ch)	((ch) == ' ' || (ch) == '\t')
-#endif
-
 /* The "standard" tab width, for displaying things to users. */
 #define	STANDARD_TAB	6
 

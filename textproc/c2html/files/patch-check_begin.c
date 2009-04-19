--- check_begin.c.orig	2009-04-19 00:03:22.000000000 -0700
+++ check_begin.c	2009-04-19 00:03:41.000000000 -0700
@@ -83,8 +83,8 @@
 const char hyphens[NUM_HYPHENS] = {'_', '@', '$', '\'', '"', '`'};
 
 /*
-   There are two types of comments: those who start with "/*" and those who start with "//"
-   If the current comment starts with "/*" comment1 is TRUE otherwise it is FALSE
+   There are two types of comments: those who start with "/ *" and those who start with "//"
+   If the current comment starts with "/ *" comment1 is TRUE otherwise it is FALSE
 */
 char comment1;
 
@@ -159,14 +159,14 @@
 	const char *begin2 = "//";
 
 	/*
-	   If line is the beginning of a comment which begins with "/*"
+	   If line is the beginning of a comment which begins with "/ *"
 	*/
 	if ( isbeginend(begin1, line) )
 	{
 		comment1 = TRUE;
 		return (TRUE); /* line is the beginning of a comment */
 	}
-	comment1 = FALSE; /* line is definitely not the beginnig of a comment starting with "/*" */
+	comment1 = FALSE; /* line is definitely not the beginnig of a comment starting with "/ *" */
 
 	/* line can now only be the beginning of a comment which begins with "//" */
 	return ( isbeginend(begin2, line) );

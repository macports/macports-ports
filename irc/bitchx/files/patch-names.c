Index: source/names.c
===================================================================
RCS file: /cvs/bitchx/BitchX/source/names.c,v
retrieving revision 1.8
diff -u -3 -p -r1.8 names.c
--- source/names.c	25 Mar 2003 04:32:14 -0000	1.8
+++ source/names.c	8 May 2003 20:26:11 -0000
@@ -1004,8 +1004,9 @@ static	int decifer_mode(char *from, char
 				malloc_strcpy(key, next_arg(rest, &rest));
 			else
 			{
-				if (rest && *key && !my_strnicmp(rest, *key, strlen(*key)))
+				if (rest && *key && (!my_strnicmp(rest, *key, strlen(*key)) || rest[0] == '*'))
 					next_arg(rest, &rest);
+
 				new_free(key);
 			}
 			(*channel)->i_mode = -1;

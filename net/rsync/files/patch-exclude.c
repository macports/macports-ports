--- exclude.c	28 Jan 2006 00:14:02 -0000	1.128
+++ exclude.c	13 Mar 2006 01:49:56 -0000
@@ -562,7 +562,7 @@ static int rule_matches(char *name, stru
		if (litmatch_array(pattern, strings, slash_handling))
			return ret_match;
	} else if (anchored_match) {
-		if (strcmp(name,pattern) == 0)
+		if (strcmp(strings[0], pattern) == 0)
			return ret_match;
	} else {
		int l1 = strlen(name);


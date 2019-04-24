--- types.c.orig	2011-11-16 19:19:29 UTC
+++ types.c
@@ -66,7 +66,8 @@ unsigned char *get_content_type(unsigned
 		if (*ct == '.') ext = ct + 1;
 		else if (dir_sep(*ct)) ext = NULL;
 	if (ext) while (ext[extl] && !dir_sep(ext[extl]) && !end_of_dir(ext[extl])) extl++;
-	if ((extl == 3 && !casecmp(ext, "htm", 3)) ||
+	if (force_html ||
+	    (extl == 3 && !casecmp(ext, "htm", 3)) ||
 	    (extl == 4 && !casecmp(ext, "html", 4))) return stracpy("text/html");
 	foreach(e, extensions) if (is_in_list(e->ext, ext, extl)) return stracpy(e->ct);
 	exxt = init_str(); el = 0;

--- color.c.orig	Mon Jan 24 10:59:01 2000
+++ color.c	Mon Jan 24 10:57:36 2000
@@ -336,7 +336,7 @@
 		error(1, "init_color_mask: getpwuid");
 	(void) sprintf(buf, "%s/.%s", pw->pw_dir, program_name);
 	if ((fp = fopen(buf, "r")) == NULL) {
-		(void) strcpy(buf, "/etc/");
+		(void) strcpy(buf, "%%PREFIX%%/etc/");
 		(void) strcat(buf, program_name);
 		if ((fp = fopen(buf, "r")) == NULL) return 0;
 	}

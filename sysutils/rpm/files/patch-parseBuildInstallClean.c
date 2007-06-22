--- build/parseBuildInstallClean.c.orig	2007-03-21 12:29:49.000000000 +0100
+++ build/parseBuildInstallClean.c	2007-06-19 16:54:45.000000000 +0200
@@ -47,7 +47,7 @@
 	    appendStringBuf(*sbp, s);
 	s = _free(s);
     } else if (parsePart == PART_CLEAN) {
-	const char * s = rpmExpand("%{?buildroot:rm -rf '%{buildroot}'\n}", NULL);
+	const char * s = rpmExpand("%{?__spec_clean_body}%{!?__spec_clean_body:%{?buildroot:rm -rf '%{buildroot}'\n}}", NULL);
 	if (s && *s)
 	    appendStringBuf(*sbp, s);
 	s = _free(s);

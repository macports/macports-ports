--- config.c.orig	2007-05-16 10:18:19.000000000 +0200
+++ config.c	2007-05-16 10:19:34.000000000 +0200
@@ -731,8 +731,10 @@
     rpm2html_dump_rdf = 0;
     rpm2html_dump_rdf_resources = 0;
     rpm2html_dump_html = 1;
+#ifdef HAVE_LIBTEMPLATE
     if (rpm2html_html_template != NULL) xmlFree(rpm2html_html_template);
     rpm2html_html_template = "rpm2html.tpl";
+#endif
     if (rpm2html_rdf_dir != NULL) xmlFree(rpm2html_rdf_dir);
     rpm2html_rdf_dir = NULL;
     if (rpm2html_rdf_resources_dir != NULL) xmlFree(rpm2html_rdf_resources_dir);

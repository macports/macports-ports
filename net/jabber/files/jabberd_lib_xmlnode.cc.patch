--- jabberd/lib/xmlnode.cc.orig	2007-04-07 19:43:18 UTC
+++ jabberd/lib/xmlnode.cc
@@ -879,9 +879,9 @@ xmlnode xmlnode_get_tag(xmlnode parent, 
 xmlnode_list_item xmlnode_get_tags(xmlnode context_node, const char *path, xht namespaces, pool p) {
     char *this_step = NULL;
     const char *ns_iri = NULL;
-    char *next_step = NULL;
-    char *start_predicate = NULL;
-    char *end_predicate = NULL;
+    const char *next_step = NULL;
+    const char *start_predicate = NULL;
+    const char *end_predicate = NULL;
     char *predicate = NULL;
     char *end_prefix = NULL;
     int axis = 0;	/* 0 = child, 1 = parent, 2 = attribute */
@@ -1830,13 +1830,14 @@ xmlnode xmlnode_select_by_lang(xmlnode_l
     }
 
     /* if language has a geographical veriant, get the language as well */
-    if (lang != NULL && strchr(lang, '-') != NULL) {
-	snprintf(general_lang, sizeof(general_lang), "%s", lang);
-	if (strchr(lang, '-') != NULL) {
-	    strchr(lang, '-')[0] = 0;
-	} else {
-	    general_lang[0] = 0;
-	}
+    if (lang != NULL) {
+#define MIN(a,b) ((a) < (b) ? (a) : (b))
+	size_t len = sizeof(general_lang);
+	const char *pos;
+	if ((pos = strchr(lang, '-')))
+	    len = MIN(len, pos - lang + 1);
+
+	snprintf(general_lang, len, "%s", lang);
     }
 
     /* iterate the nodes */

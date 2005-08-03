--- epan/radius_dict.l.orig	Wed Jul 27 14:45:25 2005
+++ epan/radius_dict.l	Wed Jul 27 14:46:35 2005
@@ -65,7 +65,7 @@
 	static gchar* attr_vendor = NULL;
 	static gchar* vendor_name = NULL;
 	static gchar* value_repr = NULL;
-	static gboolean encrypt = FALSE;
+	static gboolean rad_encrypt = FALSE;
 	static gboolean has_tag = FALSE;
 	static gchar* current_vendor = NULL;
 	
@@ -97,7 +97,7 @@
 <VENDOR_W_NAME>[0-9]+   { add_vendor(vendor_name,strtol(yytext,NULL,10)); BEGIN OUT; }
 <VENDOR_W_NAME>0x[0-9a-f]+   { add_vendor(vendor_name,strtol(yytext,NULL,16)); BEGIN OUT; }
 
-<ATTR>[0-9a-z_-]+					{ attr_name = g_strdup(yytext); encrypt = FALSE; has_tag = FALSE; BEGIN ATTR_W_NAME; }
+<ATTR>[0-9a-z_-]+					{ attr_name = g_strdup(yytext); rad_encrypt = FALSE; has_tag = FALSE; BEGIN ATTR_W_NAME; }
 <ATTR_W_NAME>[0-9]+					{ attr_id = g_strdup(yytext);  BEGIN ATTR_W_ID;}
 <ATTR_W_NAME>0x[0-9a-f]+			{ attr_id = g_strdup_printf("%u",(int)strtoul(yytext,NULL,16)); BEGIN ATTR_W_ID;}
 <ATTR_W_ID>integer					{ attr_type = radius_integer;  BEGIN ATTR_W_TYPE; }
@@ -109,11 +109,11 @@
 <ATTR_W_ID>ifid						{ attr_type = radius_ifid;  BEGIN ATTR_W_TYPE; }
 <ATTR_W_ID>[0-9a-z_-]+				{ attr_type = radius_octets;  BEGIN ATTR_W_TYPE; }
 <ATTR_W_TYPE>has_tag[,]?			{ has_tag = TRUE; attr_vendor = NULL;  BEGIN ATTR_W_VENDOR; }
-<ATTR_W_TYPE>encrypt=1[,]?			{ encrypt=TRUE;  attr_vendor = NULL;  BEGIN ATTR_W_VENDOR; }
+<ATTR_W_TYPE>rad_encrypt=1[,]?			{ rad_encrypt=TRUE;  attr_vendor = NULL;  BEGIN ATTR_W_VENDOR; }
 <ATTR_W_TYPE>[,0-9a-z_-]+=([^\n]+)	{ /* ignore other parameters */  attr_vendor = NULL;  BEGIN ATTR_W_VENDOR; }
-<ATTR_W_TYPE>[0-9a-z_-]+			{ attr_vendor = g_strdup(yytext);  add_attribute(attr_name,attr_id,attr_type,attr_vendor,encrypt,has_tag); attr_vendor = NULL;  BEGIN OUT; }
-<ATTR_W_TYPE>\n						{ add_attribute(attr_name,attr_id,attr_type,current_vendor ? g_strdup(current_vendor) : NULL ,encrypt,has_tag); linenums[include_stack_ptr]++;  BEGIN OUT; }
-<ATTR_W_VENDOR>\n					{ add_attribute(attr_name,attr_id,attr_type,attr_vendor,encrypt,has_tag); linenums[include_stack_ptr]++; BEGIN OUT; };
+<ATTR_W_TYPE>[0-9a-z_-]+			{ attr_vendor = g_strdup(yytext);  add_attribute(attr_name,attr_id,attr_type,attr_vendor,rad_encrypt,has_tag); attr_vendor = NULL;  BEGIN OUT; }
+<ATTR_W_TYPE>\n						{ add_attribute(attr_name,attr_id,attr_type,current_vendor ? g_strdup(current_vendor) : NULL ,rad_encrypt,has_tag); linenums[include_stack_ptr]++;  BEGIN OUT; }
+<ATTR_W_VENDOR>\n					{ add_attribute(attr_name,attr_id,attr_type,attr_vendor,rad_encrypt,has_tag); linenums[include_stack_ptr]++; BEGIN OUT; };
 
 <VALUE>[0-9a-z-]+					{ attr_name = g_strdup(yytext); BEGIN VALUE_W_ATTR; }
 <VALUE_W_ATTR>[^[:blank:]]+			{ value_repr = g_strdup(yytext); BEGIN VALUE_W_NAME; }

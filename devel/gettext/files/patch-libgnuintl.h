--- intl/libgnuintl.h.orig	Tue Sep  3 18:29:15 2002
+++ intl/libgnuintl.h	Tue Sep  3 17:37:47 2002
@@ -126,7 +126,7 @@
 # define gettext libintl_gettext
 #endif
 extern char *gettext _INTL_PARAMS ((const char *__msgid))
-       _INTL_ASM (libintl_gettext);
+       _INTL_ASM (_libintl_gettext);
 #endif
 
 /* Look up MSGID in the DOMAINNAME message catalog for the current
@@ -143,7 +143,7 @@
 #endif
 extern char *dgettext _INTL_PARAMS ((const char *__domainname,
 				     const char *__msgid))
-       _INTL_ASM (libintl_dgettext);
+       _INTL_ASM (_libintl_dgettext);
 #endif
 
 /* Look up MSGID in the DOMAINNAME message catalog for the current CATEGORY
@@ -184,7 +184,7 @@
 extern char *ngettext _INTL_PARAMS ((const char *__msgid1,
 				     const char *__msgid2,
 				     unsigned long int __n))
-       _INTL_ASM (libintl_ngettext);
+       _INTL_ASM (_libintl_ngettext);
 #endif
 
 /* Similar to `dgettext' but select the plural form corresponding to the
@@ -205,7 +205,7 @@
 				      const char *__msgid1,
 				      const char *__msgid2,
 				      unsigned long int __n))
-       _INTL_ASM (libintl_dngettext);
+       _INTL_ASM (_libintl_dngettext);
 #endif
 
 /* Similar to `dcgettext' but select the plural form corresponding to the
@@ -247,7 +247,7 @@
 # define textdomain libintl_textdomain
 #endif
 extern char *textdomain _INTL_PARAMS ((const char *__domainname))
-       _INTL_ASM (libintl_textdomain);
+       _INTL_ASM (_libintl_textdomain);
 #endif
 
 /* Specify that the DOMAINNAME message catalog will be found
@@ -266,7 +266,7 @@
 #endif
 extern char *bindtextdomain _INTL_PARAMS ((const char *__domainname,
 					   const char *__dirname))
-       _INTL_ASM (libintl_bindtextdomain);
+       _INTL_ASM (_libintl_bindtextdomain);
 #endif
 
 /* Specify the character encoding in which the messages from the
